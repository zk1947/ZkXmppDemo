//
//  FriendListVC.m
//  ZkXmppDemo
//
//  Created by 赵凯 on 2016/11/9.
//  Copyright © 2016年 赵凯. All rights reserved.
//

#import "FriendListVC.h"
#import "ZkXmppManager.h"
#import "ChatVC.h"
#import "FriendCell.h"
#import "AddFriendVC.h"

#define KCELL @"cell"

@interface FriendListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_friendsList;
}
@end

@implementation FriendListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"好友列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatNavBar];
    
    [self creatSubView];
    
    //获取好友列表
    [[ZkXmppManager sharedInstance] getFriendList:^(id result) {
        
        if (!_friendsList) {
            _friendsList = [NSMutableArray array];
        }
        _friendsList = (NSMutableArray *)result;
        [_tableView reloadData];
        
    }];
    
}

-(void)creatNavBar{

    [self.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:59.0/255 green:187.0/255 blue:240.0/255 alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:20],
                                                                      NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                      }];

    //右侧添加按钮
    UIButton *leftItemButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
    [leftItemButton setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [leftItemButton addTarget:self action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:leftItemButton];
    
}

-(void)addFriendAction{

    AddFriendVC *addVC = [[AddFriendVC alloc]init];
    
    [self.navigationController pushViewController:addVC animated:YES];
}


-(void)creatSubView{

    //背景图 self.view.bounds
    UIImageView *backImgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KSWIDTH, KSHEIGHT)];
    backImgv.image = [UIImage imageNamed:@"back1.png"];
//    backImgv.userInteractionEnabled = YES;
    [self.view addSubview:backImgv];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KNAVH, KSWIDTH, KSHEIGHT-KNAVH) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:KCELL];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _friendsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:KCELL forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userName = _friendsList[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ChatVC *chatVC = [[ChatVC alloc]init];
    chatVC.toJID = _friendsList[indexPath.row];
    [self.navigationController pushViewController:chatVC animated:YES];
    
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
