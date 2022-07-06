//
//  RecordTestViewController.m
//  HPRecordTool
//
//  Created by sky on 2022/6/20.
//  Copyright © 2022 何鹏. All rights reserved.
//

#import "RecordTestViewController.h"
#import "HPRecordToolManage.h"
#import "HPRecordGraphicView.h"
#import "HPRecordGraphicBackgroundView.h"
#import <Masonry/Masonry.h>
//#import "HPRecordTool-Swift.h"
#import "HPSymmetryFrequencySpectrumGraphicView.h"
#import "HPFrequencySpectrumGraphicView.h"
@interface RecordTestViewController ()<HPRecordToolProtocol,HPRecordGraphicProtocol>

@property(nonatomic,strong) HPRecordToolManage *manage;
//@property(nonatomic,strong) HPRecordGraphicBackgroundView *graphicView;
@property (nonatomic, strong) HPSymmetryFrequencySpectrumGraphicView *showAudioSizeView;
//@property (nonatomic, strong) ASRealtimeAnalyzer *analyer;

@property (nonatomic, strong) NSArray *spectrums;

@end

@implementation RecordTestViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    RealtimeConfige *confige = [RealtimeConfige confige];
    confige.frequencyBands = 26;
    confige.samplingRate = 8000;
    confige.bufferSize = 1024;
    confige.channel = 1;
    _manage = [[HPRecordToolManage alloc] initWithConfige:confige];
    _manage.delegate = self;
    
    
    _showAudioSizeView = [[HPSymmetryFrequencySpectrumGraphicView alloc] initWithShowItemCount:26];
    _showAudioSizeView.delegate = self;
    _showAudioSizeView.itemSpace = 1;
    _showAudioSizeView.itemWidth = 3;
    
    _showAudioSizeView.direction = HPFrequencySpectrumShowDirectionCentre;
    _showAudioSizeView.graphicDirect = HPRecordGraphicRectDirectCentre;
    _showAudioSizeView.itemColor = [UIColor blackColor];
    _showAudioSizeView.layer.borderColor = [UIColor blackColor].CGColor;
    _showAudioSizeView.layer.borderWidth = 1;
    [self.view addSubview:_showAudioSizeView];
    [self.showAudioSizeView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view).equalTo(@(64+20));
//        make.right.left.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@120);
        make.height.equalTo(@30);
    }];
    
    
    HPFrequencySpectrumGraphicView *graphicView = [[HPFrequencySpectrumGraphicView alloc] init];
    graphicView.delegate = self;
    graphicView.itemSpace = 1;
    graphicView.itemWidth = 3;
    graphicView.direction = HPFrequencySpectrumShowDirectionCentre;
    
    graphicView.itemColor = [UIColor blackColor];
    graphicView.layer.borderColor = [UIColor blackColor].CGColor;
    graphicView.layer.borderWidth = 1;
    [self.view addSubview:graphicView];
    [graphicView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view).equalTo(@(128+20));
        make.centerX.equalTo(self.view);
        make.width.equalTo(@177);
        make.height.equalTo(@60);
    }];
    
//    _analyer = [[ASRealtimeAnalyzer alloc] initWithFftSize:2048];
    
//    RealtimeAnalyzer *x = [[RealtimeAnalyzer alloc] init];
    
//    _graphicView = [[HPRecordGraphicBackgroundView alloc] init];
//    [_graphicView hp_setRecordSizes:@[@(0.1),@(0.2),@(0.3),@(0.2),@(0.1)]];
////    [_graphicView hp_updateDisplay];
//    _graphicView.rectangleSpace = 2;
////    _graphicView.delegate = self;
//    _graphicView.rectangleColor = [UIColor grayColor];
////    _graphicView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 200);
//    [self.view addSubview:_graphicView];
//    [_graphicView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.equalTo(self.view).equalTo(@20);
//        make.right.left.equalTo(self.view);
//        make.height.equalTo(@200);
//    }];
//    [_graphicView hp_updateDisplay];
}

-(void)hp_recordWithState:(HPRecordToolRecordState)state info:(NSDictionary * _Nullable)info{
    
    
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
        case HPRecordToolProgressChange:{
            
//            AVAudioPCMBuffer *buffer = info[@"pcmBuffer"];
//            if (buffer == nil) {
//                return;
//            }
//            // 频谱
//            NSArray<NSArray<NSNumber *> *> *frequencSpectrum = [_analyer analyseWith:buffer];
//            printf("\n");
//            if (frequencSpectrum.count >= 1) {
//                NSArray<NSNumber *> *list = frequencSpectrum[0];
//                for (NSNumber *num in list) {
//                    printf(",%f",num.floatValue);
//                }
//            }
//            printf("\n");
//            NSLog(@"xx = %ld",frequencSpectrum.count);
        }
            break;
        default:
            break;
    }
}


- (void)hp_recorderDidGenerateSpectrumWithDatas:(NSArray *)spectrums{
    
    _spectrums = [spectrums copy];
}

#pragma mark - HPRecordGraphicProtocol

-(NSArray<NSArray<NSNumber *> *> *)hp_getFrquecySpectrumData{
    
    return _spectrums;
}

-(float)hp_refreshFrequencySpectrumSize{
    
    return [_manage analyzerVoiceSize];
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
