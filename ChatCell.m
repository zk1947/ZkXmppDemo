//
//  ChatCell.m
//  ZkXmppDemo
//
//  Created by 赵凯 on 2016/11/10.
//  Copyright © 2016年 赵凯. All rights reserved.
//

#import "ChatCell.h"

#define KIMGVH 50

@interface ChatCell()
{
    UILabel *_contentLab;//文本
    UIImageView *_headImgv;//头像
    UIView *_backView;//气泡
    UIImageView *_pointImgv;
}
@end

@implementation ChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setModel:(ChatModel *)model{

    if (_model != model) {
        _model = model;
    }
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (!_contentLab) {
        
        _headImgv = [[UIImageView alloc]init];
        [self.contentView addSubview:_headImgv];
        
        _pointImgv = [[UIImageView alloc]init];
        [self.contentView addSubview:_pointImgv];
        
        _backView = [[UIView alloc]init];
        [self.contentView addSubview:_backView];
        
        _contentLab = [[UILabel alloc]init];
        [self.contentView addSubview:_contentLab];
        
    }
    
    //计算布局
    CGFloat headSelfX = KSWIDTH-KIMGVH-KEDGETOW;
    
    if (self.model.isSelf) {
        
        _headImgv.frame = CGRectMake(headSelfX, 5, KIMGVH, KIMGVH);
        _headImgv.image = [UIImage imageNamed:@"1"];
        _contentLab.frame = CGRectMake(headSelfX-KEDGETOW-self.model.textW, KEDGEONE, self.model.textW, self.model.textH);
        _contentLab.textColor = [UIColor colorWithHexString:@"cc5f49"];
        _backView.backgroundColor = [UIColor colorWithHexString:@"ffe2dc"];
    
        _pointImgv.frame = CGRectMake(CGRectGetMaxX(_contentLab.frame)+5, 15, 10, 10);
        _pointImgv.image = [UIImage imageNamed:@"icon-dialogue-right.png"];
        
    }else{
        
        _headImgv.frame = CGRectMake(KEDGETOW, 5, KIMGVH, KIMGVH);
        _headImgv.image = [UIImage imageNamed:@"2"];
        _contentLab.frame = CGRectMake(CGRectGetMaxX(_headImgv.frame)+KEDGETOW, KEDGEONE, self.model.textW, self.model.textH);
        _contentLab.textColor = [UIColor colorWithHexString:@"6c6c6c"];
        _backView.backgroundColor = [UIColor colorWithHexString:@"edecea"];
        
        _pointImgv.frame = CGRectMake(CGRectGetMaxX(_headImgv.frame)+5, 15, 10, 10);
        _pointImgv.image = [UIImage imageNamed:@"icon-dialogue-left.png"];
    }
    
    _headImgv.layer.cornerRadius = KIMGVH/2;
    _headImgv.layer.masksToBounds = YES;
    
    _backView.frame = CGRectMake(0, 0, self.model.textW+KEDGEONE, self.model.textH+KEDGEONE);
    _backView.layer.cornerRadius = 8;
    _backView.center = _contentLab.center;
    
    _contentLab.text = self.model.contentStr;
    _contentLab.font = [UIFont systemFontOfSize:KFONT];
    _contentLab.numberOfLines = 0;
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
