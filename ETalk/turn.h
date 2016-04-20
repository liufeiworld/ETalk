#ifndef _TURN_H_
#define _TURN_H_


enum{
	FROM_SERVER_RESP_CREATE_CLASSROOM=1,
	FROM_MASTER_REQ_CREATE_CLASSROOM,
	FROM_MASTER_REQ_CREATE_SESSION,
	FROM_SERVER_RESP_CREATE_SESSION,
	FROM_MASTER_REQ_DELETE_SESSION,
	FROM_SERVER_REQ_DATA,
};

struct turn_msg_desc
{
	uint32_t msg_id;
	uint8_t data[0];
};
struct from_server_resp_create_session
{
	uint32_t master_id;
	uint32_t slaver_srv_addr;
	uint32_t master_srv_addr;
	uint16_t slaver_srv_port;
	uint16_t master_srv_port;
	void * usr_sess_handle;
};
struct from_master_req_delete_session
{
	uint32_t master_id;
};
struct from_master_req_create_session
{
	void *session_handle;
	uint32_t protocol;
	int send_buf_size;
	int recv_buf_size;
	int delay;
};
struct from_server_req_data
{
	uint32_t slaver_local_addr;
	uint16_t slaver_local_port;
	uint16_t data_len;
	uint8_t data[0];
};










#endif

