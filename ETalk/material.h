//
//  material.h
//  ClassRoom
//
//  Created by etalk365 on 16/3/7.
//  Copyright © 2016年 深圳市易课科技文化有限公司. All rights reserved.
//

#ifndef material_h
#define material_h

#include <stdio.h>
#include <stdint.h>
#include "commonend.h"
#include "pcm.h"


enum {
    TO_UI_MATERIAL_MGR_HANDLE = 1,
    TO_UI_MATERIAL_HANDLE,
    TO_UI_MATERIAL_CLOSED,
    TO_UI_VOICE_START,
    TO_UI_VOICE_ERROR,
    TO_UI_VOICE_END,
    TO_UI_VOICE_STOPED,
    TO_UI_VOICE_PAUSED,
    TO_UI_MATERIAL_MAX,
};

struct to_ui_material_mgr_handle {
    void * material_mgr_handle;
};
struct to_ui_material_close {
    void * material_handle;
};
struct to_ui_material_handle {
    void * material_handle;
    char jpg_name[16];
    int voice_count;
};
struct to_ui_voice_start {
    void * material_handle;
    int voice;
};
struct to_ui_voice_end {
    void * material_handle;
    int voice;
};
struct to_ui_voice_error {
    void * material_handle;
    int voice;
};
struct to_ui_voice_stoped {
    void * material_handle;
    int voice;
};
struct to_ui_voice_paused {
    void * material_handle;
    int voice;
};


int material_mgr_create(void *usr,event_callback ec, char *path, struct pcm_player_param *pppp);

int material_play_voice(void * mgr_handle, void * material_handle, int voice);

int material_open_material(void * mgr_handle, char *material_name);

int material_mgr_delete(void * mgr_handle);

int material_close_material(void * mgr_handle, void * material_handle);

int material_stop_voice(void * mgr_handle);

int material_pause_voice(void * mgr_handle);



#endif /* material_h */
