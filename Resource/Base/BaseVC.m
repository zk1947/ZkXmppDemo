//
//  BaseVC.m
//  ZkXmppDemo
//
//  Created by 赵凯 on 2016/11/18.
//  Copyright © 2016年 赵凯. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.navigationController.navigationBar.barTintColor = KNAVCOLOR;
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:20],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                      }];
//    if (self.navigationController.viewControllers.count>1) {
    //自定义返回按钮
    UIButton *leftItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    [leftItemButton setImage:[UIImage imageNamed:@"navLeftBack.png"] forState:UIControlStateNormal];
    [leftItemButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:leftItemButton];
//    }
    
    
}

#pragma mark   =================返回事件=============
-(void)leftBtnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
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
