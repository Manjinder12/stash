//
//  SignupViewController.m
//  StashFin
//
//  Created by sachin khard on 22/04/18.
//  Copyright © 2018 StashFin. All rights reserved.
//
//9532517547
//myApp990

#import "SignupViewController.h"
#import "UIImage+animatedGIF.h"
#import "EmailLoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "SimpleListViewController.h"
#import "SKPopoverController.h"
#import "DocUploadCell.h"


#define SALARY_MODE_TAG     501
#define STATE_TAG           502
#define CITY_TAG            503
#define OCCUPIED_SINCE_TAG  504
#define RESIDENCE_TYPE_TAG  505
#define DESIGNATION_TAG     506
#define TOTAL_EXP_TAG       507
#define WORKING_SINCE_TAG   508
#define EDUCATION_TAG       509


@interface SignupViewController () <SKPopoverControllerDelegate, SimpleListVCDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
    SKPopoverController *vPopoverController;
}

@end

@implementation SignupViewController

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.topBGView.backgroundColor = ROSE_PINK_COLOR;
    
    [self setTopButtonSelected:self.basicButton isSelected:NO];
    [self setTopButtonSelected:self.professionalButton isSelected:NO];
    [self setTopButtonSelected:self.bankButton isSelected:NO];
    [self setTopButtonSelected:self.documentButton isSelected:NO];
    [self setTopButtonSelected:self.signatureButton isSelected:NO];

    imageBase64String = @"";
    uploadedDocumetsCount = 0;
    
    [self performSelector:@selector(setFieldProperties) withObject:nil afterDelay:0.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFieldProperties {
    
    if (self.landingPage <= 2) {
        self.pictureView.backgroundColor = [UIColor clearColor];
        self.trasparentImageView.backgroundColor = [UIColor whiteColor];
        self.userImageView.backgroundColor = [UIColor whiteColor];
        self.trasparentImageView.alpha = 0.25;
        
        float width = [AppDelegate instance].window.frame.size.width*0.35;
        self.pictureView.layer.cornerRadius = width/2;
        self.trasparentImageView.layer.cornerRadius = width/2;
        self.userImageView.layer.cornerRadius = (width-15)/2;
        self.userImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.userImageView.clipsToBounds = YES;
        
        salaryModeArray = [NSArray arrayWithObjects:@"In Bank",@"By Cheque",@"In Cash",nil];
        residenceTypeArray = [NSArray arrayWithObjects:@"Self Owned",@"Owned by Family",@"Rented Alone",@"Rented with Family",@"Rented with Friends",@"Paying Guest",@"Hostel",nil];
        educationArray = [NSArray arrayWithObjects:@"B.A",@"B.Arch",@"B.B.A",@"B.Com",@"B.Ed",@"B.Pharma",@"B.Sc",@"B.TEch/ B.E.",@"BCA",@"CA",@"Diploma",@"M.A",@"M.Com",@"M.Ed",@"M.Sc",@"M.Tech",@"MBA/ PGDM",@"MCA",@"PG Diploma",@"Other",nil];
        
        designationArray = [NSArray arrayWithObjects:
                            @"Programming and Design",
                            @"Software Developer",
                            @"Team Lead/Tech Lead",
                            @"System Analyst",
                            @"Tech Architect",
                            @"Database Architect/Designer",
                            @"Project Lead",
                            @"Testing Engnr",
                            @"Product Mgr",
                            @"Graphic/Web Designer",
                            @"Release Mgr",
                            @"Admin/Maintenance/Security/Datawarehousing",
                            @"DBA",
                            @"Network Admin",
                            @"System Admin",
                            @"System Security",
                            @"Tech Support Engnr",
                            @"Maintenance Engnr",
                            @"Webmaster",
                            @"IT/Networking-Mgr",
                            @"Information System(MIS)-Mgr",
                            @"System Design/Implementation/ERP/CRM",
                            @"System Integration Technician",
                            @"Business Analyst",
                            @"Datawarehousing Technician",
                            @"Outside Technical Consultant",
                            @"Functional Outside Consultant",
                            @"EDP Analyst",
                            @"QA/Testing/Documentation",
                            @"Technical Writer",
                            @"Instructional Designer",
                            @"Technical Documentor",
                            @"QA/QC Exec.",
                            @"QA/QC Mgr",
                            @"Project Management",
                            @"Project Mgr-IT/Software",
                            @"Senior Management",
                            @"Program Mgr",
                            @"Head/VP/GM-Quality",
                            @"Head/VP/GM-Technology(IT)/CTO",
                            @"CIO",
                            @"Traner/Faculty",
                            @"Trainee",
                            @"Fresher",
                            @"Outside Consultant",
                            @"IT/Technical Content Developer",
                            @"Manager",
                            @"Others",nil];
        
        occupiedSinceArray = [NSMutableArray array];
        stateArray = [NSMutableArray array];
        cityArray = [NSMutableArray array];
        stateDataArray = [NSMutableArray array];
        cityDataArray = [NSMutableArray array];
        totalExpArray = [NSMutableArray array];
        workingSinceArray = [NSMutableArray array];
        
        selectedSalaryModePosition = @"";
        selectedResidenceTypePosition = @"";
        selectedDesignationPosition = @"";
        selectedEducationPosition = @"";
        
        int currentYear = [[ApplicationUtils getDateStringFromDate:[NSDate date] withOutputFormat:@"YYYY"] intValue];
        
        for (int i = 1980; i <= currentYear; i++) {
            [occupiedSinceArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        for (int i = 1; i <= 20; i++) {
            [totalExpArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        for (int i = currentYear; i >= 1980; i--) {
            [workingSinceArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        [self getStateListFromServer];
    }
    
    self.basic1ScrollView.alpha = 0.0;
    self.basic2ScrollView.alpha = 0.0;
    self.professionalScrollView.alpha = 0.0;
    self.processingView.alpha = 0.0;
    self.resultView.alpha = 0.0;
    self.requestView.alpha = 0.0;
    self.rejectView.alpha = 0.0;
    self.finalView.alpha = 0.0;
    self.bankView.alpha = 0.0;
    self.documentView.alpha = 0.0;
    self.addDocumentPopupView.alpha = 0.0;
    self.signatureVIew.alpha = 0.0;
    self.adpvInnerView.layer.cornerRadius = 5;
    self.adpvInnerView.clipsToBounds = YES;
    self.documentTableView.tableFooterView = [UIView new];
    
    switch (self.landingPage) {
        case 1:
            self.basic1ScrollView.alpha = 1.0;
            [self setTopButtonSelected:self.basicButton isSelected:YES];
            break;
        case 2:
            self.professionalScrollView.alpha = 1.0;
            [self setTopButtonSelected:self.professionalButton isSelected:YES];
            break;
        case 3:
            self.bankView.alpha = 1.0;
            [self setTopButtonSelected:self.bankButton isSelected:YES];
            break;
        case 4:
            self.documentView.alpha = 1.0;
            [self setTopButtonSelected:self.documentButton isSelected:YES];
            break;
        case 5:
            self.rejectView.alpha = 1.0;
            break;

        default:
            self.basic1ScrollView.alpha = 1.0;
            [self setTopButtonSelected:self.basicButton isSelected:YES];
            break;
    }

    if (self.landingPage <= 2) {
        UITextField *tf = (UITextField *)[self.panView viewWithTag:FIELD_TEXTFIELD_TAG];
        [tf setDelegate:self];
        
        tf = (UITextField *)[self.aadharView viewWithTag:FIELD_TEXTFIELD_TAG];
        [tf setDelegate:self];
        
        tf = (UITextField *)[self.pincodeView viewWithTag:FIELD_TEXTFIELD_TAG];
        [tf setDelegate:self];
        
        [ApplicationUtils setFieldViewProperties:self.fNameView];
        [ApplicationUtils setFieldViewProperties:self.lNameView];
        [ApplicationUtils setFieldViewProperties:self.genderView];
        [ApplicationUtils setFieldViewProperties:self.dobView];
        [ApplicationUtils setFieldViewProperties:self.mobileView];
        [ApplicationUtils setFieldViewProperties:self.aadharInfo1View];
        [ApplicationUtils setFieldViewProperties:self.aadharInfo2View];
        [ApplicationUtils setFieldViewProperties:self.emailView];
        [ApplicationUtils setFieldViewProperties:self.passwordView];
        [ApplicationUtils setFieldViewProperties:self.panView];
        [ApplicationUtils setFieldViewProperties:self.aadharView];
        [ApplicationUtils setFieldViewProperties:self.referralcodeView];
        
        [self.nextButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
        
        [ApplicationUtils setFieldViewProperties:self.employmentTypeView];
        [ApplicationUtils setFieldViewProperties:self.companyView];
        [ApplicationUtils setFieldViewProperties:self.salaryView];
        [ApplicationUtils setFieldViewProperties:self.salaryModeView];
        [ApplicationUtils setFieldViewProperties:self.addressView];
        [ApplicationUtils setFieldViewProperties:self.landmarkView];
        [ApplicationUtils setFieldViewProperties:self.stateView];
        [ApplicationUtils setFieldViewProperties:self.cityView];
        [ApplicationUtils setFieldViewProperties:self.pincodeView];
        [ApplicationUtils setFieldViewProperties:self.occupiedsinceView];
        [ApplicationUtils setFieldViewProperties:self.residencesinceView];
        
        [self.nextBasic2Button.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
        [self.prevBasic2Button.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
        
        [ApplicationUtils setFieldViewProperties:self.educationView];
        [ApplicationUtils setFieldViewProperties:self.designationView];
        [ApplicationUtils setFieldViewProperties:self.totalExpView];
        [ApplicationUtils setFieldViewProperties:self.workingsinceView];
        [ApplicationUtils setFieldViewProperties:self.officialemailView];
        [ApplicationUtils setFieldViewProperties:self.officelandlineView];
        [ApplicationUtils setFieldViewProperties:self.officeaddressView];
        [ApplicationUtils setFieldViewProperties:self.officelandmarkView];
        [ApplicationUtils setFieldViewProperties:self.profstateView];
        [ApplicationUtils setFieldViewProperties:self.profcityView];
        [ApplicationUtils setFieldViewProperties:self.profpincodeView];
        
        [self.nextProfessionalButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
        
        [self.cardNameLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
        [self.cardNumberLabel setFont:[ApplicationUtils GETFONT_BOLD:21]];
        [self.pcardNameLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
        [self.penjoyLabel setFont:[ApplicationUtils GETFONT_BOLD:19]];
        [self.pholdLabel setFont:[ApplicationUtils GETFONT_MEDIUM:17]];
        [self.pminuteLabel setFont:[ApplicationUtils GETFONT_MEDIUM:17]];
        [self.pfillDetailsButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:16]];
        
        [self setFontsInCenterProcessingViewWithTag:1];
        [self setFontsInCenterProcessingViewWithTag:2];
        [self setFontsInCenterProcessingViewWithTag:3];
        [self setFontsInCenterProcessingViewWithTag:4];
        
        [self.ramountLabel setFont:[ApplicationUtils GETFONT_BOLD:24]];
        [self.ramountLabel setTextColor:ROSE_PINK_COLOR];
        [self.rdurationLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
        [self.rmonthLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
        [self.rcongratulationLabel setFont:[ApplicationUtils GETFONT_BOLD:24]];
        [self.rprocessedLabel setFont:[ApplicationUtils GETFONT_MEDIUM:17]];
        [self.rGetCardButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:16]];
        [self.rRequestMoreButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:16]];
        
        [self.reThankYouLabel setFont:[ApplicationUtils GETFONT_BOLD:24]];
        [self.reProcessingLabel setFont:[ApplicationUtils GETFONT_MEDIUM:17]];
        [self.reContinueButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
        
        [self.pminuteLabel setText:@"It may take us a minute. You can continue to fill other parts of the application while we get your offer ready."];
    }
    
    [self.rejectLabel setFont:[ApplicationUtils GETFONT_BOLD:24]];
    [self.rejectStaticLabel setFont:[ApplicationUtils GETFONT_MEDIUM:17]];
    [self.rejectCloseButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
    
    [self.reloadPerfiosPageButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:16]];
    [self.sUploadLabel setFont:[ApplicationUtils GETFONT_BOLD:24]];
    [self.sSignDocumentButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
    [self.skipSignatureButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
    [self performSelector:@selector(setSignatureScrollView) withObject:nil afterDelay:0.15];
    
    [self.fThankYouLabel setFont:[ApplicationUtils GETFONT_BOLD:24]];
    [self.fProcessingLabel setFont:[ApplicationUtils GETFONT_MEDIUM:17]];
    [self.fContinueButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
    
    [self.rejectStaticLabel setText:@"We regret to inform you that we are unable to process your application at this time. You may apply again after 3 months."];
    
    [self.fProcessingLabel setText:@"Your application is now complete. \n Your card will now be processed. \n\n You can now login to StashFin app using your phone number & OTP to view your profile & documents"];
    
    [self.authencicateLaterButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:17]];

    [self.adpvNameLabel setFont:[ApplicationUtils GETFONT_BOLD:20]];
    [self.adpvNameTF setFont:[ApplicationUtils GETFONT_REGULAR:18]];
    [self.adpvOKButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
    [self.adpvCancelButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];
    [self.documentDoneButton.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:18]];

    [self.cardNumberLabel setText:[ApplicationUtils stringByFormattingAsCreditCardNumber:@"0000000000000000"]];

    [self setDataFromPrefilledDic];
}

- (void)setDataFromPrefilledDic {
    if (self.prefilledDic) {
        [self updateCardNameWithFirstName:self.prefilledDic[FIRST_NAME_KEY] LastName:self.prefilledDic[LAST_NAME_KEY]];

        if (self.landingPage <= 2) {
            
            [self setTextFieldFromView:self.fNameView WithKey:FIRST_NAME_KEY];
            [self setTextFieldFromView:self.lNameView WithKey:LAST_NAME_KEY];
            
            [self.cardNumberLabel setText:[ApplicationUtils stringByFormattingAsCreditCardNumber:[ApplicationUtils validateStringData:self.cardScanDic[@"card"][@"cardNo"]]]];
            
            UIButton *radioButton1 = (UIButton *)[self.genderView viewWithTag:FIELD_RADIO1_TAG];
            UIButton *radioButton2 = (UIButton *)[self.genderView viewWithTag:FIELD_RADIO2_TAG];
            
            if ([[[ApplicationUtils validateStringData:self.prefilledDic[GENDER_KEY]] lowercaseString] isEqualToString:@"female"]) {
                [self genderButtonAction:radioButton2];
            }
            else {
                [self genderButtonAction:radioButton1];
            }
            
            UITextField *tf = [self setTextFieldFromView:self.mobileView WithKey:MOBILE_NUMBER_KEY];
            tf.enabled = NO;
            
            [self setTextFieldFromView:self.emailView WithKey:EMAIL_KEY];
            [self setTextFieldFromView:self.dobView WithKey:DOB_KEY];
            [self setTextFieldFromView:self.companyView WithKey:COMPANY_KEY];
            [self setTextFieldFromView:self.salaryView WithKey:SALARY_KEY];
            
            if ([[ApplicationUtils validateStringData:self.prefilledDic[GENDER_KEY]] length]) {
                [ApplicationUtils hideGreenCheckImageFromFieldView:self.genderView shouldHide:NO];
            }
            
            if ([[ApplicationUtils validateStringData:self.prefilledDic[DOB_KEY]] length]) {
                [ApplicationUtils hideGreenCheckImageFromFieldView:self.dobView shouldHide:NO];
            }
            
            [self setTextFieldFromView:self.referralcodeView WithKey:REFERRAL_CODE];
        }
    }

    if (self.landingPage <= 2) {
        
        UIButton *radioButton1 = (UIButton *)[self.aadharInfo1View viewWithTag:FIELD_RADIO1_TAG];
        [self aadharInfo1ButtonAction:radioButton1];
        
        radioButton1 = (UIButton *)[self.employmentTypeView viewWithTag:FIELD_RADIO1_TAG];
        [self employmentTypeButtonAction:radioButton1];
    }
}

- (UITextField *)setTextFieldFromView:(UIView *)view WithKey:(NSString *)key {
    UITextField *tf = (UITextField *)[view viewWithTag:FIELD_TEXTFIELD_TAG];
    [tf setText:self.prefilledDic[key]];
   
    if ([tf.text length]) {
        [ApplicationUtils hideGreenCheckImageFromFieldView:view shouldHide:NO];
    }
    
    return tf;
}

- (void)setSignatureScrollView {
    float xCord = 0;
    for (int i = 1; i <= 4; i++) {
        
        float height = CGRectGetHeight(self.sScrollView.frame);

        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(xCord, 0, CGRectGetWidth([AppDelegate instance].window.frame), height)];
        [bgView setBackgroundColor:[UIColor clearColor]];
        [self.sScrollView addSubview:bgView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(bgView.frame)-height*0.6)/2, height*0.04, height*0.6, height*0.6)];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [bgView addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        if (i != 4) {
            [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"signature_%d",i]]];
        }
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, imageView.frame.origin.y+imageView.frame.size.height, CGRectGetWidth(bgView.frame)-80, height*0.36)];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setNumberOfLines:0];
        [textLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [textLabel setContentMode:UIViewContentModeBottom];
        [textLabel setTextAlignment:NSTextAlignmentCenter];
        [textLabel setFont:[ApplicationUtils GETFONT_REGULAR:18]];
        [bgView addSubview:textLabel];
        
        xCord += CGRectGetWidth([AppDelegate instance].window.frame);
        
        switch (i) {
            case 1:
            {
                [textLabel setText:@"Please take a blank white paper and sign with dark pen"];
            }
                break;
            case 2:
            {
                [textLabel setText:@"Capture the signature clearly with your phone camera"];
            }
                break;
            case 3:
            {
                [textLabel setText:@"Upload your signature to the app"];
            }
                break;
            case 4:
            {
                [textLabel setText:@"We will prepare your signed documents and you will be able to review them in your profile"];
                
                NSURL *url = [[NSBundle mainBundle] URLForResource:@"signature4" withExtension:@"gif"];
                imageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
            }
                break;
            default:
                break;
        }
    }
    [self.sScrollView setContentSize:CGSizeMake(CGRectGetWidth([AppDelegate instance].window.frame)*4, CGRectGetHeight(self.sScrollView.frame))];
    [self initializePageControl];
}

- (void)initializePageControl{
    self.pageControl = [[DDPageControl alloc] init];
    [self.pageControl setCurrentPage: 0];
    [self.pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
    [self.pageControl setDefersCurrentPageDisplay:YES];
    [self.pageControl setType:DDPageControlTypeOnFullOffEmpty];
    [self.pageControl setOnColor:ROSE_PINK_COLOR];
    [self.pageControl setOffColor:[UIColor grayColor]];
    [self.pageControl setIndicatorDiameter:6.0f];
    [self.pageControl setIndicatorSpace:6.0f];
    [self.pageControl setHidesForSinglePage:YES];
    [self.pageControl setCenter:CGPointMake(self.sScrollView.center.x, self.sScrollView.frame.origin.y+CGRectGetHeight(self.sScrollView.frame)+2)];
    self.pageControl.numberOfPages = 4;
    [self.signatureVIew addSubview:self.pageControl];
}

- (void)setFontsInCenterProcessingViewWithTag:(NSInteger)tag {
    UIView *view1 = (UIView *)[self.pcenterView viewWithTag:tag];
    UILabel *lbl1 = (UILabel *)[view1 viewWithTag:100];
    [lbl1 setFont:[ApplicationUtils GETFONT_REGULAR:16]];
}

- (void)setTopButtonSelected:(UIButton *)btn isSelected:(BOOL)isSelected {
    btn.selected = isSelected;
    
    if (isSelected) {
        if (btn == self.documentButton) {
            self.documentTableView.delegate = self;
            self.documentTableView.dataSource = self;
            [self performSelector:@selector(serverCallForDocDetail) withObject:nil afterDelay:0.001];
        }
        else if (btn == self.bankButton) {
            [self performSelector:@selector(getBankStatementStatusFromServer) withObject:nil afterDelay:0.001];
        }
        [btn setBackgroundImage:[UIImage imageNamed:@"ButtonBottomWhite"] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[ApplicationUtils GETFONT_BOLD:19]];
    }
    else {
        [btn setBackgroundImage:nil forState:UIControlStateNormal];
        [btn.titleLabel setFont:[ApplicationUtils GETFONT_MEDIUM:19]];
    }
}

#pragma mark - Button Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)genderButtonAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    UIButton *radioButton1 = (UIButton *)[self.genderView viewWithTag:FIELD_RADIO1_TAG];
    UIButton *radioButton2 = (UIButton *)[self.genderView viewWithTag:FIELD_RADIO2_TAG];

    if (radioButton1.tag == btn.tag) {
        radioButton1.selected = YES;
        radioButton2.selected = NO;
    }
    else {
        radioButton1.selected = NO;
        radioButton2.selected = YES;
    }
}

- (IBAction)aadharInfo1ButtonAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    UIButton *radioButton1 = (UIButton *)[self.aadharInfo1View viewWithTag:FIELD_RADIO1_TAG];
    UIButton *radioButton2 = (UIButton *)[self.aadharInfo1View viewWithTag:FIELD_RADIO2_TAG];
    
    if (radioButton1.tag == btn.tag) {
        radioButton1.selected = YES;
        radioButton2.selected = NO;
        
        [self.aadharInfo2ViewHeight setConstant:0];
        [self.aadharInfo2View setHidden:YES];
    }
    else {
        radioButton1.selected = NO;
        radioButton2.selected = YES;
        
        [self.aadharInfo2ViewHeight setConstant:70];
        [self.aadharInfo2View setHidden:NO];
    }
}

- (IBAction)aadharInfo2ButtonAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    UIButton *radioButton1 = (UIButton *)[self.aadharInfo2View viewWithTag:FIELD_RADIO1_TAG];
    UIButton *radioButton2 = (UIButton *)[self.aadharInfo2View viewWithTag:FIELD_RADIO2_TAG];
    
    if (radioButton1.tag == btn.tag) {
        radioButton1.selected = YES;
        radioButton2.selected = NO;
    }
    else {
        radioButton1.selected = NO;
        radioButton2.selected = YES;
    }
}

- (IBAction)employmentTypeButtonAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    UIButton *radioButton1 = (UIButton *)[self.employmentTypeView viewWithTag:FIELD_RADIO1_TAG];
    UIButton *radioButton2 = (UIButton *)[self.employmentTypeView viewWithTag:FIELD_RADIO2_TAG];
    
    if (radioButton1.tag == btn.tag) {
        radioButton1.selected = YES;
        radioButton2.selected = NO;
    }
    else {
        radioButton1.selected = NO;
        radioButton2.selected = YES;
    }
}

- (IBAction)dobButtonAction:(id)sender {
    
    if (!datePicker) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *addComponents = [[NSDateComponents alloc] init];
        addComponents.year = - 18;
        
        datePicker = [[UIDatePicker alloc] init];
        datePicker.frame = CGRectMake(0, [AppDelegate instance].window.frame.size.height - 260, [AppDelegate instance].window.frame.size.width, 260);
        [datePicker setDate:[NSDate date]];
        [datePicker setMaximumDate:[calendar dateByAddingComponents:addComponents toDate:[NSDate date] options:0]];
        [datePicker setMinimumDate:[ApplicationUtils getRespectiveDate:@"1940-01-01"]];
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [datePicker addTarget:self action:@selector(updateDOBField:) forControlEvents:UIControlEventValueChanged];
        [datePicker setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:datePicker];
        datePicker.alpha = 0;
    }

    [ApplicationUtils fadeInOutView:1.0 duration:0.25 view:datePicker];
}

- (IBAction)salaryModeButtonAction:(UIButton *)sender {
    [self showDropDownListWithArray:salaryModeArray withTitle:@"Salary Mode" withSource:sender withTag:SALARY_MODE_TAG];
}

- (IBAction)stateButtonAction:(UIButton *)sender {
    [self showDropDownListWithArray:stateArray withTitle:@"State" withSource:sender withTag:STATE_TAG];
}

- (IBAction)cityButtonAction:(UIButton *)sender {
    [self showDropDownListWithArray:cityArray withTitle:@"City" withSource:sender withTag:CITY_TAG];
}

- (IBAction)occupiedSinceButtonAction:(UIButton *)sender {
    [self showDropDownListWithArray:occupiedSinceArray withTitle:@"Occupied Since" withSource:sender withTag:OCCUPIED_SINCE_TAG];
}

- (IBAction)residenceTypeButtonAction:(UIButton *)sender {
    [self showDropDownListWithArray:residenceTypeArray withTitle:@"Residence Type" withSource:sender withTag:RESIDENCE_TYPE_TAG];
}

- (IBAction)educationButtonAction:(UIButton *)sender {
    [self showDropDownListWithArray:educationArray withTitle:@"Highest Education" withSource:sender withTag:EDUCATION_TAG];
}

- (IBAction)designationButtonAction:(UIButton *)sender {
    [self showDropDownListWithArray:designationArray withTitle:@"Designation" withSource:sender withTag:DESIGNATION_TAG];
}

- (IBAction)totalExpButtonAction:(UIButton *)sender {
    [self showDropDownListWithArray:totalExpArray withTitle:@"Total Experience" withSource:sender withTag:TOTAL_EXP_TAG];
}

- (IBAction)workingSinceButtonAction:(UIButton *)sender {
    [self showDropDownListWithArray:workingSinceArray withTitle:@"Working Since" withSource:sender withTag:WORKING_SINCE_TAG];
}

- (IBAction)cameraAction:(id)sender {
    NSString *title;
    if (self.documentButton.selected) {
        title = NSLocalizedString(@"Upload Document",@"");
    }
    else {
        title = NSLocalizedString(@"Capture Photo",@"");
    }
    
    UIActionSheet *tActionSheet = [[UIActionSheet alloc]initWithTitle:title
                                                             delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"")
                                               destructiveButtonTitle:nil otherButtonTitles:
                                   NSLocalizedString(@"Gallery",@""),
                                   NSLocalizedString(@"Camera",@""),
                                   nil];
    tActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [tActionSheet showInView:self.view];
}

- (IBAction)nextButtonAction:(id)sender {
    if ([self checkValidationForBasic1Form]) {
        [self.basic2ScrollView setContentOffset:CGPointMake(0, 0)];
        [ApplicationUtils fadeInOutView:0.0 duration:0.25 view:self.basic1ScrollView];
        [ApplicationUtils fadeInOutView:1.0 duration:0.35 view:self.basic2ScrollView];
    }
}

- (IBAction)prevBasic2ButtonAction:(id)sender {
    [self.basic1ScrollView setContentOffset:CGPointMake(0, 0)];
    [ApplicationUtils fadeInOutView:0.0 duration:0.25 view:self.basic2ScrollView];
    [ApplicationUtils fadeInOutView:1.0 duration:0.35 view:self.basic1ScrollView];
}

- (IBAction)nextBasic2ButtonAction:(id)sender {
    if ([self checkValidationForBasic2Form]) {
        [self submitBasicDetailsForSignup];
    }
}

- (IBAction)nextProfessionalButtonAction:(id)sender {
    if ([self checkValidationForProfessionalForm]) {
        [self submitProfessionalDetails];
    }
}

- (IBAction)pfillDetailsButtonAction:(id)sender {
    [ApplicationUtils fadeInOutView:0.0 duration:0.25 view:self.processingView];
    [ApplicationUtils fadeInOutView:1.0 duration:0.35 view:self.professionalScrollView];
    
    [self setTopButtonSelected:self.basicButton isSelected:NO];
    [self setTopButtonSelected:self.professionalButton isSelected:YES];
}

- (IBAction)rGetCardButtonAction:(id)sender {
    [self.reProcessingLabel setText:@"Thank you for accepting the offer. We need some more information to get the card issued."];

    [ApplicationUtils fadeInOutView:0.0 duration:0.25 view:self.resultView];
    [ApplicationUtils fadeInOutView:1.0 duration:0.35 view:self.requestView];
}

- (IBAction)rRequestMoreButtonAction:(id)sender {
    [self.reProcessingLabel setText:@"We are processing your revision request. We need some more information to help out credit team."];

    [ApplicationUtils fadeInOutView:0.0 duration:0.25 view:self.resultView];
    [ApplicationUtils fadeInOutView:1.0 duration:0.35 view:self.requestView];
}

- (IBAction)sSignDocumentButtonAction:(id)sender {
    UIActionSheet *tActionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Capture Signature",@"")
                                                             delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"")
                                               destructiveButtonTitle:nil otherButtonTitles:
                                   NSLocalizedString(@"Gallery",@""),
                                   NSLocalizedString(@"Camera",@""),
                                   nil];
    tActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [tActionSheet showInView:self.view];
}

- (IBAction)reContinueButtonAction:(id)sender {
    [ApplicationUtils fadeInOutView:0.0 duration:0.25 view:self.requestView];
    [ApplicationUtils fadeInOutView:1.0 duration:0.35 view:self.professionalScrollView];
    
    [self setTopButtonSelected:self.basicButton isSelected:NO];
    [self setTopButtonSelected:self.professionalButton isSelected:YES];
}

- (IBAction)adpvCancelButtonAction:(id)sender {
    self.adpvNameTF.text = @"";
    [ApplicationUtils fadeInOutView:0.0 duration:0.35 view:self.addDocumentPopupView];
}

- (IBAction)adpvOKButtonAction:(id)sender {
    additionalDocumentName = self.adpvNameTF.text;
    [self adpvCancelButtonAction:self.adpvCancelButton];
    
    [self.documentTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.documentTableView reloadData];
    [self cameraAction:nil];
}

- (IBAction)documentDoneButtonAction:(id)sender {
    if (uploadedDocumetsCount > 0) {
        [ApplicationUtils fadeInOutView:0.0 duration:0.25 view:self.documentView];
        [ApplicationUtils fadeInOutView:1.0 duration:0.35 view:self.signatureVIew];
        
        [self setTopButtonSelected:self.documentButton isSelected:NO];
        [self setTopButtonSelected:self.signatureButton isSelected:YES];
    }
    else {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please upload atleast one document"];
    }
}

- (IBAction)fContinueButtonAction:(id)sender {
    [self getLoginDetailsFromServer];
}

- (IBAction)skipSignatureButtonAction:(id)sender {
    [ApplicationUtils fadeInOutView:0.0 duration:0.25 view:self.signatureVIew];
    [ApplicationUtils fadeInOutView:1.0 duration:0.35 view:self.finalView];
}

- (IBAction)authencicateLaterButtonAction:(id)sender {
    
    if ([[[ApplicationUtils validateStringData:bankPerfiosDic[@"statement_status"]] lowercaseString] isEqualToString:@"required"])
    {
        [AlertViewManager sharedManager].alertView =  [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Online banking is Mandatory!", nil)
                                                                                 message: NSLocalizedString(@"Banking verification is an important part of our process to ensure you get the best offer in terms of amount & rates. We may not able to get you approved without this step.", nil)
                                                                        cancelButtonItem:nil
                                                                        otherButtonItems:
                                                       [RIButtonItem itemWithLabel: NSLocalizedString(@"I'll DO THIS LATER", nil) action:^{
            
            [self navigateToDocumentUploadScreen];
        }],
                                                       [RIButtonItem itemWithLabel: NSLocalizedString(@"LETS DO IT NOW", nil) action:^{
            
            if (!bankPerfiosDic) {
                [self getBankStatementStatusFromServer];
            }
            else {
                [self loadPerfiosWebPage];
            }
            
        }], nil];
        [[AlertViewManager sharedManager].alertView show];
    }
    else {
        [self navigateToDocumentUploadScreen];
    }
}

- (void)navigateToDocumentUploadScreen {
    [ApplicationUtils fadeInOutView:0.0 duration:0.25 view:self.bankView];
    [ApplicationUtils fadeInOutView:1.0 duration:0.35 view:self.documentView];
    
    [self setTopButtonSelected:self.bankButton isSelected:NO];
    [self setTopButtonSelected:self.documentButton isSelected:YES];
    
    CGPoint bottomOffset = CGPointMake(self.topScrollView.contentSize.width - self.topScrollView.bounds.size.width, 0);
    [self.topScrollView setContentOffset:bottomOffset];
}

- (IBAction)rejectCloseButtonAction:(id)sender {
    [ApplicationUtils fadeInOutView:0.0 duration:0.25 view:self.rejectView];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    UITextField *ftf = (UITextField *)[self.fNameView viewWithTag:FIELD_TEXTFIELD_TAG];
    UITextField *ltf = (UITextField *)[self.lNameView viewWithTag:FIELD_TEXTFIELD_TAG];

    if (textField == ftf || textField == ltf) {
        NSString *newString = [[textField text] stringByReplacingCharactersInRange:range withString:string];

        if (textField == ftf) {
            [self updateCardNameWithFirstName:newString LastName:ltf.text];
        }
        else {
            [self updateCardNameWithFirstName:ftf.text LastName:newString];
        }
    }
    
    NSCharacterSet *cs = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    UITextField *tf = (UITextField *)[self.panView viewWithTag:FIELD_TEXTFIELD_TAG];
    
    if(textField == tf){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 10) ? NO : [string isEqualToString:filtered];
    }
    
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    UITextField *atf = (UITextField *)[self.aadharView viewWithTag:FIELD_TEXTFIELD_TAG];
    
    if(textField == atf){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 12) ? NO : [string isEqualToString:filtered];
    }
    
    UITextField *pintf = (UITextField *)[self.pincodeView viewWithTag:FIELD_TEXTFIELD_TAG];
    
    if(textField == pintf){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 6) ? NO : [string isEqualToString:filtered];
    }

    UITextField *landlinetf = (UITextField *)[self.officelandlineView viewWithTag:FIELD_TEXTFIELD_TAG];
    
    if(textField == landlinetf){
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 11) ? NO : [string isEqualToString:filtered];
    }

    return YES;
}

- (void)updateCardNameWithFirstName:(NSString *)fName LastName:(NSString *)lName {

    if (fName) {
        [self.cardNameLabel setText:[fName uppercaseString]];
    }
    if (lName) {
        [self.cardNameLabel setText:[[self.cardNameLabel.text stringByAppendingFormat:@" %@",lName] uppercaseString]];
    }
    
    [self.pcardNameLabel setText:self.cardNameLabel.text];
}

- (void)showDropDownListWithArray:(NSArray *)list withTitle:(NSString *)title withSource:(UIButton *)sender withTag:(NSInteger)tag {
    if (!vPopoverController) {
        SimpleListViewController *obj = [[SimpleListViewController alloc] initWithNibName:@"SimpleListViewController" bundle:nil];
        obj.preferredContentSize = CGSizeMake(220, 190);
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

    switch (tag) {
        case SALARY_MODE_TAG:
        {
            selectedSalaryModePosition = [NSString stringWithFormat:@"%ld",selectedOption+1];
            
            UIButton *button = (UIButton *)[self.salaryModeView viewWithTag:FIELD_DROPDWON_TAG];
            [button setTitle:salaryModeArray[selectedOption] forState:UIControlStateNormal];
        }
            break;
        case STATE_TAG:
        {
            if (self.professionalButton.selected) {
                UIButton *button = (UIButton *)[self.profstateView viewWithTag:FIELD_DROPDWON_TAG];
                [button setTitle:stateArray[selectedOption] forState:UIControlStateNormal];
                
                [self getCityListFromServerWithState:[button titleForState:UIControlStateNormal]];
                
                button = (UIButton *)[self.profcityView viewWithTag:FIELD_DROPDWON_TAG];
                [button setTitle:@"" forState:UIControlStateNormal];
            }
            else {
                UIButton *button = (UIButton *)[self.stateView viewWithTag:FIELD_DROPDWON_TAG];
                [button setTitle:stateArray[selectedOption] forState:UIControlStateNormal];
                
                [self getCityListFromServerWithState:[button titleForState:UIControlStateNormal]];

                button = (UIButton *)[self.cityView viewWithTag:FIELD_DROPDWON_TAG];
                [button setTitle:@"" forState:UIControlStateNormal];
            }
        }
            break;
        case CITY_TAG:
        {
            if (self.professionalButton.selected) {
                UIButton *button = (UIButton *)[self.profcityView viewWithTag:FIELD_DROPDWON_TAG];
                [button setTitle:cityArray[selectedOption] forState:UIControlStateNormal];
            }
            else {
                UIButton *button = (UIButton *)[self.cityView viewWithTag:FIELD_DROPDWON_TAG];
                [button setTitle:cityArray[selectedOption] forState:UIControlStateNormal];
            }
        }
            break;
        case OCCUPIED_SINCE_TAG:
        {
            UIButton *button = (UIButton *)[self.occupiedsinceView viewWithTag:FIELD_DROPDWON_TAG];
            [button setTitle:occupiedSinceArray[selectedOption] forState:UIControlStateNormal];
        }
            break;
        case RESIDENCE_TYPE_TAG:
        {
            selectedResidenceTypePosition = [NSString stringWithFormat:@"%ld",selectedOption+1];

            UIButton *button = (UIButton *)[self.residencesinceView viewWithTag:FIELD_DROPDWON_TAG];
            [button setTitle:residenceTypeArray[selectedOption] forState:UIControlStateNormal];
        }
            break;
        case EDUCATION_TAG:
        {
            selectedEducationPosition = [NSString stringWithFormat:@"%ld",selectedOption+1];
            
            UIButton *button = (UIButton *)[self.educationView viewWithTag:FIELD_DROPDWON_TAG];
            [button setTitle:educationArray[selectedOption] forState:UIControlStateNormal];
        }
            break;
        case DESIGNATION_TAG:
        {
            selectedDesignationPosition = [NSString stringWithFormat:@"%ld",selectedOption+1];

            UIButton *button = (UIButton *)[self.designationView viewWithTag:FIELD_DROPDWON_TAG];
            [button setTitle:designationArray[selectedOption] forState:UIControlStateNormal];
        }
            break;
        case TOTAL_EXP_TAG:
        {
            UIButton *button = (UIButton *)[self.totalExpView viewWithTag:FIELD_DROPDWON_TAG];
            [button setTitle:totalExpArray[selectedOption] forState:UIControlStateNormal];
        }
            break;
        case WORKING_SINCE_TAG:
        {
            UIButton *button = (UIButton *)[self.workingsinceView viewWithTag:FIELD_DROPDWON_TAG];
            [button setTitle:workingSinceArray[selectedOption] forState:UIControlStateNormal];
        }
            break;

        default:
            break;
    }
}

#pragma mark - Date Picker Method Call

-(void)updateDOBField:(id)sender
{
    UIButton *dob = [self.dobView viewWithTag:FIELD_DROPDWON_TAG];
    [dob setTitle:[ApplicationUtils getDateStringFromDate:datePicker.date withOutputFormat:DATE_FORMAT_DOB] forState:UIControlStateNormal];
    [ApplicationUtils fadeInOutView:0.0 duration:0.25 view:datePicker];
}

#pragma mark - DDPageControl triggered actions

- (void)pageControlClicked:(id)sender{
    
    DDPageControl *thePageControl = (DDPageControl *)sender;
    // we need to scroll to the new index
    [self.sScrollView setContentOffset: CGPointMake(self.sScrollView.bounds.size.width * thePageControl.currentPage, self.sScrollView.contentOffset.y) animated:YES];
}

#pragma mark - UIScroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView{
    // any offset changes
    CGFloat pageWidth = aScrollView.bounds.size.width;
    float fractionalPage = aScrollView.contentOffset.x / pageWidth;
    NSInteger nearestNumber = lround(fractionalPage);
    if (self.pageControl.currentPage != nearestNumber){
        self.pageControl.currentPage = nearestNumber ;
        // if we are dragging, we want to update the page control directly during the drag
        if (aScrollView.dragging)
            [self.pageControl updateCurrentPageDisplay] ;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView{
    // if we are animating (triggered by clicking on the page control), we update the page control
    [self.pageControl updateCurrentPageDisplay] ;
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
    
    UIImage *compressedImage = [ApplicationUtils compressImage:image compressRatio:0.5];
    imageBase64String = [NSString stringWithFormat:@"data:image/jpg;base64,%@",[ApplicationUtils encodeToBase64String:compressedImage compressionQuality:0.5]];

    [picker dismissViewControllerAnimated:YES completion:^{
        
        if (self.signatureButton.selected) {
            [self serverCallForUploadSignatureWithImageString:imageBase64String];
        }
        else if (self.documentButton.selected) {
            [self serverCallForDocUploadWithImageString:imageBase64String];
        }
        else {
            isProfilePicSelected = YES;
            [self.userImageView setImage:image];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -  Tableview Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return otherUploadedDocuments.count+7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DocUploadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DocUploadCell"];
    
    if (!cell)
    {
        [self.documentTableView registerNib:[UINib nibWithNibName:@"DocUploadCell" bundle:nil] forCellReuseIdentifier:@"DocUploadCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"DocUploadCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell.uploadLbl setFont:[ApplicationUtils GETFONT_MEDIUM:18]];
    
    cell.uploadBtn.tag = 1000+indexPath.row;
    [cell.uploadBtn addTarget:self action:@selector(uploadDocumentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setUploadedDocumentStatusWithCell:cell withRow:indexPath.row];

    return cell;
}

- (void)setUploadedDocumentStatusWithCell:(DocUploadCell *)cell withRow:(NSInteger)row {
  
    NSDictionary *docs = self.uploadedDocsDic[@"docs"];
    NSDictionary *otherdocs = @{};
    NSString *key = @"";
    NSInteger lastIndex = otherUploadedDocuments.count+6;

    if (row >= 6 && row != lastIndex) {
       otherdocs = otherUploadedDocuments[row-6];
    }
    
    if (row == 0) {
        cell.uploadLbl.text = @"PAN Card";
        key = @"pan_proof";
    }
    else if (row == 1) {
        cell.uploadLbl.text = @"Aadhar Card (front)";
        key = @"id_proof";
    }
    else if (row == 2) {
        cell.uploadLbl.text = @"Aadhar Card (back)";
        key = @"address_proof";
    }
    else if (row == 3) {
        cell.uploadLbl.text = @"Salary Slip1";
        key = @"salary_slip1";
    }
    else if (row == 4) {
        cell.uploadLbl.text = @"Salary Slip2";
        key = @"salary_slip2";
    }
    else if (row == 5) {
        cell.uploadLbl.text = @"Salary Slip3";
        key = @"salary_slip3";
    }
    else if (row == lastIndex) {
        cell.uploadLbl.text = @"Any Other Document";
    }
    else {
        cell.uploadLbl.text = otherdocs[@"document_name"];
        key = @"document_path";
    }
    
    if ([ApplicationUtils validateStringData:docs[key]].length || [ApplicationUtils validateStringData:otherdocs[key]].length) {
        uploadedDocumetsCount++;

        cell.uploadLbl.textColor = ROSE_PINK_COLOR;
        cell.checkBtn.selected = YES;
        cell.uploadBtn.selected = YES;
    }
    else {
        cell.uploadLbl.textColor = [UIColor lightGrayColor];
        cell.checkBtn.selected = NO;
        cell.uploadBtn.selected = NO;
    }
}

- (void)uploadDocumentButtonClicked:(UIButton *)sender {
    selectedDocument = sender.tag-1000;
    NSInteger lastIndex = otherUploadedDocuments.count+6;
    
    if (selectedDocument >= 6 && selectedDocument != lastIndex) {
        NSDictionary *otherdocs = otherUploadedDocuments[selectedDocument-6];
        selectedDocID = [ApplicationUtils validateStringData:otherdocs[@"id"]];
        additionalDocumentName = [ApplicationUtils validateStringData:otherdocs[@"document_name"]];
    }
    
    if (selectedDocument == lastIndex) {
        selectedDocID = @"";
        [ApplicationUtils fadeInOutView:1.0 duration:0.35 view:self.addDocumentPopupView];
    }
    else {
        [self cameraAction:nil];
    }
}

#pragma mark - Check Validations

- (BOOL)checkValidationForBasic1Form {
    UITextField *tf = (UITextField *)[self.fNameView viewWithTag:FIELD_TEXTFIELD_TAG];
    
    if (![ApplicationUtils validateStringData:tf.text].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter first name"];
        return NO;
    }
    
    tf = (UITextField *)[self.lNameView viewWithTag:FIELD_TEXTFIELD_TAG];
    
    if (![ApplicationUtils validateStringData:tf.text].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter last name"];
        return NO;
    }
    
    UIButton *dob = [self.dobView viewWithTag:FIELD_DROPDWON_TAG];
    
    if (![ApplicationUtils validateStringData:[dob titleForState:UIControlStateNormal]].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please select date of birth"];
        return NO;
    }

    tf = (UITextField *)[self.emailView viewWithTag:FIELD_TEXTFIELD_TAG];
    
    if (![ApplicationUtils validateStringData:tf.text].length || ![tf.text isEmail]) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter valid email"];
        return NO;
    }
    
    tf = (UITextField *)[self.passwordView viewWithTag:FIELD_TEXTFIELD_TAG];
    
    if ([ApplicationUtils validateStringData:tf.text].length < 8) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Password should be minimum 8 digit length"];
        return NO;
    }

    tf = (UITextField *)[self.panView viewWithTag:FIELD_TEXTFIELD_TAG];
    
    if (![ApplicationUtils validateStringData:tf.text].length || ![tf.text validatePAN]) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter valid PAN number"];
        return NO;
    }
    
    tf = (UITextField *)[self.aadharView viewWithTag:FIELD_TEXTFIELD_TAG];
    
    if (![ApplicationUtils validateStringData:tf.text].length || ![tf.text validateAadhar]) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter valid Aadhar number"];
        return NO;
    }
    
    if (!isProfilePicSelected) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please capture your profile pic"];
        return NO;
    }
    
    return YES;
}

- (BOOL)checkValidationForBasic2Form {
    UITextField *tf = (UITextField *)[self.companyView viewWithTag:FIELD_TEXTFIELD_TAG];
    
    if (![ApplicationUtils validateStringData:tf.text].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter company name"];
        return NO;
    }
    
    tf = (UITextField *)[self.salaryView viewWithTag:FIELD_TEXTFIELD_TAG];
    
    if (![ApplicationUtils validateStringData:tf.text].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter monthly salary"];
        return NO;
    }
    
    UIButton *lov = [self.salaryModeView viewWithTag:FIELD_DROPDWON_TAG];
    
    if (![ApplicationUtils validateStringData:[lov titleForState:UIControlStateNormal]].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please select salary mode"];
        return NO;
    }
    
    tf = (UITextField *)[self.addressView viewWithTag:FIELD_TEXTFIELD_TAG];
    
    if (![ApplicationUtils validateStringData:tf.text].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter address"];
        return NO;
    }

    lov = [self.stateView viewWithTag:FIELD_DROPDWON_TAG];
    
    if (![ApplicationUtils validateStringData:[lov titleForState:UIControlStateNormal]].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please select state"];
        return NO;
    }
    
    lov = [self.cityView viewWithTag:FIELD_DROPDWON_TAG];
    
    if (![ApplicationUtils validateStringData:[lov titleForState:UIControlStateNormal]].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please select city"];
        return NO;
    }
    
    tf = (UITextField *)[self.pincodeView viewWithTag:FIELD_TEXTFIELD_TAG];
    
    if (![ApplicationUtils validateStringData:tf.text].length || ![tf.text isNumeric]) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter valid pin code"];
        return NO;
    }
    
    lov = [self.occupiedsinceView viewWithTag:FIELD_DROPDWON_TAG];
    
    if (![ApplicationUtils validateStringData:[lov titleForState:UIControlStateNormal]].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please select occupied since"];
        return NO;
    }
    
    lov = [self.residencesinceView viewWithTag:FIELD_DROPDWON_TAG];
    
    if (![ApplicationUtils validateStringData:[lov titleForState:UIControlStateNormal]].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please select residence type"];
        return NO;
    }

    return YES;
}

- (BOOL)checkValidationForProfessionalForm {
    UIButton *lov = [self.educationView viewWithTag:FIELD_DROPDWON_TAG];
    
    if (![ApplicationUtils validateStringData:[lov titleForState:UIControlStateNormal]].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please select highest education"];
        return NO;
    }

    lov = [self.designationView viewWithTag:FIELD_DROPDWON_TAG];
    
    if (![ApplicationUtils validateStringData:[lov titleForState:UIControlStateNormal]].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please select designation"];
        return NO;
    }

    lov = [self.totalExpView viewWithTag:FIELD_DROPDWON_TAG];
    
    if (![ApplicationUtils validateStringData:[lov titleForState:UIControlStateNormal]].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please select total experience"];
        return NO;
    }
    
    lov = [self.workingsinceView viewWithTag:FIELD_DROPDWON_TAG];
    
    if (![ApplicationUtils validateStringData:[lov titleForState:UIControlStateNormal]].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please select working since"];
        return NO;
    }
    
    UITextField *tf = (UITextField *)[self.officialemailView viewWithTag:FIELD_TEXTFIELD_TAG];
    
    if (![ApplicationUtils validateStringData:tf.text].length || ![tf.text isEmail]) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter office email"];
        return NO;
    }
//
//    tf = (UITextField *)[self.officelandlineView viewWithTag:FIELD_TEXTFIELD_TAG];
//
//    if (![ApplicationUtils validateStringData:tf.text].length) {
//        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter office landline"];
//        return NO;
//    }

    tf = (UITextField *)[self.officeaddressView viewWithTag:FIELD_TEXTFIELD_TAG];
    
    if (![ApplicationUtils validateStringData:tf.text].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter office address"];
        return NO;
    }
    
    lov = [self.profstateView viewWithTag:FIELD_DROPDWON_TAG];
    
    if (![ApplicationUtils validateStringData:[lov titleForState:UIControlStateNormal]].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please select state"];
        return NO;
    }
    
    lov = [self.profcityView viewWithTag:FIELD_DROPDWON_TAG];
    
    if (![ApplicationUtils validateStringData:[lov titleForState:UIControlStateNormal]].length) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please select city"];
        return NO;
    }
    
    tf = (UITextField *)[self.profpincodeView viewWithTag:FIELD_TEXTFIELD_TAG];
    
    if (![ApplicationUtils validateStringData:tf.text].length || ![tf.text isNumeric]) {
        [ApplicationUtils showAlertWithTitle:@"" andMessage:@"Please enter valid pin code"];
        return NO;
    }
    
    return YES;
}

#pragma mark - UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *url = [[request URL] absoluteString];
    
    //prevent loading URL if it is the redirectURL
    NSArray *arr = [[ApplicationUtils validateStringData:bankPerfiosDic[@"return_url"]] componentsSeparatedByString:@"/"];
    BOOL handlingRedirectURL = [url hasSuffix:[arr lastObject]];
    
    if (handlingRedirectURL) {
        [self navigateToDocumentUploadScreen];
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    // Turn off network activity indicator upon failure to load web view
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // Turn off network activity indicator upon finishing web view load
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)startActivityIndicator {
    // Turn on network activity indicator upon starting web view load
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

#pragma mark - Service

- (void)getLoginDetailsFromServer
{
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"getLoginData"     forKey:@"mode"];
    [dictParam setValue:@"iOS"              forKey:@"device_type"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            [AlertViewManager sharedManager].alertView =  [[UIAlertView alloc] initWithTitle:@""
                                                                                     message:response
                                                                            cancelButtonItem:nil
                                                                            otherButtonItems:
                                                           [RIButtonItem itemWithLabel: NSLocalizedString(@"Ok", nil) action:^{
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                EmailLoginViewController *obj = [storyboard instantiateViewControllerWithIdentifier:@"EmailLoginViewController"];
                [self.navigationController popViewControllerAnimated:NO];
                [[AppDelegate instance].homeNavigationControler pushViewController:obj animated:YES];

            }], nil];
            [[AlertViewManager sharedManager].alertView show];
        }
        else {
            //Navigate to Home
            [[AppDelegate instance] navigateToHomeVC:response];
        }
    }];
}

- (void)serverCallForUploadSignatureWithImageString:(NSString *)imageString
{
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"uploadDocument"   forKey:@"mode"];
    [dictParam setValue:imageString         forKey:@"image"];
    [dictParam setValue:@"signature"        forKey:@"document_name"];
    [dictParam setValue:@""                 forKey:@"docId"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
        }
        else {
            [ApplicationUtils showMessage:@"Signature uploaded successfully" withTitle:@"" onView:self.view];
            [ApplicationUtils fadeInOutView:0.0 duration:0.25 view:self.signatureVIew];
            [ApplicationUtils fadeInOutView:1.0 duration:0.35 view:self.finalView];
        }
    }];
}

- (void)serverCallForDocUploadWithImageString:(NSString *)imageString
{
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"uploadDocument"           forKey:@"mode"];
    [dictParam setValue:imageString                 forKey:@"image"];

    switch (selectedDocument) {
        case 0:
        {
            [dictParam setValue:@"pan_proof"        forKey:@"document_name"];
            [dictParam setValue:@""                 forKey:@"docId"];
        }
            break;
        case 1:
        {
            [dictParam setValue:@"id_proof"         forKey:@"document_name"];
            [dictParam setValue:@"6"                forKey:@"docId"];
        }
            break;
        case 2:
        {
            [dictParam setValue:@"address_proof"    forKey:@"document_name"];
            [dictParam setValue:@"1"                forKey:@"docId"];
        }
            break;
        case 3:
        {
            [dictParam setValue:@"salary_slip1"     forKey:@"document_name"];
            [dictParam setValue:@""                 forKey:@"docId"];
        }
            break;
        case 4:
        {
            [dictParam setValue:@"salary_slip2"     forKey:@"document_name"];
            [dictParam setValue:@""                 forKey:@"docId"];
        }
            break;
        case 5:
        {
            [dictParam setValue:@"salary_slip3"     forKey:@"document_name"];
            [dictParam setValue:@""                 forKey:@"docId"];
        }
            break;
            
        default:
        {
            [dictParam setValue:@"uploadOtherDocument"  forKey:@"mode"];
            [dictParam setValue:additionalDocumentName  forKey:@"document_name"];
            [dictParam setValue:selectedDocID           forKey:@"docId"];
        }
            break;
    }
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
        }
        else {
            if (selectedDocument >= 6) {
                
                NSUInteger index = [otherUploadedDocuments indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                    if ([obj[@"id"] isEqualToString:[ApplicationUtils validateStringData:response[@"id"]]]) {
                        *stop = YES;
                        return YES;
                    }
                    return NO;
                }];
                
                if (index != NSNotFound) {
                    NSDictionary *dic = otherUploadedDocuments[index];
                    NSDictionary *tempDic = @{
                                              @"document_name" : [ApplicationUtils validateStringData:dic[@"document_name"]],
                                              @"id" : [ApplicationUtils validateStringData:dic[@"id"]],
                                              @"document_path" : [ApplicationUtils validateStringData:response[@"file_url"]]
                                              };
                    [otherUploadedDocuments replaceObjectAtIndex:index withObject:tempDic];
                }
                else {
                    NSDictionary *tempDic = @{
                                              @"document_name" : additionalDocumentName,
                                              @"id" : [ApplicationUtils validateStringData:response[@"id"]],
                                              @"document_path" : [ApplicationUtils validateStringData:response[@"file_url"]]
                                              };
                    
                    [otherUploadedDocuments addObject:tempDic];
                }
                [self.documentTableView reloadData];
            }
            else {
                [self serverCallForDocDetail];
            }
        }
    }];
}

- (void)serverCallForDocDetail
{
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"documentsFormDetails"   forKey:@"mode"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
        }
        else {
            self.uploadedDocsDic = [NSDictionary dictionaryWithDictionary:response];
            otherUploadedDocuments = [NSMutableArray arrayWithArray:self.uploadedDocsDic[@"other_selected_docs"]];
            [self.documentTableView reloadData];
        }
    }];
}

- (void)getStateListFromServer {
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"getStates"   forKey:@"mode"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:NO withHudBgView:self.view withCompletion:^(id response) {
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
        }
        else {
            stateDataArray = [NSMutableArray arrayWithArray:response[@"states"]];
            stateArray = [NSMutableArray arrayWithArray:[response[@"states"] valueForKey:@"state_name"]];
        }
    }];
}

- (void)getCityListFromServerWithState:(NSString *)statename {
    [cityArray removeAllObjects];
    [cityDataArray removeAllObjects];

    NSUInteger stateIndex = [stateDataArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"state_name"] isEqualToString:statename]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    
    if (stateIndex != NSNotFound) {
        
        NSDictionary *stateDic = stateDataArray[stateIndex];
        
        NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
        [dictParam setValue:@"getCities"        forKey:@"mode"];
        [dictParam setValue:stateDic[@"id"]     forKey:@"state_id"];
        
        [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
            if ([[response class] isSubclassOfClass:[NSString class]]) {
                [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
            }
            else {
                cityDataArray = [NSMutableArray arrayWithArray:response[@"cities"]];
                cityArray = [NSMutableArray arrayWithArray:[response[@"cities"] valueForKey:@"city_name"]];
            }
        }];
    }
}

/* RegisterAppCustomer sevice
 "device_id" = 775616754512610;
 number = 9535653595
 OTP = 
 {
 "auth_token" = 37105ad9266768a567e24f557cb3cc99b3b6e075c6c74a219a30c175bdf3cd05;
 customerID = 95255;
 loanID = 108149;
 "loan_status" = "Incomplete Application";
 }
 */

/*
 {
 "status": false,
 "loan_status": "Under Processing"
 }
 */

- (void)checkPreApprovalFromServer {
    
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"checkPreapproval"             forKey:@"mode"];

    [ServerCall getServerResponseWithParameters:dictParam withHUD:NO withHudBgView:self.view withCompletion:^(id response) {
        
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            [indicatorView stopAnimating];
            [indicatorView removeFromSuperview];

            [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
        }
        else {
            if ([[[ApplicationUtils validateStringData:response[@"loan_status"]] lowercaseString] hasPrefix:@"rejected"]) {
                [indicatorView stopAnimating];
                [indicatorView removeFromSuperview];

                [ApplicationUtils fadeInOutView:0.0 duration:0.25 view:self.processingView];
                [ApplicationUtils fadeInOutView:1.0 duration:0.35 view:self.rejectView];
            }
            else {
                if ([[ApplicationUtils validateStringData:response[@"status"]] boolValue]) {
                    [indicatorView stopAnimating];
                    [indicatorView removeFromSuperview];

                    [self.ramountLabel setText:[ApplicationUtils validateStringData:response[@"offer_amount"]]];
                    [self.ramountLabel setText:[ApplicationUtils validateStringData:response[@"offer_tenure"]]];

                    [ApplicationUtils fadeInOutView:0.0 duration:0.25 view:self.processingView];
                    [ApplicationUtils fadeInOutView:1.0 duration:0.35 view:self.resultView];
                }
                else {
                    if (self.processingView.alpha == 1.0) {
                        [self performSelector:@selector(checkPreApprovalFromServer) withObject:nil afterDelay:30];
                        [self.pminuteLabel setText:@"It is taking us time to get your offer ready. You may continue to fill other parts of the application."];
                    }
                }
            }
        }
    }];
}

- (void)getBankStatementStatusFromServer {
    
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"getBankStatementStatus"       forKey:@"mode"];

    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
        if (![[response class] isSubclassOfClass:[NSString class]])
        {
            bankPerfiosDic = [NSDictionary dictionaryWithDictionary:response];
            [self loadPerfiosWebPage];
        }
    }];
}

- (void)loadPerfiosWebPage
{    
    if ([ApplicationUtils validateStringData:bankPerfiosDic[@"link"]].length != 0)
    {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[ApplicationUtils validateStringData:bankPerfiosDic[@"link"]]]]];
        [self performSelector:@selector(startActivityIndicator) withObject:nil afterDelay:0.2];
    }
    else {
        [self navigateToDocumentUploadScreen];
    }
}

- (IBAction)reloadPerfiosPageButtonAction:(id)sender {
    [self getBankStatementStatusFromServer];
}

- (void)submitBasicDetailsForSignup {
    
    UIButton *genderButton = (UIButton *)[self.genderView viewWithTag:FIELD_RADIO1_TAG];
    UIButton *dob = [self.dobView viewWithTag:FIELD_DROPDWON_TAG];

    UITextField *numbertf = (UITextField *)[self.mobileView viewWithTag:FIELD_TEXTFIELD_TAG];
    UITextField *emailtf = (UITextField *)[self.emailView viewWithTag:FIELD_TEXTFIELD_TAG];
    UITextField *passwordtf = (UITextField *)[self.passwordView viewWithTag:FIELD_TEXTFIELD_TAG];
    UITextField *pantf = (UITextField *)[self.panView viewWithTag:FIELD_TEXTFIELD_TAG];
    UITextField *aadhartf = (UITextField *)[self.aadharView viewWithTag:FIELD_TEXTFIELD_TAG];
    UITextField *referralcodetf = (UITextField *)[self.referralcodeView viewWithTag:FIELD_TEXTFIELD_TAG];

    UITextField *companytf = (UITextField *)[self.companyView viewWithTag:FIELD_TEXTFIELD_TAG];
    UITextField *salarytf = (UITextField *)[self.salaryView viewWithTag:FIELD_TEXTFIELD_TAG];
    UITextField *addresstf = (UITextField *)[self.addressView viewWithTag:FIELD_TEXTFIELD_TAG];
    UITextField *landmarktf = (UITextField *)[self.landmarkView viewWithTag:FIELD_TEXTFIELD_TAG];
    UITextField *pintf = (UITextField *)[self.pincodeView viewWithTag:FIELD_TEXTFIELD_TAG];

    NSString *socialsource = ([ApplicationUtils validateStringData:self.prefilledDic[SOCIAL_SOURCE]].length ? [ApplicationUtils validateStringData:self.prefilledDic[SOCIAL_SOURCE]] : @"email");
    NSString *socialID = ([ApplicationUtils validateStringData:self.prefilledDic[SOCIAL_ID]].length ? [ApplicationUtils validateStringData:self.prefilledDic[SOCIAL_ID]] : @"socialid");
    NSString *socialProfilePic = ([ApplicationUtils validateStringData:self.prefilledDic[PROFILE_IMAGE_KEY]].length ? [ApplicationUtils validateStringData:self.prefilledDic[PROFILE_IMAGE_KEY]] : @"ProfilePic");
    NSString *socialProfileLink = ([ApplicationUtils validateStringData:self.prefilledDic[PROFILE_IMAGE_KEY]].length ? [ApplicationUtils validateStringData:self.prefilledDic[PROFILE_IMAGE_KEY]] : @"ProfileLink");

    UIButton *aadharRegisteredButton = (UIButton *)[self.aadharInfo1View viewWithTag:FIELD_RADIO1_TAG];
    UIButton *empTypeButton = (UIButton *)[self.employmentTypeView viewWithTag:FIELD_RADIO1_TAG];
    UIButton *occupiedsinceButton = (UIButton *)[self.occupiedsinceView viewWithTag:FIELD_DROPDWON_TAG];
    UIButton *cityButton = (UIButton *)[self.cityView viewWithTag:FIELD_DROPDWON_TAG];
    
    NSString *utm_source = @"iOS";
    NSString *utm_medium = @"";
    NSString *utm_content = @"";
    NSString *utm_term = @"";
    NSString *utm_campaign = @"";
    NSString *card_number = @"0000000000000000";

    if ([referralcodetf.text length]) {
        utm_source = referralcodetf.text;
    }

    if (self.cardScanDic) {
        card_number = [ApplicationUtils validateStringData:self.cardScanDic[@"card"][@"cardNo"]];
        
        NSDictionary *campaignDic = self.cardScanDic[@"campaign"];

        if (campaignDic && campaignDic.count) {
            utm_source = [ApplicationUtils validateStringData:campaignDic[@"utm_source"]];
            utm_medium = [ApplicationUtils validateStringData:campaignDic[@"utm_medium"]];
            utm_content = [ApplicationUtils validateStringData:campaignDic[@"utm_content"]];
            utm_term = [ApplicationUtils validateStringData:campaignDic[@"utm_term"]];
            utm_campaign = [ApplicationUtils validateStringData:campaignDic[@"utm_campaign"]];
        }
    }
    
    NSDictionary *dictParam = @{
                                @"mode"                              :@"RegisterAppCustomer",
                                @"name"                              :self.cardNameLabel.text,
                                @"gender"                            :(genderButton.selected ? @"m":@"f"),
                                @"number"                            :numbertf.text,
                                @"email"                             :emailtf.text,
                                @"password_code"                     :[ApplicationUtils md5:passwordtf.text],
                                @"pan"                               :pantf.text,
                                @"aadhaar"                           :aadhartf.text,
                                @"dob"                               :[dob titleForState:UIControlStateNormal],
                                @"image"                             :imageBase64String,
                                @"social_source"                     :socialsource,
                                @"social_id"                         :socialID,
                                @"social_profile_pic"                :socialProfilePic,
                                @"social_profile_link"               :socialProfileLink,
                                @"utm_source"                        :utm_source,
                                @"utm_medium"                        :utm_medium,
                                @"utm_term"                          :utm_term,
                                @"utm_content"                       :utm_content,
                                @"card"                              :card_number,
                                @"referral_code"                     :referralcodetf.text,
                                @"is_aadhar_registered_number"       :(aadharRegisteredButton.selected ? @"1":@"0"),
                                @"device_id"                         :[ApplicationUtils getDeviceID],
                                @"emp_type"                          :(empTypeButton.selected ? @"salaried":@"self employed"),
                                @"company"                           :companytf.text,
                                @"salary"                            :salarytf.text,
                                @"address"                           :addresstf.text,
                                @"current_address_landmark"          :landmarktf.text,
                                @"pin"                               :pintf.text,
                                @"city_id"                           :[cityButton titleForState:UIControlStateNormal],
                                @"occupied_since"                    :[occupiedsinceButton titleForState:UIControlStateNormal],
                                @"salary_mode"                       :selectedSalaryModePosition,
                                @"ownership_type_id"                 :selectedResidenceTypePosition
                                };
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
        if ([[response class] isSubclassOfClass:[NSString class]]) {
            [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
        }
        else {
            [ApplicationUtils fadeInOutView:0.0 duration:0.25 view:self.basic2ScrollView];
            [ApplicationUtils fadeInOutView:1.0 duration:0.35 view:self.professionalScrollView];
            
            [self setTopButtonSelected:self.basicButton isSelected:NO];
            [self setTopButtonSelected:self.professionalButton isSelected:YES];

//            [ApplicationUtils fadeInOutView:0.0 duration:0.25 view:self.basic2ScrollView];
//            [ApplicationUtils fadeInOutView:1.0 duration:0.35 view:self.processingView];
//
//            CGPoint center = self.penjoyLabel.center;
//            center.y += 25;
//
//            indicatorView = [[UIActivityIndicatorView alloc] init];
//            indicatorView.center = center;
//            indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//            [self.processingView addSubview:indicatorView];
//            [indicatorView startAnimating];
//
//            [ApplicationUtils save:[ApplicationUtils validateStringData:response[@"auth_token"]] :@"auth_token"];
//
//            [self performSelector:@selector(checkPreApprovalFromServer) withObject:nil afterDelay:45.0];
        }
    }];
}

- (void)submitProfessionalDetails {
    
    UIButton *totalExp = [self.totalExpView viewWithTag:FIELD_DROPDWON_TAG];
    UIButton *workingsince = [self.workingsinceView viewWithTag:FIELD_DROPDWON_TAG];
    UIButton *cityButton = (UIButton *)[self.profcityView viewWithTag:FIELD_DROPDWON_TAG];

    UITextField *emailtf = (UITextField *)[self.officialemailView viewWithTag:FIELD_TEXTFIELD_TAG];
    UITextField *landlinetf = (UITextField *)[self.officelandlineView viewWithTag:FIELD_TEXTFIELD_TAG];
    UITextField *addresstf = (UITextField *)[self.officeaddressView viewWithTag:FIELD_TEXTFIELD_TAG];
    UITextField *landmarktf = (UITextField *)[self.officelandmarkView viewWithTag:FIELD_TEXTFIELD_TAG];
    UITextField *pintf = (UITextField *)[self.profpincodeView viewWithTag:FIELD_TEXTFIELD_TAG];
    
    NSDictionary *dictParam = @{
                                @"mode"                              :@"addProfessionalInfo",
                                @"designation_id"                    :selectedDesignationPosition,
                                @"total_experience"                  :[totalExp titleForState:UIControlStateNormal],
                                @"working_since"                     :[workingsince titleForState:UIControlStateNormal],
                                @"highest_education"                 :selectedEducationPosition,
                                @"office_address_landmark"           :landmarktf.text,
                                @"office_email_id"                   :emailtf.text,
                                @"office_phone"                      :landlinetf.text,
                                @"office_address"                    :addresstf.text,
                                @"office_pin"                        :pintf.text,
                                @"office_city"                       :[cityButton titleForState:UIControlStateNormal]
                                };
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
        if (response == nil || [[response class] isSubclassOfClass:[NSString class]]) {
            [ApplicationUtils showAlertWithTitle:@"" andMessage:response];
        }
        else {
            [ApplicationUtils fadeInOutView:0.0 duration:0.25 view:self.professionalScrollView];
            [ApplicationUtils fadeInOutView:1.0 duration:0.35 view:self.bankView];
            
            [self setTopButtonSelected:self.professionalButton isSelected:NO];
            [self setTopButtonSelected:self.bankButton isSelected:YES];
        }
    }];
}


@end
