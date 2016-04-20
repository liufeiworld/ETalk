//
//  pcm.c
//  ClassRoom
//
//  Created by etalk365 on 16/3/7.
//  Copyright © 2016年 深圳市易课科技文化有限公司. All rights reserved.
//

#include "pcm.h"

int pcm_open_player(struct pcm_player_param *pppp)
{
    //    jni_main(AUDIO_TRACK_OPEN, NULL, 0);
    //    jni_main(AUDIO_TRACK_PLAY, NULL, 0);
    return 0;
}

int material_pcm_open_player(struct pcm_player_param *pppp)
{
    //    jni_main(MATERIAL_AUDIO_TRACK_OPEN, NULL, 0);
    //    jni_main(MATERIAL_AUDIO_TRACK_PLAY, NULL, 0);
    return 0;
}

void pcm_render_player(void * handle, void *pdata)
{
    struct pcm_format_desc *desc = (struct pcm_format_desc*)pdata;
    //    jni_main(AUDIO_TRACK_WRITE, (void*)desc->data, desc->out_buffer_size);
    //    jni_main_audio(AUDIO_TRACK_WRITE, (void*)desc->data, desc->out_buffer_size);
}

void material_pcm_render_player(void * handle, void *pdata)
{
    struct pcm_format_desc *desc = (struct pcm_format_desc *)pdata;
    //    jni_main(MATERIAL_AUDIO_TRACK_WRITE, (void*)desc->data, desc->out_buffer_size);
    //    jni_main_audio(MATERIAL_AUDIO_TRACK_WRITE, (void*)desc->data, desc->out_buffer_size);
}

int is_pcm_rendr_full(void * handle)
{
    return 0;
}

void pcm_close_player(void * handle)
{
    //    jni_main(AUDIO_TRACK_STOP, NULL, 0);
}

void material_pcm_close_player(void * handle)
{
    //    jni_main(MATERIAL_AUDIO_TRACK_STOP, NULL, 0);
}

/**
 * pcm recoder
 * call Java AudioRecord
 */
int pcm_open_recorder(struct pcm_recoder_param *pprp)
{
    //    jni_main(AUDIO_RECORD_OPEN, (void*)pprp, 0);
    
    return 0;
}

int pcm_start_recorder(void * handle)
{
    //    jni_main(AUDIO_RECORD_START, NULL, 0);
    //    jni_main(AUDIO_RECORD_READ, NULL, 0);
    return 0;
}

int pcm_recorder_is_closed(void * handle)
{
    return 0;
}

void pcm_close_recorder(void * handle)
{
    //    jni_main(AUDIO_RECORD_STOP, NULL, NULL);
}

void pcm_recorder_free(void * handle)
{
    
}