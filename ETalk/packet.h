//
//  packet.h
//  ClassRoom
//
//  Created by etalk365 on 16/3/7.
//  Copyright © 2016年 深圳市易课科技文化有限公司. All rights reserved.
//

#ifndef packet_h
#define packet_h

#include <stdio.h>
#include<stdint.h>



#if 1
struct PacketHeader {
    uint32_t magic;
    uint32_t packet_number:4;
    uint32_t data_len:13;
    uint32_t align_len:13;
    uint32_t type:2;
    uint32_t ssrc;
};
#else
struct PacketHeader
{
    uint8_t csrccount:4;
    uint8_t extension:1;
    uint8_t padding:1;
    uint8_t version:2;
    
    uint8_t payloadtype:7;
    uint8_t marker:1;
    
    uint16_t sequencenumber;
    uint32_t timestamp;
    uint32_t ssrc;
};
#endif

int build_packet(uint8_t *buf,
                 uint32_t data_len, uint32_t type,
                 uint32_t packet_number, uint32_t ssrc, uint32_t magic);


#endif /* packet_h */
