//
//  DQNewsDetailViewController.h
//  DQDayNews
//
//  Created by youdingquan on 16/5/12.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DQNewsDetailViewController : UIViewController
@property(nonatomic,copy)NSString * url;
@property(nonatomic,copy)void (^block)(BOOL collect);
@end
