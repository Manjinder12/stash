//
//  SignupViewController.h
//  StashFin
//
//  Created by sachin khard on 22/04/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPageControl.h"

@interface SignupViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    UIDatePicker *datePicker;
    NSArray *salaryModeArray;
    NSMutableArray *occupiedSinceArray;
    NSArray *residenceTypeArray;
    NSMutableArray *stateArray;
    NSMutableArray *stateDataArray;
    NSMutableArray *cityArray;
    NSMutableArray *cityDataArray;
    NSArray *educationArray;
    NSArray *designationArray;
    NSMutableArray *totalExpArray;
    NSMutableArray *workingSinceArray;
    
    BOOL isProfilePicSelected;
    NSString *selectedSalaryModePosition;
    NSString *selectedResidenceTypePosition;
    NSString *selectedEducationPosition;
    NSString *selectedDesignationPosition;
    NSString *imageBase64String;
    
    UIActivityIndicatorView *indicatorView;
    NSInteger selectedDocument;
    NSString *selectedDocID;
    NSString *additionalDocumentName;
    NSMutableArray *otherUploadedDocuments;
    
    NSDictionary *bankPerfiosDic;
    
    NSInteger uploadedDocumetsCount;
}

@property (strong, nonatomic) NSDictionary *prefilledDic;
@property (strong, nonatomic) NSDictionary *cardScanDic;
@property (assign, nonatomic) NSInteger landingPage;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) NSDictionary *uploadedDocsDic;


@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;

@property (weak, nonatomic) IBOutlet UIView *topBGView;
@property (weak, nonatomic) IBOutlet UIButton *basicButton;
@property (weak, nonatomic) IBOutlet UIButton *professionalButton;
@property (weak, nonatomic) IBOutlet UIButton *bankButton;
@property (weak, nonatomic) IBOutlet UIButton *documentButton;
@property (weak, nonatomic) IBOutlet UIButton *signatureButton;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (weak, nonatomic) IBOutlet UIImageView *trasparentImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UIScrollView *basic1ScrollView;
@property (weak, nonatomic) IBOutlet UIView *fNameView;
@property (weak, nonatomic) IBOutlet UIView *lNameView;
@property (weak, nonatomic) IBOutlet UIView *genderView;
@property (weak, nonatomic) IBOutlet UIView *dobView;
@property (weak, nonatomic) IBOutlet UIView *mobileView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *panView;
@property (weak, nonatomic) IBOutlet UIView *aadharView;
@property (weak, nonatomic) IBOutlet UIView *referralcodeView;
@property (weak, nonatomic) IBOutlet UIView *aadharInfo1View;
@property (weak, nonatomic) IBOutlet UIView *aadharInfo2View;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aadharInfo2ViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIScrollView *basic2ScrollView;
@property (weak, nonatomic) IBOutlet UIView *employmentTypeView;
@property (weak, nonatomic) IBOutlet UIView *companyView;
@property (weak, nonatomic) IBOutlet UIView *salaryModeView;
@property (weak, nonatomic) IBOutlet UIView *salaryView;
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UIView *landmarkView;
@property (weak, nonatomic) IBOutlet UIView *stateView;
@property (weak, nonatomic) IBOutlet UIView *cityView;
@property (weak, nonatomic) IBOutlet UIView *pincodeView;
@property (weak, nonatomic) IBOutlet UIView *occupiedsinceView;
@property (weak, nonatomic) IBOutlet UIView *residencesinceView;
@property (weak, nonatomic) IBOutlet UIButton *nextBasic2Button;
@property (weak, nonatomic) IBOutlet UIButton *prevBasic2Button;


@property (weak, nonatomic) IBOutlet UIScrollView *professionalScrollView;
@property (weak, nonatomic) IBOutlet UIView *educationView;
@property (weak, nonatomic) IBOutlet UIView *designationView;
@property (weak, nonatomic) IBOutlet UIView *totalExpView;
@property (weak, nonatomic) IBOutlet UIView *workingsinceView;
@property (weak, nonatomic) IBOutlet UIView *officialemailView;
@property (weak, nonatomic) IBOutlet UIView *officelandlineView;
@property (weak, nonatomic) IBOutlet UIView *officeaddressView;
@property (weak, nonatomic) IBOutlet UIView *officelandmarkView;
@property (weak, nonatomic) IBOutlet UIView *profstateView;
@property (weak, nonatomic) IBOutlet UIView *profcityView;
@property (weak, nonatomic) IBOutlet UIView *profpincodeView;
@property (weak, nonatomic) IBOutlet UIButton *nextProfessionalButton;

@property (weak, nonatomic) IBOutlet UIView *processingView;
@property (weak, nonatomic) IBOutlet UILabel *pcardNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *penjoyLabel;
@property (weak, nonatomic) IBOutlet UIView *pcenterView;
@property (weak, nonatomic) IBOutlet UILabel *pholdLabel;
@property (weak, nonatomic) IBOutlet UILabel *pminuteLabel;
@property (weak, nonatomic) IBOutlet UIButton *pfillDetailsButton;

@property (weak, nonatomic) IBOutlet UIView *resultView;
@property (weak, nonatomic) IBOutlet UILabel *ramountLabel;
@property (weak, nonatomic) IBOutlet UILabel *rdurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *rmonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *rcongratulationLabel;
@property (weak, nonatomic) IBOutlet UILabel *rprocessedLabel;
@property (weak, nonatomic) IBOutlet UIButton *rGetCardButton;
@property (weak, nonatomic) IBOutlet UIButton *rRequestMoreButton;

@property (weak, nonatomic) IBOutlet UIView *requestView;
@property (weak, nonatomic) IBOutlet UILabel *reThankYouLabel;
@property (weak, nonatomic) IBOutlet UILabel *reProcessingLabel;
@property (weak, nonatomic) IBOutlet UIButton *reContinueButton;

@property (weak, nonatomic) IBOutlet UIView *signatureVIew;
@property (weak, nonatomic) IBOutlet UILabel *sUploadLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *sScrollView;
@property (weak, nonatomic) IBOutlet UIButton *sSignDocumentButton;
@property (weak, nonatomic) IBOutlet UIButton *skipSignatureButton;
@property(nonatomic, strong) DDPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIView *finalView;
@property (weak, nonatomic) IBOutlet UILabel *fThankYouLabel;
@property (weak, nonatomic) IBOutlet UILabel *fProcessingLabel;
@property (weak, nonatomic) IBOutlet UIButton *fContinueButton;

@property (weak, nonatomic) IBOutlet UIView *rejectView;
@property (weak, nonatomic) IBOutlet UILabel *rejectLabel;
@property (weak, nonatomic) IBOutlet UILabel *rejectStaticLabel;
@property (weak, nonatomic) IBOutlet UIButton *rejectCloseButton;


@property (weak, nonatomic) IBOutlet UIView *bankView;
@property (weak, nonatomic) IBOutlet UIButton *authencicateLaterButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *reloadPerfiosPageButton;


@property (weak, nonatomic) IBOutlet UIView *documentView;
@property (weak, nonatomic) IBOutlet UITableView *documentTableView;
@property (weak, nonatomic) IBOutlet UIButton *documentDoneButton;
@property (weak, nonatomic) IBOutlet UIView *addDocumentPopupView;
@property (weak, nonatomic) IBOutlet UIView *adpvInnerView;
@property (weak, nonatomic) IBOutlet UILabel *adpvNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *adpvNameTF;
@property (weak, nonatomic) IBOutlet UIButton *adpvCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *adpvOKButton;


- (IBAction)reloadPerfiosPageButtonAction:(id)sender;
- (IBAction)adpvOKButtonAction:(id)sender;
- (IBAction)adpvCancelButtonAction:(id)sender;
- (IBAction)documentDoneButtonAction:(id)sender;
- (IBAction)rejectCloseButtonAction:(id)sender;
- (IBAction)fContinueButtonAction:(id)sender;
- (IBAction)sSignDocumentButtonAction:(id)sender;
- (IBAction)reContinueButtonAction:(id)sender;
- (IBAction)rGetCardButtonAction:(id)sender;
- (IBAction)rRequestMoreButtonAction:(id)sender;
- (IBAction)pfillDetailsButtonAction:(id)sender;
- (IBAction)nextProfessionalButtonAction:(id)sender;
- (IBAction)prevBasic2ButtonAction:(id)sender;
- (IBAction)nextBasic2ButtonAction:(id)sender;
- (IBAction)nextButtonAction:(id)sender;
- (IBAction)backAction:(id)sender;
- (IBAction)cameraAction:(id)sender;
- (IBAction)genderButtonAction:(id)sender;
- (IBAction)dobButtonAction:(id)sender;
- (IBAction)aadharInfo1ButtonAction:(id)sender;
- (IBAction)aadharInfo2ButtonAction:(id)sender;
- (IBAction)employmentTypeButtonAction:(id)sender;
- (IBAction)authencicateLaterButtonAction:(id)sender;

@end
