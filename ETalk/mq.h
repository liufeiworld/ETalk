#ifndef _MQ_H_
#define _MQ_H_

#include<stdint.h>

//typedef int(*mq_poll_callback)(void*usr,int mq_handle,uint8_t*data,uint32_t len);

typedef int(*mq_poll_callback)(void*usr,void *mq_handle,uint8_t*data,uint32_t len);

// int msg_queue_create(int msg_size,int msg_num);
// void msg_queue_delete(int handle);
// int msg_queue_read(int handle,uint8_t*buf,uint32_t*len);
// int msg_queue_write(int handle,uint8_t*buf,uint32_t len);
// 
// uint8_t*msg_queue_rget(int handle,uint32_t*len);
// void msg_queue_rset(int handle);
// 
// uint8_t*msg_queue_wget(int handle, uint32_t*len);
// void msg_queue_wset(int handle, int len);
// 
// void msg_queue_reset(int handle);
// uint32_t msg_queue_remind_used(int handle);
// 
// void msg_queue_rpoll(int handle,mq_poll_callback mpc,void*usr);
// int msg_queue_get_used(int handle);



void *msg_queue_create(int msg_size,int msg_num);


void msg_queue_delete(void *handle);


int msg_queue_read(void *handle,uint8_t*buf,uint32_t*len);


int msg_queue_write(void *handle,uint8_t*buf,uint32_t len);


uint8_t*msg_queue_rget(void *handle,uint32_t*len);

void msg_queue_rset(void *handle);

uint8_t*msg_queue_wget(void *handle, uint32_t*len);
void msg_queue_wset(void *handle, int len);

void msg_queue_reset(void *handle);
uint32_t msg_queue_remind_used(void *handle);

void msg_queue_rpoll(void *handle,mq_poll_callback mpc,void*usr);
int msg_queue_get_used(void *handle);

#endif

