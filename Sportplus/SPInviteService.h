//
//  SPInviteService.h
//  Sportplus
//
//  Created by 虎猫儿 on 15/3/13.
//  Copyright (c) 2015年 JiaZai. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "spCommon.h"

@interface SPInviteService : NSObject

//+(void)countAddRequestsWithBlock:(AVIntegerResultBlock)block;
/**
 *  调用后台方法<getStrangers>获取系统推荐陌生人
 *
 *  @param fromId    发起人的objectId
 *  @param sex       性别
 *  @param type      邀约类型｛实力型，友好型｝
 *  @param sportType 运动类型
 *  @param count     请求个数
 *  @param block     回调block
 */
+(void)getStrangersWithfromId:(NSString *)fromId sex:(NSString *)sex engagementType:(EngagementType)type sportType:(SPORTSTYPE)sportType count:(NSInteger)count WithBlock:(AVArrayResultBlock)block ;

/**
 *  调用后台方法<engagementWithStrangers>，创建陌生人邀约
 *
 *  @param stranger  目标用户
 *  @param sportType 运动类型
 *  @param block     回调block
 */
+(void)tryCreageEngagementToStranger:(spUser *)stranger sportType:(SPORTSTYPE)sportType WithBlock:(AVObjectResultBlock)block ;

/**
 *  在后台查询陌生人邀约
 *
 *  @param networkOnly 设置缓存政策，为true时之在联网下，false时有缓存。
 *  @param me          当前user
 *  @param block       回调block
 */
+(void)findEngagementOfStrangerIsNetWorkOnly:(BOOL)networkOnly ToUser:(spUser *)me WithBlock:(AVArrayResultBlock)block ;

#pragma mark - 好友约伴

/**
 *  查找有关我（me）的约伴邀请，发出和接收的
 *
 *  @param networkOnly 是否请求网络 or 查找缓存
 *  @param me          currentUser
 *  @param block       回调block，返回查找到的关于我的约伴亲求数组、NSError
 */
+(void)findEngagementOfFriendsIsNetWorkOnly:(BOOL)networkOnly ContainUser:(spUser *)me WithBlock:(AVArrayResultBlock)block ;

/**
 *  查找从我（me）发出的好友约伴邀请
 *
 *  @param networkOnly 是否请求网络 or 查找缓存
 *  @param me          currentUser
 *  @param block       回调block,返回查找的约伴请求数组、NSError
 */
+(void)findEngagementOfFriendsIsNetWorkOnly:(BOOL)networkOnly FromUser:(spUser *)me WithBlock:(AVArrayResultBlock)block ;

/**
 *  查找给我（me）的好友约伴邀请
 *
 *  @param networkOnly 是否请求网络 or 查找缓存
 *  @param me          currentUser
 *  @param block       回调block,返回查找的约伴请求数组、NSError

 */
+(void)findEngagementOfFriendsIsNetWorkOnly:(BOOL)networkOnly ToUser:(spUser *)me WithBlock:(AVArrayResultBlock)block ;

/**
 *  调用后台方法<engagementWithFriends>，创建好友约伴
 *
 *  @param friendList 约的朋友名单。
 *  @param sportType  运动类型
 *  @param date       运动日期
 *  @param stadium    运动场馆
 *  @param block      回调block
 *  @return engagementWithFriends方法返回EngagementFriend类objectId数组, 顺序按照GroupId中用户的顺序排列
 */
+(void)tryCreateEngagementToFriends:(NSArray *)friendList sportType:(SPORTSTYPE)sportType date:(NSDate *)date stadium:(spStadium *)stadium WithBlock:(AVIdResultBlock)block;


+ (void)acceptEngagementFriend:(spEngagement_Friend *)engagement withBlock:(AVIdResultBlock)block ;

+ (void)rejectEngagementFriend:(spEngagement_Friend *)engagement withBlock:(AVIdResultBlock)block ;

@end
