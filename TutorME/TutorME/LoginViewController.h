//
//  LoginViewController.h
//  TutorME
//
//  Created by Kumaran Sathianathan on 2016-04-03.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import "Login.h"

@interface LoginViewController : UITableViewController <UITextFieldDelegate>
{
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *passwordField;
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UIButton *signInBtn;
    Login *login;
}

@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UIButton *signInBtn;
@property (strong, nonatomic) Login *login;

@end
