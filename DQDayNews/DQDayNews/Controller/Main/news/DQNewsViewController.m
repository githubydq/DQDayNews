//
//  DQNewsViewController.m
//  DQDayNews
//
//  Created by youdingquan on 16/5/12.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQNewsViewController.h"
#import <AFNetworkReachabilityManager.h>
#import "DQNewsTableViewCell.h"
#import "DQNewsDetailViewController.h"

#import "DQNetServer.h"

#import "DQNewsModel.h"

#define CACHE_DATA [NSString stringWithFormat:@"%@/cachedata",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]]

@interface DQNewsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@property(nonatomic,strong)NSMutableArray * dataArray;
@end

static NSString * const identify = @"newscell";

@implementation DQNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark -
#pragma mark lazy load

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        NSArray * array = [NSKeyedUnarchiver unarchiveObjectWithFile:CACHE_DATA];
        _dataArray = [[NSMutableArray alloc] init];
        _dataArray = [NSMutableArray arrayWithArray:array];
    }
    return _dataArray;
}

#pragma mark -
#pragma mark configUI
-(void)configUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.table registerNib:[UINib nibWithNibName:@"DQNewsTableViewCell" bundle:nil] forCellReuseIdentifier:identify];
    self.table.tableFooterView = [[UIView alloc] init];
}

#pragma mark -
#pragma mark load data

-(void)loadData{
    AFNetworkReachabilityManager * rm = [AFNetworkReachabilityManager sharedManager];
    NSLog(@"%d",rm.isReachable);
    if (rm.isReachableViaWiFi || rm.isReachableViaWWAN || true) {
        __block DQNewsViewController * blockSelf = self;
        [DQNetServer networkServerGet:^(NSArray *array) {
            //缓存
            [NSKeyedArchiver archiveRootObject:array toFile:CACHE_DATA];
            //加载数据
            blockSelf.dataArray = [NSMutableArray arrayWithArray:array];
            [blockSelf.table reloadData];
        }];
    }
    
}

#pragma mark -
#pragma mark table delegate & datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DQNewsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify forIndexPath:indexPath];
    if (self.dataArray.count > 0) {
        DQNewsModel * model = self.dataArray[indexPath.row];
        [cell setModel:model];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DQNewsDetailViewController * detail = [[DQNewsDetailViewController alloc] init];
    DQNewsModel * model = self.dataArray[indexPath.row];
    detail.url = model.url;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

@end
