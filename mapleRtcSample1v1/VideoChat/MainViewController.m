//
//  MainViewController.m
//  maple rtc
//
//  Created by mark on 18/02/05.
//

#import "MainViewController.h"
#import "VideoChatViewController.h"

@interface MainViewController () <UITextFieldDelegate, RoomVCDelegate>
@property (weak, nonatomic) IBOutlet UITextField *roomNameTextField;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueId = segue.identifier;
    
    if ([segueId isEqualToString:@"mainToRoom"]) {
        VideoChatViewController *roomVC = segue.destinationViewController;
        roomVC.roomName = sender;
        roomVC.delegate = self;
    }
}

- (IBAction)doJoinPressed:(UIButton *)sender {
    [self enterRoom];
}

- (void)enterRoom {
    if (!self.roomNameTextField.text.length) {
        return;
    }
    
    [self performSegueWithIdentifier:@"mainToRoom" sender:self.roomNameTextField.text];
}

//MARK: - delegates

- (void)roomVCNeedClose:(VideoChatViewController *)roomVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self enterRoom];
    return YES;
}
@end
