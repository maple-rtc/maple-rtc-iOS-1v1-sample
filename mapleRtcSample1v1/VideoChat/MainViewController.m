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
    [self testHttp];
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

-(void)testHttp
{
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];//此处修改为自己公司的服务器地址
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"%@",dict);
        }
    }];
    
    [dataTask resume];
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
