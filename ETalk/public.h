//
// Created by Administrator on 2015/9/15.
//

#ifndef ETALK_PUBLIC_H
#define ETALK_PUBLIC_H


//#define DEBUG_MODE 0

//#define TAG "Etalk_Jni"
//#if DEBUG_MODE
//#define LOGI(...) __android_log_print(ANDROID_LOG_INFO , TAG, __VA_ARGS__)
//#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, TAG, __VA_ARGS__)
//#define LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, TAG, __VA_ARGS__)
//#else
//#define LOGI(...)
//#define LOGE(...)
//#define LOGD(...)
//#endif

//#define AV_LOG_TAG
//#ifndef AV_LOG_TAG
//#define AV_LOG_TAG "Etalk_ffmpeg"
//#define AV_LOGI(...) __android_log_print(ANDROID_LOG_INFO , AV_LOG_TAG, __VA_ARGS__)
//#define AV_LOGE(...) __android_log_print(ANDROID_LOG_ERROR, AV_LOG_TAG, __VA_ARGS__)
//#define AV_LOGD(...) __android_log_print(ANDROID_LOG_DEBUG, AV_LOG_TAG, __VA_ARGS__)
//#else
//#define AV_LOGI(...)
//#define AV_LOGE(...)
//#define AV_LOGD(...)
//#endif

#define AUDIO_TRACK_OPEN        0x101
#define AUDIO_TRACK_PLAY        0x102
#define AUDIO_TRACK_WRITE       0x103
#define AUDIO_TRACK_STOP        0x104

#define MATERIAL_AUDIO_TRACK_OPEN 0x111
#define MATERIAL_AUDIO_TRACK_PLAY 0x112
#define MATERIAL_AUDIO_TRACK_WRITE 0x113
#define MATERIAL_AUDIO_TRACK_STOP 0x114

#define AUDIO_RECORD_OPEN       0x201
#define AUDIO_RECORD_START      0x202
#define AUDIO_RECORD_READ       0x203
#define AUDIO_RECORD_STOP       0x204

#define CAMERA_PREVIEW_OPEN     0x301
#define CAMERA_PREVIEW_START    0x302
#define CAMERA_PREVIEW_STOP     0x303
#define CAMERA_PREVIEW_CLOSE    0x304
#define CAMERA_PREVIEW_FREE     0x305

#define CAMERA_DRAW_BITMAP      0x401

#define SESSION_RECV_DATA       0x501
#define CONFIRM_ENTER_CLASSROOM 0x502
#define SESSION_CHECK_REMOVE    0x503

#define GET_MATERIAL_URL        0x601
#define SET_MATERIAL_JPG_VOICE  0x602
#define MATERIAL_DRAW_DATA      0x605

#define TYPE_FILE_PATH 99
/**
 * CLASSROOM COMMAND
 */
enum {
    CRCMD_SHORT_MESSAGE = 1,
    CRCMD_MATERIAL = 2,
    CRCMD_AUDIO = 3,
    CRCMD_VIDEO = 4,
    CRCMD_CLASS_OVER = 5,
    CRCMD_ENTER_CLASSROOM = 6,
    CRCMD_HEARTBEAT_PACKAGE = 7,
    CRCMD_DISMISS_CLASSROOM = 8,
    CRCMD_NOTALLOWED_ENTER = 9,
    CRCMD_FILESTREAM = 10,
    CRCMD_VIDEO_MINIMIZE = 11,
    CRCMD_MATERIAL_DRAW_STREAM = 12,
};

enum Audio_Command_Type {
    Audio_Command_Open = 1,
    Audio_Command_Close,
    Audio_Command_RequestConnect,
};

enum Video_Command_Type {
    Video_Command_Open = 1,
    Video_Command_Close,
    Video_Command_RequestConnect,
};

enum ControlCommand_Material_Info {
    ControlCommand_Material_DowndLoad = 1, //教材下载命令
    ControlCommand_Material_Parsing, //教材解析命令
    ControlCommand_Material_Loading, //教材加载命令
    ControlCommand_Material_PlayAudio,//教材播放音频
    ControlCommand_Material_StopAudio,//教材停止音频
};

enum ControlCommand_MaterialDrawStream_Info
{
    ControlCommand_MaterialDrawStream_Open = 1,
    ControlCommand_MaterialDrawStream_Close,
    ControlCommand_MaterialDrawStream_RequestConnect,
};

#endif //ETALK_PUBLIC_H