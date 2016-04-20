#ifndef _NET_SOCK_H_
#define _NET_SOCK_H_

#include<sys/select.h>
//#include<android/log.h>


#define LOG_TAG "ETALK_NET"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO , LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)
#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, LOG_TAG, __VA_ARGS__)


extern void write_file_func(char *fmt, ...);
//#define printf LOGI

#define MSS_SIZE (1440-12)

void * socket_manager_create(void);
void socket_manager_delete(void * handle);
void * create_socket(void * mgr_handle,uint32_t ssrc,int protocol,struct sockaddr_in*srv_addr,int send_buf_size,int recv_buf_size);
int socket_send(void * socket_handle,char*buf,int len,int flag,struct sockaddr_in*dst_addr,int sock_len);
int socket_recv(void * socket_handle,char*buf,int len,int flag,struct sockaddr_in*src_addr,int*sock_len);
void socket_close(void * socket_handle);
int socket_getsockopt(void * socket_handle,int level, int optname, char *optval, int *optlen);
int socket_fd_isset(void * socket_handle,fd_set*pfs);
void socket_fd_set(void * socket_handle,fd_set*pfs);












#endif
