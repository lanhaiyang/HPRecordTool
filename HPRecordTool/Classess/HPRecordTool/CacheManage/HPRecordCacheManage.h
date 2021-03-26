//
//  HPRecordCacheManage.h
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/14.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPRecordCacheManage : NSObject

-(BOOL)hp_removeRecordFile;

-(NSString *)hp_cacheAssistRecordPath;

-(BOOL)hp_isExistCacheAssistRecordPath;


-(NSString *)hp_cacheMainRecordPath;

-(BOOL)hp_isExistCacheMainRecordPath;

-(BOOL)hp_removeMainRecordFile;

-(BOOL)hp_isExistFileWithFilePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
