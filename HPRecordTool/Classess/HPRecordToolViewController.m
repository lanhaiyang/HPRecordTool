//
//  HPRecordToolViewController.m
//  HPRecordTool
//
//  Created by 何鹏 on 2020/10/21.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "HPRecordToolViewController.h"
#import "HPRecordToolManage.h"
#import "HPRecordGraphicView.h"
#import "HPRecordPalyerToolManage.h"
#import "HPRecordToolViewModel.h"
#import <Masonry/Masonry.h>
#import "HPRecordGraphicViewModel.h"

@interface HPRecordToolViewController ()<HPRecordPalyerToolDelegate,HPRecordToolProtocol>

@property(nonatomic,strong) HPRecordToolManage *recordToolManage;
@property(nonatomic,strong) HPRecordGraphicView *graphicView;
@property(nonatomic,strong) HPRecordPalyerToolManage *playerToolManage;
@property(nonatomic,strong) HPRecordToolViewModel *viewModel;

@property(nonatomic,strong) UILabel *time;//显示时间
@property(nonatomic,strong) UIButton *reset;//重置
@property(nonatomic,strong) UIButton *record;//录音
@property(nonatomic,strong) UIButton *testPlayer;//试听

@end

@implementation HPRecordToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatObj];
    [self confige];
    [self layout];
}


-(void)creatObj{
    
    _time = self.time;
    _recordToolManage = self.recordToolManage;
    _graphicView = self.graphicView;
    _playerToolManage = self.playerToolManage;
    _viewModel = self.viewModel;
    
    
    _reset = self.reset;
    _record = self.record;
    _testPlayer = self.testPlayer;
    
}

-(void)confige{
    
    
}

-(void)layout{
    

    
    [self.view addSubview:self.graphicView];
    [_graphicView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).equalTo(@20);
        make.right.left.equalTo(self.view);
        make.height.equalTo(@200);
    }];
    
    [self.view addSubview:self.time];
    [self.view addSubview:self.record];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).equalTo(@15);
        make.bottom.equalTo(self.record.mas_top);
        make.right.equalTo(self.view).equalTo(@-15);
    }];
    
    
    [self.record mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view).equalTo(@(-50));
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@50);
    }];
    
    [self.view addSubview:self.reset];
    [self.reset mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.record.mas_left).equalTo(@(-25));
        make.bottom.equalTo(self.record);
        make.width.height.equalTo(@50);
    }];
    
    [self.view addSubview:self.testPlayer];
    [self.testPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.record.mas_right).equalTo(@25);
        make.bottom.equalTo(self.record);
        make.height.equalTo(@50);
    }];
    

}

#pragma mark - HPRecordPalyerToolDelegate

-(void)hp_recordPlayerState:(HPRecordPalyerToolState)state{
    
    switch (state) {
        case HPRecordPalyerToolStop:{
            
            _viewModel.isAcitonPlayer = NO;
            _reset.userInteractionEnabled = YES;
            [_reset setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            if (_recordToolManage.currentTime >= _graphicView.recordMaxSecond) {
                
                _record.userInteractionEnabled = NO;
                [_record setTitle:@"录音" forState:UIControlStateNormal];
                [_record setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                
            }else{
                
                _record.userInteractionEnabled = YES;
                [_record setTitle:@"录音" forState:UIControlStateNormal];
                [_record setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }

            _testPlayer.userInteractionEnabled = YES;
            [_testPlayer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_testPlayer setTitle:@"试听" forState:UIControlStateNormal];
            
        }
            break;
        case HPRecordPalyerToolPause:{
            
        }
            break;
        case HPRecordPalyerToolPlayer:{
            
            if (_playerToolManage.currentTime >= _recordToolManage.currentTime) {//播放到当前录制时间
                [_playerToolManage stop];
                _viewModel.isAcitonPlayer = NO;
            }else{
                [self setTimeContentWithLeftSecondTime:_playerToolManage.currentTime rightSecondTime:_graphicView.recordMaxSecond];
                _viewModel.isAcitonPlayer = YES;
                [_graphicView hp_PlayerWihtDuration:_playerToolManage.currentTime moreSpace:_graphicView.secondSpace];
            }
        }
            break;
        case HPRecordPalyerToolFailse:{
            
            
        }
            break;
        case HPRecordPalyerToolSuccess:{
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - HPRecordToolProtocol

-(void)hp_recordWithState:(HPRecordToolRecordState)state{
    
    switch (state) {
        case HPRecordToolProgressChange:{
            
            [self setTimeContentWithLeftSecondTime:_recordToolManage.currentTime rightSecondTime:_graphicView.recordMaxSecond];
            float max = [_recordToolManage voiceSize];
            [_viewModel hp_SetRecordMaxWithNumber:max];
            [_graphicView hp_setRecordSizes:_viewModel.recordMaxs];
            if (_recordToolManage.currentTime >= _graphicView.recordMaxSecond) {
                [_recordToolManage stopRecord];
            }
        }
            break;
        case HPRecordToolRecordStart:{
            
            
        }
            break;
        case HPRecordToolRecordCompoundFailse:{
            

            [_testPlayer setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            _testPlayer.userInteractionEnabled = NO;
            [_testPlayer setTitle:@"不能试听" forState:UIControlStateNormal];
        }
            break;
        case HPRecordToolRecordCompoundSuccess:{
            
            [_testPlayer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _testPlayer.userInteractionEnabled = YES;
            [_testPlayer setTitle:@"试听" forState:UIControlStateNormal];
            [_playerToolManage hp_recordFilePath:_recordToolManage.cachePath];
            
        }
            break;
        case HPRecordToolRecordPause:{
            
            
        }
            break;
        case HPRecordToolRecordStop:{
            
            [_recordToolManage pauseRecord];
            
            _reset.userInteractionEnabled = YES;
            [_reset setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            if (_recordToolManage.currentTime >= _graphicView.recordMaxSecond){
                
                _record.userInteractionEnabled = NO;
                [_record setTitle:@"录音" forState:UIControlStateNormal];
                [_record setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }else{
                
                _record.userInteractionEnabled = YES;
                [_record setTitle:@"录音" forState:UIControlStateNormal];
                [_record setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            
            _testPlayer.userInteractionEnabled = YES;
            [_testPlayer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_testPlayer setTitle:@"试听" forState:UIControlStateNormal];
            
        }
            break;
        case HPRecordToolRecordFailse:{
            
        }
            break;
        case HPRecordToolRecordSuccess:{
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - 事件

-(void)resetAction{
    
    //重置
    [_recordToolManage reset];
    _viewModel.isAcitonPlayer = NO;
    [_viewModel recordRemoveAll];
    [_graphicView hp_setRecordSizes:_viewModel.recordMaxs];
    [_graphicView hp_offsetXWithZero];
    [_graphicView graphicUpdate];
    [self setTimeContentWithLeftSecondTime:0 rightSecondTime:_graphicView.recordMaxSecond];
    
    _record.userInteractionEnabled = YES;
    [_record setTitle:@"录音" forState:UIControlStateNormal];
    [_record setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    _testPlayer.userInteractionEnabled = NO;
    [_testPlayer setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_testPlayer setTitle:@"不能试听" forState:UIControlStateNormal];
    
    _reset.userInteractionEnabled = NO;
    [_reset setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

-(void)recordAction{
    
    
    if(_viewModel.isAcitonPlayer == YES){
        
        [self playeEven];
    }else{
        
        [self recordEvent];
    }
    
    _viewModel.isAcitonPlayer = NO;
}

-(void)playeEven{
    
    [_graphicView hp_setRecordSizes:_viewModel.recordMaxs];
    [_playerToolManage stop];
    _record.userInteractionEnabled = YES;
    [_record setTitle:@"录音" forState:UIControlStateNormal];
    [_record setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [_testPlayer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _testPlayer.userInteractionEnabled = YES;
    [_testPlayer setTitle:@"试听" forState:UIControlStateNormal];
    
    _reset.userInteractionEnabled = YES;
    [_reset setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

-(void)recordEvent{
    
    //录音->录音成功->马克风正在录音
    if (_recordToolManage.isRecorder == YES) {
            
        [_recordToolManage pauseRecord];
        [_record setTitle:@"录音" forState:UIControlStateNormal];
        [_record setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        //需要到回调里面改变试听状态
        
        _reset.userInteractionEnabled = YES;
        [_reset setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else{
        
        if (_recordToolManage.currentTime >= _graphicView.recordMaxSecond) {
            
            
        }else{
                
            [_recordToolManage startRecord];
            
            [_record setTitle:@"暂停" forState:UIControlStateNormal];
            [_record setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            
            [_testPlayer setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            _testPlayer.userInteractionEnabled = NO;
            [_testPlayer setTitle:@"不能试听" forState:UIControlStateNormal];
            
            _reset.userInteractionEnabled = NO;
            [_reset setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }

    }
    
}



-(void)testPlayerAction{
    
    //试听
    
    if (_viewModel.isAcitonPlayer == NO) {
        // 切换播放状态
        
        _viewModel.isAcitonPlayer = YES;
        
        // 这是录音键不能交互
        _record.userInteractionEnabled = YES;
        [_record setTitle:@"暂停" forState:UIControlStateNormal];
        [_record setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        
        _testPlayer.userInteractionEnabled = NO;
        [_testPlayer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_testPlayer setTitle:@"正在播放" forState:UIControlStateNormal];
        
        _reset.userInteractionEnabled = NO;
        [_reset setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [_graphicView defalueNumber];
        [_graphicView hp_offsetXWithZero];
        [_playerToolManage play];
    }else{
        
        // 切换暂停状态
        _viewModel.isAcitonPlayer = NO;
        
        _record.userInteractionEnabled = YES;
        [_record setTitle:@"录音" forState:UIControlStateNormal];
        [_record setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        [_testPlayer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_testPlayer setTitle:@"试听" forState:UIControlStateNormal];
        
        _reset.userInteractionEnabled = NO;
        [_reset setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_playerToolManage pause];
    }
}

-(void)setTimeContentWithLeftSecondTime:(NSInteger)leftsecond rightSecondTime:(NSInteger)rightSecond{
    
    _time.text = [NSString stringWithFormat:@"%@/%@",[HPRecordGraphicViewModel dateFormSeconds:leftsecond],[HPRecordGraphicViewModel dateFormSeconds:rightSecond]];
}

#pragma mark - 懒加载

-(UIButton *)record{
    
    if (_record == nil) {
        _record = [[UIButton alloc] init];
        [_record setTitle:@"录音" forState:UIControlStateNormal];
        [_record setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _record.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_record addTarget:self action:@selector(recordAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _record;
}

-(UIButton *)reset{
    
    if (_reset == nil) {
        _reset = [[UIButton alloc] init];
        [_reset setTitle:@"重置" forState:UIControlStateNormal];
        [_reset setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _reset.titleLabel.textAlignment = NSTextAlignmentCenter;
        _reset.userInteractionEnabled = NO;
        [_reset addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reset;
}

-(UIButton *)testPlayer{
    
    if (_testPlayer == nil) {
        _testPlayer = [[UIButton alloc] init];
        [_testPlayer setTitle:@"试听" forState:UIControlStateNormal];
        _testPlayer.userInteractionEnabled = NO;
        [_testPlayer setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _testPlayer.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_testPlayer addTarget:self action:@selector(testPlayerAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testPlayer;
}

-(HPRecordToolManage *)recordToolManage{
    
    if (_recordToolManage == nil) {
        _recordToolManage = [[HPRecordToolManage alloc] init];
        _recordToolManage.delegate = self;
    }
    return _recordToolManage;
}

-(HPRecordGraphicView *)graphicView{
    
    if (_graphicView == nil) {
        _graphicView = [[HPRecordGraphicView alloc] init];
        _graphicView.recordMaxSecond = 10;
        [self setTimeContentWithLeftSecondTime:0 rightSecondTime:_graphicView.recordMaxSecond];
        [_graphicView graphicUpdate];
    }
    return _graphicView;
}

-(HPRecordPalyerToolManage *)playerToolManage{
    
    if (_playerToolManage == nil) {
        _playerToolManage = [[HPRecordPalyerToolManage alloc] init];
        _playerToolManage.delegate = self;
    }
    return _playerToolManage;
}

-(HPRecordToolViewModel *)viewModel{
    
    if (_viewModel == nil) {
        _viewModel = [[HPRecordToolViewModel alloc] init];
    }
    return _viewModel;
}

-(UILabel *)time{
    
    if (_time == nil) {
        _time = [[UILabel alloc] init];
        _time.textAlignment = NSTextAlignmentCenter;
        _time.textColor = [UIColor greenColor];
    }
    return _time;
}

@end
