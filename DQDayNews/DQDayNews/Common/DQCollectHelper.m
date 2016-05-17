//
//  DQCollectHelper.m
//  DQDayNews
//
//  Created by youdingquan on 16/5/17.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQCollectHelper.h"

#define COLLECT_PATH [NSString stringWithFormat:@"%@/collectdata.plist",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]]

@implementation DQCollectHelper
+(BOOL)addCollect:(DQNewsModel*)model{
    NSLog(@"%@",COLLECT_PATH);
    NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithFile:COLLECT_PATH];
    NSMutableArray * array = [NSMutableArray arrayWithArray:arr];
    [array addObject:model];
    return [NSKeyedArchiver archiveRootObject:array toFile:COLLECT_PATH];;
}
+(NSArray *)getCollect{
    NSArray * arr = [NSKeyedUnarchiver unarchiveObjectWithFile:COLLECT_PATH];
    return arr;
}
@end
