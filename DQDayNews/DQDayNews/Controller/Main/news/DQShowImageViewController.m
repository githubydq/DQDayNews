//
//  DQShowImageViewController.m
//  DQDayNews
//
//  Created by youdingquan on 16/5/13.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQShowImageViewController.h"
#import <UIImageView+WebCache.h>

@interface DQShowImageViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property(nonatomic,strong)UIImageView * imageView;
@end

@implementation DQShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark configUI
-(void)configUI{
    self.scroll.bounces = NO;
    self.scroll.contentOffset = CGPointZero;
    self.scroll.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.scroll setShowsHorizontalScrollIndicator:NO];
    [self.scroll setShowsVerticalScrollIndicator:NO];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scroll.contentSize.width, self.scroll.contentSize.height)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor blackColor];
    [self.scroll addSubview:self.imageView];
    
    NSLog(@"%@",self.url);
    [self.imageView sd_setImageWithURL:self.url];
}

#pragma mark -
#pragma mark GestureRecognizer
- (IBAction)back:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (IBAction)twoTap:(id)sender {
    CGFloat scale = 2.0;
    if (self.scroll.contentSize.width <= SCREEN_WIDTH) {
        self.scroll.contentSize = CGSizeMake(SCREEN_WIDTH*scale, SCREEN_HEIGHT*scale);
        self.imageView.frame = CGRectMake(0, 0, self.scroll.contentSize.width, self.scroll.contentSize.height);
        self.scroll.contentOffset = CGPointMake(self.scroll.contentSize.width/2.0 - SCREEN_WIDTH/2.0, self.scroll.contentSize.height/2.0 - SCREEN_HEIGHT/2.0);
    }else{
        self.scroll.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        self.imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.scroll.contentOffset = CGPointMake(0, .0);
    }
}


@end
