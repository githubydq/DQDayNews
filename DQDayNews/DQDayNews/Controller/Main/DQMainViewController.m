//
//  DQMainViewController.m
//  DQDayNews
//
//  Created by youdingquan on 16/5/12.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQMainViewController.h"
#import "DQNetServer.h"

#import "DQNewsModel.h"

#import "DQNewsViewController.h"
#import "DQSetViewController.h"

@interface DQMainViewController ()
@property(nonatomic,strong)NSArray * listArray;
@property(nonatomic,strong)NSArray * VCsNameArray;
@end

@implementation DQMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self configTabbar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark load data
-(void)loadData{
    self.listArray = @[@"新闻",@"设置"];
    self.VCsNameArray = @[@"DQNewsViewController",@"DQSetViewController"];
}

#pragma mark -
#pragma mark set tabbar
-(void)configTabbar{
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < self.VCsNameArray.count ; i++) {
        UIViewController * vc = [[NSClassFromString(self.VCsNameArray[i]) alloc] init];
        DQBaseNavViewController * nav = [[DQBaseNavViewController alloc] initWithRootViewController:vc];
        [arr addObject:nav];
    }
    self.viewControllers = arr;
    
    for (int i = 0 ; i < self.listArray.count ; i++) {
        UIViewController * vc = self.viewControllers[i];
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:self.listArray[i] image:nil selectedImage:nil];
    }
}

@end
