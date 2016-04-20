
#include"mq.h"
#include<stdint.h>
//#include<Windows.h>
#include <stdlib.h>

struct msg_buf
{
	uint32_t len;
	uint8_t msg[0];
};

struct msg_queue_desc
{
	int write_pos,read_pos;
	int msg_size,msg_num;

	struct msg_buf**mb;
};


uint8_t*msg_queue_wget(void *handle,uint32_t*len)
{
	struct msg_queue_desc*pmqd=(struct msg_queue_desc*)handle;
	struct msg_buf*pmb;

	pmb=pmqd->mb[pmqd->write_pos];
	if(pmb->len>0)return NULL;

	*len=pmqd->msg_size;
	return (uint8_t*)pmb->msg;
}
void msg_queue_wset(void *handle,int len)
{
	struct msg_queue_desc*pmqd=(struct msg_queue_desc*)handle;
	struct msg_buf*pmb;

	pmb=pmqd->mb[pmqd->write_pos];
	pmb->len=len;
	if(len>0)
		pmqd->write_pos=(pmqd->write_pos+1)%pmqd->msg_num;
}
uint32_t msg_queue_remind_used(void *handle)
{
	int i=0,pos,old;
	struct msg_queue_desc*pmqd=(struct msg_queue_desc*)handle;
	struct msg_buf*pmb;
	pos=pmqd->read_pos;
	old=pos;
	while(1){
		pmb=pmqd->mb[pos];
		if(pmb->len>0){
			i++;
			pos=(pos+1)%pmqd->msg_num;
			if(pos==old)return i;
		}
		else{
			return i;
		}
	}
}
uint8_t*msg_queue_rget(void *handle,uint32_t*len)
{
	struct msg_queue_desc*pmqd=(struct msg_queue_desc*)handle;
	struct msg_buf*pmb;

	pmb=pmqd->mb[pmqd->read_pos];
	if(pmb->len==0)return NULL;
	*len=pmb->len;
	return (uint8_t*)pmb->msg;
}
void msg_queue_rset(void *handle)
{
	struct msg_queue_desc*pmqd=(struct msg_queue_desc*)handle;
	struct msg_buf*pmb;

	pmb=pmqd->mb[pmqd->read_pos];
	pmb->len=0;
	pmqd->read_pos=(pmqd->read_pos+1)%pmqd->msg_num;

}

int msg_queue_read(void *handle,uint8_t*buf,uint32_t*len)
{
	struct msg_queue_desc*pmqd=(struct msg_queue_desc*)handle;
	struct msg_buf*pmb;
	int d_len=*len>pmqd->msg_size?pmqd->msg_size:*len;
	pmb=pmqd->mb[pmqd->read_pos];
	if(pmb->len==0)return -1;

	memcpy((char*)buf,pmb->msg,d_len);
	*len=d_len;
	pmb->len=0;
	pmqd->read_pos=(pmqd->read_pos+1)%pmqd->msg_num;
	return 0;
}	
int msg_queue_write(void *handle,uint8_t*buf,uint32_t len)
{
	struct msg_queue_desc*pmqd=(struct msg_queue_desc*)handle;
	struct msg_buf*pmb;
	int d_len=len>pmqd->msg_size?pmqd->msg_size:len;
	pmb=pmqd->mb[pmqd->write_pos];
	if(pmb->len>0)return -1;

	memcpy((char*)pmb->msg,buf,d_len);
	pmb->len=d_len;
	pmqd->write_pos=(pmqd->write_pos+1)%pmqd->msg_num;
	return 0;
}

void *msg_queue_create(int msg_size,int msg_num)
{
	uint32_t size;
	int i;
	uint8_t*addr;
	struct msg_queue_desc*pmqd;
	size=(sizeof(struct msg_buf)+msg_size+sizeof(struct msg_buf*))*msg_num;
	pmqd=(struct msg_queue_desc*)malloc(sizeof(struct msg_queue_desc)+size);
	if(!pmqd)return (void *)-1;
	memset(pmqd,0,sizeof(struct msg_queue_desc)+size);
	pmqd->mb=(struct msg_buf**)(pmqd+1);
	pmqd->msg_size=msg_size;
	pmqd->msg_num=msg_num;
	addr=(uint8_t*)((uint8_t*)pmqd->mb+msg_num*sizeof(void*));
	for(i=0;i<msg_num;i++){
		pmqd->mb[i]=(struct msg_buf*)(addr+(sizeof(struct msg_buf)+msg_size)*i);
	}

	return pmqd;
}
void msg_queue_delete(void *handle)
{
	struct msg_queue_desc*pmqd=(struct msg_queue_desc*)handle;
	free(pmqd);
}

void msg_queue_reset(void *handle)
{
	uint32_t size;
	int i;
	struct msg_buf*pmb;
	struct msg_queue_desc*pmqd=(struct msg_queue_desc*)handle;
	for(i=0;i<pmqd->msg_num;i++){
		pmb=pmqd->mb[i];
		pmb->len=0;
	}
	pmqd->read_pos=pmqd->write_pos;
}

void msg_queue_rpoll(void *handle,mq_poll_callback mpc,void*usr)
{
	struct msg_queue_desc*pmqd=(struct msg_queue_desc*)handle;
	struct msg_buf*pmb;
	int read_pos=pmqd->read_pos;
	do{
		pmb=pmqd->mb[read_pos];
		if(pmb->len==0)return;
		if(mpc(usr,handle,(uint8_t*)pmb->msg,pmb->len)==-1)return;
		read_pos=(read_pos+1)%pmqd->msg_num;
	}while(read_pos!=pmqd->read_pos);

}
int msg_queue_get_used(void *handle)
{
	struct msg_queue_desc*pmqd=(struct msg_queue_desc*)handle;
	int read_pos=pmqd->read_pos;
	struct msg_buf*pmb;
	int used=0;
	do{
		pmb=pmqd->mb[read_pos];
		if(pmb->len==0)break;
		used++;
		read_pos=(read_pos+1)%pmqd->msg_num;
	}while(read_pos!=pmqd->read_pos);
	return used;
}


