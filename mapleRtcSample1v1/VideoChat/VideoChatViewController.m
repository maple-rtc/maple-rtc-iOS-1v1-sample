//
//  VideoChatViewController.m
//  maple rtc
//
//  Created by mark on 18/02/05.
//

#import "VideoChatViewController.h"

@interface VideoChatViewController ()

@property (strong, nonatomic) BMediaKit *mBMediaKit;          // Tutorial Step 1
@property (weak, nonatomic) IBOutlet UIView *localVideo;            // Tutorial Step 3
@property (weak, nonatomic) IBOutlet UIView *remoteVideo;           // Tutorial Step 5
@property (weak, nonatomic) IBOutlet UIView *controlButtons;        // Tutorial Step 8
@property (weak, nonatomic) IBOutlet UIImageView *remoteVideoMutedIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *localVideoMutedBg;
@property (weak, nonatomic) IBOutlet UIImageView *localVideoMutedIndicator;

@property (nonatomic, strong) NSString *ownerUid;


@end

@implementation VideoChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupButtons];            // Tutorial Step 8
    [self hideVideoMuted];          // Tutorial Step 10
    [self initializeMapleEngine];   // Tutorial Step 1
    [self setupVideo];              // Tutorial Step 2
    [self joinChannel];             // Tutorial Step 4
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Tutorial Step 1
- (void)initializeMapleEngine {
    self.mBMediaKit = [BMediaKit sharedEngineWithAppId:appID delegate:self];
}

// Tutorial Step 2
- (void)setupVideo {
    //set channel profile is audio and video
    [self.mBMediaKit setChannelProfile:CHANNEL_PROFILE_VOICE_VIDEO];
    //set video conference profile is sfu
    [self.mBMediaKit setVideoConferenceProfile:VIDEO_CONFERENCE_PROFILE_SFU];
    //set media profile
    [self.mBMediaKit setMediaProfile:AUDIO_PROFILE_VOICE_STANDARD withVideo: VIDEO_PROFILE_360P];
}

// Tutorial Step 3
- (void)setupLocalVideo:(NSString*)uid {
    [self.mBMediaKit setupLocalVideo:[[BMVideoCanvas alloc] init:self.localVideo withMode:RENDER_MODE_HIDDEN withUid:uid]];
    [self.mBMediaKit startPreview];
    [self.mBMediaKit muteLocalVideoStream:false];
    // Bind local video stream to view
}

// Tutorial Step 4
- (void)joinChannel {
    [self.mBMediaKit joinChannel:self.roomName];
}

// Tutorial Step 5
- (void)rtcEngine:(BMediaKit *)engine onFirstRemoteVideoFrameSizeChanged:(NSString*)uid size:(CGSize)size
{
    
}

// Tutorial Step 6
- (IBAction)hangUpButton:(UIButton *)sender {
    [self leaveChannel];
}

- (void)leaveChannel {
    [self.mBMediaKit leaveChannel];
}

- (void)rtcEngine:(BMediaKit *)engine onAudioVolumeIndication:(NSDictionary* _Nonnull)volumeInfo totalVolume:(NSInteger)volume
{
    //NSLog(@"transfer audio category ");
}

- (void)rtcEngine:(BMediaKit *)engine onUserJoinedNotice:(NSArray *)uids{
    
    for(id obj in uids){
        
        if([self.ownerUid isEqualToString: obj]){
            return;
        }
        if (self.remoteVideo.hidden)
            self.remoteVideo.hidden = false;
        
        // Bind remote video stream to view
        [self.mBMediaKit setupRemoteVideo:[[BMVideoCanvas alloc] init:self.remoteVideo withMode:RENDER_MODE_HIDDEN withUid:obj]];
        
        [self.mBMediaKit muteRemoteVideoStream:obj mute:NO];
    }
    
}

// Tutorial Step 7
- (void)rtcEngine:(BMediaKit *)engine onUserOfflineNotice:(NSArray *)uids{
    self.remoteVideo.hidden = true;
}

// Tutorial Step 8
- (void)setupButtons {
    [self performSelector:@selector(hideControlButtons) withObject:nil afterDelay:3];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remoteVideoTapped:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    self.view.userInteractionEnabled = true;
}

- (void)hideControlButtons {
    self.controlButtons.hidden = true;
}

- (void)remoteVideoTapped:(UITapGestureRecognizer *)recognizer {
    if (self.controlButtons.hidden) {
        self.controlButtons.hidden = false;
        [self performSelector:@selector(hideControlButtons) withObject:nil afterDelay:3];
    }
}

- (void)resetHideButtonsTimer {
    [VideoChatViewController cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(hideControlButtons) withObject:nil afterDelay:3];
}

// Tutorial Step 9
- (IBAction)didClickMuteButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.mBMediaKit muteLocalAudioStream:sender.selected];
    [self resetHideButtonsTimer];
}

// Tutorial Step 10
- (IBAction)didClickVideoMuteButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.mBMediaKit muteLocalVideoStream:sender.selected];
    self.localVideo.hidden = sender.selected;
    self.localVideoMutedBg.hidden = !sender.selected;
    self.localVideoMutedIndicator.hidden = !sender.selected;
    [self resetHideButtonsTimer];
}

- (void)rtcEngine:(BMediaKit *)engine onJoinChannelSuccess:(NSString*)channelId withUid:(NSString*)uid{
    self.ownerUid = uid;
    [self setupLocalVideo:uid];         // Tutorial Step 3
}

- (void)rtcEngine:(BMediaKit *)engine onLeaveChannel:(MapleRtcLeaveChannelReason)reason{
    [self hideControlButtons];     // Tutorial Step 8
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self.remoteVideo removeFromSuperview];
    [self.localVideo removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(roomVCNeedClose:)]) {
        [self.delegate roomVCNeedClose:self];
    }
}

- (void) hideVideoMuted {
    self.remoteVideoMutedIndicator.hidden = true;
    self.localVideoMutedBg.hidden = true;
    self.localVideoMutedIndicator.hidden = true;
}

// Tutorial Step 11
- (IBAction)didClickSwitchCameraButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.mBMediaKit switchCamera];
    [self resetHideButtonsTimer];
}

@end


