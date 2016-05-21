//
//  DQCollectHelper.h
//  DQDayNews
//
//  Created by youdingquan on 16/5/17.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DQNewsModel;
@interface DQCollectHelper : NSObject
+(BOOL)createCollectionPlist;
+(BOOL)addCollect:(DQNewsModel*)model;
+(BOOL)cancleCollect:(DQNewsModel*)model;
+(NSArray *)getCollect;
@end
