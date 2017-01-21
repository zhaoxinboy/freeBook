//
//  MMUErrorType.h
//  MMULibrary
//
//  Created by liufuyin on 16/8/31.
//  Copyright © 2016年 alimama. All rights reserved.
//

typedef enum {
    MMUE_Null,                              //null
    
    MMUE_SlotIDInvalid,                     //slotID无效
    MMUE_DataLoadFailed,                    //平台数据列表加载失败
    MMUE_AllPlatfromFailed,                 //广告平台全部失败
    MMUE_DataLoadOutTime,                   //平台数据列表加载超时
    
    MMUE_PFReqTimeOut,                      //平台广告请求超时
    MMUE_PFReqNotReady,                     //平台广告尚未请求完成
    MMUE_PFAdFailed,                        //平台广告加载失败
    MMUE_PFAdObjError,                      //平台广告对象创建错误
    MMUE_PFAdIDInvalid,                     //平台广告ID无效
    
    MMUE_Banner_SizeInvalid,                //banner尺寸类型错误
    
    MMUE_Splash_LoadOutTime,                //开屏加载时长超过设置时间
    MMUE_Splash_WindowNeed,                 //开屏需要添加在window上
    MMUE_Splash_SizeInvalid,                //Splash_尺寸类型错误
    MMUE_Splash_ReserveViewSuper,           //开屏预留视图不能有父试图
    MMUE_Splash_ReserveViewSizeInvalid,     //开屏预留视图尺寸错误
    MMUE_Splash_SettingError,               //开屏视图自定义设置错误
    
    MMUE_Interstitial_DisplayFailed,        //插屏平台广告展示失败
    MMUE_Interstitial_WindowNeed,           //平台广告插屏需要window
    MMUE_Interstitial_CreativeTimeOut,      //当前创意过期
    
    MMUE_DI_DataError,                      //平台广告返回数据错误
    
    MMUE_ZIP_DOWNLOAD,                      //离线包下载错误
    MMUE_ZIP_UnzipOpen,                     //解压离线包打开文件错误
    MMUE_ZIP_Unzip,                         //解压离线包错误
    MMUE_ZIP_UnzipWrite,                    //解压离线包写入文件错误
    MMUE_ZIP_FileNotExist,                  //解压离线包后文件找不到
    
    //----------
    
    
} MMUErrorType;
