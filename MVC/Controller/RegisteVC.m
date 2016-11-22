//
//  RegisteVC.m
//  ZkXmppDemo
//
//  Created by 赵凯 on 2016/11/18.
//  Copyright © 2016年 赵凯. All rights reserved.
//

#import "RegisteVC.h"

#define KGUAGE 40
#define KCHEIGHT 40
#define KTOP [UIScreen mainScreen].bounds.size.height/4

@interface RegisteVC ()
{
    UITextField *_userText;
    UITextField *_pwdText;
}
@end

@implementation RegisteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registerSuccessAction) name:KREGISTERSUCCESS object:nil];
    
    [self creatSubView];
    
}

-(void)creatSubView{
    
    //背景图 self.view.bounds
    UIImageView *backImgv = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImgv.image = [UIImage imageNamed:@"back1.png"];
    backImgv.userInteractionEnabled = YES;
    [self.view addSubview:backImgv];
    
    //回收键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [backImgv addGestureRecognizer:tap];
    
    //用户名
    _userText = [[UITextField alloc]initWithFrame:CGRectMake(KGUAGE, KTOP, KSWIDTH-2*KGUAGE, KCHEIGHT)];
    _userText.textColor = [UIColor whiteColor];
    _userText.placeholder = @" 账 号";
    [_userText setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_userText];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(KGUAGE, CGRectGetMaxY(_userText.frame), CGRectGetWidth(_userText.frame), 1)];
    line1.backgroundColor = [UIColor whiteColor];
    line1.alpha = .7;
    [self.view addSubview:line1];
    
    //密码
    _pwdText = [[UITextField alloc]initWithFrame:CGRectMake(KGUAGE, CGRectGetMaxY(_userText.frame)+KCHEIGHT, KSWIDTH-2*KGUAGE, KCHEIGHT)];
    _pwdText.textColor = [UIColor whiteColor];
    _pwdText.secureTextEntry = YES;
    _pwdText.placeholder = @" 密 码";
    [_pwdText setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_pwdText];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(KGUAGE, CGRectGetMaxY(_pwdText.frame), CGRectGetWidth(_pwdText.frame), 1)];
    line2.backgroundColor = [UIColor whiteColor];
    line2.alpha = .7;
    [self.view addSubview:line2];
    
    //登录按钮
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(KGUAGE, CGRectGetMaxY(_pwdText.frame)+KCHEIGHT, CGRectGetWidth(_userText.frame), KCHEIGHT)];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:@"注 册" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 8;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:btn];

}

#pragma mark   ================注册事件==============
-(void)registerAction{

    [[ZkXmppManager sharedInstance] registerWithUserName:_userText.text andPassword:_pwdText.text];
}

#pragma mark   ================注册成功提醒==============
-(void)registerSuccessAction{
    [LCProgressHUD showSuccess:@"注册成功"];
}

#pragma mark   ===============回收键盘===============
-(void)tapAction:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
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
