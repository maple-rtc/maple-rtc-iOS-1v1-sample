//
//  VideoChatViewController.h
//  maple rtc
//
//  Created by mark on 18/02/05.
//

#import <UIKit/UIKit.h>
#import <MapleKit/BMediaKit.h>
#import "AppID.h"


@class VideoChatViewController;
@protocol RoomVCDelegate <NSObject>
- (void)roomVCNeedClose:(VideoChatViewController *)roomVC;
@end

@interface VideoChatViewController : UIViewController <BMediaDelegate>

@property (copy, nonatomic) NSString *roomName;
@property (weak, nonatomic) id<RoomVCDelegate> delegate;

@end

