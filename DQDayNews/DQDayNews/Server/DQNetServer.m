//
//  DQNetServer.m
//  DQDayNews
//
//  Created by youdingquan on 16/5/12.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQNetServer.h"
#import <AFNetworking.h>

#import "DQNewsModel.h"

/**
 num        返回数量
 page       翻页
 */
#define URLSTRING @"http://apis.baidu.com/txapi/apple/apple"
#define APIKEY @"132b6202fbd7c38c1d0978d5c3766d3f"

@implementation DQNetServer
+(void)networkServerGet:(ArrayBlock)block{
    AFHTTPSessionManager * session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session.requestSerializer setValue:APIKEY forHTTPHeaderField:@"apikey"];
    [session GET:URLSTRING parameters:@{@"num":@20,@"page":@1} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dict = responseObject;
        if ([dict[@"msg"] isEqualToString:@"success"]) {
            NSArray * array = dict[@"newslist"];
            NSMutableArray * result = [[NSMutableArray alloc] init];
            for (NSDictionary * dic in array) {
                DQNewsModel * model = [[DQNewsModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [result addObject:model];
            }
            block(result);
        }
        NSLog(@"%@",dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

+(void)networkServerWithPage:(NSInteger)page Block:(ArrayBlock)block{
    AFHTTPSessionManager * session = [AFHTTPSessionManager manager];
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session.requestSerializer setValue:APIKEY forHTTPHeaderField:@"apikey"];
    [session GET:URLSTRING parameters:@{@"num":@(20),@"page":@(page)} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dict = responseObject;
        if ([dict[@"msg"] isEqualToString:@"success"]) {
            NSArray * array = dict[@"newslist"];
            NSMutableArray * result = [[NSMutableArray alloc] init];
            for (NSDictionary * dic in array) {
                DQNewsModel * model = [[DQNewsModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [result addObject:model];
            }
            block(result);
        }
//        NSLog(@"%@",dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
@end
