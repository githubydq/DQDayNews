//
//  DQSetViewController.m
//  DQDayNews
//
//  Created by youdingquan on 16/5/13.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQSetViewController.h"
#import <SDImageCache.h>
#import "DQMyCollectViewController.h"

@interface DQSetViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property(nonatomic,strong)NSArray * listArray;
@end

@implementation DQSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadData];
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.table reloadData];
}

#pragma mark -
#pragma mark configUI
-(void)configUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark -
#pragma mark load data
-(void)loadData{
    self.listArray = @[@[@"清理缓存"],@[@"我的收藏"]];
}

#pragma mark -
#pragma mark table delegate & datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listArray[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identify = @"setcell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.listArray[indexPath.section][indexPath.row];
    if ([cell.textLabel.text isEqualToString:@"清理缓存"]) {
        cell.detailTextLabel.text = [self getImageCacheSize];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"清理缓存"]) {
        [self clearImageCacheComplete:^(bool complete) {
            if (YES) {
                cell.detailTextLabel.text = @"0.00M";
            }
        }];
    }else if ([cell.textLabel.text isEqualToString:@"我的收藏"]){
        DQMyCollectViewController * collect = [[DQMyCollectViewController alloc] init];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:collect animated:NO];
        self.hidesBottomBarWhenPushed = NO;
    }
}

#pragma mark -
#pragma mark image cache
-(NSString *)getImageCacheSize{
    SDImageCache * cache = [SDImageCache sharedImageCache];
    return [NSString stringWithFormat:@"%.2lfM",[cache getSize]/1024.0/1024.0];
}
-(void)clearImageCacheComplete:(void (^)(bool complete))block{
    SDImageCache * cache = [SDImageCache sharedImageCache];
    [cache clearDisk];
    [cache clearMemory];
    block(YES);
}

@end
