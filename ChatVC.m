//
//  ChatVC.m
//  ZkXmppDemo
//
//  Created by 赵凯 on 2016/11/10.
//  Copyright © 2016年 赵凯. All rights reserved.
//

#import "ChatVC.h"
#import "ZkXmppManager.h"
#import "ChatModel.h"
#import "ChatCell.h"

#define KCELL @"myCell"
#define KBOTTOMHEIHGHT 50

@interface ChatVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_tableView;
    UITextField *_textField;
    UIView *_textBackView;
    NSMutableArray *_contentList;
    CGFloat _keyH;
    BOOL _keyHidden;
}
@end

@implementation ChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"聊天";
    self.view.backgroundColor = [UIColor cyanColor];
    
    //监听键盘弹出的事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    //接受消息
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveAction:) name:KRECEIVEMESSAGE object:nil];
    
    _contentList = [NSMutableArray array];
    
    [self creatSubView];
    
}

-(void)creatSubView{
    
    //背景图
    UIImageView *backImgv = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImgv.image = [UIImage imageNamed:@"back1.png"];
    //    backImgv.userInteractionEnabled = YES;
    [self.view addSubview:backImgv];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, KNAVH, KSWIDTH, KSHEIGHT-KBOTTOMHEIHGHT-KNAVH-KBOTTOMHEIHGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[ChatCell class] forCellReuseIdentifier:KCELL];
    
    //下方视图
    _textBackView = [[UIView alloc]initWithFrame:CGRectMake(0, KSHEIGHT-KBOTTOMHEIHGHT, KSWIDTH, KBOTTOMHEIHGHT)];
    _textBackView.backgroundColor = KNAVCOLOR;
    [self.view addSubview:_textBackView];
    
    //输入框背景
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(40, 7, KSWIDTH-80, 35)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 15;
    backView.layer.borderWidth = 1;
    backView.layer.borderColor = [UIColor grayColor].CGColor;
    [_textBackView addSubview:backView];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, KSWIDTH-100, 35)];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.returnKeyType = UIReturnKeySend;
    _textField.delegate = self;
    _textField.center = backView.center;
    [_textBackView addSubview:_textField];
    //回收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
}

#pragma mark   ===============TableView代理方法===============
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatModel *model = _contentList[indexPath.row];
    return model.textH+20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:KCELL forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = _contentList[indexPath.row];
    return cell;
}

//接受消息
- (void)receiveAction:(NSNotification *)notInfo {
    
    NSDictionary *msg = notInfo.userInfo;
    NSString *text = msg[@"text"];
    [self addMessage:text WithIsSelf:NO];
}

//发送消息
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //判断文本是否为空文本
    if (_textField.text.length<1 || [_textField.text isEqualToString:@""]) {
        return NO;
    }
    [self addMessage:_textField.text WithIsSelf:YES];
    //发送消息给好友
    [[ZkXmppManager sharedInstance] sendMessage:_textField.text toFriend:_toJID];
    
    return YES;
}

//刷新数据源
-(void)addMessage:(NSString *)message WithIsSelf:(BOOL)isSelf{

    ZkXmppManager *manager = [ZkXmppManager sharedInstance];
    
    //计算文本的高度
    CGFloat textH = [manager getStringHeight:message withFont:KFONT withWidth:KSWIDTH-KHEADWIDTH];
    //文本宽度
    CGFloat textW = KSWIDTH-KHEADWIDTH;
    //文本只有一行情况下，高度定位40，宽度计算
    if (textH<40) {
        
        textH = 40;
        
        //根据字体得到NSString的尺寸
        CGSize strSize = [message sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:KFONT],NSFontAttributeName, nil]];
    
        textW = strSize.width;
    }
    
    ChatModel *model = [[ChatModel alloc]init];
    model.contentStr = message;
    model.isSelf = isSelf;
    model.textH = textH;
    model.textW = textW;
    [_contentList addObject:model];
    
    [_tableView reloadData];
    //动画滑动到最新消息处
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:_contentList.count-1 inSection:0];
    [_tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}
//单击窗口回收键盘
-(void)tapAction:(UITapGestureRecognizer *)tap{
    [self textEnding];
}
//回收键盘
-(void)textEnding{
    [self.view endEditing:YES];
    _textField.text = @"";
}

#pragma mark   ================键盘弹出事件处理==============
- (void)keyboardWillChange:(NSNotification *)note
{
    NSDictionary *userInfo = note.userInfo;
    CGRect keyFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat keyH = keyFrame.size.height;
    _keyHidden = NO;
    _keyH = keyH;
    
    _tableView.frame = CGRectMake(0, KNAVH, KSWIDTH, KSHEIGHT-KBOTTOMHEIHGHT-keyH-KNAVH);
    
    [UIView animateWithDuration:1 animations:^{
        //平移视图
        _textBackView.transform = CGAffineTransformMakeTranslation(0, -keyH);
//        if ([self judgeTextHeight]) {
//            _tableView.transform = CGAffineTransformMakeTranslation(0, -_keyH);
//        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    
    _keyHidden = YES;
    //回收键盘
    [self textEnding];
    
    _tableView.frame = CGRectMake(0, KNAVH, KSWIDTH, KSHEIGHT-KBOTTOMHEIHGHT-KNAVH);
    
    [UIView animateWithDuration:1 animations:^{
        //改变约束的值
        _textBackView.transform = CGAffineTransformIdentity;
//        _tableView.transform = CGAffineTransformIdentity;
    }];
}

-(BOOL)judgeTextHeight{

    //判断当前聊天界面内容高度
    ChatCell *cell = (ChatCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:_contentList.count - 1 inSection:0]];
    //超出键盘高度
    if (cell.frame.origin.y + cell.model.textH+ 20 > KSHEIGHT-_keyH-KBOTTOMHEIHGHT-KNAVH) {
        return YES;
    }
    return NO;
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
