//
//  queue.c
//  ClassRoom
//
//  Created by etalk365 on 16/3/7.
//  Copyright © 2016年 深圳市易课科技文化有限公司. All rights reserved.
//

#include "queue.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <wchar.h>

/*初始化队列*/
void InitQueue(Queue *s, size_t DataSize, void(*freefn)(void *)) {
    s->item = NULL;
    s->ElemSize = DataSize;
    s->length = 0;
    s->freefn = freefn;
}

/*判断队列释放为空*/
int empty(Queue *q) {
    return q->length == 0;
}

/*队列总长度*/
int size(Queue *q) {
    return (int)q->length;
}

/*返回第一个元素*/
void *front(Queue *q) {
    Node *n = q->item;
    return (n != NULL ? n->elem : NULL);
}

/*返回最后一个函数*/
void *back(Queue *q) {
    Node *n = q->item;
    while (n->Next != NULL) {
        n = n->Next;
    }
    return (n != NULL ? n->elem : NULL);
}

/*删除第一个元素*/
void pop(Queue *q) {
    Node *n = q->item;
    Node *temp;
    if (n == NULL) {
        return;
    }
    temp = n->Next;
    
    if (q->freefn != NULL) {
        q->freefn(n->elem);//释放函数外面动态分配的内存
        n->elem = NULL;
    }
    free(n->elem);  //释放元素空间
    free(n);        //释放节点空间
    q->length--;    //队列长度减1
    q->item = temp;
}

/*在末尾加入一个元素*/
void push(Queue *q, void *value) {
    Node *n, *nn;
    n = q->item;
    while (n != NULL && n->Next != NULL) {
        n = n->Next;
    }
    nn = (Node *) malloc(sizeof(Node));
    nn->Next = NULL;
    nn->elem = malloc(q->ElemSize);
    memset(nn->elem,0,q->ElemSize);
    memcpy(nn->elem, value, q->ElemSize);
    if (q->item == NULL) {
        q->item = nn;
    }
    else {
        n->Next = nn;
    }
    q->length++;
}

/*删除队列*/
void clear1(Queue *q) {
    Node *n = q->item;
    Node *temp;
    while (n != NULL) {
        temp = n->Next;
        if (q->freefn != NULL) {
            q->freefn(n->elem);
        }
        free(n->elem);
        free(n);
        n = temp;
    }
    q = NULL;
}

void charfree(void *v) {
    free(*(char **) v);
}