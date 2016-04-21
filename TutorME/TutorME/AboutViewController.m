//
//  AboutViewController.m
//  TutorME
//
//  Created by Kumaran Sathianathan on 2016-04-03.
//  Copyright © 2016 Kumaran Sathianathan. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (strong, nonatomic) Firebase *ref;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize Firebase reference
    self.ref = [[Firebase alloc] initWithUrl:@"https://burning-heat-7302.firebaseio.com/"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    // Firebase logout
    [self.ref unauth];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *loginTBC = [sb instantiateViewControllerWithIdentifier:@"loginTBC"];
    [loginTBC setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:loginTBC animated:YES completion:nil];
}

@end
