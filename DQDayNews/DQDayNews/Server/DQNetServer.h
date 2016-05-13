//
//  DQNetServer.h
//  DQDayNews
//
//  Created by youdingquan on 16/5/12.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ArrayBlock)(NSArray * array);

@interface DQNetServer : NSObject
+(void)networkServerGet:(ArrayBlock)block;
@end
