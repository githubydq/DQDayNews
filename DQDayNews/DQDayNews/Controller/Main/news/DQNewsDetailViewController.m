//
//  DQNewsDetailViewController.m
//  DQDayNews
//
//  Created by youdingquan on 16/5/12.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQNewsDetailViewController.h"
#import <AFNetworkReachabilityManager.h>
#import <MBProgressHUD.h>
#import "DQShowImageViewController.h"

#import "DQNewsModel.h"
#import "DQCollectHelper.h"

@interface DQNewsDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *web;
@property(nonatomic,strong)UIImageView * imageView;
@property(nonatomic,strong)MBProgressHUD * hud;
@end

@implementation DQNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadData];
    [self configUI];
    [self configNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark configUI
-(void)configUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.imageView.backgroundColor = [UIColor blackColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(detailTapClick)];
    [self.imageView addGestureRecognizer:tap];
    self.imageView.userInteractionEnabled = YES;
    [self.view addSubview:self.imageView];
    self.imageView.alpha = 0;
}

-(void)configNav{
    //判断是否收藏
    BOOL isCollected = NO;
    NSArray * array = [DQCollectHelper getCollect];
    for (DQNewsModel * model in array) {
        if ([model.url isEqualToString:self.url]) {
            isCollected = YES;
            break;
        }
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(detailRightClick)];
    if (isCollected) {
        [self detailRightClick];
    }
}
-(void)detailRightClick{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"收藏"]) {
        //添加收藏
        [self.navigationItem.rightBarButtonItem setTitle:@"已收藏"];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor redColor]];
        [DQCollectHelper addCollect:self.model];
    }else {
        //取消收藏
        [self.navigationItem.rightBarButtonItem setTitle:@"收藏"];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
        [DQCollectHelper cancleCollect:self.model];
    }
}

#pragma mark -
#pragma mark imageView GestureRecognizer
-(void)detailTapClick{
    self.imageView.alpha = 0;
}

#pragma mark -
#pragma mark load data
-(void)loadData{
    __block DQNewsDetailViewController * blockSelf = self;
    //创建进度控制器
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //网络环境监测
    AFNetworkReachabilityManager * rm = [AFNetworkReachabilityManager sharedManager];
//    NSLog(@"%d",rm.isReachable);
    if (rm.isReachableViaWiFi || rm.isReachableViaWWAN) {
        self.hud.labelText = @"加载中";
        [self loadAtWebView:self.web WithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }else{
        self.hud.labelText = @"没有网络";
        dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, 1.0*NSEC_PER_SEC);
        dispatch_after(t, dispatch_get_main_queue(), ^{
            [blockSelf.hud hide:YES];
        });
    }
    
}

#pragma mark -
#pragma mark modify url
-(void)loadAtWebView:(UIWebView *)webView WithRequest:(NSURLRequest *)request{
    //对URL进行处理
    if ([request.URL.absoluteString containsString:@"http://www.i4.cn/news_detail_"]) {
        //截取最后结果网址
        NSMutableString * str = [NSMutableString stringWithString:request.URL.absoluteString];
        NSRange wwwRange = [str rangeOfString:@"www"];
        [str replaceCharactersInRange:wwwRange withString:@"m"];
        NSRange detailRange = [str rangeOfString:@"_detail_"];
        [str replaceCharactersInRange:detailRange withString:@"/"];
        //获取网页文本
        NSString * bobytext = [NSString stringWithContentsOfURL:request.URL encoding:NSUTF8StringEncoding error:nil];
        //获取需要的文本
        NSArray * bobyArray = [bobytext componentsSeparatedByString:@"<div"];
        NSMutableArray * resultArray = [[NSMutableArray alloc] init];
        for (NSString * str in bobyArray) {
            if ([str containsString:@"class=\"article_content_caption\""]) {
                NSString * string = [NSString stringWithFormat:@"<div%@",str];
                [resultArray insertObject:string atIndex:0];
//                NSLog(@"===%@",str);
            }
            if ([str containsString:@"class=\"article_content_text\""]) {
                NSString * string = [NSString stringWithFormat:@"<div%@",str];
                [resultArray addObject:string];
//                NSLog(@"===%@",str);
            }
        }
        NSString * text = [resultArray componentsJoinedByString:@""];
        //组合
        NSString * requestString = [NSString stringWithFormat:@"<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\"></head><body>%@</body></html>",text];
        [webView loadHTMLString:requestString baseURL:nil];
    }
}

#pragma mark -
#pragma mark web delegate

/**
 * 将要加载
 */
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    NSLog(@"url:%@",request.URL.absoluteString);
    
    //预览图片
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        NSString * path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
//        path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:NSUTF8StringEncoding]];
        DQShowImageViewController * showImage = [[DQShowImageViewController alloc] init];
        showImage.url = [NSURL URLWithString:path];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:showImage animated:NO];
        return NO;
    }
    
    return YES;
}
/**
 * 加载完成
 */
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"function assignImageClickAction(){var imgs=document.getElementsByTagName('img');var length=imgs.length;for(var i=0; i < length;i++){img=imgs[i];img.onclick=function(){window.location.href='image-preview:'+this.src}}}"];
    [webView stringByEvaluatingJavaScriptFromString:@"assignImageClickAction();"];

}

/**
 * 开始加载
 */
-(void)webViewDidStartLoad:(UIWebView *)webView{
    self.hud.labelText = @"开始加载";
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self.hud hide:YES];
    });
}
/**
 * 加载失败
 */
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.hud.labelText = @"加载失败";
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self.hud hide:YES];
    });
}


@end
