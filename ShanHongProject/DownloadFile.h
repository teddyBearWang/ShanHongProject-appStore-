//
//  DownloadFile.h
//  ShanHongProject
//
//  Created by teddy on 15/7/15.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  FILESDOWNLOADCOMPLETE @"FilesDownloadComplete" //文件下载完成

#define  FILEDOWNLOADFAIL @"FileDownloadFail" //文件下载失败

@interface DownloadFile : NSObject

+(DownloadFile *)shareTheme;
- (void)DownloadFilesUrl:(NSString *)aFilesUrl;

@end
