//
//  ClassRoom.c
//  ClassRoom
//
//  Created by etalk365 on 16/3/7.
//  Copyright © 2016年 深圳市易课科技文化有限公司. All rights reserved.
//

#include "cr.h"
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "queue.h"
#include "cr_mgr.h"
#include "mq.h"
#include "control.h"

#define LOGI printf



Queue Form_Msg;

struct my_app_classroom_desc {
    struct app_classroom_desc acd;
    event_callback ec;
    void *usr;
    int role;
};

enum {
    FROM_UI_CREATE_SESSION = 1,
};

struct from_ui_create_session {
    int type;
    void *param;
};

struct from_ui_delete_session {
    void *session_handle;
};


char *say_hello(){
    printf("ssss");
    return "hello";
}

int Form_Msg_Dispose(struct event_desc *ped, struct app_classroom_desc *pacd,
                     struct my_app_classroom_desc *pmacd) {
    int msg;
    //if (Form_Msg.empty())
    if (empty(&Form_Msg))
        return 0;
    else {
        //if ((int)pmacd != Form_Msg.front().cr_handle) return 0;
        struct Form_Msg_desc *pfmd = NULL;
        pfmd = (struct Form_Msg_desc *) front(&Form_Msg);
        //switch (Form_Msg.front().Form_Message)
        switch (pfmd->Form_Message) {
            case FROM_UI_CREATE_AUDIOSESSION: {
                //if (create_audio_session(ped, pacd, (struct stream_session_param *)Form_Msg.front().Param) == -1)
                //{
                
                //}
//                create_audio_session(ped, pacd, (struct stream_session_param *) pfmd->Param);
            }
                break;
            case FROM_UI_DELETE_AUDIOSESSION: {
                //delete_audio_session((int)Form_Msg.front().Param,ped);
//                delete_audio_session((int) pfmd->Param, ped);
            }
                break;
            case FROM_UI_CREATE_CTLSESSION: {
                
                
                //create_control_session(ped,pacd, (struct control_session_param *)Form_Msg.front().Param);
                struct control_session_param *pcsp = (struct control_session_param *) pfmd->Param;
                LOGI("FROM_UI_CREATE_CTLSESSION addr=%d, port=%d",
                     ntohl(pcsp->srv_cr_addr.sin_addr.s_addr), ntohs(pcsp->srv_cr_addr.sin_port));
                create_control_session(ped, pacd, (struct control_session_param *) pfmd->Param);
            }
                break;
            case FROM_UI_DELETE_CTLSESSION: {
                //delete_control_session((int)Form_Msg.front().Param, ped);
                delete_control_session(pfmd->Param, ped);
            }
                break;
            case FROM_UI_CREATE_VIDEOSESSION: {
                //create_video_session(ped, pacd, (struct stream_session_param *)Form_Msg.front().Param);
//                create_video_session(ped, pacd, (struct stream_session_param *) pfmd->Param);
            }
                break;
            case FROM_UI_DELETE_VIDEOSESSION: {
                //delete_video_session((int)Form_Msg.front().Param,ped);
//                delete_video_session((int) pfmd->Param, ped);
            }
                break;
            case FROM_UI_DELETE_CR: {
                //delete_classroom((int)Form_Msg.front().Param,ped);
                delete_classroom(pfmd->Param, ped);
            }
                break;
            case FROM_UI_CREATE_FILESTREAM: {
                //create_FileStream_session(ped, pacd, (struct FileStream_session_param *)Form_Msg.front().Param);
                //                create_FileStream_session(ped, pacd, (struct FileStream_session_param *)pfmd->Param);
            }
                break;
            case FROM_UI_DELETE_FILESTREAM: {
                //delete_FileStream_session((int)Form_Msg.front().Param, ped);
                //                delete_FileStream_session((int)pfmd->Param, ped);
            }
                break;
            case FROM_UI_CREATE_MATERIALDRAWSTREAM: {
                //create_MaterialDrawStream_session(ped,pacd,(struct MaterialDrawStream_Session_Param *)Form_Msg.front().Param);
//                create_MaterialDrawStream_session(ped, pacd, (struct MaterialDrawStream_Session_Param *) pfmd->Param);
            }
                break;
            case FROM_UI_DELETE_MATERIALDRAWSTREAM: {
                //delete_MaterialDrawStream_session((int)Form_Msg.front().Param,ped);
                //                delete_MaterialDrawStream_session((int)pfmd->Param, ped);
            }
                break;
        }
        //Form_Msg.pop();
        pop(&Form_Msg);
    }
    return 1;
}


static void cr_event_callback(void *usr, struct event_desc *ped) {
    struct list_head *n = NULL;
    struct list_head *get = NULL;
    struct app_session_desc *pasd;
    struct my_app_classroom_desc *pmacd = (struct my_app_classroom_desc *) usr;
    struct app_classroom_desc *pacd = (struct app_classroom_desc *) pmacd;
    uint8_t ui_buf[64];
    switch (ped->evt_id) {
        case TO_APP_SESSION_RECV_DATA: {
            struct to_app_session_recv_data *ptasrd = (struct to_app_session_recv_data *) ped->data;
            struct app_session_desc *pasd = (struct app_session_desc *) ptasrd->user;
            if (pasd)
                pasd->cr_ec(pasd, ped);
        }
            break;
        case TO_APP_CR_HANDLE: {
            LOGI("cr_event_callback---TO_APP_CR_HANDLE");
            struct to_app_cr_handle *ptach = (struct to_app_cr_handle *) ped->data;
            pmacd->acd.p2p_cr_handle = ptach->cr_local_handle;
            //if(pmacd->role==ROLE_TYPE_TEACHER)
            if (pmacd->acd.p2p_cr_handle != -1) {
                pmacd->acd.cr_id = ptach->cr_id;
                pmacd->acd.ssrc = ptach->ssrc;
                pacd->srv_cr_addr.sin_family = AF_INET;
                pacd->srv_cr_addr.sin_addr.s_addr = htonl(ptach->cr_addr);
                pacd->srv_cr_addr.sin_port = htons(ptach->cr_port);
                ptach->cr_local_handle = pmacd;
                pmacd->ec(pmacd->usr, ped);
            }
            if (pmacd->acd.p2p_cr_handle == -1) {
                /*1，课室数据链路层已关闭*/
                /*2，线程已退出*/
                /*3，所创建的会话，提前被关闭*/
                ptach->cr_local_handle = -1;
                pmacd->ec(pmacd->usr, ped);
                
            }
        }
            break;
        case TO_APP_CR_PROC_MSG: {
            /*uint32_t len;
             uint8_t*msg;
             
             pmacd->ec(pmacd->usr,ped);
             if (ped->evt_id != TO_APP_CR_PROC_MSG){
             switch (ped->evt_id){
             case FROM_UI_CREATE_SESSION:
             {
             struct from_ui_create_session*pfucs = (struct from_ui_create_session*)ped->data;
             if (pfucs->type == SESSION_TYPE_AUDIO){
             if(create_audio_session(ped, pacd, pfucs->param)==-1){
             //notify ui
             break;
             }
             }
             }
             break;
             }
             }*/
            
            Form_Msg_Dispose(ped, pacd, pmacd);
            
            /*msg = msg_queue_rget(pmacd->acd.msg_queue_handle, &len);
             if (msg){
             struct event_desc*ped2 = (struct event_desc*)msg;
             memcpy(ped, ped2, len);
             msg_queue_rset(pmacd->acd.msg_queue_handle);
             }*/
        }
            break;
        case TO_APP_SESSION_WRITABLE: {
            struct to_app_session_writable *ptasw = (struct to_app_session_writable *) ped->data;
            struct app_session_desc *pasd = (struct app_session_desc *) ptasw->user;
            if (pasd)
                pasd->cr_ec(pasd, ped);
        }
            break;
        case TO_APP_SESSION_HANDLE: {
            struct to_app_session_handle *ptash = (struct to_app_session_handle *) ped->data;
            struct app_session_desc *pasd = (struct app_session_desc *) ptash->user;
            if (pasd) {
                pasd->cr_ec(pasd, ped);
            }
            
        }
            break;
        case TO_APP_CR_THREAD_STEP: {
            list_iterate_safe(get, n, &pacd->app_session_list_head) {
                pasd = list_get(get, struct app_session_desc, list);
                pasd->cr_ec(pasd, ped);
            }
            //            {
            uint8_t buf[32];
        last_step:
            {
                struct event_desc *ped2 = (struct event_desc *) buf;
                
                struct to_session_check_remove *ptscr = (struct to_session_check_remove *) ped2->data;
                /*是否会话可以被删除*/
                list_iterate_safe(get, n, &pacd->remove_session_list_head) {
                    pasd = list_get(get, struct app_session_desc, list);
                    ptscr->result = 0;
                    ped2->evt_id = TO_SESSION_CHECK_REMOVE;
                    pasd->cr_ec(pasd, ped2);
                    if (ptscr->result == 1) {
                        LIST_DEL(&pasd->list);
                        struct to_app_session_handle *ptash = (struct to_app_session_handle *) ped2->data;
                        ped2->evt_id = TO_APP_SESSION_HANDLE;
                        ped2->len = sizeof(struct to_app_session_handle);
                        
                        ptash->session_handle = -1;
                        ptash->slaver_addr = 0;
                        ptash->slaver_port = 0;
                        pasd->ui_ec(pasd->usr, ped2);
                        LOGI("%s,%d session: deleted\n", __FUNCTION__, __LINE__);
                        LOGI("free %s,%d", __FUNCTION__, __LINE__);
                        free(pasd);
                    }
                }
                if (pmacd->acd.p2p_cr_handle == -1) {
                    if (1){//(LIST_EMPTY(&pacd->remove_session_list_head)) {
                        /*通知上层，教室已经被完全删除*/
                        uint8_t buf[32];
                        struct event_desc *ped2 = (struct event_desc *) buf;
                        ped2->evt_id = TO_APP_CR_HANDLE;
                        struct to_app_cr_handle *ptach = (struct to_app_cr_handle *) ped2->data;
                        ptach->cr_local_handle = -1;
                        ptach->cr_addr = 0;
                        ptach->cr_id = 0;
                        ptach->cr_port = 0;
                        pmacd->ec(pmacd->usr, ped2);
                        
                        if (pmacd->acd.msg_queue_handle && pmacd->acd.msg_queue_handle != -1) {
                            msg_queue_delete(pmacd->acd.msg_queue_handle);
                            LOGI("classroom is freed!!!!!!!!!!!!!!!\n");
                            LOGI("free %s,%d", __FUNCTION__, __LINE__);
                            free(pmacd);
                        }
                    } else {
                        usleep(50000);
                        goto last_step;
                    }
                }
            }
        }
            break;
    }
}


//创建教室
int create_classroom(struct sockaddr_in *srv_addr, event_callback ec, void *usr, int role) {
    InitQueue(&Form_Msg, sizeof(struct Form_Msg_desc), NULL);
    LOGI("malloc %s,%d", __FUNCTION__, __LINE__);
    struct my_app_classroom_desc *pmacd = (struct my_app_classroom_desc *) malloc(
                                                                                  sizeof(struct my_app_classroom_desc));
    if (!pmacd) return -1;
    memset(pmacd, 0, sizeof(struct my_app_classroom_desc));
    pmacd->ec = ec;
    pmacd->usr = usr;
    pmacd->role = role;
    INIT_LIST(pmacd->acd.app_session_list_head);
    INIT_LIST(pmacd->acd.remove_session_list_head);
    pmacd->acd.srv_addr = *srv_addr;
    pmacd->acd.msg_queue_handle = msg_queue_create(64, 32);
    if (pmacd->acd.msg_queue_handle == -1) {
        LOGI("free %s,%d", __FUNCTION__, __LINE__);
        free(pmacd);
        return -1;
    }
    if (role == ROLE_TYPE_TEACHER)//老师
        return cr_create_classroom(srv_addr, cr_event_callback, pmacd);
    if (role == ROLE_TYPE_STUDENT) {//学生
        LOGI("create_classroom --- ROLE_TYPE_STUDENT");
        return cr_slaver_create_classroom(cr_event_callback, pmacd);
    }
    return 1;
}
//删除教室
int delete_classroom(void *cr_handle, struct event_desc *ped){
    clear1(&Form_Msg);
    struct my_app_classroom_desc *pmacd = (struct my_app_classroom_desc *) cr_handle;
    if (pmacd->role == ROLE_TYPE_TEACHER) {
        return cr_delete_classroom(pmacd->acd.p2p_cr_handle, ped);
        
    } else {
        return cr_slaver_delete_classroom(pmacd->acd.p2p_cr_handle, ped);
        
    }
    
}
//发送信息
int Send_BusinessMsg(void *cr_handle, unsigned int Msg, void *param, void *param2,
                     void *param3){
    LOGI("%s,%d, handle=%d", __FUNCTION__, __LINE__, cr_handle);
    struct Form_Msg_desc fmd = {0};
    fmd.cr_handle = cr_handle;
    fmd.Form_Message = Msg;
    fmd.Param = param;
    fmd.Param2 = param2;
    fmd.Param3 = param3;
    //Form_Msg.push(fmd);
    push(&Form_Msg, &fmd);
    return 0;
}



