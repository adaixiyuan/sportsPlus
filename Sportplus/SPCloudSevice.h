//
//  SPCloudSevice.h
//  Sportplus
//
//  Created by 虎猫儿 on 15/3/11.
//  Copyright (c) 2015年 JiaZai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>

static NSString *kCDCloudServiceAddFriend=@"addFriend";
static NSString *kCDCloudServiceRemoveFriend=@"removeFriend";

@interface SPCloudSevice : NSObject

+(void)callCloudRelationFnWithFromUser:(AVUser*)fromUser toUser:(AVUser*)toUser action:(NSString*)action callback:(AVIdResultBlock)callback;

/**
 *  解除好友关系
 *
 *  @param friend 朋友 : SPUser
 *  @param block  回调block
 */
+(void)removeFriend:(AVUser*)friend block:(AVIdResultBlock)block;

/**
 *  创建一个对toUser的好友申请
 *
 *  @param toUser   申请对象
 *  @param callback 回调block
 */
+(void)tryCreateAddRequestWithToUser:(AVUser*)toUser callback:(AVIdResultBlock)callback;

/**
 *  同意好友申请
 *
 *  @param objectId 好友申请.objectId
 *  @param callback 回调block
 */
+(void)agreeAddRequestWithId:(NSString*)objectId callback:(AVIdResultBlock)callback;


+(void)saveChatGroupWithId:(NSString*)groupId name:(NSString*)name callback:(AVIdResultBlock)callback;

+(id)signWithPeerId:(NSString*)peerId watchedPeerIds:(NSArray*)watchPeerIds;

+(id)groupSignWithPeerId:(NSString*)peerId groupId:(NSString*)groupId groupPeerIds:(NSArray*)groupPeerIds action:(NSString*)action;

+(void)getQiniuUptokenWithCallback:(AVIdResultBlock)callback;

@end
