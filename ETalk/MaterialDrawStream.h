//
//  MaterialDrawStream.h
//  ClassRoom
//
//  Created by etalk365 on 16/3/7.
//  Copyright © 2016年 深圳市易课科技文化有限公司. All rights reserved.
//

#ifndef MaterialDrawStream_h
#define MaterialDrawStream_h

#include <stdio.h>

#include "commonend.h"

struct MaterialDrawStream_Session_Param
{
    struct sockaddr_in srv_cr_addr;
    int role;
    int protocol;
    void *usr;
    event_callback ec;
};

struct MaterialDrawStream_Content_Param
{
    char MaterialDrawStream[1025];
    int len;
};

/*struct FileStream_content_param
 {
 char FileStream[1025];
 int len;
 };*/

void WirteMaterialDrawStreamContent(char *content,int len);
int create_MaterialDrawStream_session(struct event_desc *ped, struct app_classroom_desc *pacd, struct MaterialDrawStream_Session_Param *pmdssp);
int delete_MaterialDrawStream_session(void * MaterialDrawStreamHandle, struct event_desc*ped);

#endif /* MaterialDrawStream_h */
