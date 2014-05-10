//
//  BarsListViewController.m
//  IC Bar Buddy
//
//  Created by Charles Okpala on 3/26/14.
//  Copyright (c) 2014 Charles Okpala. All rights reserved.
//

#import "BarsListViewController.h"
#import "BarInfoViewController.h"
#import "Bar.h"
#import <Parse/Parse.h>
#import "CurrentUser.h"

@interface BarsListViewController ()
@property (strong, nonatomic) CurrentUser *curUser;
@end

@implementation BarsListViewController

- (CurrentUser *) curUser {
	if (!_curUser){
		_curUser = [[CurrentUser alloc] init];
        self.curUser = [CurrentUser sharedInstance];
        
    }
	return _curUser;
}

- (id)initWithCoder:(NSCoder *)aCoder

{
	self = [super initWithCoder:aCoder];
	if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Bars";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"Name";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 50;
    }
    return self;
}

#pragma mark - View lifecycle
-(void) callAfterTenSeconds:(NSTimer*)t
{
    [self loadObjects];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    
    [NSTimer scheduledTimerWithTimeInterval: 10.0 target: self
                                   selector: @selector(callAfterTenSeconds:) userInfo: nil repeats: YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //NSLog(@"viewDidAppear called");
    [self loadObjects];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    //want to find a way to order by number_checked_in and then by bar name
    [query orderByDescending:@"Number_Checked_in"];
    
    return query;
}



// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"barCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    UILabel *barNameLabel = (UILabel*) [cell viewWithTag:101];
    barNameLabel.text = [object objectForKey:@"Name"];
    
    UILabel *numCheckedInLabel = (UILabel*) [cell viewWithTag:102];
    numCheckedInLabel.text = [NSString stringWithFormat:@"%@", [object objectForKey:@"Number_Checked_in"]];
    
    return cell;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showBarInfo"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        BarInfoViewController *destViewController = segue.destinationViewController;
        
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        Bar *bar = [[Bar alloc] init];
        bar.barID = [object objectId];
       
        bar.barName = [object objectForKey:@"Name"];
        bar.barHours = [object objectForKey:@"Hours"];
        bar.barPhone = [object objectForKey:@"Phone"];
        bar.barAddress = [object objectForKey:@"Address"];
        bar.barImage = [object objectForKey:@"imageFile"];
        
        bar.NumberCheckedIn = [object objectForKey:@"Number_Checked_in"];
        //bar.barObject = self.objects;
        //NSLog(@"barID - %@", bar.barID);
        destViewController.bar = bar;
               

        
    }
}

@end