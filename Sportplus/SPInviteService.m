//
//  SPInviteService.m
//  Sportplus
//
//  Created by 虎猫儿 on 15/3/13.
//  Copyright (c) 2015年 JiaZai. All rights reserved.
//

#import "SPInviteService.h"

#import "SPCacheService.h"
#import "SPGroupService.h"
#import "spCommon.h"

@implementation SPInviteService

#pragma mark - 陌生人邀约

+(void)getStrangersWithfromId:(NSString *)fromId sex:(NSString *)sex engagementType:(EngagementType)type sportType:(SPORTSTYPE)sportType count:(NSInteger)count WithBlock:(AVArrayResultBlock)block ;{
    assert(fromId) ;
    assert(sex) ;//@"男" ,@"女"
    assert(type) ;
    assert(sportType) ;
    assert(count) ;
    assert(block) ;
    
    NSMutableDictionary *Parameters = [[NSMutableDictionary alloc] init] ;
    [Parameters setObject:fromId forKey:@"fromId"] ;
    [Parameters setObject:sex forKey:@"sex"] ;
    [Parameters setObject:SPNum(type) forKey:@"engagementType"] ;
    [Parameters setObject:SPNum(sportType) forKey:@"sportType"] ;
    [Parameters setObject:SPNum(count) forKey:@"count"] ;
    
    [AVCloud callFunctionInBackground:@"getStrangers" withParameters:Parameters block:block] ;
}

+(void)tryCreageEngagementToStranger:(spUser *)stranger sportType:(SPORTSTYPE)sportType WithBlock:(AVObjectResultBlock)block {
    assert(stranger) ;
    assert(sportType) ;
    assert(block) ;
    
    NSMutableDictionary *Parameters = [[NSMutableDictionary alloc] init] ;
    
    spUser *fromUser = [spUser currentUser] ;
    
    [Parameters setObject:[fromUser objectId] forKey:@"fromId"] ;
    [Parameters setObject:[stranger objectId] forKey:@"toId"] ;
    [Parameters setObject:SPNum(EngagementStatusCreatedByCreaterUser) forKey:@"status"] ;
    [Parameters setObject:SPNum(sportType) forKey:@"sportType"] ;
    
    [AVCloud callFunctionInBackground:@"engagementWithStrangers" withParameters:Parameters block:block] ;
}

+(void)findEngagementOfStrangerIsNetWorkOnly:(BOOL)networkOnly ToUser:(spUser *)me WithBlock:(AVArrayResultBlock)block{
    assert(block) ;
    if (me == nil) {
        me = [spUser currentUser] ;
    }
    spUser *curUser = [spUser currentUser] ;
    AVQuery *q = [spEngagement_Stranger query] ;
    
    [SPUtils setPolicyOfAVQuery:q isNetwokOnly:networkOnly] ;
    
    [q setCachePolicy:kAVCachePolicyNetworkElseCache] ;
    [q includeKey:@"fromId"] ;
    [q whereKey:@"toId" equalTo:curUser] ;
    //状态不为拒绝－1
    [q whereKey:@"status" notEqualTo:[NSNumber numberWithInteger:EngagementStatusRejected]] ;
    [q findObjectsInBackgroundWithBlock:block] ;
}

#pragma mark - 好友约伴

+(void)findEngagementOfFriendsIsNetWorkOnly:(BOOL)networkOnly ContainUser:(spUser *)me WithBlock:(AVArrayResultBlock)block{
    if (me == nil) {
        me = [spUser currentUser] ;
    }
    spUser *curUser = [spUser currentUser] ;
    AVQuery *q = [spEngagement_Friend query] ;
    {
        [SPUtils setPolicyOfAVQuery:q isNetwokOnly:networkOnly] ;
        [q setCachePolicy:kAVCachePolicyCacheElseNetwork] ;
//        [q includeKey:@"fromId"] ;
        [q whereKey:@"fromId" equalTo:curUser] ;
    }
    
    AVQuery *p = [spEngagement_Friend query] ;
    {
        [SPUtils setPolicyOfAVQuery:p isNetwokOnly:networkOnly] ;
        [p setCachePolicy:kAVCachePolicyCacheElseNetwork] ;
//        [p includeKey:@"toId"] ;
        [p whereKey:@"toId" equalTo:curUser] ;
    }
    
    AVQuery *mutableQuery = [AVQuery orQueryWithSubqueries:@[q,p]] ;
    
        
    [mutableQuery findObjectsInBackgroundWithBlock:block] ;
}

+(void)findEngagementOfFriendsIsNetWorkOnly:(BOOL)networkOnly FromUser:(spUser *)me WithBlock:(AVArrayResultBlock)block{
    if (me == nil) {
        me = [spUser currentUser] ;
    }
    spUser *curUser = [spUser currentUser] ;
    AVQuery *q = [spEngagement_Friend query] ;
    
    [SPUtils setPolicyOfAVQuery:q isNetwokOnly:networkOnly] ;
    
    [q setCachePolicy:kAVCachePolicyCacheElseNetwork] ;
    [q includeKey:@"fromId"] ;
    [q whereKey:@"fromId" equalTo:curUser] ;
    
    [q findObjectsInBackgroundWithBlock:block] ;
}


+(void)findEngagementOfFriendsIsNetWorkOnly:(BOOL)networkOnly ToUser:(spUser *)me WithBlock:(AVArrayResultBlock)block{
    if (me == nil) {
        me = [spUser currentUser] ;
    }
    
    spUser *curUser = [spUser currentUser] ;
    AVQuery *q = [spEngagement_Friend query] ;
    
    [SPUtils setPolicyOfAVQuery:q isNetwokOnly:networkOnly] ;
    
    [q setCachePolicy:kAVCachePolicyCacheElseNetwork] ;
    [q includeKey:@"toId"] ;
    [q whereKey:@"toId" equalTo:curUser] ;
    
    [q findObjectsInBackgroundWithBlock:block] ;
    
}

+(void)tryCreateEngagementToFriends:(NSArray *)friendList sportType:(SPORTSTYPE)sportType date:(NSDate *)date stadium:(spStadium *)stadium WithBlock:(AVIdResultBlock)block{
    assert(friendList) ;
    assert(sportType) ;
    assert(date) ;
    assert(block) ;
    
    NSString *groupName = [spUser currentUser].sP_userName ;
    
    //调用后台方法EngagementWithFriends ;
    void (^callEngagementWithFriendsMethodBlock) (AVGroup *, NSError *) = ^(AVGroup *object,NSError *error) {
        NSLog(@"开始调用后台方法EngagementWithFriends") ;
        NSMutableDictionary *Parameters = [NSMutableDictionary dictionary] ;
        
        spUser *curUser = [spUser currentUser] ;
        
        [Parameters setObject:object.groupId forKey:@"groupId"] ;
        [Parameters setObject:curUser.objectId forKey:@"fromId"] ;
        [Parameters setObject:SPNum(sportType) forKey:@"type"] ;
        
        NSString *dateString ;
        /*getDateString*/{
            NSDateFormatter *fmt = [[NSDateFormatter alloc] init] ;
            fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] ;
            fmt.dateFormat = @"yyyy-MM-dd HH:mm" ;
            
            dateString = [fmt stringFromDate:date] ;
        }
        
        [Parameters setObject:dateString forKey:@"when"] ;
        [Parameters setObject:@"测试啊" forKey:@"newstadium"] ;
        
//      EngagementFriend类objectId数组, 顺序按照GroupId中用户的顺序排列
        [AVCloud callFunctionInBackground:@"engagementWithFriends" withParameters:Parameters block:^(id object, NSError *error) {
            NSLog(@"创建完成，开始回调") ;
            block(object,nil) ;
        }] ;
    } ;
    
    
    NSLog(@"开始创建AVGroup") ;
    //分两次创建AVGroup和SpChatGroup ;
    [SPGroupService saveNewGroupWithName:groupName withCallback:^(AVGroup *group, NSError *error) {
        if (group == nil) {
            NSLog(@"创建AVGroup失败") ;
            block(nil,error) ;
        } else {
            //成功
            NSLog(@"创建AVGroup完成") ;
            //拉人
            NSLog(@"拉人开始") ;
            [self inviteMembers:friendList callback:^(BOOL succeeded, NSError *error) {
                NSLog(@"拉人结束") ;
                if (succeeded) {
                    //拉人成功
                    callEngagementWithFriendsMethodBlock(group,error) ;
                } else {
                    //拉人失败
                    block(nil,error) ;
                }
            }] ;

        }
    }] ;
}

+ (void)inviteMembers:(NSArray *)inviteIds callback:(AVBooleanResultBlock)callback {
    NSLog(@"开始邀请") ;
    [SPGroupService inviteMembersToGroup:[SPCacheService getCurrentChatGroup] userIds:inviteIds callback:^(NSArray *objects, NSError *error) {
        NSLog(@"邀请结束") ;
        if (error) {
            callback(NO,error) ;
        } else {
            callback(TRUE,error) ;
        }
    }] ;
}

+ (void)answerEngagementWithFriends:(spEngagement_Friend *)engagement status:(EngagementFriendAnswerStatus)status withBlock:(AVIdResultBlock)block {
    NSMutableDictionary *Parameters = [NSMutableDictionary dictionary] ;
    
    [AVCloud callFunctionInBackground:@"answerEngagementWithFriends" withParameters:Parameters block:block] ;
}

+ (void)acceptEngagementFriend:(spEngagement_Friend *)engagement withBlock:(AVIdResultBlock)block {
    [self answerEngagementWithFriends:engagement status:EngagementFriendAnswerStatusAccept withBlock:block] ;
}

+ (void)rejectEngagementFriend:(spEngagement_Friend *)engagement withBlock:(AVIdResultBlock)block {
    [self answerEngagementWithFriends:engagement status:EngagementFriendAnswerStatusReject withBlock:block] ;
}

@end