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
#import <MJRefresh.h>
#import "DQCollectHelper.h"

#define CACHE_DATA [NSString stringWithFormat:@"%@/cachedata",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]]

@interface DQNewsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@property(nonatomic,strong)NSMutableArray * dataArray;/**<news model array*/
@end

static NSString * const identify = @"newscell";

@implementation DQNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark -
#pragma mark configUI
-(void)configUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.table registerNib:[UINib nibWithNibName:@"DQNewsTableViewCell" bundle:nil] forCellReuseIdentifier:identify];
    self.table.tableFooterView = [[UIView alloc] init];
    //下拉刷新
    __block DQNewsViewController * blockSelf = self;
    self.table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [blockSelf loadData:YES];
        [blockSelf.table reloadData];
        [blockSelf.table.mj_header endRefreshing];
    }];
    [self.table.mj_header beginRefreshing];
    //上拉刷新
    self.table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [blockSelf loadData:NO];
        [blockSelf.table reloadData];
        [blockSelf.table.mj_footer endRefreshing];
    }];
}

#pragma mark -
#pragma mark load data

-(void)loadData:(BOOL)isHead{
    AFNetworkReachabilityManager * rm = [AFNetworkReachabilityManager sharedManager];
    NSLog(@"%d",rm.isReachable);
    if (rm.isReachableViaWiFi || rm.isReachableViaWWAN || false) {
        __block DQNewsViewController * blockSelf = self;
        //判断是否上拉下拉刷新
        static NSInteger page = 1;
        if (!isHead) {
            if (self.dataArray.count > 0) {
                page += 1;
            }
        }else{
            page = 1;
        }
        //请求数据
        [DQNetServer networkServerWithPage:page Block:^(NSArray *array) {
            if (page == 1) {
                //缓存
                [NSKeyedArchiver archiveRootObject:array toFile:CACHE_DATA];
                blockSelf.dataArray = [NSMutableArray arrayWithArray:array];
            }else{
                [blockSelf.dataArray addObjectsFromArray:array];
            }
            [blockSelf.table reloadData];
        }];
    }else{
        //没有网络，从缓存中读取
        NSArray * array = [NSKeyedUnarchiver unarchiveObjectWithFile:CACHE_DATA];
        _dataArray = [NSMutableArray arrayWithArray:array];
        [self.table reloadData];
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
    detail.model = model;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

@end
