//
//  HomeViewController.m
//  TutorME
//
//  Created by kmayo on 2016-04-04.
//  Copyright © 2016 kmayo. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"

@interface HomeViewController ()
@property (strong, nonatomic) Firebase *ref;
@property (strong, nonatomic) Firebase *qref;
@property (strong, nonatomic) Firebase *uref;
@property FirebaseHandle qhandle;
@end

@implementation HomeViewController
@synthesize qidList, descList, nameList, dateList, homeTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize Firebase reference
    self.ref = [[Firebase alloc] initWithUrl:@"https://burning-heat-7302.firebaseio.com/"];
    self.qref = [self.ref childByAppendingPath:@"questions"];
    self.uref = [self.ref childByAppendingPath:@"users"];
    
    // Initialize arrays
    self.qidList = [[NSMutableArray alloc] init];
    self.descList = [[NSMutableArray alloc] init];
    self.nameList = [[NSMutableArray alloc] init];
    self.dateList = [[NSMutableArray alloc] init];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.qidList removeAllObjects];
    [self.descList removeAllObjects];
    [self.nameList removeAllObjects];
    [self.dateList removeAllObjects];

    [self.qref removeObserverWithHandle:self.qhandle];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.qhandle = [[self.qref queryOrderedByKey] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *qsnapshot) {
                
        // Save in array so submission date is in descending order
        if (qsnapshot.value != [NSNull null]) {
            [self.qidList insertObject:qsnapshot.key atIndex:0];
            [self.descList insertObject:qsnapshot.value[@"description"] atIndex:0];
            [self.nameList insertObject:qsnapshot.value[@"submitted_by_name"] atIndex:0];
            [self.dateList insertObject:qsnapshot.value[@"submission_date"] atIndex:0];
        }
        
        [self.homeTableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [qidList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"cell";
    
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSInteger row = indexPath.row;
    cell.descLbl.text = [self.descList objectAtIndex:row];
    cell.nameLbl.text = [@"Submitted by: " stringByAppendingString:[self.nameList objectAtIndex:row]];
    cell.dateLbl.text = [@"Date Submitted: " stringByAppendingString:[self.dateList objectAtIndex:row]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Go to Question screen (UINavigationController)
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *questionNC = [sb instantiateViewControllerWithIdentifier:@"questionNC"];
    
    // Pass the qid to the Question View Controller
    QuestionViewController *questionVC = (QuestionViewController *)[questionNC topViewController];
    questionVC.qid = [self.qidList objectAtIndex:indexPath.row];
    
    [questionNC setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:questionNC animated:YES completion:nil];
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
