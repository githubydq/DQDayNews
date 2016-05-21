//
//  DQCollectHelper.m
//  DQDayNews
//
//  Created by youdingquan on 16/5/17.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQCollectHelper.h"
#import "DQNewsModel.h"

#define COLLECT_PATH [NSString stringWithFormat:@"%@/collectdata.plist",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]]

@implementation DQCollectHelper
/**
 * 创建plist文件
 */
+(BOOL)createCollectionPlist{
    NSLog(@"%@",COLLECT_PATH);
    NSFileManager * fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:COLLECT_PATH]) {
        [fm createFileAtPath:COLLECT_PATH contents:nil attributes:nil];
        NSArray * array = [NSArray new];
        [array writeToFile:COLLECT_PATH atomically:YES];
    }
    return YES;
}
/**
 * 添加收藏
 */
+(BOOL)addCollect:(DQNewsModel*)model{
    NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithFile:COLLECT_PATH];
    NSMutableArray * array = [NSMutableArray arrayWithArray:arr];
    //判断是否已收藏
    for (DQNewsModel * m in array) {
        if ([m.url isEqualToString:model.url]) {
            return YES;
        }
    }
    [array addObject:model];
    return [NSKeyedArchiver archiveRootObject:array toFile:COLLECT_PATH];;
}
/**
 * 取消收藏
 */
+(BOOL)cancleCollect:(DQNewsModel *)model{
    NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithFile:COLLECT_PATH];
    NSMutableArray * array = [NSMutableArray arrayWithArray:arr];
    //判断是否已收藏
    for (NSInteger i = array.count -1; i >=0 ; i--) {
        DQNewsModel * m = array[i];
        if ([m.url isEqualToString:model.url]) {
            NSLog(@"%s",__FUNCTION__);
            [array removeObjectAtIndex:i];
            //            [array removeObject:model];
        }
    }
    return [NSKeyedArchiver archiveRootObject:array toFile:COLLECT_PATH];;
}
/**
 * 获取收藏列表
 */
+(NSArray *)getCollect{
    NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithFile:COLLECT_PATH];
    return arr;
}
@end
