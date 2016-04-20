//
//  ClassRoom.h
//  ClassRoom
//
//  Created by etalk365 on 16/3/7.
//  Copyright © 2016年 深圳市易课科技文化有限公司. All rights reserved.
//

#ifndef ClassRoom_h
#define ClassRoom_h

#include <stdio.h>
#include "commonend.h"

char *say_hello();

#define ROLE_TYPE_STUDENT 0
#define ROLE_TYPE_TEACHER 1

enum {
    FROM_UI_CREATE_AUDIOSESSION = 1,
    FROM_UI_CREATE_VIDEOSESSION,
    FROM_UI_CREATE_CTLSESSION,
    FROM_UI_CREATE_UDPSESSION,
    FROM_UI_DELETE_AUDIOSESSION,
    FROM_UI_DELETE_VIDEOSESSION,
    FROM_UI_DELETE_CTLSESSION,
    FROM_UI_DELETE_CR,
    FROM_UI_CREATE_FILESTREAM,
    FROM_UI_DELETE_FILESTREAM,
    FROM_UI_CREATE_MATERIALDRAWSTREAM,
    FROM_UI_DELETE_MATERIALDRAWSTREAM,
};

struct Form_Msg_desc {
    void *cr_handle;
    unsigned int Form_Message;
    void *Param;
    void *Param2;
    void *Param3;
};

int create_classroom(struct sockaddr_in *srv_addr, event_callback ec, void *usr, int role);

int delete_classroom(void * cr_handle, struct event_desc *ped);

int Send_BusinessMsg(void * cr_handle, unsigned int Msg, void *param, void *param2,
                     void *param3);


#endif /* ClassRoom_h */
