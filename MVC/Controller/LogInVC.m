//
//  LogInVC.m
//  ZkXmppDemo
//
//  Created by 赵凯 on 2016/11/18.
//  Copyright © 2016年 赵凯. All rights reserved.
//

#import "LogInVC.h"
#import "FriendListVC.h"
#import "RegisteVC.h"
#import <MediaPlayer/MediaPlayer.h>

#define KGUAGE 40
#define KCHEIGHT 40
#define KTOP [UIScreen mainScreen].bounds.size.height/4

@interface LogInVC ()
{
    MPMoviePlayerController *_moviePlayer;
    UITextField *_userText;
    UITextField *_pwdText;
}
@end

@implementation LogInVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logSuccess) name:KLOGINSUCCESS object:nil];
    
    //播放视频
    [self creatMoviePlayer];
    
    //登录UI搭建
    [self creatLogUI];
    
}

#pragma mark   ===============视频播放===============
-(void)creatMoviePlayer{

    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
    NSURL *movieUrl =[NSURL fileURLWithPath:moviePath];
    _moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:movieUrl];
    [_moviePlayer.view setFrame:self.view.bounds];
    _moviePlayer.controlStyle = MPMovieControlStyleNone;
    _moviePlayer.repeatMode = MPMovieRepeatModeOne;
    [_moviePlayer play];
    [self.view addSubview:_moviePlayer.view];
    
    //添加回收键盘手势
    UIView *tapView = [[UIView alloc]initWithFrame:self.view.bounds];
    tapView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tapView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [tapView addGestureRecognizer:tap];
    
}

#pragma mark   ===============回收键盘===============
-(void)tapAction:(UITapGestureRecognizer *)tap{
    [self.view endEditing:YES];
}

#pragma mark   ===============UI搭建===============
-(void)creatLogUI{

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
    [btn setTitle:@"登 录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(logInAction) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 8;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:btn];
    
    //注册
    UIButton *regBtn = [[UIButton alloc]initWithFrame:CGRectMake(KSWIDTH-120, KSHEIGHT-60, 100, 40)];
    regBtn.backgroundColor = [UIColor clearColor];
    [regBtn setTitle:@"注册新用户" forState:UIControlStateNormal];
    [regBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regBtn];
}

#pragma mark   ===============登录===============
-(void)logInAction{

    XMPPJID *myJID = [XMPPJID jidWithUser:_userText.text domain:KDOMAIN resource:KRESOURCE ];
    
    [[ZkXmppManager sharedInstance] logInWithJID:myJID andPassword:_pwdText.text];
}
-(void)logSuccess{

    FriendListVC *friVC = [[FriendListVC alloc]init];
    
    [self.navigationController pushViewController:friVC animated:YES];

}

#pragma mark   ===============注册==============
-(void)registerAction{

    RegisteVC *regVC = [[RegisteVC alloc]init];
    [self.navigationController pushViewController:regVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [_moviePlayer play];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [_moviePlayer stop];
    [super viewWillDisappear:animated];
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
