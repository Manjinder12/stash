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
#import "REFrostedViewController.h"
#import "ServerCall.h"
#import "UIImageView+AFNetworking.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import <LGPlusButtonsView/LGPlusButtonsView.h>

@interface ProfileScreen ()<UICollectionViewDelegate,UICollectionViewDataSource,MWPhotoBrowserDelegate,LGPlusButtonsViewDelegate>
{
 
    NSMutableArray *marrPerHeader, *marrPerText, *marrProHeader, *marrProText, *marrDoc, *marrImages;
    NSDictionary *dictPersonal, *dictProfessional, *dictDocument;
    
    BOOL isStashExpand;
    
    LGPlusButtonsView *stashfinButton;
    
    NSArray *personalArr ;
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
@property (weak, nonatomic) IBOutlet UILabel *lblCustomerName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;

@property (weak, nonatomic) IBOutlet UIButton *professionalBtn;
@property (weak, nonatomic) IBOutlet UIButton *personalBtn;
@property (weak, nonatomic) IBOutlet UIButton *docBtn;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (weak, nonatomic) IBOutlet UIView *viewOuter;
@property (weak, nonatomic) IBOutlet UICollectionView *docCollection;

- (IBAction)personalTapped:(id)sender;
- (IBAction)professionalTapped:(id)sender;
- (IBAction)documenttapped:(id)sender;
- (IBAction)backBtnTapped:(id)sender;



@end

@implementation ProfileScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customInitialization];
}
- (void)customInitialization
{
    self.navigationController.navigationBar.hidden = YES;
    
    marrPerText = [[NSMutableArray alloc] init];
    marrProText = [[NSMutableArray alloc] init];
    marrDoc = [[NSMutableArray alloc] init];
    marrImages = [[NSMutableArray alloc] init];

    [_personalBtn setTitle:@"PERSONAL\nDETAIL" forState:UIControlStateNormal];
    [_professionalBtn setTitle:@"PROFESSIONAL\nDETAIL" forState:UIControlStateNormal];
    tab = 0;
    marrPerHeader = [[NSMutableArray alloc]initWithObjects:@"Contact No.",@"Date of Birth",@"PAN No.",@"Aadhar Card No.",@"Current Address",@"Permanent Address", nil];
    personalTextArr = [[NSArray alloc]initWithObjects:@"9876543210",@"17 April 1973",@"BXIPX2014H",@"3181 6734 1296",@"77, jagjivan ram nagar indore-452001",@"Kastubra ward, Pipariya-461775", nil];
    
    marrProHeader = [[NSMutableArray alloc]initWithObjects:@"Comapany Name",@"Designation",@"Employee ID",@"Work Since",@"Office Email",@"Office Landline No.",@"Company Address", nil];
    proTextArr = [[NSArray alloc]initWithObjects:@"6 Degresit Pvt Ltd",@"Sr UI/UX developer",@"6D-UI-0001",@"July 2013",@"Testing@gmail.com",@"0731 -987654321",@"Geeta Bhavan Indore", nil];
    
    [self setupProfileBlurScreen];
    self.profileTableView.estimatedRowHeight = 30.0f;
    self.profileTableView.rowHeight = UITableViewAutomaticDimension;
    
    [self serverCallForPersonalDetail];
    _viewOuter.hidden = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark LGPlusButtonsView
- (void)addStashfinButtonView
{
    stashfinButton = [[LGPlusButtonsView alloc] initWithNumberOfButtons:5 firstButtonIsPlusButton:YES showAfterInit:YES delegate:self];
    
    //stashfinButton = [LGPlusButtonsView plusButtonsViewWithNumberOfButtons:4 firstButtonIsPlusButton:YES showAfterInit:YES delegate:self];
    
    stashfinButton.coverColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    stashfinButton.position = LGPlusButtonsViewPositionBottomRight;
    stashfinButton.plusButtonAnimationType = LGPlusButtonsAppearingAnimationTypeCrossDissolveAndPop;
    stashfinButton.buttonsAppearingAnimationType = LGPlusButtonsAppearingAnimationTypeCrossDissolveAndSlideVertical;
    
    [stashfinButton setDescriptionsTexts:@[@"", @"Lost/Stolan Card", @"Change Pin", @"Reload Card",@"Chat"]];
    
    [stashfinButton setButtonsImages:@[[UIImage imageNamed:@"actionBtn"], [UIImage imageNamed:@"lostCardBtn"], [UIImage imageNamed:@"pinBtn"], [UIImage imageNamed:@"topupcardBtn"] ,[UIImage imageNamed:@"chatBtn"]]
                            forState:UIControlStateNormal
                      forOrientation:LGPlusButtonsViewOrientationAll];
    if ([[self.storyboard valueForKey:@"name"] isEqual:@"iPhone"])
    {
        [stashfinButton setButtonsSize:CGSizeMake(60.f, 60.f) forOrientation:LGPlusButtonsViewOrientationAll];
        [stashfinButton setButtonsLayerCornerRadius:60.f/2.f forOrientation:LGPlusButtonsViewOrientationAll];
        [stashfinButton setDescriptionsFont:[UIFont systemFontOfSize:16] forOrientation:LGPlusButtonsViewOrientationAll];
    }
    else
    {
        [stashfinButton setButtonsSize:CGSizeMake(90.f, 90.f) forOrientation:LGPlusButtonsViewOrientationAll];
        [stashfinButton setButtonsLayerCornerRadius:90.f/2.f forOrientation:LGPlusButtonsViewOrientationAll];
        [stashfinButton setDescriptionsFont:[UIFont systemFontOfSize:26.0] forOrientation:LGPlusButtonsViewOrientationAll];
    }
    
    [stashfinButton setButtonsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
    // [stashfinButton setButtonsLayerShadowColor:[UIColor whiteColor]];
    [stashfinButton setButtonsLayerShadowOpacity:0.5];
    [stashfinButton setButtonsLayerShadowRadius:3.f];
    [stashfinButton setButtonsLayerShadowOffset:CGSizeMake(0.f, 2.f)];
    
    [stashfinButton setDescriptionsTextColor:[UIColor whiteColor]];
    [stashfinButton setDescriptionsLayerShadowColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.f]];
    [stashfinButton setDescriptionsLayerShadowOpacity:0.25];
    [stashfinButton setDescriptionsLayerShadowRadius:1.f];
    [stashfinButton setDescriptionsLayerShadowOffset:CGSizeMake(0.f, 1.f)];
    [stashfinButton setDescriptionsLayerCornerRadius:6.f forOrientation:LGPlusButtonsViewOrientationAll];
    //[stashfinButton setDescriptionsContentEdgeInsets:UIEdgeInsetsMake(4.f, 8.f, 4.f, 8.f) forOrientation:LGPlusButtonsViewOrientationAll];
    [stashfinButton setDescriptionsContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0) forOrientation:LGPlusButtonsViewOrientationAll];
    
    [self.view addSubview:stashfinButton];
}
#pragma mark LGPlusButtonsView Delegate
- (void)plusButtonsViewDidHideButtons:(LGPlusButtonsView *)plusButtonsView
{
    isStashExpand = NO;
}
- (void)plusButtonsView:(LGPlusButtonsView *)plusButtonsView buttonPressedWithTitle:(NSString *)title description:(NSString *)description index:(NSUInteger)index
{
    if (index == 0)
    {
        //        [plusButtonsView hideButtonsAnimated:YES completionHandler:^
        //         {
        //             isStashExpand = NO;
        //         }];
    }
    else if (index == 1)
    {
        // Lost Card
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^{
            
            isStashExpand = NO;
            //            AddInvoiceQuoteVC *addInvoiceQuoteVC = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"AddInvoiceQuoteVC"];
            //            addInvoiceQuoteVC.isInvoice = YES;
            //            [ self.navigationController pushViewController:addInvoiceQuoteVC animated:YES ];
            
        }];
    }
    else if (index == 2)
    {
        // Change Pin
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^{
            
            isStashExpand = NO;
            //            AddNoteVC *addNoteVC = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"AddNoteVC"];
            //            addNoteVC.tempScheduleObject = _tempScheduleObject;
            //            [ self.navigationController pushViewController:addNoteVC animated:YES ];
            
        }];
    }
    else if (index == 3)
    {
        // Reload Card
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^{
            
            isStashExpand = NO;
            
        }];
    }
    else if (index == 4)
    {
        //Apply for new loan
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^{
            
            isStashExpand = NO;
            //            AddInvoiceQuoteVC *addInvoiceQuoteVC = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:@"AddInvoiceQuoteVC"];
            //            addInvoiceQuoteVC.isInvoice = NO;
            //            [ self.navigationController pushViewController:addInvoiceQuoteVC animated:YES ];
            
        }];
    }
    else
    {
        //Chat
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^{
            
            
            
        }];
    }
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tab == 0)
    {
        return [marrPerText count];
    }
    else
    {
        return [marrProText count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ProfileCell";
    
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        [self.profileTableView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }
    if (tab == 0)
    {
        cell.profileHeadinglbl.text = [marrPerHeader objectAtIndex:indexPath.row];
        cell.profileRightlbl.text = [marrPerText objectAtIndex:indexPath.row];
    }
    else if (tab == 1)
    {
        cell.profileHeadinglbl.text = [marrProHeader objectAtIndex:indexPath.row];
        cell.profileRightlbl.text = [marrProText objectAtIndex:indexPath.row];
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark Collectionview Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [marrDoc count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DocCell" forIndexPath:indexPath];
    
    UIImageView *imageView = [cell viewWithTag:100];
  
    [imageView setImageWithURL:[Utilities getFormattedImageURLFromString:[marrDoc objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"pdficon"]];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication] openURL:[Utilities getFormattedImageURLFromString:[marrDoc objectAtIndex:indexPath.row]] options:nil completionHandler:nil];;

//    [self openImageInFullScreenWithIndex:indexPath.row];

}
- (void)openImageInFullScreenWithIndex:(NSInteger)index
{
    MWPhotoBrowser  *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    photoBrowser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
    photoBrowser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    photoBrowser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    photoBrowser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    photoBrowser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    photoBrowser.enableGrid = NO; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    photoBrowser.startOnGrid = NO;
    [photoBrowser setCurrentPhotoIndex:1];
    
    MWPhoto *photo;
    [marrImages removeAllObjects];
    photo = [MWPhoto photoWithURL:[Utilities getFormattedImageURLFromString:[marrDoc objectAtIndex:index]]];
    
    [marrImages addObject:photo];
    if (photo != nil)
    {
        [self.navigationController pushViewController:photoBrowser animated:YES];
    }
    else
    {
        [Utilities showAlertWithMessage:@"Full Screen Image is not available"];
    }
}
#pragma mark MWPhotoBrowser Delegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser;
{
    return [marrImages count];
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;
{
    return [marrImages objectAtIndex:index];
}

- (void)docButtonAction
{
    
}
#pragma mark - Instance Methods
-(void)setupProfileBlurScreen
{

    if (!UIAccessibilityIsReduceTransparencyEnabled())
    {
        self.view.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.profileView.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        blurEffectView.alpha = 0.9f;
        [self.profileView addSubview:blurEffectView];
    }
    else
    {
        self.profileView.backgroundColor = [UIColor blackColor];
    }
    
    self.profilepic.layer.cornerRadius = self.profilepic.frame.size.width/2.0f;
    self.profilepic.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profilepic.layer.borderWidth = 0.5;
    self.profilepic.clipsToBounds = YES;
}

#pragma mark Button Action
- (IBAction)menuAction:(id)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}

- (IBAction)personalTapped:(id)sender
{
    tab =0;
    self.profileTableView.hidden = NO;
    self.docCollection.hidden = YES;

    self.perLbl.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:16.0f/255.0f blue:16.0f/255.0f alpha:1.0f];
    self.personalBtn.titleLabel.textColor = [UIColor colorWithRed:220.0f/255.0f green:16.0f/255.0f blue:16.0f/255.0f alpha:1.0f];
    
    self.proLbl.backgroundColor = [UIColor clearColor];
    self.professionalBtn.titleLabel.textColor = [UIColor darkGrayColor];
    
    self.docLbl.backgroundColor = [UIColor clearColor];
    self.docBtn .titleLabel.textColor = [UIColor darkGrayColor];
    [self.profileTableView reloadData];
}

- (IBAction)professionalTapped:(id)sender
{
    tab =1;
    self.profileTableView.hidden = NO;
    self.docCollection.hidden = YES;

    self.perLbl.backgroundColor = [UIColor clearColor];
    self.personalBtn.titleLabel.textColor = [UIColor darkGrayColor];

    self.proLbl.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:16.0f/255.0f blue:16.0f/255.0f alpha:1.0f];
    self.professionalBtn.titleLabel.textColor = [UIColor colorWithRed:220.0f/255.0f green:16.0f/255.0f blue:16.0f/255.0f alpha:1.0f];
    
    self.docLbl.backgroundColor = [UIColor clearColor];
    self.docBtn .titleLabel.textColor = [UIColor darkGrayColor];
    [self.profileTableView reloadData];
}

- (IBAction)documenttapped:(id)sender
{
    tab = 2;
    self.profileTableView.hidden = YES;
    self.docCollection.hidden = NO;

    [self.docCollection reloadData];
    
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

#pragma mark Server Call Profile Detail
- (void)serverCallForPersonalDetail
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"personalDetails" forKey:@"mode"];
    [ServerCall getServerResponseWithParameters:param withHUD:YES withCompletion:^(id response)
    {
        NSLog(@"response === %@", response);
        
        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSString *errorStr = [response objectForKey:@"error"];
            if ( errorStr.length > 0 )
            {
                [Utilities showAlertWithMessage:errorStr];
            }
            else
            {
                dictPersonal = [NSDictionary dictionaryWithDictionary:response];
                [self serverCallForProfessionalDetail];
                
            }
        }
        else
        {
            [Utilities showAlertWithMessage:response];
        }
        
    }];
}
- (void)serverCallForProfessionalDetail
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"professioanlDetails" forKey:@"mode"];
    [ServerCall getServerResponseWithParameters:param withHUD:YES withCompletion:^(id response)
     {
         NSLog(@"response === %@", response);
         
         if ([response isKindOfClass:[NSDictionary class]])
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [Utilities showAlertWithMessage:errorStr];
             }
             else
             {
                 dictProfessional = [NSDictionary dictionaryWithDictionary:response];
                 [self serverCallForDocumentsDetail];
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
         
     }];
}
- (void)serverCallForDocumentsDetail
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"documentsFormDetails" forKey:@"mode"];
    [ServerCall getServerResponseWithParameters:param withHUD:YES withCompletion:^(id response)
     {
         NSLog(@"response === %@", response);
         
         if ([response isKindOfClass:[NSDictionary class]])
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [Utilities showAlertWithMessage:errorStr];
             }
             else
             {
                 _viewOuter.hidden = YES;
                 
                 [self populatePersonalDetail:dictPersonal];
                 [self populateProfessionalDetail:dictProfessional];
                 [self populateDocumentsDetail:response];
                 
                 [self addStashfinButtonView];
                 isStashExpand = NO;
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
         
     }];
}
- (void)populatePersonalDetail:(NSDictionary *)response
{
    _lblCustomerName.text = response[@"customer_details"][@"customer_name"];
    _lblEmail.text =  response[@"customer_details"][@"email"];
    [marrPerText addObject:response[@"customer_details"][@"phone"]];
    [marrPerText addObject:response[@"customer_details"][@"dob"]];
    [marrPerText addObject:response[@"customer_details"][@"pan_number"]];
    [marrPerText addObject:response[@"customer_details"][@"aadhar_number"]];
    
    NSString *currentAddress = [NSString stringWithFormat:@"%@,%@",response[@"current_address"][@"address"],response[@"current_address"][@"state"]];
   
    NSString *permanentAddress = [NSString stringWithFormat:@"%@,%@",response[@"permanent_address"][@"address"],response[@"permanent_address"][@"state"]];
    
    [marrPerText addObject:currentAddress];
    [marrPerText addObject:permanentAddress];
    
}
- (void)populateProfessionalDetail:(NSDictionary *)response
{
    [marrProText addObject:@"Stashfin"];
    [marrProText addObject:response[@"professional_details"][@"designation"]];
    [marrProText addObject:response[@"professional_details"][@"designationId"]];
    [marrProText addObject:response[@"professional_details"][@"workingSince"]];
    [marrProText addObject:response[@"professional_details"][@"officeEmail"]];
    [marrProText addObject:response[@"professional_details"][@"officeLandLineNo"]];
    
    NSString *officeAddress = [NSString stringWithFormat:@"%@,%@",response[@"office_address"][@"address"],response[@"office_address"][@"city"]];

    [marrProText addObject:officeAddress];
    
    [self.profileTableView reloadData];
}
- (void)populateDocumentsDetail:(NSDictionary *)response
{
    [marrDoc addObject:response[@"docs"][@"address_proof"]];
    [marrDoc addObject:response[@"docs"][@"employee_id"]];
    [marrDoc addObject:response[@"docs"][@"id_proof"]];
    [marrDoc addObject:response[@"docs"][@"office_id"]];
    [marrDoc addObject:response[@"docs"][@"pan_proof"]];
    [marrDoc addObject:response[@"docs"][@"salary_slip1"]];
    [marrDoc addObject:response[@"docs"][@"salary_slip2"]];
    [marrDoc addObject:response[@"docs"][@"salary_slip3"]];
    
    self.profileTableView.hidden = NO;
    self.docCollection.hidden = YES;
    
    [self.profileTableView reloadData];
}
@end
