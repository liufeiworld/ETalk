//
//  packet.c
//  ClassRoom
//
//  Created by etalk365 on 16/3/7.
//  Copyright © 2016年 深圳市易课科技文化有限公司. All rights reserved.
//

#include "packet.h"


int build_packet(uint8_t *buf,
                 uint32_t data_len,
                 uint32_t type,
                 uint32_t packet_number, uint32_t ssrc, uint32_t magic) {
    
    struct PacketHeader *ph = (struct PacketHeader *) buf;
    
    ph->data_len = data_len;
    ph->packet_number = packet_number;
    ph->align_len = ((data_len + 3) >> 2) << 2;
    ph->type = type;
    ph->ssrc = ssrc;
    ph->magic = magic;
    return sizeof(struct PacketHeader) + ph->align_len;
}