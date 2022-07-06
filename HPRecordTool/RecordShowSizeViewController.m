//
//  RecordShowSizeViewController.m
//  HPRecordTool
//
//  Created by sky on 2022/6/20.
//  Copyright © 2022 何鹏. All rights reserved.
//

#import "RecordShowSizeViewController.h"
#import "HPSymmetryFrequencySpectrumGraphicView.h"
#import "HPRecordPalyerToolManage.h"
#import <Masonry/Masonry.h>

@interface RecordShowSizeViewController ()<HPRecordGraphicProtocol>

@property (nonatomic, strong) HPSymmetryFrequencySpectrumGraphicView  *graohicView;
@property (nonatomic, strong) HPRecordPalyerToolManage *playeToolManagge;


@end

@implementation RecordShowSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Kuba Oms - My Love" ofType:@"mp3"];
    _playeToolManagge = [[HPRecordPalyerToolManage alloc] init];
    [_playeToolManagge hp_recordFilePath:filePath];
    [_playeToolManagge play];
    
    _graohicView = [[HPSymmetryFrequencySpectrumGraphicView alloc] initWithShowItemCount:30];
    _graohicView.delegate = self;
    _graohicView.direction = HPFrequencySpectrumShowDirectionLeft;
    _graohicView.graphicDirect = HPRecordGraphicRectDirectCentre;
    _graohicView.itemColor = [UIColor grayColor];
    [self.view addSubview:self.graohicView];
    [self.graohicView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.view);
        make.width.equalTo(@200);
        make.height.equalTo(@50);
    }];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [_playeToolManagge stop];
}



-(float)hp_refreshFrequencySpectrumSize{
    
//    return ((float)arc4random() / 0x100000000);
    return [_playeToolManagge voiceSize];
}



@end
