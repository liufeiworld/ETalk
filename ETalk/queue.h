//
//  queue.h
//  ClassRoom
//
//  Created by etalk365 on 16/3/7.
//  Copyright © 2016年 深圳市易课科技文化有限公司. All rights reserved.
//

#ifndef queue_h
#define queue_h

#include <stdio.h>

/*数据节点*/
typedef struct Node_ {
    struct Node_ *Next;
    void *elem;
} Node;

/*节点*/
typedef struct {
    Node *item;
    size_t ElemSize;
    //元素大小
    size_t length;
    
    //队列长度
    void(*freefn)(void *);//自定义内存释放函数，释放外部动态申请的内存
} Queue;

/*初始化队列*/
void InitQueue(Queue *s, size_t DataSize, void(*freefn)(void *));

/*判断队列释放为空*/
int empty(Queue *q);

/*队列总长度*/
int size(Queue *q);

/*返回第一个元素*/
void *front(Queue *q);

/*返回最后一个函数*/
void *back(Queue *q);

/*删除第一个元素*/
void pop(Queue *q);

/*在末尾加入一个元素*/
void push(Queue *q, void *value);

/*删除队列*/
void clear1(Queue *q);





#endif /* queue_h */
