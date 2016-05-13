//
//  DQNewsTableViewCell.m
//  DQDayNews
//
//  Created by youdingquan on 16/5/12.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQNewsTableViewCell.h"
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

#import "DQNewsModel.h"

@interface DQNewsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *desc;

@end

@implementation DQNewsTableViewCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setModel:(DQNewsModel *)model{
    _model = model;
    if (_model) {
        self.title.text = _model.title;
        self.desc.text = _model.desc;
        self.time.text = _model.ctime;
        [self loadImage:[NSURL URLWithString:_model.picUrl]];
    }
}

#pragma mark -
#pragma mark load image
-(void)loadImage:(NSURL *)url{
    [self.image sd_setImageWithPreviousCachedImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
//    UIImage * image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[url absoluteString]];
//    if (image) {
//        [self.image setImage:image];
//    }else{
//        NSString * path = [[NSBundle mainBundle] pathForResource:@"image" ofType:@"bundle"];
//        [self.image sd_setImageWithURL:url placeholderImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/loading40x40.png",path]]];
//    }
}

@end
