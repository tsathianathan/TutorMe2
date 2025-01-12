//
//  ScoreViewController.m
//  TutorME
//
//  Created by Jimmy Lin on 2016-04-04.
//

#import "ScoreViewController.h"
#import "ScoreTableViewCell.h"

@interface ScoreViewController ()
@property (strong, nonatomic) Firebase *ref;
@property (strong, nonatomic) Firebase *uref;
@end

@implementation ScoreViewController
@synthesize nameList, schoolList, scoreList, scoreTableView;

// All Initialization are added in this method.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scoreTableView.dataSource = self;
    self.scoreTableView.delegate = self;

    // Initialize Firebase reference
    self.ref = [[Firebase alloc] initWithUrl:@"https://burning-heat-7302.firebaseio.com/"];
    self.uref = [self.ref childByAppendingPath:@"users"];
}

// This method is used to retriveve user data from the database. The data is displayed in a UILabel so that
// the user can view all the users.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.nameList = [[NSMutableArray alloc] init];
    self.schoolList = [[NSMutableArray alloc] init];
    self.scoreList = [[NSMutableArray alloc] init];
    
    
    // Retrieve user full name, school, and score from the database ordered by ascending score
    [[self.uref queryOrderedByChild:@"score"] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        
        NSString *fullName = [snapshot.value[@"last_name"] stringByAppendingFormat:@", %@", snapshot.value[@"first_name"]];
        // Save in array so score is in descending order
        [self.nameList insertObject:fullName atIndex:0];
        [self.schoolList insertObject:snapshot.value[@"school"] atIndex:0];
        [self.scoreList insertObject:[snapshot.value[@"score"] stringValue] atIndex:0];
        [self.scoreTableView reloadData];
    }];
}

// Determine the number of required for the UITableView.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.nameList count];
}

// Set a custom heigh for the UITableView cell.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

// Add data from the array into the cell.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"cell";
    
    ScoreTableViewCell *cell = (ScoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[ScoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    NSInteger row = indexPath.row;
    cell.nameLbl.text = [self.nameList objectAtIndex:row];
    cell.schoolLbl.text = [self.schoolList objectAtIndex:row];
    cell.scoreLbl.text = [self.scoreList objectAtIndex:row];
    
    return cell;
}

// This method allows the user to logout of the app. It will kill the session with Firebase.
- (IBAction)logout:(id)sender {
    // Firebase logout
    [self.ref unauth];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *loginTBC = [sb instantiateViewControllerWithIdentifier:@"loginTBC"];
    [loginTBC setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:loginTBC animated:YES completion:nil];
}


@end
