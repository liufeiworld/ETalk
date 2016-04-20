#ifndef _NET_IP_H_
#define _NET_IP_H_

#include<stdint.h>

struct ipv4_hdr
{
	uint8_t ip_verlen;
	uint8_t ip_tos;
	uint16_t ip_totallength;
	uint16_t ip_id;
	uint16_t ip_offset;
	uint8_t ip_ttl;
	uint8_t ip_protocol;
	uint16_t ip_checksum;
	uint32_t ip_srcaddr;
	uint32_t ip_dstaddr;
};
struct udp_hdr
{
	uint16_t src_portno;
	uint16_t dst_portno;
	uint16_t udp_length;
	uint16_t udp_checksum;
};


#endif
