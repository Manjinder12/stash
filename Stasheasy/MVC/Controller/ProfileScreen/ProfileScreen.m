//
//  ProfileScreen.m
//  Stasheasy
//
//  Created by tushar on 19/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "ProfileScreen.h"
#import "ProfileCell.h"
#import "DashboardScreen.h"

@interface ProfileScreen () {
 
    NSArray *personalArr;
    NSArray *personalTextArr;
    NSArray *professionalArr;
    NSArray *proTextArr;
    int tab;

}
@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIImageView *profilepic;

@property (weak, nonatomic) IBOutlet UILabel *perLbl;
@property (weak, nonatomic) IBOutlet UILabel *proLbl;
@property (weak, nonatomic) IBOutlet UILabel *docLbl;

@property (weak, nonatomic) IBOutlet UIButton *professionalBtn;
@property (weak, nonatomic) IBOutlet UIButton *personalBtn;
@property (weak, nonatomic) IBOutlet UIButton *docBtn;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;

- (IBAction)personalTapped:(id)sender;
- (IBAction)professionalTapped:(id)sender;
- (IBAction)documenttapped:(id)sender;
- (IBAction)backBtnTapped:(id)sender;



@end

@implementation ProfileScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tab =0;
    personalArr = [[NSArray alloc]initWithObjects:@"Contact No.",@"Date of Birth",@"PAN No.",@"Aadhar Card No.",@"Current Address",@"Permanent Address", nil];
    personalTextArr = [[NSArray alloc]initWithObjects:@"9876543210",@"17 April 1973",@"BXIPX2014H",@"3181 6734 1296",@"77, jagjivan ram nagar indore-452001",@"Kastubra ward, Pipariya-461775", nil];
    
    professionalArr = [[NSArray alloc]initWithObjects:@"Comapany Name",@"Designation",@"Employee ID",@"Work Since",@"Office Email",@"Office Landline No.",@"Company Address", nil];
    proTextArr = [[NSArray alloc]initWithObjects:@"6 Degresit Pvt Ltd",@"Sr UI/UX developer",@"6D-UI-0001",@"July 2013",@"Testing@gmail.com",@"0731 -987654321",@"Geeta Bhavan Indore", nil];

    [self setupProfileBlurScreen];
    self.profileTableView.estimatedRowHeight = 50.0f;
    self.profileTableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ProfileCell";
    
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        [self.profileTableView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }
    if (tab ==0) {
        cell.profileHeadinglbl.text = [personalArr objectAtIndex:indexPath.row];
        cell.profileRightlbl.text = [personalTextArr objectAtIndex:indexPath.row];
    }
    else if (tab ==1) {
        cell.profileHeadinglbl.text = [professionalArr objectAtIndex:indexPath.row];
        cell.profileRightlbl.text = [proTextArr objectAtIndex:indexPath.row];
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark - Instance Methods

-(void)setupProfileBlurScreen {

    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.view.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.profileView.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        blurEffectView.alpha = 0.9f;
        [self.profileView addSubview:blurEffectView];
    } else {
        self.profileView.backgroundColor = [UIColor blackColor];
    }
    
    self.profilepic.layer.cornerRadius = self.profilepic.frame.size.width/2.0f;
    self.profilepic.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profilepic.layer.borderWidth = 5.0f;
    self.profilepic.clipsToBounds = YES;
}

#pragma mark - IBAction Methods

- (IBAction)personalTapped:(id)sender {
    tab =0;
    self.profileTableView.hidden =NO;

    self.perLbl.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:16.0f/255.0f blue:16.0f/255.0f alpha:1.0f];
    self.personalBtn.titleLabel.textColor = [UIColor colorWithRed:220.0f/255.0f green:16.0f/255.0f blue:16.0f/255.0f alpha:1.0f];
    
    self.proLbl.backgroundColor = [UIColor clearColor];
    self.professionalBtn.titleLabel.textColor = [UIColor darkGrayColor];
    
    self.docLbl.backgroundColor = [UIColor clearColor];
    self.docBtn .titleLabel.textColor = [UIColor darkGrayColor];
    [self.profileTableView reloadData];
}

- (IBAction)professionalTapped:(id)sender {
    tab =1;
    self.profileTableView.hidden =NO;

    self.perLbl.backgroundColor = [UIColor clearColor];
    self.personalBtn.titleLabel.textColor = [UIColor darkGrayColor];

    self.proLbl.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:16.0f/255.0f blue:16.0f/255.0f alpha:1.0f];
    self.professionalBtn.titleLabel.textColor = [UIColor colorWithRed:220.0f/255.0f green:16.0f/255.0f blue:16.0f/255.0f alpha:1.0f];
    
    self.docLbl.backgroundColor = [UIColor clearColor];
    self.docBtn .titleLabel.textColor = [UIColor darkGrayColor];
    [self.profileTableView reloadData];
}

- (IBAction)documenttapped:(id)sender {
    self.profileTableView.hidden =YES;
    self.perLbl.backgroundColor = [UIColor clearColor];
    self.personalBtn.titleLabel.textColor = [UIColor darkGrayColor];
    
    self.proLbl.backgroundColor = [UIColor clearColor];
    self.professionalBtn.titleLabel.textColor = [UIColor darkGrayColor];
    
    self.docLbl.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:16.0f/255.0f blue:16.0f/255.0f alpha:1.0f];
    self.docBtn .titleLabel.textColor = [UIColor colorWithRed:220.0f/255.0f green:16.0f/255.0f blue:16.0f/255.0f alpha:1.0f];
    [self.profileTableView reloadData];
}

- (IBAction)backBtnTapped:(id)sender {
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    [self.frostedViewController setContentViewController:vc];
    [self.frostedViewController hideMenuViewController];

}
@end
