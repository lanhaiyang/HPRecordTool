//
//  ViewController.m
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/14.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "ViewController.h"
#import "HPRecordToolManage.h"
#import "HPRecordGraphicView.h"
#import <Masonry/Masonry.h>

@interface ViewController ()<HPRecordToolProtocol>

@property(nonatomic,strong) HPRecordToolManage *manage;
@property(nonatomic,strong) HPRecordGraphicView *graphicView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _manage = [[HPRecordToolManage alloc] init];
    _manage.delegate = self;
    
    _graphicView = [[HPRecordGraphicView alloc] init];
//    _graphicView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 200);
    [self.view addSubview:_graphicView];
    [_graphicView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).equalTo(@20);
        make.right.left.equalTo(self.view);
        make.height.equalTo(@200);
    }];
}

-(void)hp_recordWithState:(HPRecordToolRecordState)state{
    
    
    switch (state) {
        case HPRecordToolRecordStop:{
            
            
        }
            break;
        case HPRecordToolRecordPause:{
            
            
        }
            break;
        case HPRecordToolRecordCompoundSuccess:{
         
            NSLog(@"path = %@",_manage.cachePath);
        }
            break;
        case HPRecordToolRecordCompoundFailse:{
            
            
        }
            break;
        case HPRecordToolRecordStart:{
            
            
        }
            break;
        default:
            break;
    }
}

- (IBAction)start:(id)sender {
    
    [_manage startRecord];
    
}

- (IBAction)pause:(id)sender {
    
    [_manage pauseRecord];
}

- (IBAction)stop:(id)sender {
    
    [_manage stopRecord];
}

@end
