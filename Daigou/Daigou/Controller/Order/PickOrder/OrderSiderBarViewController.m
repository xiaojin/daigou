//
//  OrderSiderBarViewController.m
//  Daigou
//
//  Created by jin on 25/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderSiderBarViewController.h"
#import "MenuItem.h"
#import <Masonry/Masonry.h>
#import "CommonDefines.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation OrderSiderBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after    loading the view from its nib.
    
    NSMutableArray * lis=[NSMutableArray arrayWithCapacity:0];
    
    
    /**
     *  构建需要数据 2层或者3层数据 (ps 2层也当作3层来处理)
     */
    NSInteger countMax=20;
    for (int i=0; i<countMax; i++) {
        
        rightMeun * meun=[[rightMeun alloc] init];
        meun.meunName=[NSString stringWithFormat:@"菜单%d",i];
        NSMutableArray * sub=[NSMutableArray arrayWithCapacity:0];
        for ( int j=0; j <countMax+1; j++) {
            rightMeun * meun1=[[rightMeun alloc] init];
            meun1.meunName=[NSString stringWithFormat:@"%d头菜单%d",i,j];
            [sub addObject:meun1];
            //meun.meunNumber=2;
            NSMutableArray *zList=[NSMutableArray arrayWithCapacity:0];
            if (j%2==0) {
                for ( int z=0; z <countMax+2; z++) {
                    rightMeun * meun2=[[rightMeun alloc] init];
                    meun2.meunName=[NSString stringWithFormat:@"%d层菜单%d",j,z];
                    [zList addObject:meun2];
                }
            }
            meun1.nextArray=zList;
        }
        
        meun.nextArray=sub;
        [lis addObject:meun];
    }
    CGRect menuRect = CGRectZero;
    if (!self.hideHeaderView) {
        UIView *headView = [[UIView alloc]init];
        [headView setBackgroundColor:RGB(243, 244, 246)];
        [self.contentView addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.height.equalTo(@60);
        }];
        UILabel *headViewTitle = [[UILabel alloc]init];
        [headViewTitle setText:@"全部分类"];
        [headViewTitle setFont:[UIFont systemFontOfSize:14.0f]];
        [headViewTitle setTextColor:RGB(125, 125, 125)];
        [headViewTitle setTextAlignment:NSTextAlignmentCenter];
        [headView addSubview:headViewTitle];
        
        [headViewTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headView.mas_top).with.offset(10);
            make.left.equalTo(headView.mas_left);
            make.bottom.equalTo(headView.mas_bottom);
            make.width.equalTo(@80);
        }];
        menuRect = CGRectMake(0, 60, self.contentView.bounds.size.width, self.contentView.bounds.size.height-60);
    } else {
        NSLog(@"%f",self.tabHeight + self.navHeight);
        menuRect = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height-(self.tabHeight + self.navHeight));
    }
//    
    MenuItem * view=[[MenuItem alloc] initWithFrame:menuRect WithData:lis withSelectIndex:^(NSInteger left, NSInteger right,rightMeun* info) {
        NSLog(@"点击的 菜单%@",info.meunName);
    }];
    
    
    //    view.leftSelectColor=[UIColor greenColor];
    //  view.leftSelectBgColor=[UIColor redColor];
    
 
    view.isRecordLastScroll=YES;
    [self.contentView addSubview:view];


}

@end
