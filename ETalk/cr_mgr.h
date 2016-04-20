//
//  cr_mgr.h
//  ClassRoom
//
//  Created by etalk365 on 16/3/7.
//  Copyright © 2016年 深圳市易课科技文化有限公司. All rights reserved.
//

#ifndef cr_mgr_h
#define cr_mgr_h

#include <stdio.h>
#include"commonend.h"
#include"packet.h"

enum {
    TO_APP_CR_HANDLE = 1,
    TO_APP_CR_PROC_MSG,
    TO_APP_SESSION_HANDLE,
    TO_APP_SESSION_RECV_DATA,
    TO_APP_SESSION_WRITABLE,
    TO_APP_SESSION_NET_DELAY,
    TO_APP_SESSION_NET_USEABLE,
    TO_APP_CR_THREAD_STEP,
    TO_APP_CR_MAX,
};
struct to_app_cr_thread_step {
    uint32_t ms;
};
struct to_app_session_proc_msg {
    void *user;
    void * session_handle;
};
struct to_app_session_writable {
    void *user;
    void * session_handle;
    uint32_t data_len;
    uint8_t *data;
};
struct to_app_cr_handle {
    void * cr_local_handle;
    int cr_id;
    uint32_t cr_addr;
    uint16_t cr_port;
    uint16_t pad;
    uint32_t ssrc;
};

struct to_app_session_handle {
    void *user;
    void * session_handle;
    uint32_t slaver_addr;
    uint16_t slaver_port;
    uint16_t pad;
};

struct to_app_session_recv_data {
    void *user;
    void * session_handle;
    uint16_t src_port;
    uint16_t pad;
    uint32_t data_len;
    uint8_t *data;
};


int cr_create_classroom(struct sockaddr_in *srv_addr, event_callback ec, void *usr);

int cr_delete_classroom(void * handle, struct event_desc *ped);

int cr_create_session(struct event_desc *ped, void *usr, int protocol, int delay, int send_buf_size,
                      int recv_buf_size);

int cr_delete_session(void * session_handle, struct event_desc *ped);

int cr_slaver_create_classroom(event_callback ec, void *usr);

int cr_slaver_delete_classroom(void * handle, struct event_desc *ped);

int cr_join_session(struct sockaddr_in *slaver_srv_addr, int protocol, void *usr, int delay,
                    int send_buf_size, int recv_buf_size, struct event_desc *ped);

int cr_quit_session(void * session_handle, struct event_desc *ped);

typedef void(*tcp_stream_callback)(void *usr, struct PacketHeader *pph);

void cr_pharse_packet(void *usr, tcp_stream_callback tsc, uint8_t *buf, uint32_t len, uint8_t *buf2,
                      uint32_t *buf_pos, uint16_t src_port);





#endif /* cr_mgr_h */
