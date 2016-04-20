//
//  control.h
//  ClassRoom
//
//  Created by etalk365 on 16/3/7.
//  Copyright © 2016年 深圳市易课科技文化有限公司. All rights reserved.
//

#ifndef control_h
#define control_h

#include <stdio.h>
#include "commonend.h"

struct control_session_param {
    struct sockaddr_in srv_cr_addr;
    int role;
    int protocol;
    void *usr;
    event_callback ec;
};

struct control_content_param {
    //    string content;
    char context[1024];
    int len;
};

//void WirteContent(string content, int len);
void WriteContent(char *content, int len);

int create_control_session(struct event_desc *ped, struct app_classroom_desc *pacd,
                           struct control_session_param *psp);

int delete_control_session(void * control_handle, struct event_desc *ped);





#endif /* control_h */
