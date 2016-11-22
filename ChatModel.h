//
//  ChatModel.h
//  ZkXmppDemo
//
//  Created by 赵凯 on 2016/11/11.
//  Copyright © 2016年 赵凯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject

@property(nonatomic,copy)NSString *contentStr;
@property(nonatomic,assign)BOOL isSelf;
@property(nonatomic,assign)CGFloat textH;//文本高度
@property(nonatomic,assign)CGFloat textW;//文本宽度

@end
