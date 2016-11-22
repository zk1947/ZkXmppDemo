//
//  ZkXmppManager.h
//  ZkXmppDemo
//
//  Created by 赵凯 on 2016/11/8.
//  Copyright © 2016年 赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FriendsBlock)(id result);

@interface ZkXmppManager : NSObject<XMPPStreamDelegate,XMPPRosterDelegate>

@property(nonatomic,strong)XMPPStream *xmppStream;//连接流
@property(nonatomic,strong)XMPPRoster *xmppRoster;//好友
@property(nonatomic,copy)NSString *password;//密码
@property(nonatomic,copy)NSString *userName;//账号
@property(nonatomic,assign)BOOL isRegister;
@property(nonatomic,copy)FriendsBlock friendsBlock;

+ (instancetype)sharedInstance;


/**
 连接登录

 @param JID 用户名
 @param password 密码
 */
-(void)logInWithJID:(XMPPJID *)JID andPassword:(NSString *)password;


/**
 注册方法

 @param userName <#userName description#>
 @param password <#getFriendList description#>
 */
-(void)registerWithUserName:(NSString *)userName andPassword:(NSString *)password;


/**
 获取好友列表

 @param block <#block description#>
 */
-(void)getFriendList:(FriendsBlock)block;


/**
 添加好友

 @param jid <#jid description#>
 */
-(void)addFriendWith:(XMPPJID *)jid;

/**
 发送消息给好友

 @param message <#message description#>
 @param userJid <#userJid description#>
 */
- (void) sendMessage:(NSString *) message toFriend:(NSString *)userJid;


/**
 获取文本高度

 @param contentStr 文本内容
 @param font 字体大小
 @param width 给定宽度
 @return 返回高度
 */
-(CGFloat)getStringHeight:(NSString *)contentStr withFont:(CGFloat)font withWidth:(CGFloat)width;


@end





