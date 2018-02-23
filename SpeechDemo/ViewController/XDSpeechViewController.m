//
//  XDSpeechViewController.m
//  SpeechDemo
//
//  Created by mxd_iOS on 2018/2/23.
//  Copyright © 2018年 Xudong.ma. All rights reserved.
//

#import "XDSpeechViewController.h"
#import <Speech/Speech.h>

@interface XDSpeechViewController () <SFSpeechRecognitionTaskDelegate>

@property (nonatomic, strong) SFSpeechRecognitionTask *recognitionTask;
@property (nonatomic, strong) SFSpeechRecognizer      *speechRecognizer;
@property (nonatomic, strong) UILabel                 *recognizerLabel;

@end

@implementation XDSpeechViewController

#pragma mark -
#pragma mark - LazyLoading

#pragma mark -
#pragma mark - Set_Method

#pragma mark -
#pragma mark - ViewLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self instanceSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - SystemMethod

#pragma mark -
#pragma mark - InitializeMethod

- (void)instanceSubViews
{
    self.navigationItem.title = @"测 试";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    /** Demo Frame设置随意了一些(勿喷)*/
    self.recognizerLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 120, self.view.bounds.size.width - 100, 100)];
    self.recognizerLabel.numberOfLines = 0;
    self.recognizerLabel.font          = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.recognizerLabel.adjustsFontForContentSizeCategory = YES;
    self.recognizerLabel.textColor     = [UIColor redColor];
    [self.view addSubview:self.recognizerLabel];
    
    
    //0.0获取权限
    //0.1在info.plist里面配置
    /*
     typedef NS_ENUM(NSInteger, SFSpeechRecognizerAuthorizationStatus) {
     SFSpeechRecognizerAuthorizationStatusNotDetermined,
     SFSpeechRecognizerAuthorizationStatusDenied,
     SFSpeechRecognizerAuthorizationStatusRestricted,
     SFSpeechRecognizerAuthorizationStatusAuthorized,
     };
     */
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        switch (status) {
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                NSLog(@"NotDetermined");
                break;
            case SFSpeechRecognizerAuthorizationStatusDenied:
                NSLog(@"Denied");
                break;
            case SFSpeechRecognizerAuthorizationStatusRestricted:
                NSLog(@"Restricted");
                break;
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                NSLog(@"Authorized");
                break;
            default:
                break;
        }
    }];
    
    //1.创建SFSpeechRecognizer识别实例
    self.speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    
    //2.创建识别请求
    SFSpeechURLRecognitionRequest *request = [[SFSpeechURLRecognitionRequest alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"xxx.mp3" ofType:nil]]];
    
    //3.开始识别任务
    self.recognitionTask = [self recognitionTaskWithRequest1:request];
}

#pragma mark -
#pragma mark - PersonalMethod

#pragma mark -
#pragma mark - ButtonClickMethod

#pragma mark -
#pragma mark - NotificationMethod

#pragma mark -
#pragma mark - ...Delegate/DataSourceMethod

- (SFSpeechRecognitionTask *)recognitionTaskWithRequest1:(SFSpeechURLRecognitionRequest *)request
{
    return [self.speechRecognizer recognitionTaskWithRequest:request
                                                    delegate:self];
}


// Called when the task first detects speech in the source audio
- (void)speechRecognitionDidDetectSpeech:(SFSpeechRecognitionTask *)task
{
    
}

// Called for all recognitions, including non-final hypothesis
- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didHypothesizeTranscription:(SFTranscription *)transcription
{
    
}

// Called only for final recognitions of utterances. No more about the utterance will be reported
- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishRecognition:(SFSpeechRecognitionResult *)recognitionResult
{
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:18],
                                 };
    
    CGRect rect = [recognitionResult.bestTranscription.formattedString boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    self.recognizerLabel.text = recognitionResult.bestTranscription.formattedString;
    self.recognizerLabel.frame = CGRectMake(50, 120, rect.size.width, rect.size.height);
}

// Called when the task is no longer accepting new audio but may be finishing final processing
- (void)speechRecognitionTaskFinishedReadingAudio:(SFSpeechRecognitionTask *)task
{
    
}

// Called when the task has been cancelled, either by client app, the user, or the system
- (void)speechRecognitionTaskWasCancelled:(SFSpeechRecognitionTask *)task
{
    
}

// Called when recognition of all requested utterances is finished.
// If successfully is false, the error property of the task will contain error information
- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishSuccessfully:(BOOL)successfully {
    if (successfully)
    {
        NSLog(@"全部解析完毕");
    }
}

#pragma mark -
#pragma mark - NetworkHandlerMethod

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
