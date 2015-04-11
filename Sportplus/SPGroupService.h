//
//  SPGroupService.h
//  Sportplus
//
//  Created by 虎猫儿 on 15/3/11.
//  Copyright (c) 2015年 JiaZai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
#import "spChatGroup.h"

@interface SPGroupService : NSObject

+(void)findGroupsWithCallback:(AVArrayResultBlock)callback cacheFirst:(BOOL)cacheFirst;

+(void)findGroupsByIds:(NSMutableSet*)groupIds withCallback:(AVArrayResultBlock)callback;

/**
 *  创建AVGroup名为name,并在服务器端通过AVGroup.objectId 创建 SPChatGroup .
 *
 *  @param name     Group Name
 *  @param callback 回调
 */
+ (void)saveNewGroupWithName:(NSString*)name withCallback:(AVGroupResultBlock)callback;

/**
 *  邀请用户到群组里
 *
 *  @param chatGroup 目标群组
 *  @param userIds   userId数组
 *  @param callback  回调block,返回peerId(userId)数组
 */
+(void)inviteMembersToGroup:(spChatGroup*) chatGroup userIds:(NSArray*)userIds callback:(AVArrayResultBlock)callback;

+(void)kickMemberFromGroup:(spChatGroup*)chatGroup userId:(NSString*)userId;

+(void)quitFromGroup:(spChatGroup*)chatGroup;

+ (AVGroup *)joinGroupById:(NSString *)groupId;

+(AVGroup*)getGroupById:(NSString*)groupId;

+(void)setDelegateWithGroupId:(NSString*)groupId;

@end
