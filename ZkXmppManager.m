//
//  ZkXmppManager.m
//  ZkXmppDemo
//
//  Created by 赵凯 on 2016/11/8.
//  Copyright © 2016年 赵凯. All rights reserved.
//

#import "ZkXmppManager.h"

@implementation ZkXmppManager

#pragma mark   ===============单例对象===============
static ZkXmppManager *_xManager;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _xManager = [ZkXmppManager new];
    });
    return _xManager;
}

- (XMPPStream *)xmppStream{

    if (!_xmppStream) {
        
        _xmppStream = [[XMPPStream alloc]init];
        //socket连接的时候 配置host（ip） port（端口）
        [self.xmppStream setHostName:KX_HOST];
        [self.xmppStream setHostPort:KX_PORT];
        //添加代理方法
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        //设置断开重练对象
//        XMPPReconnect *connect = [[XMPPReconnect alloc] init];
//        [connect activate:self.xmppStream];
        
        //设置好友列表对象、创建存储的方式
        XMPPRosterMemoryStorage *xmppStorage = [[XMPPRosterMemoryStorage alloc] init];
        self.xmppRoster = [[XMPPRoster alloc]initWithRosterStorage:xmppStorage];
        [self.xmppRoster activate:self.xmppStream];
        [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    return _xmppStream;
}

#pragma mark   ===============建立TCP连接,登录===============
-(void)logInWithJID:(XMPPJID *)JID andPassword:(NSString *)password{

    //配置JID
    [self.xmppStream setMyJID:JID];
    self.password = password;
    _isRegister = NO;
    //连接请求
    [self.xmppStream connectWithTimeout:60 error:nil];
}

#pragma mark   ===============注册==============
-(void)registerWithUserName:(NSString *)userName andPassword:(NSString *)password{

    self.userName = userName;
    self.password = password;
    
    //建立匿名连接----连接成功发送用户名密码---注册成功后断开连接--
    
    XMPPJID *myJID = [XMPPJID jidWithUser:@"anonymous" domain:KDOMAIN resource:KRESOURCE ];
    [self.xmppStream setMyJID:myJID];
    _isRegister = YES;
    //连接请求
    [self.xmppStream connectWithTimeout:60 error:nil];

}

#pragma mark   ===============发送在线状态===============
-(void)goOnline{

    XMPPPresence *presence = [XMPPPresence presence];
    // show 是固定的，有几种类型 dnd(请勿打扰)、xa(隐身)、away(离开)、chat(在线)，在方法XMPPPresence 的intShow中可以看到
    [presence addChild:[DDXMLNode elementWithName:@"show" stringValue:@"chat"]];
    // status ---自定义的内容，可以是任何的。
    [presence addChild:[DDXMLNode elementWithName:@"status" stringValue:@"在线"]];
    [self.xmppStream sendElement:presence];
    
}

#pragma mark   ===============获取好友列表===============
-(void)getFriendList:(FriendsBlock)block{

    self.friendsBlock = block;
    
    XMPPJID *jid = self.xmppStream.myJID;
    
    NSXMLElement *iqElement  =[NSXMLElement elementWithName:@"iq"];
    [iqElement addAttributeWithName:@"from" stringValue:jid.description];
    [iqElement addAttributeWithName:@"type" stringValue:@"get"];
//    [iqElement addAttributeWithName:@"to" stringValue:jid.domain];
    [iqElement addAttributeWithName:@"id" stringValue:@"123456"];
    //创建子节点
//    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
//    [iqElement addChild:query];
    
    [self.xmppStream sendElement:iqElement];
    
}

#pragma mark   ================添加好友==============
-(void)addFriendWith:(XMPPJID *)jid{

    [self.xmppRoster addUser:jid withNickname:@"好友"];
    
}

#pragma mark   ================聊天==============
- (void) sendMessage:(NSString *) message toFriend:(NSString *)userJid{
    if (!message || [message isEqualToString:@""]) {
        return;
    }
    NSXMLElement *messageElement = [NSXMLElement elementWithName:@"message"];
    [messageElement addAttributeWithName:@"to" stringValue:userJid];
    //取出自己的jid
    XMPPJID *jid = self.xmppStream.myJID;
    [messageElement addAttributeWithName:@"from" stringValue:jid.description];
    [messageElement addAttributeWithName:@"type" stringValue:@"chat"];
    [messageElement addAttributeWithName:@"xml:lang" stringValue:@"en"];
    NSXMLElement *bodyElement = [NSXMLElement elementWithName:@"body" stringValue:message];
    [messageElement addChild:bodyElement];
    //发送消息
    [self.xmppStream sendElement:messageElement];
}


#pragma mark   ==============Stream代理方法===============

/**
 连接是否成功

 @param sender <#sender description#>
 */
- (void)xmppStreamDidConnect:(XMPPStream *)sender{

    NSLog(@"连接成功啦！！！");
    
    if (_isRegister) {//注册
        
        XMPPJID *myJID = [XMPPJID jidWithUser:self.userName domain:KDOMAIN resource:KRESOURCE ];
        [self.xmppStream setMyJID:myJID];
        
        [self.xmppStream registerWithPassword:self.password error:nil];
        
    }else{//登录
        //发送认证
        [self.xmppStream authenticateWithPassword:self.password error:nil];
    }
    
}
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    NSLog(@"连接失败原因：%@",error);
}

/**
 登录是否成功

 @param sender <#sender description#>
 */
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{

    NSLog(@"登录成功啦！！！");
    
    [self goOnline];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:KLOGINSUCCESS object:nil];
    
}
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    //主动断开连接
    [self.xmppStream disconnect];

    NSLog(@"登录失败原因:%@",error);
}


/**
 注册是否成功

 @param sender <#sender description#>
 */
- (void)xmppStreamDidRegister:(XMPPStream *)sender{

    NSLog(@"注册成功");
    
    [[NSNotificationCenter defaultCenter]postNotificationName:KREGISTERSUCCESS object:nil];
    
    //断开连接
    [self.xmppStream disconnect];
    
}
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{

    NSLog(@"注册失败原因:%@",error);
    //断开连接
    [self.xmppStream disconnect];
}

/**
 获取好友列表

 @param sender <#sender description#>
 @param iq <#iq description#>
 @return <#return value description#>
 */
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{

    NSLog(@"%@",iq);

    NSMutableArray *friendList = [NSMutableArray array];
    for (DDXMLElement *element in iq.children) {
        if ([element.name isEqualToString:@"query"]) {
            for (DDXMLElement *item in element.children) {
                if ([item.name isEqualToString:@"item"]) {
                    NSString *jid = [item attributeStringValueForName:@"jid"];
                    [friendList addObject:jid];          //array  就是你的群列表
                }
            }
        }
    }

    if (self.friendsBlock) {
        self.friendsBlock(friendList);
    }
    
//    NSLog(@"%@",friendList);
    return YES;
}


/**
 添加好友成功

 @param sender <#sender description#>
 @param iq <#iq description#>
 */
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterPush:(XMPPIQ *)iq{

    NSLog(@"添加好友成功 %@",iq.description);
}

/**
 接受消息

 @param sender <#sender description#>
 @param message <#message description#>
 */
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
 
    if ([message isChatMessageWithBody]) {
        NSString *body = message.body;
        XMPPJID *jid = message.from;
        NSString *userFrom = [jid description];
        NSDictionary *dic = @{
                              @"fromUser":userFrom,
                              @"text":body
                              };
        //发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KRECEIVEMESSAGE object:nil userInfo:dic];
    }

    
}


/**
 获取文本高度

 @param contentStr w文本内容
 @param font 字号
 @param width 宽度
 @return 返回高度
 */
-(CGFloat)getStringHeight:(NSString *)contentStr withFont:(CGFloat)font withWidth:(CGFloat)width{

    CGRect contentRect = [contentStr boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font],NSFontAttributeName, nil] context:nil];
    
    return contentRect.size.height;
}



@end
