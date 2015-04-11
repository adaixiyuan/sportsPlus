//
//  SPCacheService.h
//  Sportplus
//
//  Created by 虎猫儿 on 15/3/12.
//  Copyright (c) 2015年 JiaZai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "spCommon.h"
#import "spChatGroup.h"

@interface SPCacheService : NSObject

/**
 *  缓存User数组
 *
 *  @param users AvUser数组
 */
+ (void)registerUsers:(NSArray*)users;

/**
 *  缓存单个User
 *
 *  @param user AvUser
 */
+ (void)registerUser:(AVUser*)user;

/**
 *  查找缓存中是否有userId对应的对象
 *
 *  @param userId AvUser.objectId
 *
 *  @return 有缓存为对应的AvUser对象，没有为nil
 */
+ (AVUser *)lookupUser:(NSString*)userId;

/**
 *  查找缓存中是否有对应ChatGroup
 *
 *  @param groupId spChatGroup.objectId
 *
 *  @return spChatGroup对象
 */
+(spChatGroup*)lookupChatGroupById:(NSString*)groupId;

/**
 *  缓存chatGroup
 *
 *  @param chatGroup spChatGroup对象
 */
+(void)registerChatGroup:(spChatGroup*)chatGroup;

/**
 *  通过UserId WithOutData在服务器上拉取用户信息。并缓存
 *
 *  @param userIds  NSSet
 *  @param callback 回调
 */
+(void)cacheUsersWithIds:(NSSet*)userIds callback:(AVArrayResultBlock)callback;

+(void)cacheChatGroupsWithIds:(NSMutableSet*)groupIds withCallback:(AVArrayResultBlock)callback;

/**
 *  添加ChatGroups的缓存
 *
 *  @param chatGroups chatGroup数组
 */
+(void)registerChatGroups:(NSArray*)chatGroups;


+(void)cacheMsgs:(NSArray*)msgs withCallback:(AVArrayResultBlock)callback;

#pragma mark - current chat group

+(void)setCurrentChatGroup:(spChatGroup*)chatGroup;

+(spChatGroup*)getCurrentChatGroup;

+(void)refreshCurrentChatGroup:(AVBooleanResultBlock)callback;

+(void)setFriends:(NSArray*)_friends;

+(NSArray*)getFriends;

@end
