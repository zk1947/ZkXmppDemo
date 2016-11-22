//
//  UIColor+ZkColor.h
//  ZkXmppDemo
//
//  Created by 赵凯 on 2016/11/22.
//  Copyright © 2016年 赵凯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZkColor)

+ (UIColor *)colorWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

/**
 *  16进制转uicolor
 *
 *  @param color @"#FFFFFF" ,@"OXFFFFFF" ,@"FFFFFF"
 *
 *  @return uicolor
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

@end
