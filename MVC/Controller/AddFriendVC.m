//
//  AddFriendVC.m
//  ZkXmppDemo
//
//  Created by 赵凯 on 2016/11/19.
//  Copyright © 2016年 赵凯. All rights reserved.
//

#import "AddFriendVC.h"

@interface AddFriendVC ()
{
    UITextField *_userText;
}
@end

@implementation AddFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"添加好友";
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    
    [self creatSubView];
    
}

-(void)creatSubView{

    //背景图
    UIImageView *backImgv = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImgv.image = [UIImage imageNamed:@"back1.png"];
    //    backImgv.userInteractionEnabled = YES;
    [self.view addSubview:backImgv];
    
    //用户名
    _userText = [[UITextField alloc]initWithFrame:CGRectMake(40, 100, KSWIDTH-2*40, 40)];
    _userText.textColor = [UIColor whiteColor];
    _userText.placeholder = @" 账 号";
    [_userText setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_userText];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(_userText.frame), CGRectGetWidth(_userText.frame), 1)];
    line1.backgroundColor = [UIColor whiteColor];
    line1.alpha = .7;
    [self.view addSubview:line1];
    
    //按钮
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(_userText.frame)+40, CGRectGetWidth(_userText.frame), 40)];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:@"添  加" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 8;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:btn];

}


-(void)btnAction{

    XMPPJID *myJID = [XMPPJID jidWithUser:_userText.text domain:KDOMAIN resource:KRESOURCE ];
    
    [[ZkXmppManager sharedInstance] addFriendWith:myJID];
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
