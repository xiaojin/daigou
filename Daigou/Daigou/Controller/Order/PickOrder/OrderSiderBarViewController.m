//
//  OrderSiderBarViewController.m
//  Daigou
//
//  Created by jin on 25/08/2015.
//  Copyright (c) 2015 dg. All rights reserved.
//

#import "OrderSiderBarViewController.h"
#import "MenuItem.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@implementation OrderSiderBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSMutableArray * lis=[NSMutableArray arrayWithCapacity:0];
    
    
    /**
     *  构建需要数据 2层或者3层数据 (ps 2层也当作3层来处理)
     */
    NSInteger countMax=10;
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
    
    
    MenuItem * view=[[MenuItem alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) WithData:lis withSelectIndex:^(NSInteger left, NSInteger right,rightMeun* info) {
        
        NSLog(@"点击的 菜单%@",info.meunName);
    }];
    
    //    view.leftSelectColor=[UIColor greenColor];
    //  view.leftSelectBgColor=[UIColor redColor];
    view.isRecordLastScroll=YES;
    [self.contentView addSubview:view];
}

@end
