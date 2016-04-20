//
//  MaterialDrawStream.c
//  ClassRoom
//
//  Created by etalk365 on 16/3/7.
//  Copyright © 2016年 深圳市易课科技文化有限公司. All rights reserved.
//

#include "MaterialDrawStream.h"
#include "cr_mgr.h"
#include "queue.h"
#include "cr.h"
#include <stdlib.h>
//#include<Windows.h>

//queue <struct MaterialDrawStream_Content_Param> WriteMaterialDraw;



//Queue write_content;

//struct MaterialDraw_session_desc
//{
//    struct app_session_desc amsd;
//    int role;
//    uint8_t buf[4096];
//    uint32_t buf_pos;
//};

//static void MaterialDrawStream_packet_callback(void*usr, struct PacketHeader*pph)
//{
//    uint8_t buf[32];
//    struct event_desc*ped = (struct event_desc*)buf;
//    struct MaterialDraw_session_desc*pamsd = (struct MaterialDraw_session_desc*)usr;
//    ped->evt_id = TO_APP_SESSION_RECV_DATA;
//    ped->len = sizeof(struct to_app_session_recv_data);
//    
//    struct to_app_session_recv_data *ptasrd = (struct to_app_session_recv_data *)ped->data;
//    ptasrd->data = (uint8_t*)(pph + 1);
//    ptasrd->data_len = pph->data_len;
//    ptasrd->session_handle = (int)pamsd;
//    ptasrd->user = pamsd->amsd.usr;
//    pamsd->amsd.ui_ec(pamsd->amsd.usr, ped);
//}
//
//static void MaterialDrawStream_event_callback(void*usr, struct event_desc*ped)
//{
//    struct list_head* n = NULL;
//    struct list_head* get = NULL;
//    uint8_t*buf;
//    uint32_t size;
//    struct app_slaver_desc *pasd = NULL;
//    struct session_slaver_desc*pausd;
//    switch (ped->evt_id)
//    {
//        case TO_APP_CR_THREAD_STEP:
//        {
//            struct to_app_cr_thread_step*ptacts = (struct to_app_cr_thread_step*)ped->data;
//            //printf("%s,%d,ms:%d\n",__FUNCTION__,__LINE__,ptacts->ms);
//        }
//            break;
//        case TO_APP_SESSION_RECV_DATA:
//        {
//            struct MaterialDraw_session_desc*pamsd = (struct MaterialDraw_session_desc*)usr;
//            struct to_app_session_recv_data *ptasrd = (struct to_app_session_recv_data *)ped->data;
//            if (pamsd->amsd.p2p_session_handle != ptasrd->session_handle)break;
//            
//            cr_pharse_packet((void*)pamsd, MaterialDrawStream_packet_callback, ptasrd->data, ptasrd->data_len, pamsd->buf, &pamsd->buf_pos,ptasrd->src_port);
//        }
//            break;
//        case TO_APP_SESSION_WRITABLE:
//        {
//            struct to_app_session_writable*ptasw = (struct to_app_session_writable*)ped->data;
//            struct MaterialDraw_session_desc*pamsd = (struct MaterialDraw_session_desc*)usr;
//            //            if (WriteMaterialDraw.empty())
//            if (empty(&write_content))
//            {
//                ptasw->data_len = 0;
//                break;
//            }
//            else
//            {
//                struct MaterialDrawStream_Content_Param *pmcp = NULL;
//                pmcp = (struct MaterialDrawStream_Content_Param *)front(&write_content);
//                //                buf = (uint8_t *)WriteMaterialDraw.front().MaterialDrawStream;
//                //                size = (uint32_t)WriteMaterialDraw.front().len;
//                buf = (uint8_t*) pmcp->MaterialDrawStream;
//                size = (uint32_t)pmcp->len;
//                
//                struct PacketHeader*pph;
//                int len2 = build_packet((uint8_t*)ptasw->data, size, 0, 0,pamsd->amsd.pacd->ssrc, 0xdeadbeed);
//                if (len2 > ptasw->data_len){
//                    ptasw->data_len = 0;
//                    break;
//                }
//                pph = (struct PacketHeader*)ptasw->data;
//                memcpy((char*)(pph + 1), buf, size);
//                ptasw->data_len = len2;
//                //                WriteMaterialDraw.pop();
//                pop(&write_content);
//            }
//            //pamsd->amsd.ui_ec(pamsd->amsd.usr, ped);
//        }
//            break;
//        case TO_APP_SESSION_HANDLE:
//        {
//            struct to_app_session_handle*ptash = (struct to_app_session_handle*)ped->data;
//            struct MaterialDraw_session_desc*pamsd = (struct MaterialDraw_session_desc*)usr;
//            pamsd->amsd.p2p_session_handle = ptash->session_handle;
//            if (ptash->session_handle != -1)
//            {
//                pamsd->amsd.slaver_srv_addr = ptash->slaver_addr;
//                pamsd->amsd.slaver_srv_port = ptash->slaver_port;
//                //printf("audio_addr:%u,audio_port:%u\n", pamsd->amsd.slaver_srv_addr, pamsd->amsd.slaver_srv_port);
//                ptash->session_handle = (int)pamsd;
//                pamsd->amsd.ui_ec(pamsd->amsd.usr, ped);
//            }
//            else
//            {
//                LIST_DEL(&pamsd->amsd.list);
//                list_iterate_safe(get, n, &pamsd->amsd.app_slaver_list_head)
//                {
//                    pasd = list_get(get, struct app_slaver_desc, list);
//                    LIST_DEL(&pasd->list);
//                    free(pasd);
//                }
//                struct app_classroom_desc*pacd;
//                pacd = pamsd->amsd.pacd;
//                LIST_ADD_TAIL(&pamsd->amsd.list, &pacd->remove_session_list_head);
//            }
//        }
//            break;
//        case TO_SESSION_CHECK_REMOVE:
//        {
//            struct to_session_check_remove*ptscr = (struct to_session_check_remove*)ped->data;
//            ptscr->result = 1;
//        }
//            break;
//    }
//}
//
//int create_MaterialDrawStream_session(struct event_desc *ped, struct app_classroom_desc *pacd, struct MaterialDrawStream_Session_Param *pmdssp)
//{
//    struct MaterialDraw_session_desc *psd;
//    psd = (struct MaterialDraw_session_desc*) malloc(sizeof(struct MaterialDraw_session_desc));
//    if (!psd)
//        return -1;
//    memset(psd, 0, sizeof(struct MaterialDraw_session_desc));
//    psd->amsd.ui_ec = pmdssp->ec;
//    psd->amsd.usr = pmdssp->usr;
//    psd->amsd.cr_ec = MaterialDrawStream_event_callback;
//    INIT_LIST(psd->amsd.app_slaver_list_head);
//    
//    psd->role = pmdssp->role;
//    psd->amsd.pacd = pacd;
//    LIST_ADD_TAIL(&psd->amsd.list, &pacd->app_session_list_head);
//    if (pmdssp->role == ROLE_TYPE_TEACHER)
//    {
//        return cr_create_session(ped, (void *)psd, pmdssp->protocol, 0, 4320, 4320);
//    }
//    else
//    {
//        return cr_join_session(&pmdssp->srv_cr_addr, pmdssp->protocol, (void *)psd, 0, 4320, 4320, ped);
//    }
//    return 0;
//}
//int delete_MaterialDrawStream_session(int MaterialDrawStreamHandle, struct event_desc*ped)
//{
//    struct MaterialDraw_session_desc*pamsd = (struct MaterialDraw_session_desc*)MaterialDrawStreamHandle;
//    if (pamsd->role == 1){
//        return cr_delete_session(pamsd->amsd.p2p_session_handle, ped);
//    }
//    else{
//        return cr_quit_session(pamsd->amsd.p2p_session_handle, ped);
//    }
//}
//
//void WirteMaterialDrawStreamContent(char *content, int len)
//{
//    struct MaterialDrawStream_Content_Param mdscp;
//    memcpy(mdscp.MaterialDrawStream, content, len);
//    mdscp.len = len;
//    //    WriteMaterialDraw.push(mdscp);
//    push(&write_content, &mdscp);
//}