//
//  spEngagement_Stranger.m
//  Sportplus
//
//  Created by 虎猫儿 on 15/3/13.
//  Copyright (c) 2015年 JiaZai. All rights reserved.
//

#import "spEngagement_Stranger.h"

@implementation spEngagement_Stranger

@dynamic when ;
@dynamic stadium ;
@dynamic newstadium ;
@dynamic sportType ;
@dynamic status ;
@dynamic fromId ;
@dynamic toId ;

+ (NSString *)parseClassName{
    return @"EngagementStrangers" ;
}

- (NSString *)getOtherId {
    NSString *Id ;
    spUser *curUser = [spUser currentUser] ;
    if ( [curUser.objectId isEqualToString:self.fromId.objectId] ) {
        Id = self.toId.objectId ;
    }else{
        Id = self.fromId.objectId ;
    }
    return Id ;
}

@end
