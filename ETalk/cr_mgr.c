
#include"cr_mgr.h"
#include"list.h"
#include"turn.h"

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>
#include<errno.h>
#include <sys/socket.h>
#include<sys/time.h>
#include<arpa/inet.h>
#include"sock.h"
#include <signal.h>

#define SOCKET_ERROR -1
#define GetLastError errno
#define WSAGetLastError errno

#define SES_CONN_TIMEOUT	8

static char sdcardPath[] = "/storage/emulated/0/etalk_camera/netlib.log";
char buf[4096];
void dbg_print(const char* f, int line, const char* format, ...)
{
//  va_list args;
//
//#ifdef _MSC_VER
//  SYSTEMTIME tlt;
//  GetLocalTime (&tlt);
//  fprintf(stderr, "%02d:%02d:%02d.%03u|[%s:%d]", tlt.wHour, tlt.wMinute,
//      tlt.wSecond, tlt.wMilliseconds, f, line);
//#else
//  struct timeval lt;
//  struct tm* tlt = NULL;
//  gettimeofday(&lt, NULL);
//  tlt = localtime((time_t*)&lt.tv_sec);
//  fprintf(stderr, "%02d:%02d:%02d.%06u [%s:%d]\t", tlt->tm_hour, tlt->tm_min,
//      tlt->tm_sec, (uint32_t)lt.tv_usec, f, line);
//#endif
//
//  va_start(args, format);
//  vfprintf(stderr, format, args);
//  va_end(args);
//
}
//#define debug dbg_print

#define DBG_ATTR __FILE__, __LINE__


void write_file_func(char *fmt, ...)
{
	char buf[1024] = {0};
	int len;
	va_list args;
//	va_start(args, fmt);
	len=vsprintf(buf, fmt, args);
//	va_end(args);
	FILE *fp_net = NULL;
	fp_net = fopen(sdcardPath, "w+");
	fwrite(buf, len, 1, fp_net);
	fclose(fp_net);
}


#define MAKE_TO_APP_CR_THREAD_STEP(m,cb,usr)   {\
	uint8_t buf2[32]; \
	struct event_desc*ped=(struct event_desc*)(buf2); \
	ped->evt_id=TO_APP_CR_THREAD_STEP; \
	struct to_app_cr_thread_step*ptacts=(struct to_app_cr_thread_step*)ped->data; \
	ptacts->ms=(m); \
	(cb)((usr),ped); \
}	
#define MAKE_TO_APP_SESSION_NET_DELAY(cb,usr)   {\
	uint8_t buf2[32]; \
	struct event_desc*ped=(struct event_desc*)(buf2); \
	ped->evt_id=TO_APP_SESSION_NET_DELAY; \
	(cb)((usr),ped); \
}
#define MAKE_TO_APP_SESSION_NET_USEABLE(cb,usr)   {\
	uint8_t buf2[32]; \
	struct event_desc*ped=(struct event_desc*)(buf2); \
	ped->evt_id=TO_APP_SESSION_NET_USEABLE; \
	(cb)((usr),ped); \
}

#define MAKE_TO_APP_CR_HANDLE(h,i,a,p,s,cb,usr)   {\
	uint8_t buf2[32]; \
	struct event_desc*ped=(struct event_desc*)(buf2); \
	ped->evt_id=TO_APP_CR_HANDLE; \
	ped->len=sizeof(struct to_app_cr_handle); \
	struct to_app_cr_handle*ptussh=(struct to_app_cr_handle*)ped->data; \
	ptussh->cr_local_handle=(h); \
	ptussh->cr_id=(i); \
	ptussh->cr_addr=(a); \
	ptussh->cr_port=(p); \
	ptussh->ssrc=(s); \
	(cb)((usr),ped); \
}

#define MAKE_TO_APP_SESSION_HANDLE(v,h,a,p,cb,usr)   {\
	uint8_t buf2[32]; \
	struct event_desc*ped=(struct event_desc*)(buf2); \
	ped->evt_id=TO_APP_SESSION_HANDLE; \
	ped->len=sizeof(struct to_app_session_handle); \
	struct to_app_session_handle*ptussh=(struct to_app_session_handle*)ped->data; \
	ptussh->user=(v); \
	ptussh->session_handle=(h); \
	ptussh->slaver_addr=(a); \
	ptussh->slaver_port=(p); \
	(cb)((usr),ped); \
}
#define MAKE_TO_APP_SESSION_RECV_DATA(u,h,l,d,p,cb,usr)   {\
	uint8_t buf2[64]; \
	struct event_desc*ped=(struct event_desc*)(buf2); \
	ped->evt_id=TO_APP_SESSION_RECV_DATA; \
	ped->len=sizeof(struct to_app_session_recv_data); \
	struct to_app_session_recv_data*ptussh=(struct to_app_session_recv_data*)ped->data; \
	ptussh->user=(u); \
	ptussh->session_handle=(h); \
	ptussh->data_len=(l); \
	ptussh->data=(d); \
	ptussh->src_port=(p); \
	(cb)((usr),ped); \
}

enum{
	SOCKET_STATUS_CONNECTING=1,
	SOCKET_STATUS_CONNECTED,
	SOCKET_STATUS_WRITE_WOULDBLOCK,
};

#define TCP_BUF_LEN 1024*32

struct tcp_buffer_desc
{
	uint8_t tcp_buf[TCP_BUF_LEN];
};
struct protocol_head_desc
{
	uint16_t align_len;
	uint16_t real_len;	
	uint32_t ssrc;
	char data[0];
};	
	
	
struct socket_desc
{	
	void * sock_handle;
	char buf[32768];
	int data_len;
	int sent_pos;
	int recv_pos;
	int status;
	struct  timeval connect_time;
};	
	
struct classroom_desc
{	
	struct sockaddr_in srv_addr;
	struct sockaddr_in srv_cr_addr;
	void * srv_socket_handle;
	int socket_status;
	struct socket_desc tcp_srv_sd;
	int thread_handle;
    	pthread_t thread_id;
	event_callback ec;
	void*usr;
	void * cr_srv_handle;
	uint32_t cr_srv_id;
	struct list_head session_list_head;
	struct  timeval last_time;
	uint32_t ssrc;
	void * socket_mgr_handle;
	void * firewall_handle;
};	
	
enum{
	REQUEST_CREATE_CLASSROOM=1,
	REQUEST_DELETE_CLASSROOM,
	REQUEST_RESTART_CLASSROOM,
	REQUEST_CLASSROOM_EXIT,
	REQUEST_CLASSROOM_SIGNALED,
};
struct request_delete_classroom
{
	void * cr_srv_handle;
};
enum{
	REPLY_CREATE_CLASSROOM=1,
	REPLY_CREATE_CLASSROOM2,
	REPLY_DELETE_CLASSROOM,
	REPLY_RESTART_CLASSROOM,
	REPLY_CLASSROOM_EXIT,
	REPLY_CLASSROOM_SIGNALED,
};
struct reply_create_classroom
{	
	uint32_t turnserver_port;
	void * handle;
	uint32_t cr_id;
};
enum{
	FROM_APP_DELETE_CR=TO_APP_CR_MAX,
	FROM_APP_CREATE_SESSION,
	FROM_APP_DELETE_SESSION,
	FROM_APP_JOIN_SESSION,
	FROM_APP_QUIT_SESSION,
};	
struct from_app_create_session
{	
	void*usr;
	int protocol;
	int send_buf_size;
	int recv_buf_size;
	int delay;
};	
struct from_app_delete_session
{	
	void * session_handle;
};	
struct session_desc;


struct session_desc
{
	struct socket_desc sess_sd;
	struct classroom_desc*pcd;
	struct list_head list;
	int protocol;
	void*usr;
	struct sockaddr_in master_addr;
	uint32_t master_srv_id;
	struct sockaddr_in slaver_addr;
	int send_buf_size;
	int recv_buf_size;
	int delay;
};	
static struct session_desc* create_p2p_session(struct classroom_desc*pcd,int protocol,void*usr,int delay,int send_buf_size,int recv_buf_size)
{	
	uint8_t buf[32];
	struct session_desc*psd=(struct session_desc*)malloc(sizeof(struct session_desc));
	if(!psd)return NULL;
	memset(psd,0,sizeof(struct session_desc));
	
	psd->usr=usr;
	psd->protocol=protocol;
	psd->send_buf_size=send_buf_size;
	psd->recv_buf_size=recv_buf_size;
	psd->delay=delay;
	struct turn_msg_desc*ptmd=(struct turn_msg_desc*)buf;
	struct from_master_req_create_session*pfmrcs=(struct from_master_req_create_session*)ptmd->data;
	ptmd->msg_id=FROM_MASTER_REQ_CREATE_SESSION;
	pfmrcs->protocol=protocol;
	pfmrcs->session_handle=psd;
	pfmrcs->send_buf_size=send_buf_size;
	pfmrcs->recv_buf_size=recv_buf_size;
	pfmrcs->delay=delay;
	printf("%s,%d,pfmrcs->session_handle:0x%x\n",__FUNCTION__,__LINE__,pfmrcs->session_handle);
	if(socket_send(pcd->tcp_srv_sd.sock_handle,(char*)buf,sizeof(struct turn_msg_desc)+sizeof(struct from_master_req_create_session),0,NULL,0)==SOCKET_ERROR){
		printf("%s,%d,%d\n",__FUNCTION__,__LINE__,GetLastError);
		free(psd);
		return NULL;
	}
	
	psd->pcd=pcd;
	LIST_ADD_TAIL(&psd->list,&pcd->session_list_head);
	return psd;
}	
struct request_desc
{	
	int len;
	int request_id;
	char data[0];
};	
static int cmd_create_classroom(void * socket_handle)
{	
	uint8_t buf[128];
	
	struct request_desc*prd=(struct request_desc*)buf;
	int err;
	memset(buf,0,sizeof(buf));
	
	prd->request_id=REQUEST_CREATE_CLASSROOM;
	prd->len=0;
	printf("%s,%d\n",__FUNCTION__,__LINE__);
	if (socket_send(socket_handle, (char*)buf, sizeof(struct request_desc) + prd->len, 0,NULL,0) == SOCKET_ERROR){
		err=WSAGetLastError;
		printf("create_classroom send err:%d\n",err);
		return -1;
	}
	printf("%s,%d\n",__FUNCTION__,__LINE__);
	return 0;
}
static int cmd_delete_classroom(struct classroom_desc*pcd)
{
	uint8_t buf[128];
	struct request_desc*prd=(struct request_desc*)buf;
	struct request_delete_classroom*prdc;
	int err;
	memset(buf,0,sizeof(buf));
	
	prd->request_id=REQUEST_DELETE_CLASSROOM;
	prd->len=sizeof(struct request_delete_classroom);
	prdc=(struct request_delete_classroom*)prd->data;
	prdc->cr_srv_handle=pcd->cr_srv_handle;
	
	if (socket_send(pcd->srv_socket_handle, (char*)buf, sizeof(struct request_desc) + prd->len, 0,NULL,0) == SOCKET_ERROR){
		err=WSAGetLastError;
		printf("create_classroom send err:%d\n",err);
		return -1;
	}
	return 0;
}

static void internal_delete_session(struct session_desc*psd)
{
	struct list_head* n = NULL;
  	struct list_head* get = NULL;
	
	socket_close(psd->sess_sd.sock_handle);
	MAKE_TO_APP_SESSION_HANDLE(psd->usr,-1,0,0,psd->pcd->ec, psd->pcd->usr);
	LIST_DEL(&psd->list);
	printf("%s,session be deleted\n",__FUNCTION__);
	free(psd);
}	
static void*  cr_thread(void* lpThreadParameter)
{	
	struct classroom_desc*pcd=(struct classroom_desc*)lpThreadParameter;
	struct session_desc*psd;
	char buf[32768];
	fd_set fdrset;
	fd_set fdwset;
	struct timeval tv;
	struct sockaddr_in saddr;
	struct list_head* n = NULL;
  	struct list_head* get = NULL;
	struct list_head* n2 = NULL;
  	struct list_head* get2 = NULL;
	int ret;
	int nb;
	struct event_desc*ped=(struct event_desc*)buf;
	struct request_desc*prd=(struct request_desc*)buf;
	struct turn_msg_desc*ptmd = (struct turn_msg_desc*)buf;
	printf("%s,%d,ok begin classroom thread\n",__FUNCTION__,__LINE__);
	while(1){
		FD_ZERO(&fdrset);
		FD_ZERO(&fdwset);
		if (pcd->srv_socket_handle && pcd->srv_socket_handle != -1){
			socket_fd_set(pcd->srv_socket_handle, &fdrset);
			if(pcd->socket_status==SOCKET_STATUS_CONNECTING){
				socket_fd_set(pcd->srv_socket_handle, &fdwset);
			}
		}
		
		if (pcd->tcp_srv_sd.sock_handle && pcd->tcp_srv_sd.sock_handle != -1){
			if(pcd->tcp_srv_sd.status==SOCKET_STATUS_CONNECTING){
				socket_fd_set(pcd->tcp_srv_sd.sock_handle, &fdwset);
			}
			socket_fd_set(pcd->tcp_srv_sd.sock_handle, &fdrset);
		}
		
		list_iterate_safe(get, n, &pcd->session_list_head){
			psd = list_get(get, struct session_desc, list);
			if (psd->sess_sd.sock_handle && psd->sess_sd.sock_handle != -1){
				socket_fd_set(psd->sess_sd.sock_handle, &fdrset);
				if(psd->sess_sd.status==SOCKET_STATUS_CONNECTING|| psd->sess_sd.status==SOCKET_STATUS_WRITE_WOULDBLOCK){
					socket_fd_set(psd->sess_sd.sock_handle, &fdwset);
				}
			}
		}
		tv.tv_sec = 0;
		tv.tv_usec = 30000;
		
		ret=select(FD_SETSIZE,&fdrset,&fdwset,0,&tv);
		if(ret<0){
			printf("%s,select error:%d\n",__FUNCTION__,GetLastError);
		}else if(ret==0){
			
		}else{
			ptmd = (struct turn_msg_desc*)buf;
/*******************************SESSION****************************************/
			list_iterate_safe(get, n, &pcd->session_list_head){
				psd = list_get(get, struct session_desc, list);
				if (socket_fd_isset(psd->sess_sd.sock_handle, &fdwset)){
					if(psd->sess_sd.status==SOCKET_STATUS_CONNECTING){
			 			int err;
						int socklen = sizeof(struct sockaddr_in);
						if(socket_getsockopt(psd->sess_sd.sock_handle, SOL_SOCKET, SO_ERROR, (char *)&err, &socklen)==SOCKET_ERROR){
							goto next;
						}
						if (err == 0){
							psd->sess_sd.status=SOCKET_STATUS_CONNECTED;
							printf("%s,%d\n",__FUNCTION__,__LINE__);
							MAKE_TO_APP_SESSION_HANDLE(psd->usr,psd,ntohl(psd->slaver_addr.sin_addr.s_addr),ntohs(psd->slaver_addr.sin_port),pcd->ec,pcd->usr);
						}else{
next:
							printf("%s,%d,%d\n",__FUNCTION__,__LINE__,err);
							MAKE_TO_APP_SESSION_HANDLE(psd->usr,-1,0,0,pcd->ec, pcd->usr);
							socket_close(psd->sess_sd.sock_handle);
							LIST_DEL(&psd->list);
							free(psd);
							continue;
						}
					}else if(psd->sess_sd.status==SOCKET_STATUS_WRITE_WOULDBLOCK){
						printf("%s,%d send can be used\n",__FUNCTION__,__LINE__);
						psd->sess_sd.status=SOCKET_STATUS_CONNECTED;
						MAKE_TO_APP_SESSION_NET_USEABLE(pcd->ec,pcd->usr);
					}
				}	
				
				if (socket_fd_isset(psd->sess_sd.sock_handle, &fdrset)){
					if(psd->protocol==IPPROTO_UDP){
						
						int saddr_size = sizeof(struct sockaddr_in);
						nb = socket_recv(psd->sess_sd.sock_handle, buf, sizeof(buf), 0,&saddr, &saddr_size);
						if(nb==SOCKET_ERROR ){
							printf("%s,%d,%d\n",__FUNCTION__,__LINE__,GetLastError);
							//internal_delete_session(psd);
						}else if(nb>0){
							MAKE_TO_APP_SESSION_RECV_DATA(psd->usr,psd,nb,(uint8_t*)buf,ntohs(saddr.sin_port),pcd->ec,pcd->usr);
						}	
					}else{
						nb=socket_recv(psd->sess_sd.sock_handle,(char*)buf,sizeof(buf),0,NULL,NULL);
						if(nb==SOCKET_ERROR){
							printf("%s,%d,%d\n",__FUNCTION__,__LINE__,GetLastError);
							internal_delete_session(psd);
						}else{
							MAKE_TO_APP_SESSION_RECV_DATA(psd->usr,psd,nb,(uint8_t*)buf,0,pcd->ec,pcd->usr);
						}
					}	
				}
			}
			
/******************************CLASSROOM*************************************/
			if (socket_fd_isset(pcd->tcp_srv_sd.sock_handle, &fdrset)){
				
				nb = socket_recv(pcd->tcp_srv_sd.sock_handle, buf, sizeof(buf), 0,NULL,NULL);
				
				if(nb==SOCKET_ERROR){	
					/*教室异常*/
					printf("%s,%d,%d\n",__FUNCTION__,__LINE__,GetLastError);
					goto out;
				}
				else{
					uint32_t pos=0;
					while(nb){
						printf("ptmd->msg_id:%d,nb:%d\n",ptmd->msg_id,nb);
						struct turn_msg_desc*ptmd=(struct turn_msg_desc*)(buf+pos);
						nb-=sizeof(struct turn_msg_desc);
						pos+=sizeof(struct turn_msg_desc);
						switch(ptmd->msg_id){
							case FROM_SERVER_RESP_CREATE_SESSION:
							{	
								struct from_server_resp_create_session*pfsrcs=(struct from_server_resp_create_session*)ptmd->data;
								
								list_iterate_safe(get, n, &pcd->session_list_head){
									psd = list_get(get, struct session_desc, list);
									
									if(psd==pfsrcs->usr_sess_handle){
										printf("%s,%d usr_sess_handle:0x%x,psd:0x%x,master port:%d\n",__FUNCTION__,__LINE__,pfsrcs->usr_sess_handle,psd,pfsrcs->master_srv_port);
										psd->slaver_addr.sin_family=AF_INET;
										psd->slaver_addr.sin_addr.s_addr=htonl(pfsrcs->slaver_srv_addr);
										psd->slaver_addr.sin_port=htons(pfsrcs->slaver_srv_port);
										psd->master_addr.sin_family=AF_INET;
										psd->master_addr.sin_addr.s_addr=htonl(pfsrcs->master_srv_addr);
										psd->master_addr.sin_port=htons(pfsrcs->master_srv_port);
										psd->master_srv_id=pfsrcs->master_id;
										
										if(psd->master_srv_id==-1){
											MAKE_TO_APP_SESSION_HANDLE(psd->usr,-1,ntohl(psd->slaver_addr.sin_addr.s_addr),ntohs(psd->slaver_addr.sin_port),pcd->ec,pcd->usr);
											LIST_DEL(&psd->list);
											free(psd);
										}else{
											psd->sess_sd.sock_handle = create_socket(pcd->socket_mgr_handle, pcd->ssrc,psd->protocol, &psd->master_addr, psd->send_buf_size, psd->recv_buf_size);
											if (psd->sess_sd.sock_handle == -1){
												MAKE_TO_APP_SESSION_HANDLE(psd->usr,-1,ntohl(psd->slaver_addr.sin_addr.s_addr),ntohs(psd->slaver_addr.sin_port),pcd->ec,pcd->usr);
												LIST_DEL(&psd->list);
												free(psd);
											}else{
												if(psd->protocol==IPPROTO_UDP){
													psd->sess_sd.status=SOCKET_STATUS_CONNECTED;
													MAKE_TO_APP_SESSION_HANDLE(psd->usr,psd,ntohl(psd->slaver_addr.sin_addr.s_addr),ntohs(psd->slaver_addr.sin_port),pcd->ec,pcd->usr);
												}
												else{
													psd->sess_sd.status=SOCKET_STATUS_CONNECTING;
													gettimeofday(&psd->sess_sd.connect_time,NULL);
												}
											}
										}
										break;
									}
								}
								pos+=sizeof(struct from_server_resp_create_session);
								nb-=sizeof(struct from_server_resp_create_session);
							}
								break; 
						}
					}
				}	
			}		
			
			if (socket_fd_isset(pcd->tcp_srv_sd.sock_handle, &fdwset)){
				if(pcd->tcp_srv_sd.status==SOCKET_STATUS_CONNECTING){
					int err;
					int socklen = sizeof(struct sockaddr_in);
					if(socket_getsockopt(pcd->tcp_srv_sd.sock_handle, SOL_SOCKET, SO_ERROR, (char *)&err, &socklen)==SOCKET_ERROR){
						printf("%s,%d,%d\n",__FUNCTION__,__LINE__,err);
						goto out;
					}
					if (err == 0){
						pcd->tcp_srv_sd.status=SOCKET_STATUS_CONNECTED;
						printf("%s,%d,%d\n",__FUNCTION__,__LINE__,GetLastError);
						MAKE_TO_APP_CR_HANDLE(pcd, pcd->cr_srv_id,ntohl(pcd->srv_cr_addr.sin_addr.s_addr),ntohs(pcd->srv_cr_addr.sin_port),pcd->ssrc,pcd->ec, pcd->usr);
					}else{
						printf("%s,%d,%d\n",__FUNCTION__,__LINE__,err);
						goto out;
					}
				}
			}
			
			if (socket_fd_isset(pcd->srv_socket_handle, &fdwset)){
				if(pcd->socket_status==SOCKET_STATUS_CONNECTING){
					int err;
					int socklen = sizeof(struct sockaddr_in);
					if(socket_getsockopt(pcd->srv_socket_handle, SOL_SOCKET, SO_ERROR, (char *)&err, &socklen)==SOCKET_ERROR){
						printf("%s,%d,%d\n",__FUNCTION__,__LINE__,err);
						goto out;
					}
					if (err == 0){
						pcd->socket_status=SOCKET_STATUS_CONNECTED;
						if (cmd_create_classroom(pcd->srv_socket_handle) == -1){
							printf("%s,%d,%d\n",__FUNCTION__,__LINE__,GetLastError);
						}else{
							printf("%s,%d\n",__FUNCTION__,__LINE__);
						}
					}else{
						printf("%s,%d,%d\n",__FUNCTION__,__LINE__,err);
						goto out;
					}
				}
			}
			
/****************************处理服务器消息**************************/
			if (socket_fd_isset(pcd->srv_socket_handle, &fdrset)){
				
				int saddr_size = sizeof(struct sockaddr_in);
				nb = socket_recv(pcd->srv_socket_handle, buf, sizeof(buf), 0,NULL,NULL);
				if(nb==SOCKET_ERROR){
					printf("%s,%d,%d\n",__FUNCTION__,__LINE__,GetLastError);
					if(pcd->cr_srv_handle==0 || pcd->cr_srv_handle==-1){
						/*教师还未创建*/
						printf("%s,%d,%d\n",__FUNCTION__,__LINE__,GetLastError);
						goto out;
					}
				}
				else{	
					switch(prd->request_id){
						case REPLY_CREATE_CLASSROOM:
						{	
							struct reply_create_classroom*prcc=(struct reply_create_classroom*)prd->data;
							pcd->cr_srv_handle=prcc->handle;
							pcd->cr_srv_id=prcc->cr_id;
							pcd->srv_cr_addr.sin_family=AF_INET;
							pcd->srv_cr_addr.sin_port=(uint16_t)htons(prcc->turnserver_port);
							pcd->srv_cr_addr.sin_addr.s_addr=pcd->srv_addr.sin_addr.s_addr;
							if (pcd->cr_srv_id > 0){
								
								socket_close(pcd->srv_socket_handle);
								pcd->srv_socket_handle=-1;
								printf("srv_cr_addr %s:%d\n",inet_ntoa(pcd->srv_cr_addr.sin_addr),prcc->turnserver_port&0xffff);
								pcd->tcp_srv_sd.sock_handle = create_socket(pcd->socket_mgr_handle, pcd->ssrc,IPPROTO_TCP, &pcd->srv_cr_addr, 0, 0);
								if (pcd->tcp_srv_sd.sock_handle == -1){
									printf("%s,%d,%d\n",__FUNCTION__,__LINE__,GetLastError);
									goto out;
								}else{
									printf("%s,%d,%d\n",__FUNCTION__,__LINE__,GetLastError);
									pcd->tcp_srv_sd.status=SOCKET_STATUS_CONNECTING;
								}
							}else{
								printf("%s,%d\n",__FUNCTION__,__LINE__);
								goto out;
							}
						}
							break;
					}
				}
			}
		}
/*************************处理CLASSROOM上层消息******************************/
		ped=(struct event_desc*)buf;
		ped->evt_id=TO_APP_CR_PROC_MSG;
		ped->len=0;
		pcd->ec(pcd->usr,ped);
		if(ped->evt_id!=TO_APP_CR_PROC_MSG){
			switch(ped->evt_id){
				case FROM_APP_DELETE_CR:
				{	
					goto out;
				}	
				break;
				case FROM_APP_CREATE_SESSION:
				{	
					if(pcd->cr_srv_handle==0){
						printf("%s,%d,can not create session\n",__FUNCTION__,__LINE__);
					}else{
						printf("%s,%d\n",__FUNCTION__,__LINE__);
						struct from_app_create_session*pfacs=(struct from_app_create_session*)ped->data;
						psd=create_p2p_session(pcd,pfacs->protocol,pfacs->usr,pfacs->delay,pfacs->send_buf_size,pfacs->recv_buf_size);
						if(psd==NULL){
							MAKE_TO_APP_SESSION_HANDLE(pfacs->usr,-1,0,0,pcd->ec, pcd->usr);
						}
					}
				}
				break;
				case FROM_APP_DELETE_SESSION:
				{
					struct from_app_delete_session*pfads=(struct from_app_delete_session*)ped->data;
					list_iterate_safe(get, n, &pcd->session_list_head){
						psd = list_get(get, struct session_desc, list);
						if(psd==pfads->session_handle){
							internal_delete_session(psd);
							break;
						}
					}
				}
				break;
			}
		}
/*********************************可写数据/线程周期************************************/
				list_iterate_safe(get, n, &pcd->session_list_head){

					int i=0,k;
					ped=(struct event_desc*)buf;
					psd = list_get(get, struct session_desc, list);
					if(psd->sess_sd.status!=SOCKET_STATUS_CONNECTED)continue;
					ped->evt_id=TO_APP_SESSION_WRITABLE;
					struct to_app_session_writable*ptasw=(struct to_app_session_writable*)ped->data;
					ptasw->session_handle=psd;
					ptasw->user=psd->usr; 
					ptasw->data_len=0;
					ptasw->data=(uint8_t*)psd->sess_sd.buf;
					if(psd->protocol==IPPROTO_UDP){
						/*只取最大一个MSS_SIZE的包*/
						while(1){
							ptasw->data=(uint8_t*)(psd->sess_sd.buf+psd->sess_sd.recv_pos);
							ptasw->data_len=MSS_SIZE-psd->sess_sd.recv_pos;
							pcd->ec(pcd->usr,ped);
							if(ptasw->data_len==0 && psd->sess_sd.recv_pos>0){
								int nb;
								nb=socket_send(psd->sess_sd.sock_handle,(char*)psd->sess_sd.buf,psd->sess_sd.recv_pos,0,&psd->master_addr,sizeof(struct sockaddr_in));
								if(nb==SOCKET_ERROR){
									printf("%s sendto error:%d\n",__FUNCTION__,WSAGetLastError);
								}else{
									struct PacketHeader*ph=(struct PacketHeader*)psd->sess_sd.buf;
									//printf("sendto server master port:%d num:%d,real:%d,ssrc:0x%x,magic:0x%x\n",ntohs(psd->master_addr.sin_port),psd->sess_sd.recv_pos,nb,ph->ssrc,ph->magic);
								}
								//printf("%s %d nb:%d,recv_pos:%d\n",__FUNCTION__,__LINE__,nb,psd->sess_sd.recv_pos);
								psd->sess_sd.recv_pos=0;
							}
							else if(ptasw->data_len==0xffffffff){
								break;
							}else{
								psd->sess_sd.recv_pos+=ptasw->data_len;
							}
						}
						
					}else{
					/*取空缓冲区队列*/
					if((psd->sess_sd.recv_pos-psd->sess_sd.sent_pos)<MSS_SIZE){
						while(1){
							ptasw->data=(uint8_t*)(psd->sess_sd.buf+psd->sess_sd.recv_pos);
							ptasw->data_len=sizeof(psd->sess_sd.buf)-psd->sess_sd.recv_pos;
							pcd->ec(pcd->usr,ped);
							if(ptasw->data_len){
								psd->sess_sd.recv_pos+=ptasw->data_len;
							}else{
								break;
							}
						}
						if(psd->delay && (psd->sess_sd.recv_pos-psd->sess_sd.sent_pos)<MSS_SIZE){
							//printf("%s,%d psd->sess_sd.sent_pos:%dpsd->sess_sd.recv_pos:%d\n",__FUNCTION__,__LINE__,psd->sess_sd.sent_pos,psd->sess_sd.recv_pos);
							continue;
						}
					}
						while(psd->sess_sd.sent_pos<psd->sess_sd.recv_pos){
							int snd_nb;
							snd_nb=(psd->sess_sd.recv_pos-psd->sess_sd.sent_pos)>MSS_SIZE?MSS_SIZE:(psd->sess_sd.recv_pos-psd->sess_sd.sent_pos);
							if(psd->delay && snd_nb<MSS_SIZE){
								if(psd->sess_sd.sent_pos>0){
									memcpy(psd->sess_sd.buf,psd->sess_sd.buf+psd->sess_sd.sent_pos,snd_nb);
									psd->sess_sd.recv_pos=snd_nb;
									psd->sess_sd.sent_pos=0;
								}
								break;
							}
							nb=socket_send(psd->sess_sd.sock_handle,(char*)psd->sess_sd.buf+psd->sess_sd.sent_pos,snd_nb,0,&psd->master_addr,sizeof(struct sockaddr_in));
							if(nb==SOCKET_ERROR){
								int err=WSAGetLastError;
								printf("%s,%d,send tcp buf error:%d\n",__FUNCTION__,__LINE__,err);
								if(err==EAGAIN){
									printf("%s,%d send need to wait...\n",__FUNCTION__,__LINE__);
									psd->sess_sd.status=SOCKET_STATUS_WRITE_WOULDBLOCK;
									MAKE_TO_APP_SESSION_NET_DELAY(pcd->ec,pcd->usr);
								}else{
									internal_delete_session(psd);
								}
								break;
							}else{
								psd->sess_sd.sent_pos+=snd_nb;
							}
							if(psd->sess_sd.sent_pos==psd->sess_sd.recv_pos){
								psd->sess_sd.sent_pos=psd->sess_sd.recv_pos=0;
							}
						}
					}
				}
				struct timeval  cur_time;
				uint32_t ms;
				gettimeofday(&cur_time,NULL);
				if(pcd->last_time.tv_sec==0 && pcd->last_time.tv_usec==0){
					pcd->last_time=cur_time;
					ms=0;
				}else{
					if(cur_time.tv_usec<pcd->last_time.tv_usec){
						ms=(cur_time.tv_sec-pcd->last_time.tv_sec-1)*1000+1000+(cur_time.tv_usec-pcd->last_time.tv_usec)/1000;
					}else{
						ms=(cur_time.tv_sec-pcd->last_time.tv_sec)*1000+(cur_time.tv_usec-pcd->last_time.tv_usec)/1000;
					}
					pcd->last_time=cur_time;
				}
				MAKE_TO_APP_CR_THREAD_STEP(ms,pcd->ec, pcd->usr);

				/*计算连接超时10秒*/
				list_iterate_safe(get, n, &pcd->session_list_head){
					psd = list_get(get, struct session_desc, list);
					if(psd->sess_sd.status==SOCKET_STATUS_CONNECTING){
						ms=cur_time.tv_sec-psd->sess_sd.connect_time.tv_sec;
					}	
					//printf("%s,%d,%d,%d\n",__FUNCTION__,__LINE__,cur_time.wSecond,pssd->sd.connect_time.wSecond);
					if(ms>=SES_CONN_TIMEOUT){
						internal_delete_session(psd);
					}
					
				}
			}
out:
	
	list_iterate_safe(get, n, &pcd->session_list_head){
		psd = list_get(get, struct session_desc, list);
		internal_delete_session(psd);
	}
	if(pcd->socket_mgr_handle && pcd->socket_mgr_handle!=-1){
		if(pcd->tcp_srv_sd.sock_handle && pcd->tcp_srv_sd.sock_handle!=-1)
			socket_close(pcd->tcp_srv_sd.sock_handle);
		if(pcd->srv_socket_handle && pcd->srv_socket_handle!=-1)
			socket_close(pcd->srv_socket_handle);
		socket_manager_delete(pcd->socket_mgr_handle);
	}
	MAKE_TO_APP_CR_HANDLE(-1,0,0,0,pcd->ssrc,pcd->ec,pcd->usr);
	MAKE_TO_APP_CR_THREAD_STEP(0,pcd->ec, pcd->usr);
	
	free(pcd);
	return 0;
}
int cr_create_classroom(struct sockaddr_in*srv_addr,  event_callback ec, void*usr)
{	
	struct classroom_desc*pcd=(struct classroom_desc*)malloc(sizeof(struct classroom_desc));
	if(!pcd)return -1;
	memset(pcd,0,sizeof(struct classroom_desc));
	INIT_LIST(pcd->session_list_head);
	pcd->socket_mgr_handle=socket_manager_create();
	if(pcd->socket_mgr_handle==-1){
		free(pcd);
		return -1;
	}
	srand(time(0));
	uint8_t*p=(uint8_t*)&pcd->ssrc;
	int i;
	for(i=0;i<4;i++){
		p[i]=rand()%256;
	}
	
	pcd->ec=ec;
	pcd->usr=usr;
	pcd->srv_addr=*srv_addr;
	pcd->srv_socket_handle=create_socket(pcd->socket_mgr_handle,pcd->ssrc,IPPROTO_TCP,&pcd->srv_addr,0,0);
	
	if (pcd->srv_socket_handle == -1){
		free(pcd);
		return -1;
	}
	pcd->socket_status=SOCKET_STATUS_CONNECTING;
	
	pcd->thread_handle = pthread_create(&pcd->thread_id, NULL,cr_thread, (void*)pcd);
	if(pcd->thread_handle != 0){
		socket_close(pcd->srv_socket_handle);
		free(pcd);
		return -1;
	}
	return 0;
}
	
int cr_delete_classroom(void * handle,struct event_desc*ped)
{	
	struct classroom_desc*pcd=(struct classroom_desc*)handle;
	if(handle==0 || handle==-1)return 0;
	ped->evt_id=FROM_APP_DELETE_CR;
	ped->len=0;
	return sizeof(struct event_desc)+ped->len;
}	
	
int cr_create_session(struct event_desc*ped,void*usr,int protocol,int delay,int send_buf_size,int recv_buf_size)
{	
	struct from_app_create_session*pfacs=(struct from_app_create_session*)ped->data;
	printf("%s,%d\n",__FUNCTION__,__LINE__);
	ped->evt_id=FROM_APP_CREATE_SESSION;
	ped->len=sizeof(struct from_app_create_session);
	pfacs->protocol=protocol;
	pfacs->usr=usr;
	pfacs->send_buf_size=send_buf_size;
	pfacs->recv_buf_size=recv_buf_size;
	pfacs->delay=delay;
	return sizeof(struct event_desc)+ped->len;
}	
int cr_delete_session(void * session_handle,struct event_desc*ped){
	
	struct from_app_delete_session*pfads=(struct from_app_delete_session*)ped->data;
	ped->evt_id=FROM_APP_DELETE_SESSION;
	ped->len=sizeof(struct from_app_delete_session);
	pfads->session_handle=session_handle;
	return sizeof(struct event_desc)+ped->len;
}	
	
struct slaver_classroom_desc;
struct slaver_session_desc
{	
	struct sockaddr_in slaver_srv_addr;
	struct socket_desc sd;
	int send_buf_size;
	int recv_buf_size;
	int delay;
	int protocol;
	struct list_head list;
	struct slaver_classroom_desc*pscd;
	void*usr;
	uint32_t ssrc;
};	
	
struct slaver_classroom_desc
{
	struct list_head slaver_ssession_list_head;
	  int thread_handle;
	pthread_t thread_id;
	
	event_callback ec;
	void*usr;
	struct timeval  last_time;
	uint32_t ssrc;
	void *socket_mgr_handle;
};

struct from_app_join_session
{
	int protocol;
	struct sockaddr_in slaver_srv_addr;
	void*usr;
	int send_buf_size;
	int recv_buf_size;
	int delay;
};
struct from_app_quit_session
{
	void * session_handle;
};
static void internal_slaver_delete_session(struct slaver_session_desc*pssd)
{
	if(pssd->sd.sock_handle && pssd->sd.sock_handle!=-1)
		socket_close(pssd->sd.sock_handle);
	LIST_DEL(&pssd->list);
	MAKE_TO_APP_SESSION_HANDLE(pssd->usr,-1,0,0,pssd->pscd->ec,pssd->pscd->usr);
	free(pssd);
}
#if 0
static void segv_signal_handler()
{
	void *buffer[30] = {0};
 	size_t size;
 	char **strings = NULL;
 	size_t i = 0;
	
	size = backtrace(buffer, 30);
	printf("size:%d\n",size);
 	strings = backtrace_symbols(buffer, size);
	for (i = 0; i < size; i++)
 	{
 		if(strings[i])
  			printf("%s\n", strings[i]);
		else printf("string[i] is null\n");
 	}
	free(strings);
	signal(SIGABRT,SIG_DFL);
}
#endif
static void signal_handler(int code)
{
  printf("receive signal: %s\n", code);
  switch(code)
  	{
		case SIGABRT:
			//segv_signal_handler();
			break;
  	}
}
static void*  cr_slaver_thread(void* lpThreadParameter)
{	
	struct slaver_classroom_desc*pscd=(struct slaver_classroom_desc*)lpThreadParameter;
	char buf[32768];
	fd_set fdrset;
	fd_set fdwset;
	int ret;
	int nb;
	struct timeval  cur_time;
	uint32_t ms;
	struct timeval tv;
	struct sockaddr_in saddr;
	struct slaver_session_desc*pssd;
	struct sigaction sa;
	
	sa.sa_handler = signal_handler;
  	sigemptyset(&sa.sa_mask);
	sa.sa_flags = SA_NOCLDSTOP;
	// sa.sa_restorer = NULL;
  	sa.sa_flags = 0;
	sigaction(SIGABRT, &sa, NULL);
	
	struct list_head* n = NULL;
  	struct list_head* get = NULL;
	struct event_desc*ped=(struct event_desc*)buf;
	struct turn_msg_desc*ptmd=(struct turn_msg_desc*)buf;
	printf( "%s,%d,thread2:%d\n",__FUNCTION__,__LINE__,getpid());
	MAKE_TO_APP_CR_HANDLE(pscd,0,0,0,pscd->ssrc,pscd->ec, pscd->usr);
	while(1){		
		FD_ZERO(&fdrset);
		FD_ZERO(&fdwset);
		
		list_iterate_safe(get, n, &pscd->slaver_ssession_list_head){
			pssd = list_get(get, struct slaver_session_desc, list);
            
			socket_fd_set(pssd->sd.sock_handle,&fdrset);
            
			if(pssd->sd.status==SOCKET_STATUS_CONNECTING || pssd->sd.status==SOCKET_STATUS_WRITE_WOULDBLOCK){
				socket_fd_set(pssd->sd.sock_handle, &fdwset);
			}	
		}
		tv.tv_sec = 0;
		tv.tv_usec = 30000;
		ret=select(FD_SETSIZE,&fdrset,&fdwset,0,&tv);
		if(ret<0){
			int err=GetLastError;
		//	printf("%s,select error:%d\n",__FUNCTION__,err);
			if(err!=10022)
				goto out;
		}else if(ret==0){  
			
		}else{
			list_iterate_safe(get, n, &pscd->slaver_ssession_list_head){
				pssd = list_get(get, struct slaver_session_desc, list);
				if (socket_fd_isset(pssd->sd.sock_handle, &fdrset)){
					if(pssd->protocol==IPPROTO_UDP){
						struct sockaddr_in saddr;
						int saddr_size = sizeof(struct sockaddr_in);
						nb = socket_recv(pssd->sd.sock_handle, buf, sizeof(buf), 0, &saddr, &saddr_size);
						if(nb==SOCKET_ERROR){
							printf("%s,%d,%d\n",__FUNCTION__,__LINE__,GetLastError);
						}else if(nb>0){
							MAKE_TO_APP_SESSION_RECV_DATA(pssd->usr,pssd,nb,(uint8_t*)buf,ntohs(saddr.sin_port),pscd->ec,pscd->usr);
						}
					}else{
						nb=socket_recv(pssd->sd.sock_handle,(char*)buf,sizeof(buf),0,NULL,NULL);
						if(nb==SOCKET_ERROR){
							
							printf("%s,%d,%d,%d\n",__FUNCTION__,__LINE__,GetLastError,nb);
							internal_slaver_delete_session(pssd);
							continue;
						}else{
							//printf("%s,%d slaver received tcp packet size:%d\n",__FUNCTION__,__LINE__,nb);
							MAKE_TO_APP_SESSION_RECV_DATA(pssd->usr,pssd,nb,(uint8_t*)buf,0,pscd->ec,pscd->usr);
						}
					}
				}
				if (socket_fd_isset(pssd->sd.sock_handle, &fdwset)){
					if(pssd->sd.status==SOCKET_STATUS_CONNECTING){
						int err;
						int socklen = sizeof(struct sockaddr_in);
						if(socket_getsockopt(pssd->sd.sock_handle, SOL_SOCKET, SO_ERROR, (char *)&err, &socklen)==SOCKET_ERROR){
							printf("%s,%d,%d\n",__FUNCTION__,__LINE__,err);
						}else{
							if (err == 0){
								pssd->sd.status=SOCKET_STATUS_CONNECTED;
								MAKE_TO_APP_SESSION_HANDLE(pssd->usr,pssd,0,0,pscd->ec,pscd->usr);
								printf("%s,%d\n",__FUNCTION__,__LINE__);
							}else{
								printf("%s,%d,%d\n",__FUNCTION__,__LINE__,err);
							}
						}
					}else if(pssd->sd.status==SOCKET_STATUS_WRITE_WOULDBLOCK){
						printf("%s,%d,send can be used\n",__FUNCTION__,__LINE__);
						pssd->sd.status = SOCKET_STATUS_CONNECTED;
						MAKE_TO_APP_SESSION_NET_USEABLE(pscd->ec,pscd->usr);
					}
				}
			}
		}
/********************************writable****************************************/
		list_iterate_safe(get, n, &pscd->slaver_ssession_list_head){
		int i=0,k;
		ped=(struct event_desc*)buf;
		pssd = list_get(get, struct slaver_session_desc, list);
		if(pssd->sd.status!=SOCKET_STATUS_CONNECTED)continue;
		ped->evt_id=TO_APP_SESSION_WRITABLE;
		struct to_app_session_writable*ptasw=(struct to_app_session_writable*)ped->data;
		ptasw->session_handle=pssd;
		ptasw->user=pssd->usr; 
		ptasw->data_len=0;
		ptasw->data=(uint8_t*)pssd->sd.buf;
		/*取空缓冲区队列*/
		if(pssd->protocol==IPPROTO_UDP){
		/*只取最大一个MSS_SIZE的包*/
			while(1){
				ptasw->data=(uint8_t*)(pssd->sd.buf+pssd->sd.recv_pos);
				ptasw->data_len=MSS_SIZE-pssd->sd.recv_pos;
				pscd->ec(pscd->usr,ped);
				if(ptasw->data_len==0 && pssd->sd.recv_pos>0){
					nb=socket_send(pssd->sd.sock_handle,(char*)pssd->sd.buf,pssd->sd.recv_pos,0,&pssd->slaver_srv_addr,sizeof(struct sockaddr_in));
					if(nb==SOCKET_ERROR){
						printf("%s sendto error:%d\n",__FUNCTION__,WSAGetLastError);
					}else{
						struct PacketHeader*ph=(struct PacketHeader*)pssd->sd.buf;
						printf("sendto slaver port:%d num:%d,real:%d,ssrc:0x%x,magic:0x%x\n",ntohs(pssd->slaver_srv_addr.sin_port),pssd->sd.recv_pos,nb,ph->ssrc,ph->magic);
					}
					printf("%s %d nb:%d,recv_pos:%d\n",__FUNCTION__,__LINE__,nb,pssd->sd.recv_pos);
					pssd->sd.recv_pos=0;
				}else if(ptasw->data_len==0xffffffff){
					break;
				}else{
					pssd->sd.recv_pos+=ptasw->data_len;
				}
			}
		}
		else{
		if((pssd->sd.recv_pos-pssd->sd.sent_pos)<MSS_SIZE){
			while(1){
				ptasw->data=(uint8_t*)(pssd->sd.buf+pssd->sd.recv_pos);
				ptasw->data_len=sizeof(pssd->sd.buf)-pssd->sd.recv_pos;
				pscd->ec(pscd->usr,ped);
				if(ptasw->data_len){
					pssd->sd.recv_pos+=ptasw->data_len;
				}else{
					break;
				}
			}
			if(pssd->delay && (pssd->sd.recv_pos-pssd->sd.sent_pos)<MSS_SIZE){
				//printf("%s,%d pssd->sd.sent_pos:%d pssd->sd.recv_pos:%d\n",__FUNCTION__,__LINE__,pssd->sd.sent_pos,pssd->sd.recv_pos);
				continue;
			}
		}
		
		while(pssd->sd.sent_pos<pssd->sd.recv_pos){
			int snd_nb;
			snd_nb=(pssd->sd.recv_pos-pssd->sd.sent_pos)>MSS_SIZE?MSS_SIZE:(pssd->sd.recv_pos-pssd->sd.sent_pos);
			if(pssd->delay && snd_nb<MSS_SIZE){
				if(pssd->sd.sent_pos>0){
					memcpy(pssd->sd.buf,pssd->sd.buf+pssd->sd.sent_pos,snd_nb);
					pssd->sd.recv_pos=snd_nb;
					pssd->sd.sent_pos=0;
				}
				break;
			}
			nb=socket_send(pssd->sd.sock_handle,(char*)pssd->sd.buf+pssd->sd.sent_pos,snd_nb,0,&pssd->slaver_srv_addr,sizeof(struct sockaddr_in));
			if(nb==SOCKET_ERROR){
				int err=WSAGetLastError;
				printf("%s,%d,send tcp buf error:%d\n",__FUNCTION__,__LINE__,err);
				if(err==EAGAIN){
					printf("%s,%d send need to wait...\n",__FUNCTION__,__LINE__);
					pssd->sd.status=SOCKET_STATUS_WRITE_WOULDBLOCK;
					MAKE_TO_APP_SESSION_NET_DELAY(pscd->ec,pscd->usr);
				}else{
					internal_slaver_delete_session(pssd);
				}
				break;
			}else{
				pssd->sd.sent_pos+=snd_nb;
			}
			if(pssd->sd.sent_pos==pssd->sd.recv_pos){
				//printf("%s,%d,pssd->sd.sent_pos==pssd->sd.recv_pos\n",__FUNCTION__,__LINE__);
				pssd->sd.sent_pos=pssd->sd.recv_pos=0;
			}
		}
		}
	}
/******************************************************************************/
		ped=(struct event_desc*)buf;
		ped->evt_id=TO_APP_CR_PROC_MSG;
		ped->len=0;
		pscd->ec(pscd->usr,ped);
		if(ped->evt_id!=TO_APP_CR_PROC_MSG){
			switch(ped->evt_id){
				case FROM_APP_JOIN_SESSION:
				{	
					struct from_app_join_session*pfajs=(struct from_app_join_session*)ped->data;
					struct slaver_session_desc*pssd=(struct slaver_session_desc*)malloc(sizeof(struct slaver_session_desc));
					if(!pssd){
						break;
					}
					memset(pssd,0,sizeof(struct slaver_session_desc));
					pssd->protocol=pfajs->protocol;
					pssd->usr=pfajs->usr;
					pssd->delay=pfajs->delay;
					pssd->slaver_srv_addr=pfajs->slaver_srv_addr;
					pssd->send_buf_size=pfajs->send_buf_size;
					pssd->recv_buf_size=pfajs->recv_buf_size;
					pssd->sd.sock_handle=create_socket(pscd->socket_mgr_handle,pscd->ssrc,pssd->protocol,&pfajs->slaver_srv_addr,pssd->send_buf_size,pssd->recv_buf_size);
					if(pssd->sd.sock_handle==-1){
						MAKE_TO_APP_SESSION_HANDLE(pssd->usr,-1,0,0,pscd->ec,pscd->usr);
						free(pssd);
						printf("%s,%d,%d\n",__FUNCTION__,__LINE__,GetLastError);
					}else{
						if(pssd->protocol==IPPROTO_TCP){
							pssd->sd.status=SOCKET_STATUS_CONNECTING;
							gettimeofday(&pssd->sd.connect_time,NULL);
							printf("%s,%d,create tcp connecting...current seconds4:%d\n",__FUNCTION__,__LINE__,pssd->sd.connect_time.tv_sec);
						}else{
							pssd->sd.status=SOCKET_STATUS_CONNECTED;
							MAKE_TO_APP_SESSION_HANDLE(pssd->usr,pssd,0,0,pscd->ec,pscd->usr);
						}
						pssd->pscd=pscd;
						LIST_ADD_TAIL(&pssd->list, &pscd->slaver_ssession_list_head);
						printf("%s,%d,%s:%d\n",__FUNCTION__,__LINE__,inet_ntoa(pssd->slaver_srv_addr.sin_addr),htons(pssd->slaver_srv_addr.sin_port));
					}
				}	
					break;
				case FROM_APP_DELETE_CR:
				{	
					goto out;
				}	
					break;
				case FROM_APP_QUIT_SESSION:
				{	
					struct from_app_quit_session*pfaqs=(struct from_app_quit_session*)ped->data;
					list_iterate_safe(get, n, &pscd->slaver_ssession_list_head){
						pssd = list_get(get, struct slaver_session_desc, list);
						if(pssd==pfaqs->session_handle){
							if(pssd->protocol==IPPROTO_TCP)
								
							socket_close(pssd->sd.sock_handle);
							LIST_DEL(&pssd->list);
							MAKE_TO_APP_SESSION_HANDLE(pssd->usr,-1,0,0,pssd->pscd->ec,pssd->pscd->usr);
							free(pssd);
						}
					}
				}	
					break;
			}
		}
		gettimeofday(&cur_time,NULL);
		if(pscd->last_time.tv_usec==0&&pscd->last_time.tv_sec==0){
			pscd->last_time=cur_time;
			ms=0;
		}else{
			if(cur_time.tv_usec<pscd->last_time.tv_usec){
				ms=(cur_time.tv_sec-pscd->last_time.tv_sec-1)*1000+1000+(cur_time.tv_usec-pscd->last_time.tv_usec)/1000;
			}else{
				ms=(cur_time.tv_sec-pscd->last_time.tv_sec)*1000+(cur_time.tv_usec-pscd->last_time.tv_usec)/1000;
			}
			pscd->last_time=cur_time;
		}
		MAKE_TO_APP_CR_THREAD_STEP(ms,pscd->ec, pscd->usr);
		
		/*计算连接超时SES_CONN_TIMEOUT秒*/
		list_iterate_safe(get, n, &pscd->slaver_ssession_list_head){
			pssd = list_get(get, struct slaver_session_desc, list);
			
			if(pssd->sd.status==SOCKET_STATUS_CONNECTING){
				ms=cur_time.tv_sec-pssd->sd.connect_time.tv_sec;
				printf("%s,%d,%d\n",__FUNCTION__,__LINE__,ms);
				if(ms>=SES_CONN_TIMEOUT){
					internal_slaver_delete_session(pssd);
				}
			}
		}
	}	
out:
	list_iterate_safe(get, n, &pscd->slaver_ssession_list_head){
		pssd = list_get(get, struct slaver_session_desc, list);
		internal_slaver_delete_session(pssd);
	}
	MAKE_TO_APP_CR_HANDLE(-1, 0,0,0,pscd->ssrc,pscd->ec, pscd->usr);
	MAKE_TO_APP_CR_THREAD_STEP(0,pscd->ec, pscd->usr);
	if(pscd->socket_mgr_handle && pscd->socket_mgr_handle!=-1){
		socket_manager_delete(pscd->socket_mgr_handle);
	}
	free(pscd);
	return NULL;
}


int cr_slaver_create_classroom(event_callback ec, void*usr)
{	
#if 0
	 int fd;
  	fflush(stderr);  
  	setvbuf(stderr,NULL,_IONBF,0);
	int save_fd = dup(STDERR_FILENO);
	memset(buf,0,sizeof(buf));
	sprintf(buf,sdcardPath,getpid());
	fd = open(buf,(O_RDWR | O_CREAT), 0644);  
	dup2(fd,STDERR_FILENO); 
	debug(DBG_ATTR, "cr_slaver_create_classroom\n");
#endif
	printf("cr_slaver_create_classroom\n");
	struct slaver_classroom_desc*pscd=(struct slaver_classroom_desc*)malloc(sizeof(struct slaver_classroom_desc));
	if(!pscd)return -1;
	memset(pscd,0,sizeof(struct slaver_classroom_desc));
	pscd->socket_mgr_handle=socket_manager_create();
	if(pscd->socket_mgr_handle==(void*)-1){
		free(pscd);
		return -1;
	}
	srand(time(0));
	uint8_t*p=(uint8_t*)&pscd->ssrc;
	int i;
	for(i=0;i<4;i++){
		p[i]=rand()%256;
	}
	pscd->ec=ec;
	pscd->usr=usr;
	INIT_LIST(pscd->slaver_ssession_list_head);
	
	printf("%s,%d\n",__FUNCTION__,__LINE__);
	pscd->thread_handle = pthread_create(&pscd->thread_id,  NULL, cr_slaver_thread, (void*)pscd);
	if(pscd->thread_handle !=0){
		free(pscd);
		return -1;
	}
	printf("%s,%d thread id:%d\n",__FUNCTION__,__LINE__,pscd->thread_id);
	return 0;
}	
int cr_slaver_delete_classroom(void * handle,struct event_desc*ped)
{	
	ped->evt_id = FROM_APP_DELETE_CR;
	ped->len=0;
	return ped->len+sizeof(struct event_desc);
}	
int cr_join_session(struct sockaddr_in*slaver_srv_addr,  int protocol,void*usr,int delay,int send_buf_size,int recv_buf_size,struct event_desc*ped)
{	
	ped->evt_id=FROM_APP_JOIN_SESSION;
	ped->len=sizeof(struct from_app_join_session);
	struct from_app_join_session*pfajs=(struct from_app_join_session*)ped->data;
	pfajs->protocol=protocol;
	pfajs->usr=usr;
	pfajs->slaver_srv_addr=*slaver_srv_addr;
	pfajs->send_buf_size=send_buf_size;
	pfajs->recv_buf_size=recv_buf_size;
	pfajs->delay=delay;
	return ped->len+sizeof(struct event_desc);
}	
int cr_quit_session(void * session_handle,struct event_desc*ped)
{	
	ped->evt_id=FROM_APP_QUIT_SESSION;
	ped->len=sizeof(struct from_app_quit_session);
	struct from_app_quit_session*pfaqs=(struct from_app_quit_session*)ped->data;
	pfaqs->session_handle = session_handle;
	return ped->len+sizeof(struct event_desc);
}	
void cr_pharse_packet(void*usr,tcp_stream_callback tsc,uint8_t*buf,uint32_t len,uint8_t*buf2,uint32_t*buf_pos,uint16_t src_port)
{	
	uint32_t l_buf_pos=*buf_pos;
	int tmp_nb;
	struct PacketHeader*pph;
	if(len<sizeof(struct PacketHeader)){
		printf("error packet:%d\n",len);
	}
	pph=(struct PacketHeader*)buf;
	
	//printf("recvfrom server port:%d packet len:%d,ssrc:0x%x,magic:0x%x,%d\n",src_port,len,pph->ssrc,pph->magic,l_buf_pos);
	while(len){
			if(l_buf_pos<sizeof(struct PacketHeader)){
				tmp_nb=MIN(sizeof(struct PacketHeader)-l_buf_pos,len);
				memcpy(buf2+l_buf_pos,buf,tmp_nb);
				l_buf_pos+=tmp_nb;
				if(l_buf_pos<sizeof(struct PacketHeader)){
					break;
				}
				len-=tmp_nb;
				buf+=tmp_nb;
				pph=(struct PacketHeader*)buf2;
				if(pph->magic!=0xdeadbeed){
					printf("recv src_port:%d invalid packet:0x%x\n",src_port,pph->magic);
					*buf_pos=0;
					return;
				}
				if(len==0)break;
			}
			pph=(struct PacketHeader*)buf2;
			tmp_nb=MIN(pph->align_len-(l_buf_pos-sizeof(struct PacketHeader)),len);
			memcpy(buf2+l_buf_pos,buf,tmp_nb);
			l_buf_pos+=tmp_nb;
			if(l_buf_pos == pph->align_len+sizeof(struct PacketHeader)){
				tsc(usr,pph);
				l_buf_pos=0;
				buf+=tmp_nb;
				len-=tmp_nb;
			}else{
				break;
			}
	}
	*buf_pos=l_buf_pos;
}




  
