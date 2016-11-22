//
//  FriendCell.m
//  ZkXmppDemo
//
//  Created by 赵凯 on 2016/11/18.
//  Copyright © 2016年 赵凯. All rights reserved.
//

#import "FriendCell.h"

@interface FriendCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImgv;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation FriendCell


-(void)setUserName:(NSString *)userName{

    if (_userName != userName) {
        _userName = userName;
    }
    
    [self setNeedsLayout];
}

-(void)layoutSubviews{

    [super layoutSubviews];
    
    _headImgv.layer.cornerRadius = 25;
    _headImgv.layer.masksToBounds = YES;
    
     NSArray *strArr = [self.userName componentsSeparatedByString:@"@"];
    _nameLab.text = strArr[0];
    
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
