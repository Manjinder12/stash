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
#import "DocumentUploadVC.h"

@interface ProfileScreen ()<UICollectionViewDelegate,UICollectionViewDataSource,MWPhotoBrowserDelegate,LGPlusButtonsViewDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate, UIAlertViewDelegate>
{
    AppDelegate *appDelegate;
    UIImagePickerController *imagePicker;
    UIImage *selectedImage;
 
    NSMutableArray *marrPerHeader, *marrPerText, *marrProHeader, *marrProText, *marrDoc, *marrImages, *marrDocTitle;
    NSDictionary *dictPersonal, *dictProfessional, *dictDocument;
    
    BOOL isImageChange,isStashExpand;
    
    LGPlusButtonsView *stashfinButton;
    
    NSArray *personalArr ;
    NSArray *personalTextArr;
    NSArray *professionalArr;
    NSArray *proTextArr;
    int tab;

}
@property (weak, nonatomic) IBOutlet UIView *profileView;
@property (weak, nonatomic) IBOutlet UIImageView *profilepic;
@property (weak, nonatomic) IBOutlet UIImageView *imageBanner;

@property (weak, nonatomic) IBOutlet UITextField *txtOld;
@property (weak, nonatomic) IBOutlet UITextField *txtNew;
@property (weak, nonatomic) IBOutlet UITextField *txtRetype;


@property (weak, nonatomic) IBOutlet UILabel *perLbl;
@property (weak, nonatomic) IBOutlet UILabel *proLbl;
@property (weak, nonatomic) IBOutlet UILabel *docLbl;
@property (weak, nonatomic) IBOutlet UILabel *lblCustomerName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;

@property (weak, nonatomic) IBOutlet UIButton *professionalBtn;
@property (weak, nonatomic) IBOutlet UIButton *personalBtn;
@property (weak, nonatomic) IBOutlet UIButton *docBtn;
@property (weak, nonatomic) IBOutlet UIButton *btnPicture;
@property (weak, nonatomic) IBOutlet UIButton *btnPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnUpload;

@property (weak, nonatomic) IBOutlet UITableView *profileTableView;

@property (weak, nonatomic) IBOutlet UIView *viewOuter;
@property (weak, nonatomic) IBOutlet UIView *viewPopup;


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
   
    appDelegate = [ AppDelegate sharedDelegate ];
    _viewPopup.hidden = YES;
    imagePicker = [[UIImagePickerController alloc] init];
   
    isImageChange = NO;
    
    [ Utilities setBorderAndColor:_btnPicture ];
    [ Utilities setBorderAndColor:_btnUpload ];
    [ Utilities setBorderAndColor:_btnPassword ];
    
    marrPerText = [[NSMutableArray alloc] init];
    marrProText = [[NSMutableArray alloc] init];
    marrImages = [[NSMutableArray alloc] init];

    [_personalBtn setTitle:@"PERSONAL\nDETAIL" forState:UIControlStateNormal];
    [_professionalBtn setTitle:@"PROFESSIONAL\nDETAIL" forState:UIControlStateNormal];
    
    
    marrPerHeader = [[NSMutableArray alloc]initWithObjects:@"Contact No.",@"Date of Birth",@"PAN No.",@"Aadhar Card No.",@"Current Address",@"Permanent Address", nil];
    personalTextArr = [[NSArray alloc]initWithObjects:@"9876543210",@"17 April 1973",@"BXIPX2014H",@"3181 6734 1296",@"77, jagjivan ram nagar indore-452001",@"Kastubra ward, Pipariya-461775", nil];
    
    marrProHeader = [[NSMutableArray alloc]initWithObjects:@"Comapany Name",@"Designation",@"Employee ID",@"Work Since",@"Office Email",@"Office Landline No.",@"Company Address", nil];
    proTextArr = [[NSArray alloc]initWithObjects:@"6 Degresit Pvt Ltd",@"Sr UI/UX developer",@"6D-UI-0001",@"July 2013",@"Testing@gmail.com",@"0731 -987654321",@"Geeta Bhavan Indore", nil];
    
//    marrDocTitle = [[ NSMutableArray alloc ] initWithObjects:@"PAN Card",@"ID Proof",@"Address Proof",@"Employee ID",@"Salary Slip1",@"Salary Slip2",@"Salary Slip3",@"Office ID", nil];
    
    [self setupProfileBlurScreen:appDelegate.dictCustomer[@"profile_pic"]];
    self.profileTableView.estimatedRowHeight = 30.0f;
    self.profileTableView.rowHeight = UITableViewAutomaticDimension;
    
    _viewOuter.hidden = NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    tab = 0;
    marrDocTitle = [[ NSMutableArray alloc ] initWithObjects:@"PAN Card",@"ID Proof",@"Address Proof",@"Employee ID",@"Salary Slip1",@"Salary Slip2",@"Salary Slip3",@"Office ID",nil];
    marrDoc = [[NSMutableArray alloc] init];

    self.profileTableView.hidden = NO;
    self.docCollection.hidden = YES;
    self.btnUpload.hidden = YES;
    [ self actionForTap ];
    [self serverCallForPersonalDetail];
}
#pragma mark UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    selectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self serverCallForUpdateProfile];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark LGPlusButtonsView
- (void)addStashFinButtonView
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
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^
         {
             isStashExpand = NO;
             [self navigateToViewControllerWithIdentifier:@"LostStolenVC"];
         }];
    }
    else if (index == 2)
    {
        // Reload Card
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^
         {
             isStashExpand = NO;
             [self navigateToViewControllerWithIdentifier:@"ChangePinVC"];
         }];
    }
    else if (index == 3)
    {
        // Change Pin
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^{
            
            isStashExpand = NO;
            [self navigateToViewControllerWithIdentifier:@"ReloadCardVC"];
        }];
    }
    else
    {
        //Chat
        [plusButtonsView hideButtonsAnimated:YES completionHandler:^
         {
             isStashExpand = NO;
             [self navigateToViewControllerWithIdentifier:@"ChatScreen"];
         }];
    }
}
- (void)navigateToViewControllerWithIdentifier:(NSString *)identifier
{
    UIViewController *vc = [[Utilities getStoryBoard] instantiateViewControllerWithIdentifier:identifier];
    [self.navigationController pushViewController:vc animated:YES];
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
        cell.profileRightlbl.text = [ Utilities getStringFromResponse:[marrPerText objectAtIndex:indexPath.row]];
    }
    else if (tab == 1)
    {
        cell.profileHeadinglbl.text = [marrProHeader objectAtIndex:indexPath.row];
        cell.profileRightlbl.text = [ Utilities getStringFromResponse:[marrProText objectAtIndex:indexPath.row] ];
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
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    UILabel *lblTitle = (UILabel *)[cell viewWithTag:101];
    
    NSString *docPath = [marrDoc objectAtIndex:indexPath.row];
    
    if ( docPath.length > 0 )
    {
        [imageView setImageWithURL:[Utilities getFormattedImageURLFromString:[marrDoc objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"pdficon"]];
        
        lblTitle.text = [ marrDocTitle objectAtIndex: indexPath.row];
    }
    
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
- (UIImage *)blurredImageWithImage:(UIImage *)sourceImage
{
    
    //  Create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    //  Setting up Gaussian Blur
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    /*  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
     up exactly to the bounds of our original image */
    
     CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
     
     UIImage *retVal = [UIImage imageWithCGImage:cgImage];
     return retVal;
}
-(void)setupProfileBlurScreen:(NSString *)url
{
    self.profilepic.layer.cornerRadius = self.profilepic.frame.size.width/2.0f;
    self.profilepic.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profilepic.layer.borderWidth = 0.5;
    self.profilepic.clipsToBounds = YES;
    self.profilepic.image = [UIImage imageNamed:@""];
    
    [self.profilepic setImageWithURL:[Utilities getFormattedImageURLFromString:[NSString stringWithFormat:@"%@",url]] placeholderImage:[UIImage imageNamed:@"profile"]];
    
    if ( !isImageChange )
    {
        _imageBanner.image = [ self blurredImageWithImage:self.profilepic.image];
    }
    else
    {
        _imageBanner.image = [ self blurredImageWithImage:selectedImage];
    }

}

#pragma mark Button Action
- (IBAction)menuAction:(id)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}
- (IBAction)changePictureAction:(id)sender
{
    UIActionSheet *imagePop = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose From Library", nil];
    [imagePop showInView:self.view];
}
- (IBAction)personalTapped:(id)sender
{
    [ self actionForTap ];
}
- (void)actionForTap
{
    tab =0;
    self.profileTableView.hidden = NO;
    self.docCollection.hidden = YES;
    self.btnUpload.hidden = YES;
    
    
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
    tab = 1;
    self.profileTableView.hidden = NO;
    self.docCollection.hidden = YES;
    self.btnUpload.hidden = YES;

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
    self.btnUpload.hidden = NO;


    [self.docCollection reloadData];
    
    self.perLbl.backgroundColor = [UIColor clearColor];
    self.personalBtn.titleLabel.textColor = [UIColor darkGrayColor];
    
    self.proLbl.backgroundColor = [UIColor clearColor];
    self.professionalBtn.titleLabel.textColor = [UIColor darkGrayColor];
    
    self.docLbl.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:16.0f/255.0f blue:16.0f/255.0f alpha:1.0f];
    self.docBtn .titleLabel.textColor = [UIColor colorWithRed:220.0f/255.0f green:16.0f/255.0f blue:16.0f/255.0f alpha:1.0f];
    [self.profileTableView reloadData];
}

- (IBAction)backBtnTapped:(id)sender
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    [self.frostedViewController setContentViewController:vc];
    [self.frostedViewController hideMenuViewController];

}
- (IBAction)uploadDocumentAction:(id)sender
{
    DocumentUploadVC *docVC = [ self.storyboard instantiateViewControllerWithIdentifier:@"DocumentUploadVC" ];
    [self.navigationController pushViewController:docVC animated:YES];
}
- (IBAction)changePasswordAction:(id)sender
{
    if ( _txtOld.text.length == 0 )
    {
        [ Utilities showAlertWithMessage:@"Enter old password." ];
    }
    else if ( _txtNew.text.length == 0 )
    {
        [ Utilities showAlertWithMessage:@"Enter new password." ];
    }
    else if ( _txtRetype.text.length == 0 )
    {
        [ Utilities showAlertWithMessage:@"Retype password." ];
    }
    else if ( _txtNew.text != _txtRetype.text )
    {
        [ Utilities showAlertWithMessage:@"Password does not match!" ];
    }
    else
    {
        [ self.view endEditing:YES ];
        [ self serverCallForChangePassword ];
    }
}
- (IBAction)popupAction:(id)sender
{
    _txtOld.text = @"";
    _txtNew.text = @"";
    _txtRetype.text = @"";
    
    [ self showPopupView:_viewPopup onViewController:self ];
}
#pragma mark Server Call
- (void)serverCallForPersonalDetail
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"personalDetails" forKey:@"mode"];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
    [ServerCall getServerResponseWithParameters:param withHUD:NO withCompletion:^(id response)
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
            }
        }
        else
        {
            [Utilities showAlertWithMessage:response];
            [SVProgressHUD dismiss];
        }
        [self serverCallForProfessionalDetail];
    }];
}
- (void)serverCallForProfessionalDetail
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"professioanlDetails" forKey:@"mode"];
   
    [ServerCall getServerResponseWithParameters:param withHUD:NO withCompletion:^(id response)
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
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
             [SVProgressHUD dismiss];
         }
         
         [self serverCallForDocumentsDetail];
         
     }];
}
- (void)serverCallForDocumentsDetail
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"documentsFormDetails" forKey:@"mode"];
    
    [ServerCall getServerResponseWithParameters:param withHUD:NO withCompletion:^(id response)
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
                 
//                 [self addStashFinButtonView];
                 isStashExpand = NO;
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
         
         [SVProgressHUD dismiss];
     }];
}
- (void)populatePersonalDetail:(NSDictionary *)response
{
    _lblCustomerName.text = response[@"customer_details"][@"customer_name"];
    [ marrPerText removeAllObjects ];
    _lblEmail.text = [ Utilities getStringFromResponse:response[@"customer_details"][@"email"] ];
    [ Utilities getStringFromResponse:response[@"customer_details"][@"phone"] ];

    [marrPerText addObject:[ Utilities getStringFromResponse:response[@"customer_details"][@"phone"]]];
    
    [marrPerText addObject:[ Utilities getStringFromResponse:response[@"customer_details"][@"dob"]]];
    [marrPerText addObject:[ Utilities getStringFromResponse:response[@"customer_details"][@"pan_number"]]];
    [marrPerText addObject:[ Utilities getStringFromResponse:response[@"customer_details"][@"aadhar_number"]]];
    
    NSString *currentAddress = [NSString stringWithFormat:@"%@,%@",response[@"current_address"][@"address"],response[@"current_address"][@"state"]];
   
    NSString *permanentAddress = [NSString stringWithFormat:@"%@,%@",response[@"permanent_address"][@"address"],response[@"permanent_address"][@"state"]];
    
    [marrPerText addObject:[ Utilities getStringFromResponse:currentAddress]];
    [marrPerText addObject:[ Utilities getStringFromResponse:permanentAddress]];
    
}
- (void)populateProfessionalDetail:(NSDictionary *)response
{
    [ marrProText removeAllObjects ];
    [marrProText addObject:@"StashFin"];
    
    if ([response[@"professional_details"][@"designation"] isKindOfClass:[NSNull class]])
    {
        [marrProText addObject:@""];
    }
    else
    {
        [marrProText addObject:response[@"professional_details"][@"designation"]];
    }
    
    if ([response[@"professional_details"][@"designationId"] isKindOfClass:[NSNull class]])
    {
        [marrProText addObject:@""];
    }
    else
    {
        [marrProText addObject:response[@"professional_details"][@"designationId"]];
    }
    
    if ([response[@"professional_details"][@"workingSince"] isKindOfClass:[NSNull class]])
    {
        [marrProText addObject:@""];
    }
    else
    {
        [marrProText addObject:response[@"professional_details"][@"workingSince"]];
    }

    if ([response[@"professional_details"][@"officeEmail"] isKindOfClass:[NSNull class]])
    {
        [marrProText addObject:@""];
    }
    else
    {
        [marrProText addObject:response[@"professional_details"][@"officeEmail"]];
    }
    
    if ([response[@"professional_details"][@"officeLandLineNo"] isKindOfClass:[NSNull class]])
    {
        [marrProText addObject:@""];
    }
    else
    {
        [marrProText addObject:response[@"professional_details"][@"officeLandLineNo"]];
    }

    
    NSString *officeAddress = [NSString stringWithFormat:@"%@,%@",response[@"office_address"][@"address"],response[@"office_address"][@"city"]];

    [marrProText addObject:officeAddress];
    
    [self.profileTableView reloadData];
}
- (void)populateDocumentsDetail:(NSDictionary *)response
{
    [ marrDoc removeAllObjects ];
    [ marrDocTitle removeAllObjects ];
    NSDictionary *dict = response[@"docs"];
    for ( id key in dict)
    {
        if ( ![[dict valueForKey:key] isEqualToString:@""] )
        {
            if ( [key isEqualToString:@"address_proof"])
            {
                [ marrDocTitle addObject:@"Address Proof" ];
            }
            
            else if ( [key isEqualToString:@"employee_id"])
            {
                [ marrDocTitle addObject:@"Employee ID" ];
            }
            
            else if ( [key isEqualToString:@"id_proof"])
            {
                [ marrDocTitle addObject:@"ID Proof" ];
            }
            
            else if ( [key isEqualToString:@"office_id"])
            {
                [ marrDocTitle addObject:@"Office ID" ];
            }
            
            else if ( [key isEqualToString:@"pan_proof"])
            {
                [ marrDocTitle addObject:@"PAN Card" ];
            }
            else if ( [key isEqualToString:@"salary_slip1"])
            {
                [ marrDocTitle addObject:@"Salary Slip1" ];
            }
            
            else if ( [key isEqualToString:@"salary_slip2"])
            {
                [ marrDocTitle addObject:@"Salary Slip2" ];
            }
            
            else if ( [key isEqualToString:@"salary_slip3"])
            {
                [ marrDocTitle addObject:@"Salary Slip3" ];
            }
            [marrDoc addObject:[dict valueForKey:key]];
        }
    }

    
    
    
    /*[ marrDoc addObject:dictDocs[@"pan_proof"] ];
    [ marrDoc addObject:dictDocs[@"id_proof"] ];
    [ marrDoc addObject:dictDocs[@"address_proof"] ];
    [ marrDoc addObject:dictDocs[@"employee_id"] ];
    [ marrDoc addObject:dictDocs[@"salary_slip1"] ];
    [ marrDoc addObject:dictDocs[@"salary_slip2"] ];
    [ marrDoc addObject:dictDocs[@"salary_slip3"] ];
    [ marrDoc addObject:dictDocs[@"office_id"] ];*/
    
    NSArray *otherDoc = response[@"other_selected_docs"];
    if ( [otherDoc count] != 0 )
    {
        for (NSDictionary *dictOther in otherDoc)
        {
            [marrDoc addObject:dictOther[@"document_path"]];
            [marrDocTitle addObject:dictOther[@"document_name"]];
        }
    }

    self.profileTableView.hidden = NO;
    self.docCollection.hidden = YES;
    self.btnUpload.hidden = YES;
    
    [self.profileTableView reloadData];
}
- (void)serverCallForChangePassword
{
    NSDictionary *param = [NSMutableDictionary new];
   
    [ param setValue:@"changePassword" forKey:@"mode" ];
    [ param setValue:_txtOld.text forKey:@"oldPassword" ];
    [ param setValue:_txtNew.text forKey:@"newPassword" ];
    
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
                 UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle:@"StashFin" message:response[@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [ alert show ];
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
     }];

}
#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self choosePhotoFromLibrary];
            break;
        default:
            break;
    }
}
- (void)takePhoto
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}
- (void)choosePhotoFromLibrary
{
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)serverCallForUpdateProfile
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    NSString *base64String = [ NSString stringWithFormat:@"data:image/jpg;base64,%@",[Utilities getBase64EncodedStringOfImage:selectedImage]];

    NSDictionary *dictParam = [[NSDictionary alloc] initWithObjectsAndKeys:@"updateProfilePic",@"mode",base64String,@"image", nil];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withCompletion:^(id response)
    {
        NSLog(@"updateProfilePic respone === %@", response);
        
        if ( [response isKindOfClass:[NSDictionary class]] )
        {
            NSString *errorStr = [response objectForKey:@"error"];
            if ( errorStr.length > 0 )
            {
                [Utilities showAlertWithMessage:errorStr];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    isImageChange = YES;
                    [ self setupProfileBlurScreen:response[@"file_url"] ];
                });
            }
        }
        else
        {
            
        }

    }];
    
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}
- (void)setProfileImage
{

}
#pragma mark Helper Method
- (void)showPopupView:(UIView *)popupView onViewController:(UIViewController *)viewcontroller
{
    UIView *overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [overlayView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [overlayView setTag:786];
    [popupView setHidden:NO];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnOverlay:)];
    [overlayView addGestureRecognizer:tapGesture];
    
    [viewcontroller.view addSubview:overlayView];
    [viewcontroller.view bringSubviewToFront:popupView];
    popupView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        popupView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        //        [self.view bringSubviewToFront:_viewPicker];
    }];
    
}
- (void)tappedOnOverlay:(UIGestureRecognizer *)gesture
{
    [ self.view endEditing:YES ];
    [self hidePopupView:_viewPopup fromViewController:self];
}
- (void)hidePopupView:(UIView *)popupView fromViewController:(UIViewController *)viewcontroller
{
    UIView *overlayView = [viewcontroller.view viewWithTag:786];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         popupView.transform = CGAffineTransformMakeScale(0.01, 0.01);
     }
                     completion:^(BOOL finished)
     {
         [popupView setHidden:YES];
         
     }];
    [overlayView removeFromSuperview];
}

#pragma mark UIAlertview Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [ self.view endEditing:YES ];
    [ self hidePopupView:_viewPopup fromViewController:self ];
}


@end
