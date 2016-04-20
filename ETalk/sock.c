

#include<stdlib.h>
#include<stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <fcntl.h>
#include <ctype.h>
#include<errno.h>
#include <netinet/in.h>
#include <netinet/tcp.h> 
#include <arpa/inet.h>  /* TCP_NODELAY, TCP_CORK */
#include"ip.h"
#include"list.h"
#include"sock.h"
#include <unistd.h>


//#define RAW_UDP_ENABLE	

#define SD_BOTH 2

#define SOCKET_ERROR -1
#define GetLastError errno
#define WSAGetLastError() errno

#define SOCKET_BUF_LEN 2048
struct ip_opt_hdr
{	
	uint8_t code;
	uint8_t length;
	uint8_t offset;
	uint8_t pad;
	uint32_t addrs[9]; 
};
struct raw_udp_socket_desc
{
	struct ipv4_hdr ih;
	struct udp_hdr uh;
	uint32_t pri_data[0];
};
struct socket_mgr_desc;
struct udp_socket_desc
{
	uint16_t send_packet_number;
	uint16_t last_recv_packet_number;
	int type;
	uint32_t pri_data[0];
};
struct socket_desc
{
	struct list_head list;
	int protocol;
	int type;
	int socket;
	uint32_t ssrc;
	struct socket_mgr_desc*psmd;
	uint32_t pri_data[0];
};	
struct socket_mgr_desc
{	
	struct list_head socket_list_head;
};	
	
struct RTPHeader
{	
#ifdef RTP_BIG_ENDIAN
	uint8_t version:2;
	uint8_t padding:1;
	uint8_t extension:1;
	uint8_t csrccount:4;
	uint8_t marker:1;
	uint8_t payloadtype:7;
#else // little endian
	uint8_t csrccount:4;
	uint8_t extension:1;
	uint8_t padding:1;
	uint8_t version:2;
	
	uint8_t payloadtype:7;
	uint8_t marker:1;
#endif // RTP_BIG_ENDIAN
	
	uint16_t sequencenumber;
	uint32_t timestamp;
	uint32_t ssrc;
};

static void swap(unsigned int *a, unsigned int *b)//Ωªªª
{    
	*a = (*a)^(*b);    *b = (*a)^(*b);    *a = (*a)^(*b);
}
static unsigned short checksum_16(unsigned short *addr,int len)  
{  
    unsigned short chksum;  
    unsigned int sum = 0;  
  	
   while(len > 1)  
    {  
        sum += *addr++;  
        len -= 2;  
    }   
    	
    if(len == 1)  
        sum += *(unsigned char*)addr;  
    	
    sum = (sum>>16) + (sum & 0xffff);  
    sum += (sum>>16);  
    chksum = ~sum;
    return (chksum);
}  	
	
static int udp_send_rtp_packet(struct socket_desc*psd,char*data,int len,struct sockaddr_in*dst_addr,int sock_len)
{	
	
	struct RTPHeader*prh;
	struct udp_socket_desc*pusd=(struct udp_socket_desc*)(psd->pri_data);
	int nb,snd_len;
	
	struct sockaddr_in si;
#ifdef RAW_UDP_ENABLE	
	
		
		
		if(getsockname(psd->socket,(struct sockaddr*)&si,&sock_len)==SOCKET_ERROR){
			int error = WSAGetLastError;
			printf("getsockname err:%d\n",error);
			return SOCKET_ERROR;
		}
		printf("udp socket src addr 0x%s:%d\n",inet_ntoa(si.sin_addr),ntohs(si.sin_port));
		struct ipv4_hdr*pih;
		struct udp_hdr*puh;
		
		struct raw_udp_socket_desc*prusd=(struct raw_udp_socket_desc*)pusd->pri_data;
		pih=&prusd->ih;
		pih->ip_verlen=(4<<4)|(sizeof(struct ipv4_hdr)/sizeof(uint32_t));
		pih->ip_tos=0xb8;
		pih->ip_ttl=63;
		pih->ip_srcaddr=si.sin_addr.s_addr;
		pih->ip_protocol=IPPROTO_UDP;
		pih->ip_checksum=checksum_16((uint16_t*)pih,sizeof(struct ipv4_hdr));
		pih->ip_offset=0;
		pih->ip_id=0;
				
		puh=&prusd->uh;
		puh->src_portno=si.sin_port;
		

	pih->ip_totallength=sizeof(struct ipv4_hdr)+sizeof(struct udp_hdr)+len+sizeof(struct RTPHeader);
	puh->udp_length=sizeof(struct udp_hdr)+len+sizeof(struct RTPHeader);
	puh->udp_checksum=0;
	puh->dst_portno=dst_addr->sin_port;
	prh=(struct RTPHeader*)prusd->pri_data;
	int optval=1;
	if(setsockopt(psd->socket,IPPROTO_IP,IP_HDRINCL,(char *)&optval,sizeof(optval))==SOCKET_ERROR){
		printf("%s,%d,err:%d\n",__FUNCTION__,__LINE__,WSAGetLastError);
		return SOCKET_ERROR;
	}
	snd_len=sizeof(ipv4_hdr)+sizeof(struct udp_hdr)+sizeof(struct RTPHeader)+len;
#else
	prh=(struct RTPHeader*)pusd->pri_data;
	snd_len=len+sizeof(struct RTPHeader);
#endif
	prh->csrccount=0;
	prh->payloadtype=1;
	prh->sequencenumber=htons(pusd->send_packet_number++);
	prh->timestamp=htonl(1);
	prh->ssrc = htonl(psd->ssrc);
	prh->version=2;
	prh->marker = 1;
	prh->extension = 1;
	prh->padding = 0;
	memcpy(prh+1,data,len);
	nb=sendto(psd->socket,(char*)prh,snd_len,0,(struct sockaddr*)dst_addr,sock_len);
	
	if(nb==SOCKET_ERROR ){
		printf("%s sendto error:%d\n",__FUNCTION__,GetLastError);
	}
	else if(nb<(len+sizeof(struct RTPHeader))){
		printf("%s sendto small packet\n",__FUNCTION__);
	}
	return nb;
}	
int socket_send(void * socket_handle,char*buf,int len,int flag,struct sockaddr_in*dst_addr,int sock_len)
{	
	struct socket_desc*psd=(struct socket_desc*)socket_handle;
	struct list_head* n = NULL;
  	struct list_head* get = NULL;
	struct socket_desc*psd2=NULL;
	int nb;
	if(socket_handle==0 || socket_handle==-1)return SOCKET_ERROR;
	list_iterate_safe(get, n, &psd->psmd->socket_list_head){
		psd2 = list_get(get, struct socket_desc, list);
		if(psd2==psd)break;
		psd2=NULL;
	}
	if(psd2){
		if(psd2->protocol==IPPROTO_TCP){
			nb= send(psd2->socket,buf,len,flag);
			return nb;
		}else{
			
			return udp_send_rtp_packet(psd2,buf,len,dst_addr,sock_len);
		}
	}
	return SOCKET_ERROR;
}
int socket_recv(void * socket_handle,char*buf,int len,int flag,struct sockaddr_in*src_addr,int*sock_len)
{
	struct socket_desc*psd=(struct socket_desc*)socket_handle;
	struct list_head* n = NULL;
  	struct list_head* get = NULL;
	struct socket_desc*psd2=NULL;
	int nb;
	if(socket_handle==0 || socket_handle==-1)return SOCKET_ERROR;
	
	list_iterate_safe(get, n, &psd->psmd->socket_list_head){
		psd2 = list_get(get, struct socket_desc, list);
		if(psd2==psd)break;
		psd2=NULL;
	}
	if(psd2){
		if(psd2->protocol==IPPROTO_TCP){
			nb= recv(psd2->socket,buf,len,flag);
			if(nb<=0){
				return SOCKET_ERROR;
			}
			return nb;
		}else{
			char rtp_buf[8192];
			
			
			nb=recvfrom(psd2->socket,rtp_buf,sizeof(rtp_buf),flag,(struct sockaddr*)src_addr,sock_len);
			if(nb==SOCKET_ERROR){
				printf("%s recvfrom error:%d\n",__FUNCTION__,GetLastError);
				return SOCKET_ERROR;
			}else{
				/*Ω‚ŒˆRTPÕ∑*/
				if(nb<sizeof(struct RTPHeader) ||((nb-sizeof(struct RTPHeader))>MSS_SIZE)){
					printf("%s recvfrom  packet size abnormal:%d\n",__FUNCTION__,nb);
					return 0;
				}else{
					struct RTPHeader*prh=(struct RTPHeader*)rtp_buf;
					struct udp_socket_desc*pusd=(struct udp_socket_desc*)psd2->pri_data;
					uint16_t recv_num=ntohs(prh->sequencenumber);
					if((pusd->last_recv_packet_number+1)!=recv_num){
						printf("recv form udp port:%d invalid seq packet:%d\n",ntohs(src_addr->sin_port),recv_num);
					}
					pusd->last_recv_packet_number=recv_num;
					memcpy(buf,rtp_buf+sizeof(struct RTPHeader),nb-sizeof(struct RTPHeader));
					return nb-sizeof(struct RTPHeader);
				}
			}
		}
	}
	return SOCKET_ERROR;
}
void socket_close(void * socket_handle)
{
	struct socket_desc*psd=(struct socket_desc*)socket_handle;
	struct list_head* n = NULL;
  	struct list_head* get = NULL;
	struct socket_desc*psd2=NULL;

	if(socket_handle==0 || socket_handle==-1)return;
	
	list_iterate_safe(get, n, &psd->psmd->socket_list_head){
		psd2 = list_get(get, struct socket_desc, list);
		if(psd2==psd)break;
		psd2=NULL;
	}
	if(psd2){
		shutdown(psd2->socket,SD_BOTH);
		close(psd2->socket);
		LIST_DEL(&psd2->list);
		free(psd2);
	}
}
void socket_fd_set(void *socket_handle,fd_set*pfs)
{
	struct socket_desc*psd=(struct socket_desc*)socket_handle;
	
	struct list_head* n = NULL;
  	struct list_head* get = NULL;
	struct socket_desc*psd2=NULL;

	if(socket_handle==0 || socket_handle==-1)return;
	
	list_iterate_safe(get, n, &psd->psmd->socket_list_head){
		psd2 = list_get(get, struct socket_desc, list);
		if(psd2==psd)break;
		psd2=NULL;
	}
	if(psd2){
		FD_SET(psd2->socket,pfs);
	}	
}
int socket_fd_isset(void * socket_handle,fd_set*pfs)
{
	if( socket_handle==0 || socket_handle==-1)return 0;
	struct socket_desc*psd=(struct socket_desc*)socket_handle;
	
	struct list_head* n = NULL;
  	struct list_head* get = NULL;
	struct socket_desc*psd2=NULL;
	
	list_iterate_safe(get, n, &psd->psmd->socket_list_head){
		psd2 = list_get(get, struct socket_desc, list);
		if(psd2==psd)break;
		psd2=NULL;
	}
	
	if(psd2){
		return FD_ISSET(psd2->socket,pfs);
	}
	
	return 0;
}
int socket_getsockopt(void * socket_handle,int level, int optname, char *optval, int *optlen)
{
	struct socket_desc*psd=(struct socket_desc*)socket_handle;
	
	struct list_head* n = NULL;
  	struct list_head* get = NULL;
	struct socket_desc*psd2=NULL;

	if(socket_handle==0 || socket_handle==-1)return SOCKET_ERROR;
	
	list_iterate_safe(get, n, &psd->psmd->socket_list_head){
		psd2 = list_get(get, struct socket_desc, list);
		if(psd2==psd)break;
		psd2=NULL;
	}
	if(psd2){
		return getsockopt(psd2->socket,level, optname, optval, optlen);
	}
	return SOCKET_ERROR;
}
int create_socket2(void * mgr_handle,uint32_t ssrc,int protocol,struct sockaddr_in*srv_addr,int send_buf_size,int recv_buf_size)
{	
int ret;
    int socketfd;

    struct sockaddr_in server_addr;

    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    //server_addr.sin_port = htons(31212);
    server_addr.sin_port = htons(4569);
    server_addr.sin_addr.s_addr = inet_addr("121.201.35.80");

    socketfd = socket(AF_INET, SOCK_STREAM, 0);
    if (socketfd == -1) {
        printf("socket create failed!%d\n", errno);
        return -1;
    }
    printf("socket create success!, socket=%d\n", socketfd);
    fcntl(socketfd, F_SETFL, fcntl(socketfd, F_GETFL, 0)|O_NONBLOCK);
    ret = connect(socketfd, (struct sockaddr*)&server_addr, sizeof(server_addr));
    if (ret == -1) {
        printf("connect failed!errno=%d\n", errno);
//        return -1;
    } else {
        printf("connect success!, ret=%d\n", ret);
    }
	return -1;

}
void * create_socket(void * mgr_handle,uint32_t ssrc,int protocol,struct sockaddr_in*srv_addr,int send_buf_size,int recv_buf_size)
{	
	uint32_t size,size2;
	int sock;
	struct sockaddr_in addr;
	int len = sizeof(size);
	int on=1;
	struct socket_mgr_desc*psmd=(struct socket_mgr_desc*)mgr_handle;
	struct socket_desc*psd=(struct socket_desc*)malloc(SOCKET_BUF_LEN);
	if(!psd)return -1;
	memset(psd,0,SOCKET_BUF_LEN);
	
	psd->psmd=psmd;
	psd->protocol=protocol;
	if(protocol==IPPROTO_TCP)
	{
		psd->type=SOCK_STREAM;
	}else {
#ifdef RAW_UDP_ENABLE
		psd->type=SOCK_RAW;
#else
		psd->type=SOCK_DGRAM;
#endif
	}
	if(protocol==IPPROTO_TCP)
		psd->socket=socket(AF_INET, psd->type, 0);
	else
		psd->socket=socket(AF_INET,psd->type,IPPROTO_UDP);
	
	if(psd->socket==-1){
		printf("%s,%d,%d\n",__FUNCTION__,__LINE__, GetLastError);
		goto err;
	}
	if(protocol==IPPROTO_TCP)
		size=recv_buf_size;
	else
		size=(MSS_SIZE+12)*45;
	if (size && setsockopt(psd->socket,SOL_SOCKET,SO_RCVBUF,(const char *)&size,sizeof(int))==SOCKET_ERROR)
	{
		printf("%s,%d,%d\n",__FUNCTION__,__LINE__, GetLastError);
		goto err;
	}
	if(protocol==IPPROTO_TCP)
		size=recv_buf_size;
	else
		size=(MSS_SIZE+12)*45;
	if (size && setsockopt(psd->socket,SOL_SOCKET,SO_SNDBUF,(const char *)&size,sizeof(int)) ==SOCKET_ERROR)
	{
		printf("%s,%d,%d\n",__FUNCTION__,__LINE__, GetLastError);
		goto err;
	}
	getsockopt(psd->socket,SOL_SOCKET,SO_SNDLOWAT,(char *)&size,&len);
	getsockopt(psd->socket,SOL_SOCKET,SO_RCVLOWAT, (char *)&size2,&len);
	printf("%s,old sndlowat is:%d old rcvlowat:%d\n",__FUNCTION__,size,size2);
	size=4;
	
	if( setsockopt(psd->socket, SOL_SOCKET, SO_REUSEADDR, (char*)&on, sizeof(int))==SOCKET_ERROR){
		printf("%s,%d,%d\n",__FUNCTION__,__LINE__, GetLastError);
		goto err;
	}
	if(protocol==IPPROTO_TCP){
		on=1;
		if(setsockopt(psd->socket, IPPROTO_TCP, TCP_NODELAY, (char*)&on, sizeof(int))==SOCKET_ERROR){
			printf("%s,%d,%d\n",__FUNCTION__,__LINE__, GetLastError);
			goto err;
		}
	}

	if(fcntl(psd->socket, F_SETFL, fcntl(psd->socket, F_GETFL, 0)|O_NONBLOCK)==SOCKET_ERROR){
		printf("%s,%d,%d\n",__FUNCTION__,__LINE__, GetLastError);
		goto err;
	}
	
#if 0
	memset(&addr,0,sizeof(struct sockaddr_in));
	addr.sin_family = AF_INET;
	
	if (bind(psd->socket,(struct sockaddr *)&addr,sizeof(struct sockaddr_in)) != 0)
	{
		printf("%s,%d,%d\n",__FUNCTION__,__LINE__, WSAGetLastError);
		goto err;
	}
#endif
	if(protocol==IPPROTO_TCP){
		int addr_size=0;
		int ret;
		addr_size=sizeof(struct sockaddr_in);
		printf("ddddd%s,%d,%s:%d\n",__FUNCTION__,__LINE__,inet_ntoa(srv_addr->sin_addr),ntohs(srv_addr->sin_port));
		
	
		ret = connect(psd->socket, (struct sockaddr*)srv_addr, addr_size);
		printf("%s,%d,connect ret:%d\n",__FUNCTION__,__LINE__,ret);
		if(ret==SOCKET_ERROR){
			int error = GetLastError;
//			printf("%s,%d,connect err:%s\n",__FUNCTION__,__LINE__,perror(error));
            perror("connect:");
			if( error!= 36){
				printf("connect err:%d\n",error);
				goto err;
			}
		}
	}else{
#ifndef RAW_UDP_ENABLE
		unsigned char  service_type = 48<<2;
		printf("setsockopt IPPROTO_IP IP_TOS service_type:0x%x\n",service_type);
		if (setsockopt(psd->socket, IPPROTO_IP, IP_TOS, (char *)&service_type, sizeof(service_type)) == SOCKET_ERROR){
			int error = GetLastError;
			if( error!= EAGAIN){ 
				printf("connect err:%d\n",error);
				goto err;
			}
		}
#if 0
		DWORD on = 1;
		setsockopt(psd->socket,IPPROTO_UDP, UDP_NOCHECKSUM,(char *)&on,sizeof(on));
#endif
#endif
	}
	goto out;
err:
	close(psd->socket);
	free(psd);
	return (void *)-1;
out:
	psd->ssrc=ssrc;
	LIST_ADD_TAIL(&psd->list,&psmd->socket_list_head);
	return psd;
}	
	
void * socket_manager_create(void)
{	
	struct socket_mgr_desc*psmd=(struct socket_mgr_desc*)malloc(sizeof(struct socket_mgr_desc));
	if(!psmd)return -1;
	memset(psmd,0,sizeof(struct socket_mgr_desc));
	INIT_LIST(psmd->socket_list_head);
	return(void*)psmd;
}	
	
void socket_manager_delete(void * handle)
{
	struct list_head* n = NULL;
  	struct list_head* get = NULL;
	struct socket_desc*psd;
	struct socket_mgr_desc*psmd=(struct socket_mgr_desc*)handle;
	list_iterate_safe(get, n, &psmd->socket_list_head){
		psd = list_get(get, struct socket_desc, list);
		shutdown(psd->socket,SD_BOTH);
		close(psd->socket);
		LIST_DEL(&psd->list);
		free(psd);
	}
	free(psmd);
}










