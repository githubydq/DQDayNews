//
//  DQMyCollectViewController.m
//  DQDayNews
//
//  Created by youdingquan on 16/5/17.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQMyCollectViewController.h"
#import "DQCollectHelper.h"
#import "DQNewsModel.h"
#import "DQNewsDetailViewController.h"
#import "DQCollectHelper.h"

@interface DQMyCollectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property(nonatomic,strong)NSMutableArray * dataArray;
@end

@implementation DQMyCollectViewController

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
    [self loadData];
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
    self.dataArray = [NSMutableArray arrayWithArray:[DQCollectHelper getCollect]];
}

#pragma mark -
#pragma mark table delegate & datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identify = @"collectcell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (self.dataArray.count) {
        DQNewsModel * model = self.dataArray[indexPath.row];
        cell.textLabel.text = model.title;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count) {
        DQNewsModel * model = self.dataArray[indexPath.row];
        DQNewsDetailViewController * detail = [[DQNewsDetailViewController alloc] init];
        detail.url = model.url;
        detail.model = model;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:NO];
    }
}

@end
