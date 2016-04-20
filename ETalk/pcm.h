//
//  pcm.h
//  ClassRoom
//
//  Created by etalk365 on 16/3/7.
//  Copyright © 2016年 深圳市易课科技文化有限公司. All rights reserved.
//

#ifndef pcm_h
#define pcm_h

#include <stdio.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C"
{
#endif
    
    struct sample_data_desc {
        char *data;
        int len;
    };
    
    typedef void(*pcm_sample_callback)(void *usr, void *pdesc);
    
    //for render
    struct pcm_format_desc {
        uint16_t *sample[2];
        int sample_nr;
        int channels;
        int AudioType;
        uint16_t *data;
        int out_buffer_size;
    };
    
    struct pcm_recoder_param {
        int nChannels;
        int nSamplesPerSec;
        int wBitsPerSample;
        int buffer_size;
        pcm_sample_callback psc;
        void *usr;
    };
    
    
    struct pcm_player_param {
        int nChannels;
        int nSamplesPerSec;
        int wBitsPerSample;
        int buffer_size;
    };
    
    
    int pcm_open_recorder(struct pcm_recoder_param *pprp);
    
    int pcm_start_recorder(void * handle);
    
    void pcm_stop_recorder(void * handle);
    
    void pcm_close_recorder(void * handle);
    
    void pcm_recorder_free(void * handle);
    
    int pcm_open_player(struct pcm_player_param *pppp);
    
    void pcm_close_player(void * handle);
    
    void pcm_render_player(void * handle, void *pdata);
    
    int is_pcm_rendr_full(void * handle);
    
    int is_pcm_rendr_empty(void * handle);
    
    int is_pcm_player_closed(void * handle);
    
    void pcm_free_player(void * handle);
    
    int pcm_recorder_is_closed(void * handle);
    
    void material_pcm_close_player(void * handle);
    
#ifdef __cplusplus
}
#endif

#endif /* pcm_h */
