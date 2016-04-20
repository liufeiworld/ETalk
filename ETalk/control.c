//
//  control.c
//  ClassRoom
//
//  Created by etalk365 on 16/3/7.
//  Copyright © 2016年 深圳市易课科技文化有限公司. All rights reserved.
//

#include "control.h"
#include <string.h>
#include <stdlib.h>
#include "cr_mgr.h"
#include "cr.h"
#include "queue.h"

#define LOGI printf

//#include <iostream>
//queue <struct control_content_param> write_content;
Queue write_content;


struct control_session_slaver_desc {
    struct app_slaver_desc asd;
};

struct control_session_desc {
    struct app_session_desc amsd;
    int role;
    uint8_t buf[4096];
    uint32_t buf_pos;
};


static void control_packet_callback(void *usr, struct PacketHeader *pph) {
    uint8_t buf[32];
    struct event_desc *ped = (struct event_desc *) buf;
    struct control_session_desc *pamsd = (struct control_session_desc *) usr;
    ped->evt_id = TO_APP_SESSION_RECV_DATA;
    ped->len = sizeof(struct to_app_session_recv_data);
    
    struct to_app_session_recv_data *ptasrd = (struct to_app_session_recv_data *) ped->data;
    ptasrd->data = (uint8_t *) (pph + 1);
    ptasrd->data_len = pph->data_len;
    ptasrd->session_handle = pamsd;
    ptasrd->user = pamsd->amsd.usr;
    pamsd->amsd.ui_ec(pamsd->amsd.usr, ped);
}

static void control_event_callback(void *usr, struct event_desc *ped) {
    struct list_head *n = NULL;
    struct list_head *get = NULL;
    uint8_t *buf;
    uint32_t size;
    struct app_slaver_desc *pasd = NULL;
    struct session_slaver_desc *pausd;
    switch (ped->evt_id) {
        case TO_APP_SESSION_NET_DELAY: {
            LOGI("control_event_callback:TO_APP_SESSION_NET_DELAY");
            
        }
            break;
        case TO_APP_SESSION_NET_USEABLE: {
            LOGI("control_event_callback:TO_APP_SESSION_NET_USEABLE");
            
        }
            break;
        case TO_APP_CR_THREAD_STEP: {
            //            LOGI("control_event_callback:TO_APP_CR_THREAD_STEP");
            struct to_app_cr_thread_step *ptacts = (struct to_app_cr_thread_step *) ped->data;
            //            LOGI("%s,%d,ms:%d\n",__FUNCTION__,__LINE__,ptacts->ms);
        }
            break;
        case TO_APP_SESSION_RECV_DATA: {
            //            LOGI("control_event_callback:TO_APP_SESSION_RECV_DATA");
            struct control_session_desc *pamsd = (struct control_session_desc *) usr;
            struct to_app_session_recv_data *ptasrd = (struct to_app_session_recv_data *) ped->data;
            if (pamsd->amsd.p2p_session_handle != ptasrd->session_handle) break;
            
            LOGI("%s: TO_APP_SESSION_RECV_DATA:%d\n", __FUNCTION__, ptasrd->data_len);
            cr_pharse_packet((void *) pamsd, control_packet_callback, ptasrd->data,
                             ptasrd->data_len, pamsd->buf, &pamsd->buf_pos, ptasrd->src_port);
        }
            break;
        case TO_APP_SESSION_WRITABLE: {
            //            LOGI("control_event_callback:TO_APP_SESSION_WRITABLE");
            struct to_app_session_writable *ptasw = (struct to_app_session_writable *) ped->data;
            struct control_session_desc *pamsd = (struct control_session_desc *) usr;
            
            //if(write_content.empty()){
            if (empty(&write_content)) {
                //                LOGI("empty:write_content");
                ptasw->data_len = 0;
                break;
            }
            else {
                struct control_content_param *pccp = NULL;
                pccp = (struct control_content_param *) front(&write_content);
                //buf=(uint8_t *)write_content.front().content.c_str();
                //size = (uint32_t)write_content.front().len;
                buf = (uint8_t *) pccp->context;
                LOGI("buf:%s", buf);
                size = (uint32_t) pccp->len;
                
                struct PacketHeader *pph;
                int len2 = build_packet((uint8_t *) ptasw->data, size, 0, 0, pamsd->amsd.pacd->ssrc,
                                        0xdeadbeed);
                if (len2 > ptasw->data_len) {
                    ptasw->data_len = 0;
                    break;
                }
                pph = (struct PacketHeader *) ptasw->data;
                memcpy((char *) (pph + 1), buf, size);
                ptasw->data_len = len2;
                //write_content.pop();
                pop(&write_content);
            }
        }
            break;
        case TO_APP_SESSION_HANDLE: {
            struct to_app_session_handle *ptash = (struct to_app_session_handle *) ped->data;
            struct control_session_desc *pamsd = (struct control_session_desc *) usr;
            pamsd->amsd.p2p_session_handle = ptash->session_handle;
            LOGI("control_event_callback:TO_APP_SESSION_HANDLE handle = %zd\n", ptash->session_handle);
            if (ptash->session_handle != -1) {
                pamsd->amsd.slaver_srv_addr = ptash->slaver_addr;
                pamsd->amsd.slaver_srv_port = ptash->slaver_port;
                LOGI("audio_addr:%u,audio_port:%u\n", pamsd->amsd.slaver_srv_addr,
                     pamsd->amsd.slaver_srv_port);
                ptash->session_handle =pamsd;
                pamsd->amsd.ui_ec(pamsd->amsd.usr, ped);
            }
            else {
                LIST_DEL(&pamsd->amsd.list);
                list_iterate_safe(get, n, &pamsd->amsd.app_slaver_list_head) {
                    pasd = list_get(get, struct app_slaver_desc, list);
                    LIST_DEL(&pasd->list);
                    LOGI("free %s,%d", __FUNCTION__, __LINE__);
                    free(pasd);
                }
                struct app_classroom_desc *pacd;
                pacd = pamsd->amsd.pacd;
                LIST_ADD_TAIL(&pamsd->amsd.list, &pacd->remove_session_list_head);
            }
        }
            break;
        case TO_SESSION_CHECK_REMOVE: {
            LOGI("control_event_callback:TO_SESSION_CHECK_REMOVE");
            struct to_session_check_remove *ptscr = (struct to_session_check_remove *) ped->data;
            ptscr->result = 1;
        }
            break;
    }
}

int create_control_session(struct event_desc *ped, struct app_classroom_desc *pacd,
                           struct control_session_param *psp) {
    LOGI("create_control_session:InitQueue");
    InitQueue(&write_content, sizeof(struct control_content_param), NULL);
    struct control_session_desc *psd;
    LOGI("malloc %s,%d", __FUNCTION__, __LINE__);
    psd = (struct control_session_desc *) malloc(sizeof(struct control_session_desc));
    if (!psd)
        return -1;
    memset(psd, 0, sizeof(struct control_session_desc));
    psd->amsd.ui_ec = psp->ec;
    psd->amsd.usr = psp->usr;
    psd->amsd.cr_ec = control_event_callback;
    INIT_LIST(psd->amsd.app_slaver_list_head);
    
    psd->role = psp->role;
    psd->amsd.pacd = pacd;
    LIST_ADD_TAIL(&psd->amsd.list, &pacd->app_session_list_head);
    
    if (psp->role == ROLE_TYPE_TEACHER) {
        return cr_create_session(ped, (void *) psd, psp->protocol, 0, 0, 0);
    }
    else {
        return cr_join_session(&psp->srv_cr_addr, psp->protocol, (void *) psd, 0, 0, 0, ped);
    }
    return 0;
}

int delete_control_session(void * control_handle, struct event_desc *ped) {
    clear1(&write_content);
    struct control_session_desc *pamsd = (struct control_session_desc *) control_handle;
    if (pamsd->role == 1) {
        return cr_delete_session(pamsd->amsd.p2p_session_handle, ped);
    } else {
        return cr_quit_session(pamsd->amsd.p2p_session_handle, ped);
    }
}


void WriteContent(char *content, int len) {
    struct control_content_param ccp;
    //ccp.context = content;
    memset(ccp.context, 0, sizeof(ccp.context) / sizeof(ccp.context[0]));
    memcpy(ccp.context, content, len);
    ccp.len = len;
    //write_content.push(ccp);
    push(&write_content, &ccp);
}