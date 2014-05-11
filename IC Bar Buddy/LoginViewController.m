//
//  LoginViewController.m
//  IC Bar Buddy
//
//  Created by Charles Okpala on 4/2/14.
//  Copyright (c) 2014 Charles Okpala. All rights reserved.
//

#import "LoginViewController.h"
#import "BarsListViewController.h"
#import "CurrentUser.h"
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) CurrentUser *curUser;

@end

@implementation LoginViewController


- (CurrentUser *) curUser {
	if (!_curUser){
		_curUser = [[CurrentUser alloc] init];
        self.curUser = [CurrentUser sharedInstance];
        
    }
	return _curUser;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.enterAppButton.layer.cornerRadius = 10;
    self.enterAppButton.clipsToBounds = YES;
    
    [FBProfilePictureView class];
    // Do any additional setup after loading the view.
    self.enterAppButton.hidden = true;
    // Custom initialization
   
    // Create a FBLoginView to log the user in with basic, email and likes permissions
    // You should ALWAYS ask for basic permissions (basic_info) when logging the user in
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.readPermissions = @[@"basic_info", @"email", @"user_likes", @"user_friends"];
    
    // Set this loginUIViewController to be the loginView button's delegate
    loginView.delegate = self;
    
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame,(self.view.center.x - (loginView.frame.size.width / 2)),270  );
    
    
    // Add the button to the view
    [self.view addSubview:loginView];
    
   /*
    */
    
    
}


- (void) myThreadMainMethod: (FBLoginView *)loginView{

    PFQuery *query1 = [PFQuery queryWithClassName:@"Users"];
    [query1 whereKey:@"FacebookID" equalTo: self.userID];
    
    if ([query1 countObjects] == 0){
        PFObject *usersDatabase = [PFObject objectWithClassName:@"Users"];
        usersDatabase[@"FacebookID"] = self.userID;
        usersDatabase[@"Name"] = self.userName;
        usersDatabase[@"CurrentBar"] = @"NA";
        usersDatabase[@"TimeCheckedIn"] = @"NA";
        [usersDatabase saveInBackground];
        //self.curUser.userDatabaseID = [usersDatabase objectId];
        
    }
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.curUser.usersInfo = objects;
            for (PFObject *item in objects){
                if([item[@"FacebookID"] isEqualToString:self.userID]){
                    self.curUser.userDatabaseID = [item objectId];
                    self.curUser.currentBar = item[@"CurrentBar"];
                    self.curUser.favoriteBars = item[@"Favorites"];
                    self.curUser.userBarActivity = [[item[@"BarActivity"] reverseObjectEnumerator] allObjects];
                    //NSLog(@"%@", self.curUser.userDatabaseID);
                    break;
                }
            }
        }
    }];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Bars"];
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"Number_Checked_in" ascending:true] ;
            self.curUser.barObject = [[[objects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]] reverseObjectEnumerator]  allObjects];
            
        }
    }];
    
}



// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
   
    self.profilePictureView.profileID = user.id;
    self.nameLabel.text = user.name;
    self.enterAppButton.hidden = false;
    self.curUser.user = user.name;
    self.curUser.profilePictureView = user.id;
    self.userID = user.id;
    self.userName = user.name;
    NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(myThreadMainMethod:)
                                                   object:nil];
    [myThread start];
}
// Implement the loginViewShowingLoggedInUser: delegate method to modify your app's UI for a logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    self.statusLabel.text = @"You're logged in as";
}

// Implement the loginViewShowingLoggedOutUser: delegate method to modify your app's UI for a logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePictureView.profileID = nil;
    self.nameLabel.text = @"";
    self.statusLabel.text= @"You're not logged in!";
    self.enterAppButton.hidden = true;
    
    //NSLog(@"You're not logged in!");
}

// You need to override loginView:handleError in order to handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) showFriends:(NSArray *)friendData
{
    self.curUser.userFriends = friendData;
    
    for(NSDictionary *item in self.curUser.usersInfo){
        //NSLog(@"%@", item[@"FacebookID"]);
        if ([self.curUser.profilePictureView isEqualToString: item[@"FacebookID"]]){
            self.curUser.userBarActivity = [[item[@"BarActivity"] reverseObjectEnumerator] allObjects];
            break;
        }
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /*
    NSString *query =
    @"SELECT uid, name, pic_square FROM user WHERE uid IN "
    @"(SELECT uid2 FROM friend WHERE uid1 = me() LIMIT 25)";
     */
    NSString *query = [NSString stringWithFormat:@"SELECT name,uid, pic_small, pic_square FROM user WHERE is_app_user = 1 AND uid IN (SELECT uid2 FROM friend WHERE uid1 = %@) order by concat(first_name,last_name) asc", self.curUser.profilePictureView];
    // Set up the query parameter
    NSDictionary *queryParam = @{ @"q": query };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (error) {
                                  NSLog(@"Error: %@", [error localizedDescription]);
                              } else {
                                  //NSLog(@"Result: %@", result);
                                  // Get the friend data to display
                                  NSArray *friendInfo = (NSArray *) result[@"data"];
                                  // Show the friend details display
                                  [self showFriends:friendInfo];
                              }
                          }];
    


}

@end