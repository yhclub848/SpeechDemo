# 浅谈iOS语音识别+语音播报


###前言

最近在做一个翻译工具，由于项目需要兼容 iOS 8.0，所以语音识别、合成都是用的科大讯飞的。使用过程中发现在线转语音不是很好，受网络的影响声音经常断断续续的，而它的离线转语音价格有太贵。而且支持的语种较少，现在换成系统自带的语音合成、语音识别。一些心得记录一下方便需要同学查阅。

###语音识别

####优点

说话时，可以一个一个字识别，科大讯飞是一段话识别一次，这样的体验很好，可以及时响应到用户；
支持58种语种，其中包括一些地方方言(例如：粤语)；
识别度非常高；
###缺点

只支持iOS10以上的系统（iOS 10以下的系统需要做兼容，我用的是科大讯飞）
###框架主要类

```
#import <Foundation/Foundation.h>
#import <Speech/SFSpeechRecognitionResult.h>
#import <Speech/SFSpeechRecognitionRequest.h>
#import <Speech/SFSpeechRecognitionTask.h>
#import <Speech/SFSpeechRecognitionTaskHint.h>
#import <Speech/SFSpeechRecognizer.h>
#import <Speech/SFTranscriptionSegment.h>
#import <Speech/SFTranscription.h>
```

###如何使用
```
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
```

上面代码是一个简单的列子，创建```XDSpeechViewController```的VC直接拷贝上面代码,然后```info.plist ```添加用户使用权限
```Privacy - Microphone Usage Description```
```Privacy - Speech Recognition Usage Description```
就可以使用了。

###这里再重点说下修改本地化语言（需要识别的语言）
```
[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]
```
本地化语言的```keylocaleIdentifier```可以通过 ```[SFSpeechRecognizer supportedLocales]``` 获取到，目前一共是58种。

```
for (NSLocale *lacal in [SFSpeechRecognizer supportedLocales]) {
NSLog(@"localeIdentifier = %@,languageCode = %@, countryCode = %@",lacal.localeIdentifier,lacal.languageCode,lacal.countryCode);
}

打印日志如下：

localeIdentifier = nl-NL,languageCode = nl, countryCode = NL(荷兰)
localeIdentifier = es-MX,languageCode = es, countryCode = MX (墨西哥)
localeIdentifier = zh-TW,languageCode = zh, countryCode = TW(中国台湾)
localeIdentifier = fr-FR,languageCode = fr, countryCode = FR(法国)
localeIdentifier = it-IT,languageCode = it, countryCode = IT( 意大利)
localeIdentifier = vi-VN,languageCode = vi, countryCode = VN(越南)
localeIdentifier = en-ZA,languageCode = en, countryCode = ZA(南非)
localeIdentifier = ca-ES,languageCode = ca, countryCode = ES(西班牙)
localeIdentifier = es-CL,languageCode = es, countryCode = CL(智利)
localeIdentifier = ko-KR,languageCode = ko, countryCode = KR( 韩国)
localeIdentifier = ro-RO,languageCode = ro, countryCode = RO(罗马尼亚)
localeIdentifier = fr-CH,languageCode = fr, countryCode = CH(瑞士-法语)
localeIdentifier = en-PH,languageCode = en, countryCode = PH(菲律宾)
localeIdentifier = en-CA,languageCode = en, countryCode = CA(加拿大-英语)
localeIdentifier = en-SG,languageCode = en, countryCode = SG(新加坡)
localeIdentifier = en-IN,languageCode = en, countryCode = IN(印度)
localeIdentifier = en-NZ,languageCode = en, countryCode = NZ(新西兰)
localeIdentifier = it-CH,languageCode = it, countryCode = CH(瑞士-意大利语)
localeIdentifier = fr-CA,languageCode = fr, countryCode = CA(加拿大-法语)
localeIdentifier = da-DK,languageCode = da, countryCode = DK(丹麦)
localeIdentifier = de-AT,languageCode = de, countryCode = AT(奥地利-德语)
localeIdentifier = pt-BR,languageCode = pt, countryCode = BR(巴西-葡萄牙语)
localeIdentifier = yue-CN,languageCode = yue, countryCode = CN（中国-粤语）
localeIdentifier = zh-CN,languageCode = zh, countryCode = CN(中国-简文)
localeIdentifier = sv-SE,languageCode = sv, countryCode = SE(瑞典-萨尔瓦多语)
localeIdentifier = es-ES,languageCode = es, countryCode = ES（西班牙-英语）
localeIdentifier = ar-SA,languageCode = ar, countryCode = SA(沙乌地阿拉伯-阿根廷语)
localeIdentifier = hu-HU,languageCode = hu, countryCode = HU(匈牙利)
localeIdentifier = fr-BE,languageCode = fr, countryCode = BE(比利时-法语)
localeIdentifier = en-GB,languageCode = en, countryCode = GB(英式英语)
localeIdentifier = ja-JP,languageCode = ja, countryCode = JP(日本)
localeIdentifier = zh-HK,languageCode = zh, countryCode = HK(中国香港-粤语)
localeIdentifier = fi-FI,languageCode = fi, countryCode = FI(芬兰)
localeIdentifier = tr-TR,languageCode = tr, countryCode = TR(土耳其)
localeIdentifier = nb-NO,languageCode = nb, countryCode = NO(挪威)
localeIdentifier = en-ID,languageCode = en, countryCode = ID(印度尼西亚-英语)
localeIdentifier = en-SA,languageCode = en, countryCode = SA(沙乌地阿拉伯-英语)
localeIdentifier = pl-PL,languageCode = pl, countryCode = PL(波兰)
localeIdentifier = id-ID,languageCode = id, countryCode = ID(印度尼西亚)
localeIdentifier = ms-MY,languageCode = ms, countryCode = MY(马来西亚-蒙特塞拉特语)
localeIdentifier = el-GR,languageCode = el, countryCode = GR(希腊)
localeIdentifier = cs-CZ,languageCode = cs, countryCode = CZ(捷克共和国)
localeIdentifier = hr-HR,languageCode = hr, countryCode = HR(克罗地亚)
localeIdentifier = en-AE,languageCode = en, countryCode = AE(阿拉伯联合酋长国-英语)
localeIdentifier = he-IL,languageCode = he, countryCode = IL(以色列)
localeIdentifier = ru-RU,languageCode = ru, countryCode = RU(俄罗斯)
localeIdentifier = de-CH,languageCode = de, countryCode = CH(瑞士-德语)
localeIdentifier = en-AU,languageCode = en, countryCode = AU(澳大利亚-英语)
localeIdentifier = de-DE,languageCode = de, countryCode = DE(德语)
localeIdentifier = nl-BE,languageCode = nl, countryCode = BE(比利时-荷兰语)
localeIdentifier = th-TH,languageCode = th, countryCode = TH(泰国)
localeIdentifier = pt-PT,languageCode = pt, countryCode = PT(葡萄牙)
localeIdentifier = sk-SK,languageCode = sk, countryCode = SK(斯洛伐克)
localeIdentifier = en-US,languageCode = en, countryCode = US(美式英语)
localeIdentifier = en-IE,languageCode = en, countryCode = IE(爱尔兰-英语)
localeIdentifier = es-CO,languageCode = es, countryCode = CO(哥伦比亚-西班牙语)
localeIdentifier = uk-UA,languageCode = uk, countryCode = UA(乌克兰)
localeIdentifier = es-US,languageCode = es, countryCode = US(美国-西班牙语)
```

###语音合成

####优点

- 支持的30多种语种；
- 语速、语调、音量都可以自己控制，可以自定义自己喜欢的格式；
####缺点

- 发音效果一般理想
- 播音员默认只有一个（讯飞可以选择播音员发音效果很好）
###框架主要类
```
#import<AVFoundation/AVSpeechSynthesis.h>
```
###如何使用

#####1、初始化设置```AVSpeechSynthesizer```
```
AVSpeechSynthesizer *player  = [[AVSpeechSynthesizer alloc]init];
player.delegate  = self;
self.player      = player;
AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:string];//设置语音内容
utterance.voice  = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-TW"];//设置语言 zh-CN yue-CN
utterance.rate   = self.rate;  //设置语速
utterance.volume = self.volume;  //设置音量（0.0~1.0）默认为1.0
utterance.pitchMultiplier = self.pitchMultiplier;  //设置语调 (0.5-2.0)
utterance.postUtteranceDelay = 0; //目的是让语音合成器播放下一语句前有短暂的暂停
[player speakUtterance:utterance];
```
#####2、控制部分

- 停止
```
[self.player stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
```
- 暂停
```
[self.player pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
```

- 继续播放
```
[self.player continueSpeaking];
```

#####3、代理部分
```
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
NSLog(@"朗读开始");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance{
NSLog(@"朗读暂停");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance{
NSLog(@"朗读继续");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
NSLog(@"朗读结束");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance{

}
```
设置声音效果的方法，注意选英语则读不了汉语，但是汉语可以和英语混用，这个我已经试过了。但是读起来比较生硬。

#####avspeech支持的语言种类包括：
```
"[AVSpeechSynthesisVoice 0x978a0b0] Language: th-TH",(泰国)

"[AVSpeechSynthesisVoice 0x977a450] Language: pt-BR",(巴西-葡萄牙语)

"[AVSpeechSynthesisVoice 0x977a480] Language: sk-SK",(斯洛伐克)

"[AVSpeechSynthesisVoice 0x978ad50] Language: fr-CA",(加拿大-法语)

"[AVSpeechSynthesisVoice 0x978ada0] Language: ro-RO",(罗马尼亚)

"[AVSpeechSynthesisVoice 0x97823f0] Language: no-NO",(挪威)

"[AVSpeechSynthesisVoice 0x978e7b0] Language: fi-FI",(芬兰)

"[AVSpeechSynthesisVoice 0x978af50] Language: pl-PL",(波兰)

"[AVSpeechSynthesisVoice 0x978afa0] Language: de-DE",(德国)

"[AVSpeechSynthesisVoice 0x978e390] Language: nl-NL",(荷兰)

"[AVSpeechSynthesisVoice 0x978b030] Language: id-ID",(印度尼西亚)
"[AVSpeechSynthesisVoice 0x978b080] Language: tr-TR",(土耳其)

"[AVSpeechSynthesisVoice 0x978b0d0] Language: it-IT",(意大利)

"[AVSpeechSynthesisVoice 0x978b120] Language: pt-PT",(葡萄牙)

"[AVSpeechSynthesisVoice 0x978b170] Language: fr-FR",(法国)

"[AVSpeechSynthesisVoice 0x978b1c0] Language: ru-RU",(俄罗斯)

"[AVSpeechSynthesisVoice 0x978b210] Language: es-MX",(墨西哥-西班牙语)

"[AVSpeechSynthesisVoice 0x978b2d0] Language: zh-HK",中文(香港)粤语

"[AVSpeechSynthesisVoice 0x978b320] Language: sv-SE",(瑞典-萨尔瓦多语)

"[AVSpeechSynthesisVoice 0x978b010] Language: hu-HU",(匈牙利)

"[AVSpeechSynthesisVoice 0x978b440] Language: zh-TW",中文(台湾)

"[AVSpeechSynthesisVoice 0x978b490] Language: es-ES",(西班牙)

"[AVSpeechSynthesisVoice 0x978b4e0] Language: zh-CN",中文(普通话)

"[AVSpeechSynthesisVoice 0x978b530] Language: nl-BE",(比利时-荷兰语)

"[AVSpeechSynthesisVoice 0x978b580] Language: en-GB",英语(英国)

"[AVSpeechSynthesisVoice 0x978b5d0] Language: ar-SA",(沙乌地阿拉伯-阿根廷语)

"[AVSpeechSynthesisVoice 0x978b620] Language: ko-KR",(韩国)

"[AVSpeechSynthesisVoice 0x978b670] Language: cs-CZ",(捷克共和国)

"[AVSpeechSynthesisVoice 0x978b6c0] Language: en-ZA",(南非-英语)

"[AVSpeechSynthesisVoice 0x978aed0] Language: en-AU",(澳大利亚-英语)

"[AVSpeechSynthesisVoice 0x978af20] Language: da-DK",(丹麦)

"[AVSpeechSynthesisVoice 0x978b810] Language: en-US",英语(美国)

"[AVSpeechSynthesisVoice 0x978b860] Language: en-IE",(爱尔兰-英语)

"[AVSpeechSynthesisVoice 0x978b8b0] Language: hi-IN",(印度)

"[AVSpeechSynthesisVoice 0x978b900] Language: el-GR",(希腊)

"[AVSpeechSynthesisVoice 0x978b950] Language: ja-JP"(日本)
```

[博客详解](https://www.jianshu.com/p/7fbeaeecab04)
