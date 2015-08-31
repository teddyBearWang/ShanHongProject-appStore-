//
//  DownloadFile.m
//  ShanHongProject
//
//  Created by teddy on 15/7/15.
//  Copyright (c) 2015年 teddy. All rights reserved.
//

#import "DownloadFile.h"
#import <AFNetworking.h>

static DownloadFile *downloadFile = nil;


@implementation DownloadFile

#pragma mark - 单例
+(DownloadFile *)shareTheme
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadFile = [[DownloadFile alloc] init];
    });
    
    return downloadFile;

}

#pragma mark - 通过请求得到文件的路劲

- (void)DownloadFilesUrl:(NSString *)aFilesUrl
{
    //aFileUrl = http://115.236.169.28/xjxly/FileDoc/12345.pdf
    //先判断缓存中是否存在文件
    NSString *filePath = [self cacheFile:aFilesUrl];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        //文件存在,则发送一个通知
        [[NSNotificationCenter defaultCenter] postNotificationName:FILESDOWNLOADCOMPLETE object:filePath];
    }else{
        //若是不存在，则下载
        [self loadFileFromUrl:aFilesUrl];
    }
    
    
}

- (NSString *)cacheFile:(NSString *)filename
{
    // filename = http://115.236.169.28/xjxly/FileDoc/12345.pdf
    //获得根目录路径
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //pdf文件夹存在的路径
    cacheFolder = [cacheFolder stringByAppendingPathComponent:@"PDF"];
    //cacheFolder = ****/pdf/12345.pdf
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cacheFolder]) {
        //文件不存在
        NSError *error = nil;
        //文件夹不存在，则创建
        [fileManager createDirectoryAtPath:cacheFolder withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            return nil;
        }
    }
    
    //传入值是一个url,取最后的文件名称
    NSArray *paths = [filename componentsSeparatedByString:@"/"];
    if (paths.count == 0) {
        return nil;
    }
    
    //最后下载好的文件存放地址
    NSString *filePaths = [NSString stringWithFormat:@"%@/%@",cacheFolder,[paths lastObject]];
    return filePaths;
}


#pragma mark - 下载文件，下载完成之后，发送通知

- (void)loadFileFromUrl:(NSString *)url
{
    //URL= http://115.236.169.28/xjxly/FileDoc/12345.pdf
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation *operation = nil;
    NSString *Url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    @try {
        operation = [manager GET:Url parameters:nil success:nil failure:nil];

    }
    @catch (NSException *exception) {
    }
    [operation waitUntilFinished];
    if (operation.responseData != nil) {
        //缓存路径
        NSString *cacheFile = [self cacheFile:url];
        [operation.responseData writeToFile:cacheFile atomically:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:FILESDOWNLOADCOMPLETE object:[self cacheFile:url]];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:FILEDOWNLOADFAIL object:[self cacheFile:url]];
    }
}

@end
