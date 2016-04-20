//
//  material.c
//  ClassRoom
//
//  Created by etalk365 on 16/3/7.
//  Copyright © 2016年 深圳市易课科技文化有限公司. All rights reserved.
//

#include "material.h"

#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
//#include <io.h>
#include <fcntl.h>
#include "commonend.h"
#include "mq.h"
#include "pcm.h"
//#include "codec.h"

//#include "../inc/public.h"
//#include <process.h>
#include <pthread.h>

#include <unistd.h>
#define LOGI printf

/**************************************************************/
#define MAX_VOICE_NUM 32

#define MAKE_TO_UI_MATERIAL_MGR_HANDLE(h, cb, usr)   {\
uint8_t buf[32]; \
struct event_desc*pud=(struct event_desc*)(buf); \
pud->evt_id=TO_UI_MATERIAL_MGR_HANDLE; \
pud->len=sizeof(struct to_ui_material_mgr_handle); \
struct to_ui_material_mgr_handle*ptummh=(struct to_ui_material_mgr_handle*)pud->data; \
ptummh->material_mgr_handle=(h); \
(cb)((usr),pud); \
}
#define MAKE_TO_UI_MATERIAL_HANDLE(h, j, v, cb, usr)   {\
uint8_t buf[32]; \
struct event_desc*pud=(struct event_desc*)(buf); \
pud->evt_id=TO_UI_MATERIAL_HANDLE; \
pud->len=sizeof(struct to_ui_material_handle); \
struct to_ui_material_handle*ptummh=(struct to_ui_material_handle*)pud->data; \
ptummh->material_handle=(h); \
if((j)){ \
    memset(ptummh->jpg_name,0,sizeof(ptummh->jpg_name)); \
    strcpy(ptummh->jpg_name,(j)); \
} \
ptummh->voice_count=(v); \
(cb)((usr),pud); \
}
#define MAKE_TO_UI_MATERIAL_CLOSED(h, cb, usr)   {\
uint8_t buf[32]; \
struct event_desc*pud=(struct event_desc*)(buf); \
pud->evt_id=TO_UI_MATERIAL_CLOSED; \
pud->len=sizeof(struct to_ui_material_close); \
struct to_ui_material_close*ptummh=(struct to_ui_material_close*)pud->data; \
ptummh->material_handle=(h); \
(cb)((usr),pud); \
}
#define MAKE_TO_UI_VOICE_END(h, v, cb, usr)   {\
uint8_t buf[32]; \
struct event_desc*pud=(struct event_desc*)(buf); \
pud->evt_id=TO_UI_VOICE_END; \
pud->len=sizeof(struct to_ui_voice_end); \
struct to_ui_voice_end*ptummh=(struct to_ui_voice_end*)pud->data; \
ptummh->material_handle=(h); \
ptummh->voice=(v); \
(cb)((usr),pud); \
}
#define MAKE_TO_UI_VOICE_START(h, v, cb, usr)   {\
uint8_t buf[32]; \
struct event_desc*pud=(struct event_desc*)(buf); \
pud->evt_id=TO_UI_VOICE_START; \
pud->len=sizeof(struct to_ui_voice_start); \
struct to_ui_voice_start*ptummh=(struct to_ui_voice_start*)pud->data; \
ptummh->material_handle=(h); \
ptummh->voice=(v); \
(cb)((usr),pud); \
}
#define MAKE_TO_UI_VOICE_ERROR(h, v, cb, usr)   {\
uint8_t buf[32]; \
struct event_desc*pud=(struct event_desc*)(buf); \
pud->evt_id=TO_UI_VOICE_ERROR; \
pud->len=sizeof(struct to_ui_voice_error); \
struct to_ui_voice_error*ptummh=(struct to_ui_voice_error*)pud->data; \
ptummh->material_handle=(h); \
ptummh->voice=(v); \
(cb)((usr),pud); \
}
#define MAKE_TO_UI_VOICE_STOPED(h, v, cb, usr)   {\
uint8_t buf[32]; \
struct event_desc*pud=(struct event_desc*)(buf); \
pud->evt_id=TO_UI_VOICE_STOPED; \
pud->len=sizeof(struct to_ui_voice_stoped); \
struct to_ui_voice_stoped*ptummh=(struct to_ui_voice_stoped*)pud->data; \
ptummh->material_handle=(h); \
ptummh->voice=(v); \
(cb)((usr),pud); \
}
#define MAKE_TO_UI_VOICE_PAUSED(h, v, cb, usr)   {\
uint8_t buf[32]; \
struct event_desc*pud=(struct event_desc*)(buf); \
pud->evt_id=TO_UI_VOICE_PAUSED; \
pud->len=sizeof(struct to_ui_voice_paused); \
struct to_ui_voice_paused*ptummh=(struct to_ui_voice_paused*)pud->data; \
ptummh->material_handle=(h); \
ptummh->voice=(v); \
(cb)((usr),pud); \
}

struct voice_header {
    uint32_t offset;
    uint32_t len;
};
struct material_desc {
    int total_voice_count;
    int playing_voice_num;
    char jpg_name[16];
    FILE *playing_voice_file;
    int pause;
    struct list_head list;//->material_mgr_desc.material_list_head
};
struct material_mgr_desc {
    struct list_head material_list_head;
    struct material_desc *pmd;
    //当前已打开的教材
    //    HANDLE thread_handle;
    int thread_handle;
    pthread_t thread_id;
    event_callback ec;
    void *usr;
    struct pcm_player_param ppp;
    void * aac_decoder_handle;
    void * render_handle;
    void * msg_queue_handle;
    char path[256];
};

enum {
    FROM_UI_EVT_MGR_DELETE = TO_UI_MATERIAL_MAX,
    FROM_UI_EVT_OPEN_MATERIAL,
    FROM_UI_EVT_CLOSE_MATERIAL,
    FROM_UI_EVT_PLAY_VOICE,
    FROM_UI_EVT_STOP_VOICE,
    FROM_UI_EVT_PAUSE_VOICE,
    FROM_UI_EVT_MAX
};
struct from_ui_evt_mgr_delete {
    void * material_mgr_handle;
    
};
struct from_ui_evt_open_material {
    void * material_mgr_handle;
    char material_name[16];
};
struct from_ui_evt_close_material {
    void * material_mgr_handle;
    void * material_handle;
};
struct from_ui_evt_play_voice {
    void * material_mgr_handle;
    void * material_handle;
    uint32_t voice;
};


static void copy_file(FILE *dst, FILE *src, uint32_t src_size, int align16) {
    uint32_t i, j, k;
    char buf[128];
    
    j = src_size / 16;
    k = src_size % 16;
    
    int ret;
    for (i = 0; i < j; i++) {
        fread(buf, 16, 1, src);
        fwrite(buf, 16, 1, dst);
    }
    for (i = 0; i < k; i++) {
        fread(buf, 1, 1, src);
        fwrite(buf, 1, 1, dst);
    }
    if (align16 == 0)return;
    buf[0] = 0;
    
    
    k = ftell(dst) % 16;
    if (k) {
        for (i = 0; i < (16 - k); i++)
            fwrite(buf, 1, 1, dst);
    }
}

static struct material_desc *internal_material_open(struct material_mgr_desc *pmmd,
                                                    char *filename) {
    char buf[256];
    char dir_name[256];
    int i;
    char *pos;
    FILE *jpg_file;
    FILE *file;
    FILE *voice_file;
    uint32_t size;
    int vn;
    char material_file[256];
    struct voice_header vh[MAX_VOICE_NUM];
    
    struct material_desc *pvd = (struct material_desc *) malloc(sizeof(struct material_desc));
    if (!pvd)return NULL;
    memset(pvd, 0, sizeof(struct material_desc));
    memset(material_file, 0, sizeof(material_file));
    
    strcpy(material_file, pmmd->path);
    strcat(material_file, filename);
    
    file = fopen(material_file, "rb");
    if (file == NULL) {
        LOGI("%s,fopen fail\n", __FUNCTION__);
        return NULL;
    }
    memset(buf, 0, sizeof(buf));
    fread((char *) &vn, 4, 1, file);
    LOGI("%s,voice_num=%d\n", __FUNCTION__, vn);
    for (i = 0; i < vn; i++) {
        fread((char *) &vh[i], sizeof(struct voice_header), 1, file);
        LOGI("%s,offset:0x%x,len:0x%x\n", __FUNCTION__, vh[i].offset, vh[i].len);
    }
    
    strcpy(pvd->jpg_name, filename);
    
    pos = strstr(pvd->jpg_name, ".et3");
    pos++;
    *(pos++) = 'j';
    *(pos++) = 'p';
    *(pos++) = 'g';
    *(pos) = 0;
    if (vn == 0) {
        fseek(file, 0, SEEK_END);
        size = ftell(file);
        fseek(file, 4, SEEK_SET);
    } else {
        size = vh[0].offset;
        size -= (4 + sizeof(struct voice_header) * vn);
        fseek(file, 4 + sizeof(struct voice_header) * vn, SEEK_SET);
    }
    memset(material_file, 0, sizeof(material_file));
    strcpy(material_file, pmmd->path);
    strcat(material_file, pvd->jpg_name);
    jpg_file = fopen(material_file, "wb+");
    if (jpg_file == NULL) {
        fclose(file);
        free(pvd);
        return NULL;
    }
    copy_file(jpg_file, file, size, 0);
    
    fclose(jpg_file);
    pos = strstr(material_file, ".jpg");
    while (*pos-- != '/');
    pos += 2;
    *pos = 0;
    
    for (i = 0; i < vn; i++) {
        sprintf(buf, "%s%d", material_file, i);
        voice_file = fopen(buf, "wb+");
        if (voice_file == NULL) {
            LOGI("%s,%d fopen error\n", __FUNCTION__, __LINE__);
            fclose(file);
            return NULL;
        }
        fseek(file, vh[i].offset, SEEK_SET);
        copy_file(voice_file, file, vh[i].len, 0);
        fclose(voice_file);
    }
    fclose(file);
    pvd->total_voice_count = vn;
    LIST_ADD_TAIL(&pvd->list, &pmmd->material_list_head);
    return pvd;
}

static void internal_material_close(struct material_mgr_desc *pmmd, struct material_desc *pmd) {
    if (pmd->playing_voice_file) {
        fclose(pmd->playing_voice_file);
        pmd->playing_voice_file = 0;
        pmd->pause = 0;
    }
}

static void aac_decode_callback(void *usr, void *pdata) {
    struct material_mgr_desc *pmmd = (struct material_mgr_desc *) usr;
    //    pcm_render_player(pmmd->render_handle, pdata);
    //    material_pcm_render_player(pmmd->render_handle, pdata);
}

static uint32_t material_mgr_thread(void *lpThreadParameter) {
    struct list_head *n = NULL;
    struct list_head *get = NULL;
    struct material_desc *pmd;
    struct material_mgr_desc *pmmd = (struct material_mgr_desc *) lpThreadParameter;
    //    pmmd->render_handle = material_pcm_open_player(&pmmd->ppp);
//    if (pmmd->render_handle == -1) goto out;
//    //    pmmd->aac_decoder_handle = create_aac_decoder(aac_decode_callback, pmmd, AudioMaterial);
//    if (pmmd->aac_decoder_handle == -1) {
//        LOGI("%s:create_aac_decoder", __FUNCTION__);
//        goto out;
//    }

    uint32_t msg_len;
    struct event_desc *ped;
    
    MAKE_TO_UI_MATERIAL_MGR_HANDLE( pmmd, pmmd->ec, pmmd->usr);
    while (1) {
        
        
        /*检查消息队列*/
        ped = (struct event_desc *) msg_queue_rget(pmmd->msg_queue_handle, &msg_len);
        if (!ped) {
            goto next;
        }
        switch (ped->evt_id) {
            case FROM_UI_EVT_MGR_DELETE:
                goto out;
                break;
            case FROM_UI_EVT_OPEN_MATERIAL: {
                struct from_ui_evt_open_material *pfuemd = (struct from_ui_evt_open_material *) ped->data;
                pmd = internal_material_open(pmmd, pfuemd->material_name);
                if (pmd != NULL) {
                    MAKE_TO_UI_MATERIAL_HANDLE( pmd, pmd->jpg_name, pmd->total_voice_count,
                                               pmmd->ec, pmmd->usr);
                } else {
                    MAKE_TO_UI_MATERIAL_HANDLE(-1, NULL, 0, pmmd->ec, pmmd->usr);
                    material_stop_voice(pmmd);
                }
            }
                break;
            case FROM_UI_EVT_CLOSE_MATERIAL: {
                struct from_ui_evt_close_material *pfuecm = (struct from_ui_evt_close_material *) ped->data;
                list_iterate_safe(get, n, &pmmd->material_list_head) {
                    pmd = list_get(get, struct material_desc, list);
                    if ( pmd == pfuecm->material_handle) {
                        LIST_DEL(&pmd->list);
                        if (pmd == pmmd->pmd)
                            internal_material_close(pmmd, pmd);
                        MAKE_TO_UI_MATERIAL_CLOSED( pmd, pmmd->ec, pmmd->usr);
                        free(pmd);
                        break;
                    }
                }
            }
                break;
            case FROM_UI_EVT_STOP_VOICE: {
                if (pmmd->pmd) {
                    internal_material_close(pmmd, pmmd->pmd);
                    MAKE_TO_UI_VOICE_STOPED( pmmd->pmd, pmmd->pmd->playing_voice_num, pmmd->ec, pmmd->usr);
                    pmmd->pmd = NULL;
                }
            }
                break;
            case FROM_UI_EVT_PAUSE_VOICE: {
                if (pmmd->pmd) {
                    pmmd->pmd->pause = 1;
                    MAKE_TO_UI_VOICE_PAUSED( pmmd->pmd, pmmd->pmd->playing_voice_num, pmmd->ec, pmmd->usr);
                }
            }
                break;
            case FROM_UI_EVT_PLAY_VOICE: {
                struct from_ui_evt_play_voice *pfuepv = (struct from_ui_evt_play_voice *) ped->data;
                if (pmmd->pmd) {
                    if (pmmd->pmd->playing_voice_num == pfuepv->voice) {
                        pmmd->pmd->pause = 0;
                        break;
                    }
                    internal_material_close(pmmd, pmmd->pmd);
                    pmmd->pmd = NULL;
                }
                list_iterate_safe(get, n, &pmmd->material_list_head) {
                    pmd = list_get(get, struct material_desc, list);
                    if ( pmd == pfuepv->material_handle) {
                        char voice_file[256];
                        char *pos;
                        memset(voice_file, 0, sizeof(voice_file));
                        strcpy(voice_file, pmmd->path);
                        strcat(voice_file, pmd->jpg_name);
                        
                        pos = strstr(voice_file, ".jpg");
                        while (*pos-- != '/');
                        pos += 2;
                        *pos = pfuepv->voice + '0';
                        memset(pos + 1, 0, sizeof(voice_file) - (pos - voice_file - 1));
                        pmd->playing_voice_file = fopen((const char *) voice_file, "rb");
                        if (pmd->playing_voice_file == NULL) {
                            MAKE_TO_UI_VOICE_ERROR( pmd, pfuepv->voice, pmmd->ec, pmmd->usr);
                        } else {
                            MAKE_TO_UI_VOICE_START( pmd, pfuepv->voice, pmmd->ec, pmmd->usr);
                            pmd->playing_voice_num = pfuepv->voice;
                            pmmd->pmd = pmd;
                        }
                        break;
                    }
                }
            }
                break;
        }
        msg_queue_rset(pmmd->msg_queue_handle);
        
    next:
        if (pmmd->pmd == NULL || pmmd->pmd->pause == 1) {
            //Sleep(100);
            usleep(100000);
            continue;
        }
        if (/* DISABLES CODE */ (1)){//(is_pcm_rendr_full(pmmd->render_handle) == 0) {
            char buf[1024];
            uint16_t frame_len;
            if (fread((char *) &frame_len, 2, 1, pmmd->pmd->playing_voice_file) == 0) {
                /*notify ui*/
                internal_material_close(pmmd, pmmd->pmd);
                MAKE_TO_UI_VOICE_END( pmd, pmd->playing_voice_num, pmmd->ec, pmmd->usr);
                pmmd->pmd = NULL;
            } else {
                if (frame_len) {
                    fread((char *) buf, 1, frame_len, pmmd->pmd->playing_voice_file);
                    //                    decode_aac_frame(pmmd->aac_decoder_handle, buf, frame_len, AudioMaterial);
                }
            }
        } else {
            //Sleep(100);
            usleep(100000);
        }
    }
out:
    if (pmmd->render_handle && pmmd->render_handle != -1) {
        material_pcm_close_player(pmmd->render_handle);
    }
    if (pmmd->aac_decoder_handle && pmmd->aac_decoder_handle != -1) {
        //        delete_aac_decoder(pmmd->aac_decoder_handle, AudioMaterial);
    }
    list_iterate_safe(get, n, &pmmd->material_list_head) {
        pmd = list_get(get, struct material_desc, list);
        LIST_DEL(&pmd->list);
        if (pmd == pmmd->pmd)
            internal_material_close(pmmd, pmd);
        MAKE_TO_UI_MATERIAL_CLOSED( pmd, pmmd->ec, pmmd->usr);
        free(pmd);
    }
    if (pmmd->msg_queue_handle && pmmd->msg_queue_handle != -1) {
        msg_queue_delete(pmmd->msg_queue_handle);
    }
    
    MAKE_TO_UI_MATERIAL_MGR_HANDLE(-1, pmmd->ec, pmmd->usr);
    free(pmmd);
    return 0;
}

 int material_mgr_create(void *usr, event_callback ec, char *path, struct pcm_player_param *pppp) {
    struct material_mgr_desc *pmmd = (struct material_mgr_desc *) malloc(
                                                                         sizeof(struct material_mgr_desc));
    if (!pmmd)return -1;
    memset(pmmd, 0, sizeof(struct material_mgr_desc));
    pmmd->msg_queue_handle = msg_queue_create(32, 8);
    if (pmmd->msg_queue_handle == -1) {
        free(pmmd);
        return -1;
    }
    pmmd->ec = ec;
    pmmd->usr = usr;
    pmmd->ppp = *pppp;
    INIT_LIST(pmmd->material_list_head);
    printf("path:%ld\n",strlen(path));
    strcpy(pmmd->path, path);
    
    //    pmmd->thread_handle=(HANDLE)_beginthreadex(NULL, 0, material_mgr_thread, (void*)pmmd, 0, (uint32_t*)&pmmd->thread_id);
    pmmd->thread_handle = pthread_create(&pmmd->thread_id, NULL, (void *) material_mgr_thread, (void *) pmmd);
    if (pmmd->thread_handle != 0) {
        msg_queue_delete(pmmd->msg_queue_handle);
        free(pmmd);
        return -1;
    }
    return 0;
}

//int material_mgr_delete(int mgr_handle) {
//    uint32_t len;
//    struct event_desc *ped;
//    struct from_ui_evt_mgr_delete *pfuemd;
//    struct material_mgr_desc *pmmd = (struct material_mgr_desc *) mgr_handle;
//    ped = (struct event_desc *) msg_queue_wget(pmmd->msg_queue_handle, &len);
//    if (ped == NULL)return -1;
//    ped->evt_id = FROM_UI_EVT_MGR_DELETE;
//    ped->len = sizeof(struct from_ui_evt_mgr_delete);
//    pfuemd = (struct from_ui_evt_mgr_delete *) ped->data;
//    pfuemd->material_mgr_handle = mgr_handle;
//    msg_queue_wset(pmmd->msg_queue_handle, sizeof(struct event_desc) + ped->len);
//    return 0;
//}
//
int material_play_voice(void * mgr_handle, void * material_handle, int voice) {
    uint32_t len;
    struct event_desc *ped;
    struct from_ui_evt_play_voice *pfuemd;
    struct material_mgr_desc *pmmd = (struct material_mgr_desc *) mgr_handle;
    ped = (struct event_desc *) msg_queue_wget(pmmd->msg_queue_handle, &len);
    if (ped == NULL)return -1;
    ped->evt_id = FROM_UI_EVT_PLAY_VOICE;
    ped->len = sizeof(struct from_ui_evt_play_voice);
    pfuemd = (struct from_ui_evt_play_voice *) ped->data;
    pfuemd->material_mgr_handle = mgr_handle;
    pfuemd->material_handle = material_handle;
    pfuemd->voice = voice;
    msg_queue_wset(pmmd->msg_queue_handle, sizeof(struct event_desc) + ped->len);
    return 0;
}

int material_stop_voice(void * mgr_handle) {
    uint32_t len;
    struct event_desc *ped;
    struct from_ui_evt_play_voice *pfuemd;
    struct material_mgr_desc *pmmd = (struct material_mgr_desc *) mgr_handle;
    ped = (struct event_desc *) msg_queue_wget(pmmd->msg_queue_handle, &len);
    if (ped == NULL)return -1;
    ped->evt_id = FROM_UI_EVT_STOP_VOICE;
    ped->len = 0;
    msg_queue_wset(pmmd->msg_queue_handle, sizeof(struct event_desc) + ped->len);
    return 0;
}

int material_pause_voice(void * mgr_handle) {
    uint32_t len;
    struct event_desc *ped;
    struct from_ui_evt_play_voice *pfuemd;
    struct material_mgr_desc *pmmd = (struct material_mgr_desc *) mgr_handle;
    ped = (struct event_desc *) msg_queue_wget(pmmd->msg_queue_handle, &len);
    if (ped == NULL)return -1;
    ped->evt_id = FROM_UI_EVT_PAUSE_VOICE;
    ped->len = 0;
    msg_queue_wset(pmmd->msg_queue_handle, sizeof(struct event_desc) + ped->len);
    return 0;
}

int material_open_material(void * mgr_handle, char *material_name) {
    LOGI("mgr_handle=%zd,material_name:%s", mgr_handle, material_name);
    uint32_t len;
    struct event_desc *ped;
    struct from_ui_evt_open_material *pfuemd;
    struct material_mgr_desc *pmmd = (struct material_mgr_desc *) mgr_handle;
    ped = (struct event_desc *) msg_queue_wget(pmmd->msg_queue_handle, &len);
    if (ped == NULL)return -1;
    ped->evt_id = FROM_UI_EVT_OPEN_MATERIAL;
    ped->len = sizeof(struct from_ui_evt_open_material);
    pfuemd = (struct from_ui_evt_open_material *) ped->data;
    pfuemd->material_mgr_handle = mgr_handle;
    memset(pfuemd->material_name, 0, sizeof(pfuemd->material_name));
    strcpy(pfuemd->material_name, material_name);
    msg_queue_wset(pmmd->msg_queue_handle, sizeof(struct event_desc) + ped->len);
    return 0;
}

int material_close_material(void * mgr_handle, void * material_handle) {
    uint32_t len;
    struct event_desc *ped;
    struct from_ui_evt_close_material *pfuemd;
    struct material_mgr_desc *pmmd = (struct material_mgr_desc *) mgr_handle;
    ped = (struct event_desc *) msg_queue_wget(pmmd->msg_queue_handle, &len);
    if (ped == NULL)return -1;
    ped->evt_id = FROM_UI_EVT_CLOSE_MATERIAL;
    ped->len = sizeof(struct from_ui_evt_close_material);
    pfuemd = (struct from_ui_evt_close_material *) ped->data;
    pfuemd->material_mgr_handle = mgr_handle;
    pfuemd->material_handle = material_handle;
    msg_queue_wset(pmmd->msg_queue_handle, sizeof(struct event_desc) + ped->len);
    return 0;
}