//
//  ViewController.m
//  ZkXmppDemo
//
//  Created by 赵凯 on 2016/11/8.
//  Copyright © 2016年 赵凯. All rights reserved.
//

#import "ViewController.h"
#import "ZkXmppManager.h"
#import "FriendListVC.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    
}


#pragma mark   ===============登录事件===============
- (IBAction)logInAction:(id)sender {
    
    
}
#pragma mark   ===============注册事件===============
- (IBAction)registerAction:(id)sender {
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
