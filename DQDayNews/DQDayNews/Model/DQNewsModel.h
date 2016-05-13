//
//  DQNewsModel.h
//  DQDayNews
//
//  Created by youdingquan on 16/5/12.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DQNewsModel : NSObject<NSCoding>
@property(nonatomic,copy)NSString * ctime;
@property(nonatomic,copy)NSString * desc;
@property(nonatomic,copy)NSString * picUrl;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * url;
@end
