//
//  CheckViewDetailVC.m
//  DriverProject
//
//  Created by zyx on 15/9/21.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "CheckViewDetailVC.h"
#import "DriverOrderDetailsCell.h"
#import "DriverScoreCell.h"


@interface CheckViewDetailVC ()
{
    NSInteger _flage;
    NSArray *_DetailList;

}

@end

@implementation CheckViewDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _flage=0;
    
    
    self.view.backgroundColor=Textlightwhite_COLOR;
    self.backView.backgroundColor=Textwhite_COLOR;
    self.backLabel.text=@"查看明细";
    self.backLabel.textColor=Textblack_COLOR;
    self.backButton.backgroundColor=[UIColor clearColor];
    [self.backButton addTarget:self action:@selector(BackView) forControlEvents:UIControlEventTouchUpInside];
    self.backButtonimage.image=[UIImage imageNamed:@"common_navbar_return.png"];
    [self initlable];
    
    [self initTableView];
    

    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(void)initlable
{
    _DetailList=[[NSArray alloc]init];
    _detaillabel = ({
        UILabel * lable=[[UILabel alloc]initWithFrame:CGRectZero];
        lable.font = [UIFont boldSystemFontOfSize:27];
        lable.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        lable.textAlignment=NSTextAlignmentCenter;
        lable.textColor = Assist_COLOR;
        lable.backgroundColor=[UIColor clearColor];
        lable;
    });
    [self.view addSubview:_detaillabel];


    _detaillabel.text=@"";
    
    _detaillabel.frame=CGRectMake(0, CUSTOM_NAV_HEIGHT, self.view.width, CUSTOM_NAV_HEIGHT*1.5);

}
-(void)initTableView
{
    _detailTable = ({
        UITableView *  atableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        atableView.delegate = self;
        atableView.dataSource = self;
        atableView.backgroundColor = [UIColor clearColor];
        atableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        atableView.showsVerticalScrollIndicator = NO;
        atableView.showsHorizontalScrollIndicator = NO;
        atableView;
    });
    [self.view addSubview:_detailTable];
    _detailTable.frame=CGRectMake(0, _detaillabel.bottom+15, self.view.width, self.view.height-(_detaillabel.bottom+15));
    
}

-(void)viewWillAppear:(BOOL)animated
{
    QiFacade*       facade;
    facade=[QiFacade sharedInstance];
    _flage=[facade getOrderCostDetailsID:_orderID];
    NSLog(@"takeOutMoneyFlag=%ld",(long)_flage);
    [facade addHttpObserver:self tag:_flage];
    
    [self showLoadingWithText:@""];
}

-(void)BackView
{

    [self.navigationController popViewControllerAnimated:YES];

}


#pragma  mark  tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    NSInteger intergerNum=2;
    
    intergerNum=[_DetailList count];
    
    return intergerNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"DriverOrderDetailsCell1";
    DriverOrderDetailsCell *sectionCell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (sectionCell == nil) {
        sectionCell = [[DriverOrderDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        sectionCell.backgroundColor=[UIColor clearColor];
    }
    
    sectionCell.showSeperateLine=YES;
    sectionCell.showTopSeperateLine=NO;
    sectionCell.isIndentationWidth=YES;
    if(indexPath.row==0)
    {
        sectionCell.showTopSeperateLine=YES;
    }
    if(indexPath.row==([_DetailList count]-1))
    {
        sectionCell.isIndentationWidth=NO;
    }
    
    
    NSDictionary *dic=[_DetailList objectAtIndex:indexPath.row];
    sectionCell.titleText=[dic objectForKey:@"desc"];
    sectionCell.contentText=[dic objectForKey:@"fee"];
    
    

    
    return sectionCell;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}



#pragma mark - UITableViewDelegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark  改变第一个字符串

-(NSRange)getRangeWithStr:(NSString *)_str searchStr:(NSString *)_searchStr
{
    return [_str rangeOfString:_searchStr];
}


-(void)changeString:(NSString *)LastString changeLable:(UILabel *)Lable
{
    NSRange range01=[self getRangeWithStr:LastString searchStr:@"¥"];
    if(range01.location!=NSNotFound)
    {
        
        NSLog(@"NSStringFromRange01==%@",NSStringFromRange(range01));
        
        NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",LastString]];
        
        [dateString addAttributes:@{
                                    NSFontAttributeName:[UIFont systemFontOfSize:15],
                                    NSForegroundColorAttributeName:Lable.textColor
                                    }
                            range:NSMakeRange(0, 1)];
        [dateString addAttributes:@{
                                    NSFontAttributeName:[UIFont systemFontOfSize:14],
                                    NSForegroundColorAttributeName:Lable.textColor
                                    }
                            range:NSMakeRange(1, 1)];
        
        [dateString addAttributes:@{
                                    NSFontAttributeName: [UIFont systemFontOfSize:27],
                                    NSForegroundColorAttributeName:Lable.textColor
                                    }
                            range:NSMakeRange(2, [LastString length]-2)];
        
        Lable.attributedText = dateString;
    }
}

#pragma 网络处理

- (void)requestFinished:(NSDictionary*)response tag:(NSInteger)iRequestTag
{
    [self dismissLoading];
    NSLog(@"成功 /n%@",response);
    if(_flage!=0&&response!=nil&&iRequestTag==_flage)
    {
        _flage=0;
        NSDictionary *dic=[response objectForKey:@"data"];
        _DetailList=[dic objectForKey:@"detail"];
        if([_DetailList count]>0)
        {
            [_detailTable reloadData];
            _detaillabel.text=[NSString stringWithFormat:@"¥ %@",[dic objectForKey:@"fee"]];
            [self changeString:_detaillabel.text changeLable:_detaillabel];
            
        }
        
    }
    
    
}


- (void)requestFailed:(NSDictionary*)response tag:(NSInteger)iRequestTag
{
    
    [self dismissLoading];
    NSString *Message=[response objectForKey:@"message"];
    if(Message!=nil)
    {
        NSLog(@"Message==%@",Message);

    }
    
    [self showWarningMessage:Message];
    
    NSLog(@"失败 /n%@",response);
    
}







@end
