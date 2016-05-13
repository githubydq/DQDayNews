//
//  DQNewsModel.m
//  DQDayNews
//
//  Created by youdingquan on 16/5/12.
//  Copyright © 2016年 youdingquan. All rights reserved.
//

#import "DQNewsModel.h"

@implementation DQNewsModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues{
    self.ctime = keyedValues[@"ctime"];
    self.desc = keyedValues[@"description"];
    self.picUrl = keyedValues[@"picUrl"];
    self.title = keyedValues[@"title"];
    self.url = keyedValues[@"url"];
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%@, %@, %@, %@, %@",self.ctime, self.desc, self.picUrl, self.title, self.url];
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_ctime forKey:@"ctime"];
    [aCoder encodeObject:_desc forKey:@"desc"];
    [aCoder encodeObject:_picUrl forKey:@"picUrl"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_url forKey:@"url"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.ctime = [aDecoder decodeObjectForKey:@"ctime"];
        self.desc = [aDecoder decodeObjectForKey:@"desc"];
        self.picUrl = [aDecoder decodeObjectForKey:@"picUrl"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
    }
    return self;
}

@end
