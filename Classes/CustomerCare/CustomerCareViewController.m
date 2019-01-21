//
//  CustomerCareViewController.m
//  StashFin
//
//  Created by sachin khard on 13/10/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "CustomerCareViewController.h"
#import "SimpleListViewController.h"
#import "SKPopoverController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "AttachmentView.h"


@interface CustomerCareViewController ()<SKPopoverControllerDelegate, SimpleListVCDelegate>
{
    SKPopoverController *vPopoverController;
}

@end

@implementation CustomerCareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getTopicsFromServer];
    imageCount = 0;
    
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    
    [self.textView setFont:[ApplicationUtils GETFONT_REGULAR:17]];
    [ApplicationUtils setFieldViewProperties:self.topicView];

    [self.submitButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
    
    [self.addButton setTintColor:ROSE_PINK_COLOR];
    [self.addButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
    self.addButton.layer.cornerRadius = 5;
    self.addButton.layer.borderWidth = 0.5;
    self.addButton.layer.borderColor = [UIColor grayColor].CGColor;
   
    /*
    topicsArray = [NSArray arrayWithObjects:@"Loan Status Query",
                                            @"Bank Statement Upload Error",
                                            @"Document Upload",
                                            @"Other Questions/ Comments",
                                            @"Need Another Loan",
                                            @"EMI Status Query",
                                            @"Email/ Phone/ Address Change",
                                            @"Foreclose My Loan",
                                            @"EMI Date Change",
                                            @"Unable To Pay EMI",
                                            @"Other Query",
                                            @"Other Category",
                                            @"IVR Ticket",
                                            @"IVR Payment Related Query",
                                            @"Have a StashFin Loan",
                                            @"Line of Credit (LOC) issue",
                                            @"Status of My Loan - Application",
                                            @"Card Related issue",
                                            @"EMI Related issue",
                                            @"Reschedule My Pickup",
                                            nil];
     */
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Customer Care";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addButtonAction:(id)sender {
    
    if (imageCount >= 3) {
        [ApplicationUtils showMessage:@"Sorry! You can't upload more than 3 attachments." withTitle:@"" onView:self.view];
    }
    else {
        UIActionSheet *tActionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Add Attachment",@"")
                                                                 delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"")
                                                   destructiveButtonTitle:nil otherButtonTitles:
                                       NSLocalizedString(@"Gallery",@""),
                                       NSLocalizedString(@"Camera",@""),
                                       nil];
        tActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [tActionSheet showInView:self.view];
    }
}

- (IBAction)topicsButtonAction:(id)sender {
    if (topicsArray.count) {
        [self showDropDownListWithArray:topicsArray withTitle:@"Select Topic" withSource:sender withTag:101];
    }
}

- (IBAction)submitButtonAction:(id)sender {
    UIButton *button = (UIButton *)[self.topicView viewWithTag:FIELD_DROPDWON_TAG];
    NSString *category = [button titleForState:UIControlStateNormal];
    
    if (!category.length) {
        [ApplicationUtils showMessage:@"Please select topic" withTitle:@"" onView:self.view];
    }
    else if (![self.textView.text length]) {
        [ApplicationUtils showMessage:@"Please enter your message" withTitle:@"" onView:self.view];
    }
    else {
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
        [dictParam setValue:@"Ticketapi"            forKey:@"mode"];
        [dictParam setValue:category                forKey:@"category"];
        [dictParam setValue:self.textView.text      forKey:@"message"];
        
        NSArray *subViews = self.attachmentView.subviews;
        
        for (NSInteger i = 0; i < subViews.count; i++) {
            AttachmentView *obj = [subViews objectAtIndex:i];

            UIImage *compressedImage = [ApplicationUtils compressImage:obj.imageView.image compressRatio:0.5];
            NSString *imageBase64String = [NSString stringWithFormat:@"data:image/jpg;base64,%@",[ApplicationUtils encodeToBase64String:compressedImage compressionQuality:0.5]];

            switch (i) {
                case 0: {
                    [dictParam setValue:imageBase64String         forKey:@"image1"];
                }
                    break;
                    
                case 1: {
                    [dictParam setValue:imageBase64String         forKey:@"image2"];
                }
                    break;
                    
                case 2: {
                    [dictParam setValue:imageBase64String         forKey:@"image3"];
                }
                    break;
                    
                default:
                    break;
            }
        }
        
        [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:[AppDelegate instance].window withCompletion:^(id response) {
            if ([[response class] isSubclassOfClass:[NSString class]]) {
                [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
            }
            else {
                [AlertViewManager sharedManager].alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Thank you. Your request has been raised." cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"OK", nil) action:^{
                    
                    [ApplicationUtils popVCWithFadeAnimation:self.navigationController];
                    
                }] otherButtonItems: nil];
                [[AlertViewManager sharedManager].alertView show];
            }
        }];
    }
}

/*
 {
 status = 1;
 "ticket_number" = "Sorry!!! Message was not sent. Mailer error: SMTP connect() failed. https://github.com/PHPMailer/PHPMailer/wiki/Troubleshooting";
 }
 */

- (void)showDropDownListWithArray:(NSArray *)list withTitle:(NSString *)title withSource:(UIButton *)sender withTag:(NSInteger)tag {
    if (!vPopoverController) {
        SimpleListViewController *obj = [[SimpleListViewController alloc] initWithNibName:@"SimpleListViewController" bundle:nil];
        obj.preferredContentSize = CGSizeMake(280, 220);
        obj.modalInPopover = NO;
        obj.delegate = self;
        obj.listArray = list;
        obj.headerTitle = title;
        obj.dropdowntag = tag;
        
        vPopoverController = [[SKPopoverController alloc] initWithContentViewController:obj];
        vPopoverController.delegate = self;
        vPopoverController.passthroughViews = @[sender];
        vPopoverController.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
        vPopoverController.wantsDefaultContentAppearance = NO;
        
        [vPopoverController presentPopoverFromRect:sender.bounds
                                            inView:sender
                          permittedArrowDirections:SKPopoverArrowDirectionAny
                                          animated:YES
                                           options:SKPopoverAnimationOptionFadeWithScale];
    }
    else {
        [vPopoverController dismissPopoverAnimated:YES completion:^{
            [self popoverControllerDidDismissPopover:vPopoverController];
        }];
    }
}

#pragma mark - SKPopoverController Delegate

- (void)popoverControllerDidDismissPopover:(SKPopoverController *)controller
{
    if (controller == vPopoverController)
    {
        vPopoverController.delegate = nil;
        vPopoverController = nil;
    }
}

#pragma mark - SimpleListViewController Delegate

- (void)selectedListOption:(NSInteger)selectedOption WithDropdownTag:(NSInteger)tag {
    [vPopoverController dismissPopoverAnimated:YES completion:^{
        [self popoverControllerDidDismissPopover:vPopoverController];
    }];
    
    UIButton *button = (UIButton *)[self.topicView viewWithTag:FIELD_DROPDWON_TAG];
    [button setTitle:topicsArray[selectedOption] forState:UIControlStateNormal];
    
    [ApplicationUtils hideGreenCheckImageFromFieldView:self.topicView shouldHide:NO];
}


#pragma mark - delegate methods of UIActionSheet

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        return;
    }
    
    switch (buttonIndex) {
        case 0:
        {
            self.imagePickerController = [[UIImagePickerController alloc] init];
            [self.imagePickerController setDelegate: self];
            self.imagePickerController.allowsEditing = YES;
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        }
            break;
        case 1:
        {
            [self imageUsingCamera];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Taking Image Using Camera

- (void) imageUsingCamera{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [AlertViewManager sharedManager].alertView =  [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Camera not available", nil)
                                                                                 message: NSLocalizedString(@"Sorry camera not available on device", nil)
                                                                        cancelButtonItem:[RIButtonItem itemWithLabel: NSLocalizedString(@"OK", nil) action:^{
        }]
                                                                        otherButtonItems: nil];
        [[AlertViewManager sharedManager].alertView show];
    }
    else{
        [self takeImageCamera];
    }
}

- (void) takeImageCamera{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        [self showCameraController];
    }
    else {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                [self showCameraController];
            }
            else {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    //load your data here.
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ApplicationUtils showCameraPermissionAlert];
                    });
                });
            }
        }];
    }
}

- (void)showCameraController {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    switch (status)
    {
        case PHAuthorizationStatusAuthorized: {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                //load your data here.
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self openCameraAnimated:YES];
                });
            });
        }
            break;
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus authorizationStatus)
             {
                 if (authorizationStatus == PHAuthorizationStatusAuthorized)
                 {
                     dispatch_async(dispatch_get_global_queue(0, 0), ^{
                         //load your data here.
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self openCameraAnimated:YES];
                         });
                     });
                 }
                 else
                 {
                     dispatch_async(dispatch_get_global_queue(0, 0), ^{
                         //load your data here.
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [ApplicationUtils showPhotosPermissionAlert];
                         });
                     });
                 }
             }];
            break;
        }
        default:
        {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                //load your data here.
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ApplicationUtils showPhotosPermissionAlert];
                });
            });
        }
            break;
    }
}

- (void)openCameraAnimated:(BOOL)animated {
    
    self.imagePickerController = [[UIImagePickerController alloc]init];
    [self.imagePickerController setDelegate: self];
    self.imagePickerController.allowsEditing = YES;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePickerController.showsCameraControls = YES;
    [self presentViewController:self.imagePickerController animated:animated completion:nil];
}

#pragma mark - ImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [ApplicationUtils normalizedImage:image];

    [picker dismissViewControllerAnimated:YES completion:^{
        
        AttachmentView *obj = [[AttachmentView alloc] initWithFrame:CGRectMake(0, imageCount*60, self.view.frame.size.width, 60)];
        [obj.textLabel setText:[NSString stringWithFormat:@"Attchment %1d",imageCount+1]];
        [obj.imageView setImage:image];
        [obj.deleteButton setTag:imageCount];
        [obj.deleteButton addTarget:self action:@selector(deleteAttachmentView:) forControlEvents:UIControlEventTouchUpInside];
        [obj setTag:1000+imageCount];
        [self.attachmentView addSubview:obj];
        
        imageCount++;
        self.attachmentViewHeight.constant = imageCount*60 + 20;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteAttachmentView:(UIButton *)sender {

    NSArray *subViews = self.attachmentView.subviews;

    for (NSInteger i = sender.tag; i < subViews.count; i++) {
        AttachmentView *obj = [subViews objectAtIndex:i];
        
        if (obj.tag == 1000+sender.tag) {
            [obj removeFromSuperview];
        }
        else {
            [obj setFrame:CGRectMake(obj.frame.origin.x, obj.frame.origin.y-60, obj.frame.size.width, obj.frame.size.height)];
            [obj setTag:1000+i-1];
            [obj.deleteButton setTag:i-1];
            [obj.textLabel setText:[NSString stringWithFormat:@"Attchment %1d",i]];
        }
    }
    
    imageCount--;
    if (imageCount == 0) {
        self.attachmentViewHeight.constant = 60;
    }
    else {
        self.attachmentViewHeight.constant -= 60;
    }
}


#pragma mark - service

- (void)getTopicsFromServer {
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"tokenApiCategoryList"     forKey:@"mode"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:[AppDelegate instance].window withCompletion:^(id response) {
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
        }
        else {
            NSArray *tempArray = response[@"tokenApiCategoryList"];
            topicsArray = [NSArray arrayWithArray:[tempArray valueForKey:@"query_type_name"]];
        }
    }];
}

@end
