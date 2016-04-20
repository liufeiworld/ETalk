//
//  common.h
//  ClassRoom
//
//  Created by etalk365 on 16/3/7.
//  Copyright © 2016年 深圳市易课科技文化有限公司. All rights reserved.
//

#ifndef commonend_h
#define commonend_h

#include <stdio.h>
#include <stdint.h>
#include <netinet/in.h>
#include "list.h"


/**
 * \def MAX
 * \brief Maximum number of the two arguments.
 */
#define    MAX(a, b) ((a) > (b) ? (a) : (b))

/**
 * \def MIN
 * \brief Minimum number of the two arguments.
 */
#define    MIN(a, b) ((a) < (b) ? (a) : (b))


struct event_desc {
    uint32_t evt_id;
    uint32_t len;
    uint8_t data[0];
};

typedef void(*event_callback)(void *usr, struct event_desc *ped);

enum {
    TO_SESSION_CHECK_REMOVE = 0x1000,
};
struct to_session_check_remove {
    int result;
};
struct app_session_desc;

struct app_slaver_desc {
    struct list_head list;
    uint32_t ssrc;
    struct app_session_desc *pamsd;
};

struct app_classroom_desc;
struct app_session_desc {
    struct list_head app_slaver_list_head;
    struct list_head list;
    uint32_t slaver_srv_addr;
    uint16_t slaver_srv_port;
    uint16_t pad;
    void * p2p_session_handle;
    event_callback cr_ec;
    //classroom����
    event_callback ui_ec;
    //ui��ص�
    void *usr;
    //ui���û�����
    struct app_classroom_desc *pacd;
};

struct app_classroom_desc {
    struct list_head app_session_list_head;
    struct list_head remove_session_list_head;
    struct sockaddr_in srv_addr;
    struct sockaddr_in srv_cr_addr;
    void * p2p_cr_handle;
    void * msg_queue_handle;
    int cr_id;
    uint32_t ssrc;
};



#endif /* commonend_h */
