//
//  HPRecordCacheManage.m
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/14.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "HPRecordCacheManage.h"

@interface HPRecordCacheManage()

@property(nonatomic,strong) NSFileManager *fileManage;

@end

@implementation HPRecordCacheManage


- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self create];
    }
    return self;
}

-(void)create{
    
    _fileManage = [NSFileManager defaultManager];
}


-(NSString *)hp_cacheRecordBasePath{
    
    //1.获取沙盒地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [path stringByAppendingString:@"/Record"];
    if ([_fileManage fileExistsAtPath:filePath] == NO) {
          [_fileManage createDirectoryAtPath:filePath attributes:nil];
    };
    //先判断这个文件夹是否存在，如果不存在则创建，否则不创建
    return filePath;
}



-(NSString *)hp_cacheAssistRecordPath{
    
    //1.获取沙盒地址
    NSString *path = [self hp_cacheRecordBasePath];
    NSString *filePath = nil;
    if (self.cachePath.length != 0 && self.pathExtension.length != 0) {
        
        filePath = [NSString stringWithFormat:@"%@/record1.%@",path,self.pathExtension];
    }else{
        
        filePath = [NSString stringWithFormat:@"%@/record1.m4a",path];
    }

    return filePath;
}

-(BOOL)hp_isExistCacheAssistRecordPath{
    
    NSString *path = [self hp_cacheAssistRecordPath];
    return [_fileManage fileExistsAtPath:path];
}


-(NSString *)hp_cacheMainRecordPath{

    
    if (_cachePath.length != 0 && _pathExtension.length != 0) {
        
        return _cachePath;
    }else{
        
        //1.获取沙盒地址
        NSString *path = [self hp_cacheRecordBasePath];
        NSString *filePath = [NSString stringWithFormat:@"%@/record.m4a",path];
        return filePath;
    }
}

-(BOOL)hp_isExistCacheMainRecordPath{
    
    NSString *path = [self hp_cacheMainRecordPath];
    return [_fileManage fileExistsAtPath:path];
}

-(BOOL)hp_isExistFileWithFilePath:(NSString *)filePath{
    
    if (filePath.length == 0) {
        return NO;
    }
    
    return [_fileManage fileExistsAtPath:filePath];
}


-(BOOL)hp_removeRecordFile{
    
    BOOL isRemoveMainRecord = [self hp_removeFileWithPath:[self hp_cacheMainRecordPath]];
    BOOL isRemoveAssistRecord = [self hp_removeFileWithPath:[self hp_cacheAssistRecordPath]];
    return isRemoveMainRecord == YES && isRemoveAssistRecord == YES;
}

-(BOOL)hp_removeFileWithPath:(NSString *)path{
    
    if (path.length == 0) {
        return nil;
    }
    if ([_fileManage fileExistsAtPath:path]){
        
        NSURL *pathURL = [NSURL fileURLWithPath:path];
        NSError *error;
        [_fileManage removeItemAtURL:pathURL error:&error];
        
        if (error == nil) {
            return YES;
        }
        return NO;
    }else{
        
        return YES;
    }
}

-(BOOL)hp_removeMainRecordFile{
    
    NSString *path = [self hp_cacheMainRecordPath];
    if ([_fileManage fileExistsAtPath:path]){
        
        NSURL *pathURL = [NSURL fileURLWithPath:path];
        NSError *error;
        [_fileManage removeItemAtURL:pathURL error:&error];
        
        if (error == nil) {
            return YES;
        }
        return NO;
    }else{
        
        return YES;
    }
}


@end
