//
//  SignupScreen.m
//  Stashfin
//
//  Created by Duke on 01/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "SignupScreen.h"
#import "SingleTableViewCell.h"
#import "salaryTableView.h"
#import "DoubleTableViewCell.h"
#import "UploadCell.h"
#import "CommonFunctions.h"
#import "UserServices.h"
#import "BasicInfo.h"
#import "City.h"
#import "Pickers.h"
#import "StateVC.h"
#import "LoanApplication.h"
#import "AppDelegate.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "EducationPicker.h"
#import "ProfessionalEducation.h"
#import "Utilities.h"
#import "StatusVC.h"
#import "LandingVC.h"

@interface SignupScreen ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
{
    AppDelegate *appDelegate;
    UserServices *userService;
    LoanApplication *loanApplicationObj, *serverLoanObj;
    EducationPicker *eduPicker;
    ProfessionalEducation *pfobj;
    BasicInfo *basicInfoModalObj;
    Pickers *pickerObj;
    City *cityObj;
    
    UIPickerView * picker;
    NSArray *basicInfoArray, *idDetailArray, *professionalArray, *docArray;
    
    NSMutableDictionary *basicInfoDic;
    NSMutableArray *marrCity, *pickerArr, *marrState, *marrIDProof, *marrAddress, *marrDocName, *marrDocTitle, *marrDocs, *marrOther;
    UITextField *selTextfield;
    UIDatePicker *datePickerView;
    int currentRow;
    UIDatePicker *date;
    UIImage *checkImage, *checkoffImage, *uploadActive, *uploadDeactive, *selectedImage;
    UIImagePickerController *imagePicker;
    UIButton *btnUpload;
    NSString *strDocID, *strDocName;
    BOOL isDocUpload, isOtpGenerate, isAddreesProof, isIdProof, isOtherDoc, isOtherPopUP, isDocPickDone;
    NSInteger selectedIndex, time, btnTag;
    NSTimer *timer;
    NSString *loanID, *strPhoneNo;
}

@property (weak, nonatomic) IBOutlet UITextField *txtOTP;
@property (weak, nonatomic) IBOutlet UITextField *txtOther;

@property (weak, nonatomic) IBOutlet UIButton *btnFirst;
@property (weak, nonatomic) IBOutlet UIButton *btnSecond;
@property (weak, nonatomic) IBOutlet UIButton *btnThird;
@property (weak, nonatomic) IBOutlet UIButton *btnFourth;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnVerify;
@property (weak, nonatomic) IBOutlet UIButton *btnResend;

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIView *viewOtpVerify;
@property (weak, nonatomic) IBOutlet UIView *viewProofPopUp;
@property (weak, nonatomic) IBOutlet UIView *viewOtherPopUp;

@property (weak, nonatomic) IBOutlet UITableView *signupTableview;
@property (weak, nonatomic) IBOutlet UITableView *tblOptions;


@property (weak, nonatomic) IBOutlet UILabel *basicinfoLbl;
@property (weak, nonatomic) IBOutlet UILabel *idDetailLbl;
@property (weak, nonatomic) IBOutlet UILabel *personalInfoLbl;
@property (weak, nonatomic) IBOutlet UILabel *docLbl;
@property (weak, nonatomic) IBOutlet UILabel *lblMobileNo;






@end

@implementation SignupScreen
@synthesize signupStep;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customInitialization];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupStateCityPin) name:@"scp" object:nil];
}
- (void)customInitialization
{
    checkImage = [UIImage imageNamed:@"check"];
    checkoffImage = [UIImage imageNamed:@"checkoff"];
    uploadDeactive = [UIImage imageNamed:@"upload"];
    uploadActive = [UIImage imageNamed:@"uploadBtn"];
    
    imagePicker = [[UIImagePickerController alloc] init];
    
    appDelegate = [AppDelegate sharedDelegate];
    userService = [[UserServices alloc]init];
    
    _viewOtpVerify.hidden = YES;
    _viewProofPopUp.hidden = YES;
    _viewOtherPopUp.hidden = YES;
    
    basicInfoDic = [NSMutableDictionary dictionary];
    
    isDocUpload = NO;
    isOtpGenerate = NO;
    selectedIndex = 0;
    
    _signupTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _signupTableview.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self setupView];

    if (signupStep > 1)
    {
        if (signupStep == 2 )
        {
            [ self serverCallToGetLoginData ];
        }
        
        [self setSignUpStepView];
    }
   
    
    
    [self.signupTableview reloadData];
    
    [ Utilities setBorderAndColor:_btnVerify ];
    [ Utilities setBorderAndColor:_btnResend ];

}

#pragma mark UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    selectedImage = [info valueForKey:UIImagePickerControllerEditedImage];
    
    if ( !isOtherDoc )
    {
        [ self serverCallForDocUpload ];
    }
    else
    {
        [ self serverCallForOtherDocUpload ];
    }
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}
- (void)setSignUpStepView
{
    switch (signupStep)
    {
        case idDetails:
        {
            _firstView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            [_btnFirst setBackgroundImage:[UIImage imageNamed:@"greenBtn"] forState:UIControlStateNormal];
            self.basicinfoLbl.textColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            [_btnSecond setBackgroundImage:[UIImage imageNamed:@"two"] forState:UIControlStateNormal];
            self.idDetailLbl.textColor = [UIColor blackColor];
            [ self serverCallForLoanApplication ];
            break;
        }
        case personalInfo:
        {
            _firstView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            [_btnFirst setBackgroundImage:[UIImage imageNamed:@"greenBtn"] forState:UIControlStateNormal];
            self.basicinfoLbl.textColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            
            _secondView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            [_btnSecond setBackgroundImage:[UIImage imageNamed:@"greenBtn"] forState:UIControlStateNormal];
            self.idDetailLbl.textColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            
            [_btnThird setBackgroundImage:[UIImage imageNamed:@"three"] forState:UIControlStateNormal];
            self.personalInfoLbl.textColor = [UIColor blackColor];
            [self professionalDetailsServiceCall];
            break;

        }
        case docUpload:
        {
            _firstView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            [_btnFirst setBackgroundImage:[UIImage imageNamed:@"greenBtn"] forState:UIControlStateNormal];
            self.basicinfoLbl.textColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            
            _secondView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            [_btnSecond setBackgroundImage:[UIImage imageNamed:@"greenBtn"] forState:UIControlStateNormal];
            self.idDetailLbl.textColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];

            _thirdView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            [_btnThird setBackgroundImage:[UIImage imageNamed:@"greenBtn"] forState:UIControlStateNormal];
            self.personalInfoLbl.textColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            
            [_btnFourth setBackgroundImage:[UIImage imageNamed:@"four"] forState:UIControlStateNormal];
            self.docLbl.textColor = [UIColor blackColor];
            isDocUpload = YES;
            [ self serverCallForDocDetail ];
            break;
        }
        default:
            break;
    }
    
    if (signupStep < 5)
    {
        if (signupStep == 4)
        {
            [ _btnNext setBackgroundImage:[UIImage imageNamed:@"register"] forState:UIControlStateNormal];
        }
        [self.signupTableview reloadData];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Instance Methods

-(void)setupView
{
//    signupStep = 1;
    NSDictionary *loanDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Loan Amount",@"First",@"Tenure in months",@"Second",nil];
    NSDictionary *dobDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Date of birth",@"First",@"Gender",@"Second",nil];
    NSDictionary *eduDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Linkedin",@"First",@"Education",@"Second",nil];
    NSDictionary *desDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Designation",@"First",@"Since",@"Second",nil];
    NSDictionary *expDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Total Exp",@"First",@"Official Email ID",@"Second",nil];
    
    basicInfoArray = [NSArray arrayWithObjects:@"First Name",@"Last Name",@"Email",@"Mobile Number",@"Company Name",@"check",@"Monthly Salary in Hand",@"City", nil];
   
    idDetailArray = [NSArray arrayWithObjects:loanDic,@"Select reason of Loan",dobDic,@"PAN Number",@"Aadhaar Number",@"Name in Aadhar Card",@"Salary",@"Select Salary Modes",@"Current Address",@"State, City, Pin",@"Select Occupied Since",@"Select Residence Type", nil];
    
    professionalArray = [NSArray arrayWithObjects:eduDic,@"Company Name",desDic,expDic,@"Office Landline No.",@"Office Address(State,City,Pin)", nil];
    
    docArray = [NSArray arrayWithObjects:@"PAN Card",@"ID Proof",@"Address Proof",@"Employee ID",@"Salary Slip 1",@"Salary Slip 2",@"Salary Slip 3",@"Office ID",@"Any other Document",@"Mention", nil];
  
    marrDocTitle = [[ NSMutableArray alloc ] initWithObjects:@"PAN Card",@"ID Proof",@"Address Proof",@"Employee ID",@"Salary Slip1",@"Salary Slip2",@"Salary Slip3",@"Office ID",nil];

    
    marrDocName = [[ NSMutableArray alloc ] initWithObjects:@"pan_proof",@"id_proof",@"address_proof",@"employee_id",@"salary_slip1",@"salary_slip2",@"salary_slip3",@"office_id",nil];

    marrDocs = [ NSMutableArray new ];
    marrOther = [ NSMutableArray new ];
    marrState = [NSMutableArray array];
    pickerArr = [NSMutableArray array];
    marrIDProof = [ NSMutableArray array ];
    marrAddress = [ NSMutableArray array ];
    marrCity = [[NSMutableArray alloc] initWithObjects:@"Delhi",@"Ghaziabad", @"Faridabad",@"Gurgaon",@"Noida",@"Banglore",@"Pune",nil ];

    isOtherDoc = NO;
    isAddreesProof = NO;
    isIdProof = NO;
    
//    marrCity = [NSMutableArray arrayWithObjects:@"PAN Card",@"ID Proof",@"Address Proof",@"Employee ID",@"Salary Slip 1",@"Salary Slip 2",@"Salary Slip 3",@"Office ID",@"Another Document",@"Mention", nil];

    
    // modal basic info initlization
    basicInfoModalObj = [[BasicInfo alloc]init];
    loanApplicationObj = [[LoanApplication alloc]init];
    serverLoanObj = [[LoanApplication alloc]init];
    cityObj = [[City alloc]init];
    pickerObj = [[Pickers alloc]init];
    eduPicker = [[EducationPicker alloc]init];
    pfobj = [[ProfessionalEducation alloc]init];
}

#pragma mark Button Action
- (IBAction)okAction:(id)sender
{
    selectedIndex = 0;
    NSDictionary *dict;
    
    if ( !isOtherDoc )
    {
        if ( isIdProof )
        {
            dict = [marrIDProof objectAtIndex:selectedIndex];
            strDocID = [NSString stringWithFormat:@"%d",[dict[@"id"] intValue]];
            strDocName = @"id_proof";
        }
        else if( isAddreesProof )
        {
            dict = [marrAddress objectAtIndex:selectedIndex];
            strDocID = [NSString stringWithFormat:@"%d",[dict[@"id"] intValue]];
            strDocName = @"address_proof";
        }
        
        [ Utilities hidePopupView:_viewProofPopUp fromViewController:self ];
    }
    else
    {
        if ( [_txtOther.text isEqualToString:@""] )
        {
            [ Utilities showAlertWithMessage:@"Enter document name" ];
        }
        else
        {
            strDocID = @"";
            strDocName = _txtOther.text;
            
            [ Utilities hidePopupView:_viewOtherPopUp fromViewController:self ];
            [ self.view endEditing:YES ];
        }
    }
    
    UIActionSheet *imagePop = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose From Library", nil];
    [imagePop showInView:self.view];
    
}
- (IBAction)popUpCancelAction:(id)sender
{
    selectedIndex = 0;
    [ self.view endEditing:YES ];
    
    if ( !isOtherDoc )
    {
        [ Utilities hidePopupView:_viewProofPopUp fromViewController:self ];
    }
    else
    {
        [ Utilities hidePopupView:_viewOtherPopUp fromViewController:self ];
    }

}
- (IBAction)backAAction:(id)sender
{
    NSArray *vcARray = self.navigationController.viewControllers;
    
    for ( UIViewController *vc in vcARray )
    {
        
        if ( [vc isKindOfClass:[ LandingVC class ]] )
        {
            [ self.navigationController popToViewController:vc animated:YES ];
            break;
        }
    }
}
- (IBAction)firstAction:(id)sender
{
    
}
- (IBAction)secondAction:(id)sender
{
    
}
- (IBAction)thirdAction:(id)sender
{
    
}
- (IBAction)fourthAction:(id)sender
{
    
}
- (IBAction)verifyAction:(id)sender
{
    [ self serverCallToSubmitOTP ];
}
- (IBAction)resendOtpAction:(id)sender
{
    [ self serverCallToGenerateOTP ];
}
- (IBAction)nextAction:(id)sender
{
     switch (signupStep)
    {
         case 1:
        {
             if([self performStepOneValidation])
             {
                 [self serverCallForBasicInfo];
             }
        }
            break;
        
        case 2:
        {
            if ( [self performStepTwoValidation] )
            {
                [self serverCallForSaveloanApplication];
            }
        }
            break;
        
        case 3:
        {
            if ( [self performStepThreeValidation] )
            {
                [self serverCallToSubmitProfessionDetails];
            }
        }
            break;
         case 4:
            
        {
            if ( isDocPickDone )
            {
                [ self serverCallToGetLoginData ];
            }
            else
            {
                [ Utilities showAlertWithMessage:@"Upload atleast one relevant document." ];
            }
        }
             break;
             
        default:
            break;
    }
}

- (void)updateUserInput:(UITextField *)txtInput
{
    switch (signupStep)
    {
            case 1:
            {
             NSArray *keysarr = [basicInfoModalObj giveKeysArray];
             NSString *key = [keysarr objectAtIndex:txtInput.tag];
             [basicInfoModalObj setValue:txtInput.text forKey:key];
            }
            break;
            
            case 2:
            {
         
                NSArray *loanKeys = [loanApplicationObj giveKeysArray];
                id key = [loanKeys objectAtIndex:txtInput.tag];
                if ([key isKindOfClass:[NSDictionary class]])
                {
                    if (txtInput.tag == 0)
                    {
                        [txtInput setKeyboardType:UIKeyboardTypeNumberPad];
                        if ([txtInput.placeholder isEqualToString:@"Loan Amount"])
                        {
                            [loanApplicationObj setValue:txtInput.text forKey:@"loanAmount"];
                            [serverLoanObj setValue:txtInput.text forKey:@"loanAmount"];
                        }
                        else
                        {
                            [loanApplicationObj setValue:txtInput.text forKey:@"tenure"];
                            [serverLoanObj setValue:txtInput.text forKey:@"tenure"];
                        }
                    }
                }
                else
                {
                    NSString *keyStr = (NSString *)key;
                    [loanApplicationObj setValue:txtInput.text forKey:keyStr];
                    [serverLoanObj setValue:txtInput.text forKey:keyStr];
                    
                }
            }
              break;
            
            case 3:
            {
                NSArray *profKeys = [pfobj giveprofKeysArray];
                id key = [profKeys objectAtIndex:txtInput.tag];
                if ([key isKindOfClass:[NSDictionary class]])
                {
                    if (txtInput.tag == 0)
                    {
                        if ([txtInput.placeholder isEqualToString:@"Linkedin"])
                        {
                            [pfobj setValue:txtInput.text forKey:@"linkedin"];
                        }
                    }
                    else if (txtInput.tag == 2)
                    {
                        if ([txtInput.placeholder isEqualToString:@"Designation"])
                        {
                            [pfobj setValue:txtInput.text forKey:@"designation"];
                        }
                    }
                    else if (txtInput.tag == 3)
                    {
                        if ([txtInput.placeholder isEqualToString:@"Total Exp"])
                        {
                            [pfobj setValue:txtInput.text forKey:@"experienceYears"];
                        }
                        else
                        {
                            [pfobj setValue:txtInput.text forKey:@"officeemail"];
                        }
                    }
                }
                else
                {
                    [pfobj setValue:txtInput.text forKey:key];
                }
            }
                break;
            case 4:
                break;
                
            default:
                break;
        }
    
}

-(void)getEmployementType:(UIButton *)sender
{
    salaryTableView *salaryCell  = (salaryTableView *) [[[sender superview] superview] superview];
    if (sender.tag  == 0)
    {
        [salaryCell.businessBtn setBackgroundImage:[UIImage imageNamed:@"checkoff"] forState:UIControlStateNormal];
        [salaryCell.salBtn setBackgroundImage: [UIImage imageNamed:@"check"] forState:UIControlStateNormal];
//        [basicInfoDic setObject:@"Salaried" forKey:@"employmentType"];
        [basicInfoModalObj setValue:@"Salaried" forKey:@"employmentType"];
    }
    else
    {
        [salaryCell.businessBtn setBackgroundImage: [UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [salaryCell.salBtn setBackgroundImage: [UIImage imageNamed:@"checkoff"] forState:UIControlStateNormal];
//        [basicInfoDic setObject:@"business" forKey:@"employmentType"];
        [basicInfoModalObj setValue:@"Business" forKey:@"employmentType"];
    }
}

-(BOOL)performStepOneValidation
{
    for (NSString *key in [basicInfoModalObj giveKeysArray])
    {
        NSError *error;
        id fieldValue;
        fieldValue = [basicInfoModalObj valueForKey:key];
        [basicInfoModalObj validateValue:&fieldValue forKey:key error:&error];
    
        if (error)
        {
            UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"StashFin" message:[error.userInfo objectForKey:NSLocalizedDescriptionKey] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
            return NO;

        }
    }
    return YES;
}

-(BOOL)performStepTwoValidation
{
    for (id key in [loanApplicationObj giveKeysArray])
    {
        NSError *error;
        id fieldValue;

        if ( [key isKindOfClass:[NSDictionary class]] )
        {
            for (id dictKey in key)
            {
                fieldValue = [loanApplicationObj valueForKey:[key valueForKey:dictKey]];
                [loanApplicationObj validateValue:&fieldValue forKey:[key valueForKey:dictKey] error:&error];
                
                if (error)
                {
                    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"StashFin" message:[error.userInfo objectForKey:NSLocalizedDescriptionKey] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        
                    }];
                    
                    [alert addAction:ok];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                    return NO;
                }
            }
        }
        else
        {
            fieldValue = [loanApplicationObj valueForKey:key];
            [loanApplicationObj validateValue:&fieldValue forKey:key error:&error];
            
            if (error)
            {
                UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"StashFin" message:[error.userInfo objectForKey:NSLocalizedDescriptionKey] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    
                }];
                
                [alert addAction:ok];
                
                [self presentViewController:alert animated:YES completion:nil];
                return NO;
                
            }
        }
        
    }
    return YES;
}
-(BOOL)performStepThreeValidation
{
    for (id key in [pfobj giveprofKeysArray])
    {
        NSError *error;
        id fieldValue;
        
        if ( [key isKindOfClass:[NSDictionary class]] )
        {
            for (id dictKey in key)
            {
                fieldValue = [pfobj valueForKey:[key valueForKey:dictKey]];
                [pfobj validateValue:&fieldValue forKey:[key valueForKey:dictKey] error:&error];
                
                if (error)
                {
                    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"StashFin" message:[error.userInfo objectForKey:NSLocalizedDescriptionKey] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        
                    }];
                    
                    [alert addAction:ok];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                    return NO;
                }
            }
        }
        else
        {
            fieldValue = [pfobj valueForKey:key];
            [pfobj validateValue:&fieldValue forKey:key error:&error];
            
            if (error)
            {
                UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"Stashfin" message:[error.userInfo objectForKey:NSLocalizedDescriptionKey] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    
                }];
                
                [alert addAction:ok];
                
                [self presentViewController:alert animated:YES completion:nil];
                return NO;
                
            }
        }
        
    }
    return YES;
}
-(void)changeStepColour:(int)signupstep
{
    switch (signupstep)
    {
        case basicInfo:
        {
            _firstView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            [_btnFirst setBackgroundImage:[UIImage imageNamed:@"greenBtn"] forState:UIControlStateNormal];
            self.basicinfoLbl.textColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            [_btnSecond setBackgroundImage:[UIImage imageNamed:@"two"] forState:UIControlStateNormal];
            self.idDetailLbl.textColor = [UIColor blackColor];
            
            [ self serverCallToGenerateOTP ];
            [self serverCallForLoanApplication];

            break;
        }
        case idDetails:
        {
            _secondView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            [_btnSecond setBackgroundImage:[UIImage imageNamed:@"greenBtn"] forState:UIControlStateNormal];
            self.idDetailLbl.textColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            [_btnThird setBackgroundImage:[UIImage imageNamed:@"three"] forState:UIControlStateNormal];
            self.personalInfoLbl.textColor = [UIColor blackColor];
            [self professionalDetailsServiceCall];
            break;
        }
        case personalInfo:
        {
            _thirdView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            [_btnThird setBackgroundImage:[UIImage imageNamed:@"greenBtn"] forState:UIControlStateNormal];
            self.personalInfoLbl.textColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            [_btnFourth setBackgroundImage:[UIImage imageNamed:@"four"] forState:UIControlStateNormal];
            self.docLbl.textColor = [UIColor blackColor];
            [ self serverCallForDocDetail ];
            break;
        }
        case docUpload:
        {
            break;
        }
        default:
            break;
    }
   
    if (signupStep < 4)
    {
        signupStep += 1;
        if (signupStep == 4)
        {
            [ _btnNext setBackgroundImage:[UIImage imageNamed:@"register"] forState:UIControlStateNormal];
        }
        [self.signupTableview reloadData];
    }

}

#pragma mark UIALertController Delegate
-(void)showAlertWithTitle:(NSString *)atitle withMessage:(NSString *)message
{
    UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:atitle message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)setPickerArray:(UITextField *)textField
{
    if (signupStep == 2)
    {
        if (textField.tag == 1)
        {
            pickerArr = [pickerObj giveLoanPickerArr];
        }
        else if (textField.tag == 7)
        {
            pickerArr = [pickerObj giveSalPickerArr];
        }
        else if (textField.tag == 11)
        {
            pickerArr = [pickerObj giveResidencePickerArr];
        }
    }
    else if (signupStep == 3)
    {
        if (textField.tag == 0)
        {
            pickerArr = [eduPicker giveEducationPickerArr];
        }
    }
}

-(void)setupStateCityPin
{
    NSString *addressString = [NSString stringWithFormat:@"%@,%@,%@",appDelegate.stateName,appDelegate.cityName,appDelegate.residencePin];
    selTextfield.text = addressString;
    [loanApplicationObj setValue:addressString forKey:@"scp"];
    [serverLoanObj setValue:addressString forKey:@"scp"];
}

#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( tableView == self.signupTableview )
    {
        switch (signupStep)
        {
            case basicInfo:
            {
                return basicInfoArray.count;
                break;
            }
            case idDetails:
            {
                return idDetailArray.count;
                break;
            }
            case personalInfo:
            {
                return professionalArray.count;
                break;
            }
            case docUpload:
            {
                return marrDocs .count;
                break;
            }
            default:
                break;
        }
        return 0;
    }
    else
    {
        if ( isIdProof )
        {
            return marrIDProof.count;
        }
        else if ( isAddreesProof )
        {
            return marrAddress.count;
        }
        return 0;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (signupStep)
    {
        case basicInfo:
        {
            if ([[basicInfoArray objectAtIndex:indexPath.row] isEqualToString:@"check"])
            {
                return (45.0f/320.0f) * self.view.frame.size.width;
            }
            else
            {
                return (35.0f/320.0f) * self.view.frame.size.width;
            }
            
            break;
        }
        case idDetails:
        {
            return (38.0f/320.0f) * self.view.frame.size.width;
            break;
        }
        case personalInfo:
        {
            return (38.0f/320.0f) * self.view.frame.size.width;
            break;
        }
        case docUpload:
        {
            return (44.0f/320.0f) * self.view.frame.size.width;
            break;
        }
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( tableView == self.signupTableview )
    {
        switch (signupStep)
        {
            case basicInfo:
            {
                if ([[basicInfoArray objectAtIndex:indexPath.row] isEqualToString:@"check"])
                {
                    static NSString *salaryTableIdentifier = @"salaryTableView";
                    salaryTableView *salaryCell  =  [tableView dequeueReusableCellWithIdentifier:salaryTableIdentifier];
                    if (salaryCell == nil)
                    {
                        salaryCell =[[[NSBundle mainBundle] loadNibNamed:@"salaryTableView" owner:self options:nil] objectAtIndex:0];
                    }
                    
                    [salaryCell.salBtn addTarget:self action:@selector(getEmployementType:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [salaryCell.businessBtn addTarget:self action:@selector(getEmployementType:) forControlEvents:UIControlEventTouchUpInside];
                    
                    salaryCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return salaryCell;
                    
                }
                else
                {
                    static NSString *singleTableIdentifier = @"SingleTableViewCell";
                    SingleTableViewCell *singleCell  =  [tableView dequeueReusableCellWithIdentifier:singleTableIdentifier];
                    if (singleCell == nil)
                    {
                        singleCell =[[[NSBundle mainBundle] loadNibNamed:@"SingleTableViewCell" owner:self options:nil] objectAtIndex:0];
                        
                        singleCell.singleTextField.delegate = self;
                        [singleCell.singleTextField addTarget:self action:@selector(updateUserInput:) forControlEvents:UIControlEventEditingChanged];
                        
                    }
                    NSArray *keysarr = [basicInfoModalObj giveKeysArray];
                    NSString *key = [keysarr objectAtIndex:indexPath.row];
                    NSString *valStr = [basicInfoModalObj valueForKey:key];
                    if ( valStr.length > 0)
                    {
                        singleCell.singleTextField.text = valStr;
                    }
                    singleCell.singleTextField.tag = indexPath.row;
                    singleCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UIColor *color = [UIColor lightGrayColor];
                    singleCell.singleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[basicInfoArray objectAtIndex:indexPath.row] attributes:@{NSForegroundColorAttributeName: color}];
                    
                    return singleCell;
                }
                
                
                
                break;
            }
            case idDetails:
            {
                if ([[idDetailArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]])
                {
                    static NSString *doubleTableIdentifier = @"DoubleTableViewCell";
                    DoubleTableViewCell *doubleCell =  [tableView dequeueReusableCellWithIdentifier:doubleTableIdentifier];
                    if (doubleCell == nil)
                    {
                        doubleCell =[[[NSBundle mainBundle] loadNibNamed:@"DoubleTableViewCell" owner:self options:nil] objectAtIndex:0];
                        [doubleCell.firstField addTarget:self action:@selector(updateUserInput:) forControlEvents:UIControlEventEditingChanged];
                        [doubleCell.secondField addTarget:self action:@selector(updateUserInput:) forControlEvents:UIControlEventEditingChanged];
                    }
                    NSDictionary *rowDic = [idDetailArray objectAtIndex:indexPath.row];
                    
                    UIColor *color = [UIColor lightGrayColor];
                    // set first field
                    doubleCell.firstField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[rowDic objectForKey:@"First"] attributes:@{NSForegroundColorAttributeName: color}];
                    // set second field
                    doubleCell.secondField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[rowDic objectForKey:@"Second"] attributes:@{NSForegroundColorAttributeName: color}];
                    
                    //set tag for double textfield
                    doubleCell.firstField.tag = indexPath.row;
                    doubleCell.secondField.tag = indexPath.row;
                    doubleCell.firstField.delegate =self;
                    doubleCell.secondField.delegate =self;
                    
                    if ([[rowDic objectForKey:@"first"] isEqualToString:@"DOB"])
                    {
                        doubleCell.calendarBtn.hidden = NO;
                    }
                    
                    NSArray *keysarr = [loanApplicationObj giveKeysArray];
                    NSDictionary *dict = [keysarr objectAtIndex:indexPath.row];
                    NSString *key1 = [dict objectForKey:@"first"];
                    NSString *key2 = [dict objectForKey:@"second"];
                    NSString *valStr1 = [loanApplicationObj valueForKey:key1];
                    NSString *valStr2 = [loanApplicationObj valueForKey:key2];
                    if ( valStr1.length > 0 )
                    {
                        doubleCell.firstField.text = valStr1;
                    }
                    if ( valStr2.length > 0 )
                    {
                        doubleCell.secondField.text = valStr2;
                    }
                    
                    doubleCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return doubleCell;
                }
                else
                {
                    static NSString *singleTableIdentifier = @"SingleTableViewCell";
                    SingleTableViewCell *singleCell  =  [tableView dequeueReusableCellWithIdentifier:singleTableIdentifier];
                    if (singleCell == nil) {
                        singleCell =[[[NSBundle mainBundle] loadNibNamed:@"SingleTableViewCell" owner:self options:nil] objectAtIndex:0];
                        singleCell.singleTextField.delegate = self;
                        [singleCell.singleTextField addTarget:self action:@selector(updateUserInput:) forControlEvents:UIControlEventEditingChanged];
                    }
                    NSArray *keysarr = [loanApplicationObj giveKeysArray];
                    NSString *key = [keysarr objectAtIndex:indexPath.row];
                    NSString *valStr = [loanApplicationObj valueForKey:key];
                    if ( valStr.length > 0 )
                    {
                        singleCell.singleTextField.text = valStr;
                    }
                    
                    singleCell.singleTextField.tag = indexPath.row;
                    UIColor *color = [UIColor lightGrayColor];
                    singleCell.singleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[idDetailArray objectAtIndex:indexPath.row] attributes:@{NSForegroundColorAttributeName: color}];
                    singleCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    return singleCell;
                }
                
                break;
            }
            case personalInfo:
            {
                if ([[professionalArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]) {
                    static NSString *doubleTableIdentifier = @"professionalTableViewCell";
                    DoubleTableViewCell *doubleCell =  [tableView dequeueReusableCellWithIdentifier:doubleTableIdentifier];
                    if (doubleCell == nil) {
                        doubleCell =[[[NSBundle mainBundle] loadNibNamed:@"DoubleTableViewCell" owner:self options:nil] objectAtIndex:0];
                        doubleCell.firstField.delegate =self;
                        doubleCell.secondField.delegate =self;
                        
                        [doubleCell.firstField addTarget:self action:@selector(updateUserInput:) forControlEvents:UIControlEventEditingChanged];
                        [doubleCell.secondField addTarget:self action:@selector(updateUserInput:) forControlEvents:UIControlEventEditingChanged];
                        
                    }
                    //set tag for double textfield
                    [doubleCell.firstField setTag:indexPath.row];
                    doubleCell.secondField.tag = indexPath.row;
                    
                    
                    
                    NSDictionary *rowDic = [professionalArray objectAtIndex:indexPath.row];
                    UIColor *color = [UIColor lightGrayColor];
                    doubleCell.firstField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[rowDic objectForKey:@"First"] attributes:@{NSForegroundColorAttributeName: color}];
                    doubleCell.secondField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[rowDic objectForKey:@"Second"] attributes:@{NSForegroundColorAttributeName: color}];
                    doubleCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    if ([[rowDic objectForKey:@"First"] isEqualToString:@"DOB"]) {
                        doubleCell.calendarBtn.hidden = NO;
                    }
                    else if ([[rowDic objectForKey:@"Second"] isEqualToString:@"Since"]) {
                        doubleCell.secondCalBtn.hidden = NO;
                    }
                    
                    
                    NSArray *keysarr = [pfobj giveprofKeysArray];
                    NSDictionary *dict = [keysarr objectAtIndex:indexPath.row];
                    NSString *key1 = [dict objectForKey:@"First"];
                    NSString *key2 = [dict objectForKey:@"Second"];
                    NSString *valStr1 = [pfobj valueForKey:key1];
                    NSString *valStr2 = [pfobj valueForKey:key2];
                    if ( valStr1.length > 0 )
                    {
                        doubleCell.firstField.text = valStr1;
                    }
                    if ( valStr2.length > 0 )
                    {
                        doubleCell.secondField.text = valStr2;
                    }
                    
                    
                    
                    return doubleCell;
                    
                }
                else
                {
                    static NSString *singleTableIdentifier = @"SingleTableViewCell";
                    SingleTableViewCell *singleCell  =  [tableView dequeueReusableCellWithIdentifier:singleTableIdentifier];
                    if (singleCell == nil) {
                        singleCell =[[[NSBundle mainBundle] loadNibNamed:@"SingleTableViewCell" owner:self options:nil] objectAtIndex:0];
                        singleCell.singleTextField.delegate = self;
                        [singleCell.singleTextField addTarget:self action:@selector(updateUserInput:) forControlEvents:UIControlEventEditingChanged];
                    }
                    
                    NSArray *keysarr = [pfobj giveprofKeysArray];
                    NSString *key = [keysarr objectAtIndex:indexPath.row];
                    NSString *valStr = [pfobj valueForKey:key];
                    if ( valStr.length > 0 )
                    {
                        singleCell.singleTextField.text = valStr;
                    }
                    singleCell.singleTextField.tag = indexPath.row;
                    singleCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UIColor *color = [UIColor lightGrayColor];
                    singleCell.singleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[professionalArray objectAtIndex:indexPath.row] attributes:@{NSForegroundColorAttributeName: color}];
                    return singleCell;
                }
                
                break;
            }
            case docUpload:
            {
                static NSString *uploadTableIdentifier = @"UploadCell";
                UploadCell *uploadCell  =  [tableView dequeueReusableCellWithIdentifier:uploadTableIdentifier];
                if (uploadCell == nil) {
                    uploadCell =[[[NSBundle mainBundle] loadNibNamed:@"UploadCell" owner:self options:nil] objectAtIndex:0];
                }
                uploadCell.uploadLbl.text = [marrDocTitle objectAtIndex:indexPath.row];
                uploadCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                uploadCell.checkBtn.tag = indexPath.row;
                [uploadCell.checkBtn addTarget:self action:@selector(checkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                uploadCell.uploadBtn.tag = indexPath.row;
                [uploadCell.uploadBtn addTarget:self action:@selector(uploadAction:) forControlEvents:UIControlEventTouchUpInside];
                
                uploadCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                NSString *path = [ marrDocs objectAtIndex:indexPath.row ];
                if ( path.length > 0 || ![ path isEqualToString:@""])
                {
                    isDocPickDone = YES;
                    [uploadCell.checkBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
                    uploadCell.uploadLbl.textColor = [UIColor redColor];
                    [uploadCell.uploadBtn setBackgroundImage:[UIImage imageNamed:@"uploadBtn"] forState:UIControlStateNormal];
                }
                else
                {
                    [uploadCell.checkBtn setBackgroundImage:[UIImage imageNamed:@"checkoff"] forState:UIControlStateNormal];
                    uploadCell.uploadLbl.textColor = [UIColor lightGrayColor];
                    [uploadCell.uploadBtn setBackgroundImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];
                    
                }
                return uploadCell;
                
                break;
            }
            default:
                break;
        }
        return 0;
    }
    else
    {
        UITableViewCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"OptionCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *leftImage = (UIImageView *)[cell viewWithTag:111];
        
        if ( selectedIndex == indexPath.row )
        {
            leftImage.image = [UIImage imageNamed:@"checked"];
        }
        else
        {
            leftImage.image = [UIImage imageNamed:@"unchecked"];
        }
        
        UILabel *lblTitle = (UILabel *)[cell viewWithTag:222];
        
        NSDictionary *dict;
        if ( isIdProof )
        {
            dict = [marrIDProof objectAtIndex:indexPath.row];
            lblTitle.text = [NSString stringWithFormat:@"%@",dict[@"document_name"]];
        }
        if ( isAddreesProof )
        {
            dict = [marrAddress objectAtIndex:indexPath.row];
            lblTitle.text = [NSString stringWithFormat:@"%@",dict[@"document_name"]];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( tableView == _signupTableview )
    {
        selectedIndex = indexPath.row;
    }
    else
    {
        selectedIndex = indexPath.row;
        [ _tblOptions reloadData ];
    }

}
- (void)checkButtonAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ( [ btn currentBackgroundImage ] == checkoffImage )
    {
        [ btn setBackgroundImage:checkImage forState:UIControlStateNormal ];
    }
    else
    {
        [ btn setBackgroundImage:checkoffImage forState:UIControlStateNormal ];
    }
}
- (void)updateUploadButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ( [ btn currentBackgroundImage ] == uploadDeactive )
    {
        [ btn setBackgroundImage:uploadActive forState:UIControlStateNormal ];
    }
    else
    {
        [ btn setBackgroundImage:uploadDeactive forState:UIControlStateNormal ];
    }
}
- (void)uploadAction:(UIButton *)btn
{
    btnTag = btn.tag;
    NSString *path = [ marrDocs objectAtIndex:btnTag ];
    
    if ( [path isEqualToString:@""] )
    {
        NSString *title = [ marrDocTitle objectAtIndex:btn.tag ];
        if ( [title isEqualToString:@"ID Proof"] )
        {
            isIdProof = YES;
            isAddreesProof = NO;
            isOtherDoc = NO;
            isOtherPopUP  = NO;
            
            [ Utilities showPopupView:_viewProofPopUp onViewController:self];
            [ _tblOptions reloadData ];
            
        }
        else if ( [title isEqualToString:@"Address Proof"] )
        {
            isAddreesProof = YES;
            isIdProof = NO;
            isOtherDoc = NO;
            isOtherPopUP  = NO;
            
            if ( self.view.frame.size.width == 320 )
            {
                _tblOptions.scrollEnabled = YES;
            }
            
            [ Utilities showPopupView:_viewProofPopUp onViewController:self];
            [ _tblOptions reloadData ];
        }
        else if ( [title isEqualToString:@"Any other document"] )
        {
            isOtherDoc = YES;
            isAddreesProof = NO;
            isIdProof = NO;
            
            _txtOther.text = @"";
            
            [ Utilities showPopupView:_viewOtherPopUp onViewController:self];
            [ _tblOptions reloadData ];
        }
        else
        {
            isIdProof = NO;
            isAddreesProof = NO;
            isOtherDoc = NO;
            
            strDocID = @"";
            strDocName = [ marrDocName objectAtIndex:btnTag ];
            UIActionSheet *imagePop = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose From Library", nil];
            [imagePop showInView:self.view];
        }
    }
}
#pragma mark TextField Delegate

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if (signupStep == 1 )
    {
        if ( textField.tag == 2 )
        {
            [ textField setKeyboardType:UIKeyboardTypeEmailAddress ];
            selTextfield = textField;
            return YES;
        }
        else if ( textField.tag == 3 || textField.tag == 6 )
        {
            [ textField setKeyboardType:UIKeyboardTypeNumberPad ];
            selTextfield = textField;
            return YES;
        }
        if ( textField.tag == 7 )
        {
            [pickerArr removeAllObjects];
            pickerArr = [ NSMutableArray arrayWithArray:marrCity ];
            picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
            [picker setDataSource: self];
            [picker setDelegate: self];
            picker.showsSelectionIndicator = YES;
            textField.inputView = picker;
            selTextfield = textField;
        }
    }
    else if( signupStep == 2 )
    {
        if ((textField.tag == 1 || textField.tag == 2 || textField.tag == 7  || textField.tag == 10 || textField.tag == 11 ))
        {
            if ((textField.tag == 1 || textField.tag == 7 || textField.tag == 11))
            {
                [self setPickerArray:textField];
            }
            else if (textField.tag == 2)
            {
                if ([textField.placeholder isEqualToString:@"Gender"]) {
                    // gender textfield
                    pickerArr = [NSMutableArray arrayWithArray:[NSArray arrayWithObjects:@"Male",@"Female", nil]];
                }
                else {
                    // dob textfield
                    datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectZero];
                    [datePickerView setDatePickerMode:UIDatePickerModeDate];
                    [datePickerView addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
                    datePickerView .maximumDate = [ NSDate date];
                    textField.inputView = datePickerView;
                    selTextfield = textField;
                    return YES;
                }
            }
            else if (textField.tag == 10)
            {
                [pickerArr removeAllObjects];
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy"];
                int i2  = [[formatter stringFromDate:[NSDate date]] intValue];
                //Create Years Array from 1960 to This year
                for (int i=1960; i<=i2; i++)
                {
                    [pickerArr addObject:[NSString stringWithFormat:@"%d",i]];
                }
                
            }
            picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
            [picker setDataSource: self];
            [picker setDelegate: self];
            picker.showsSelectionIndicator = YES;
            textField.inputView = picker;
            selTextfield = textField;
        }
        
        else if ( textField.tag == 4 || textField.tag == 6 )
        {
            textField.keyboardType = UIKeyboardTypeNumberPad;
            selTextfield = textField;
            return YES;
        }
        
        else if ( textField.tag == 9 )
        {
            StateVC *statvc = [self.storyboard instantiateViewControllerWithIdentifier:@"StateVC"];
            statvc.statesArray = [pickerObj giveStatesPickerArr];
            selTextfield = textField;
            [self.navigationController pushViewController:statvc animated:YES];
            return NO;
        }
        else if ( [textField.placeholder isEqualToString:@"Loan Amount"] || [textField.placeholder isEqualToString:@"Tenure in months"])
        {
            textField.keyboardType = UIKeyboardTypeNumberPad;
            selTextfield = textField;
            return YES;
        }
        else
        {
//            [ textField becomeFirstResponder ];
        }

    }
    else if( signupStep == 3 )
    {
        if ( (textField.tag == 0 || textField.tag == 2 || textField.tag == 5) )
        {
            if ((textField.tag == 0 && [textField.placeholder isEqualToString:@"Education"] )|| (textField.tag == 2 &&  [textField.placeholder isEqualToString:@"Since"]))
            {
                if (textField.tag == 2)
                {
                    [pickerArr removeAllObjects];
                    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy"];
                    int i2  = [[formatter stringFromDate:[NSDate date]] intValue];
                    //Create Years Array from 1960 to This year
                    for (int i = 1960; i<=i2; i++)
                    {
                        [pickerArr addObject:[NSString stringWithFormat:@"%d",i]];
                    }
                }
                else
                {
                    [self setPickerArray:textField];
                }
                picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
                [picker setDataSource: self];
                [picker setDelegate: self];
                picker.showsSelectionIndicator = YES;
                textField.inputView = picker;
                selTextfield = textField;
            }
            else if (textField.tag == 5)
            {
                StateVC *statvc = [self.storyboard instantiateViewControllerWithIdentifier:@"StateVC"];
                statvc.statesArray = [eduPicker giveStatesPickerArr];
                selTextfield = textField;
                [self.navigationController pushViewController:statvc animated:YES];
                return NO;
            }
        }
        else if ( textField.tag == 3)
        {
            if ([textField.placeholder isEqualToString:@"Total Exp"])
            {
                [ textField setKeyboardType:UIKeyboardTypeNumberPad ];
            }
            else
            {
                [ textField setKeyboardType:UIKeyboardTypeEmailAddress ];
            }
            selTextfield = textField;
            return YES;
        }
        else if ( textField.tag == 4 )
        {
            [ textField setKeyboardType:UIKeyboardTypeNumberPad ];
            selTextfield = textField;
            return YES;
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ((signupStep == 2 && (textField.tag == 1 || textField.tag == 7 || textField.tag == 8 || textField.tag == 2 || textField.tag == 10 || textField.tag == 11) )|| (signupStep == 3 && (textField.tag == 0 || textField.tag == 2)))
    {
        [textField addCancelDoneOnKeyboardWithTarget:self cancelAction:@selector(cancelAction:) doneAction:@selector(doneAction:)];
    }
}
-  (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ( signupStep == 1 )
    {
        if ( textField.tag == 3 && textField.text.length >=10 && range.length == 0 )
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else if ( signupStep == 2 )
    {
        if ( _txtOTP.text.length >= 4  && range.length == 0)
        {
            return NO;
        }
        else  if ( textField.tag == 3 && textField.text.length >= 10 && range.length == 0)
        {
            return NO;
        }
        else  if ( textField.tag == 4 && textField.text.length >= 12 && range.length == 0)
        {
            return NO;
        }
        else if ([textField.placeholder isEqualToString:@"Loan Amount"] && textField.text.length >= 6 && range.length == 0)
        {
            return NO;
        }
        else if ([textField.placeholder isEqualToString:@"Tenure in months"] && textField.text.length >= 2 && range.length == 0 )
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
}

-(void)doneAction:(id)baritem
{
    if (signupStep ==2)
    {
        if (selTextfield.tag == 1)
        {
            Pickers *loanObj = [[Pickers alloc]init];
            loanObj = [pickerArr objectAtIndex:currentRow];
            [loanApplicationObj setValue:loanObj.loanreason forKey:@"reason"];
            [serverLoanObj setValue:loanObj.id_loaon_reason forKey:@"reason"];
            selTextfield.text = loanObj.loanreason;
        }
        else if (selTextfield.tag == 7)
        {
            Pickers *salObj = [[Pickers alloc]init];
            salObj = [pickerArr objectAtIndex:currentRow];
            [loanApplicationObj setValue:salObj.salmode forKey:@"salary_mode"];
            [serverLoanObj setValue:salObj.id_sal forKey:@"salary_mode"];
            selTextfield.text = salObj.salmode;
            // changed to sal_id from salmode
        }
        else if (selTextfield.tag == 11)
        {
            Pickers *resObj = [[Pickers alloc]init];
            resObj = [pickerArr objectAtIndex:currentRow];
            [loanApplicationObj setValue:resObj.owner_type forKey:@"residenceType"];
            [serverLoanObj setValue:resObj.id_owner forKey:@"residenceType"];
            selTextfield.text = resObj.owner_type;
        }
        else if (selTextfield.tag == 2)
        {
            if ([selTextfield.placeholder isEqualToString:@"Gender"])
            {
                selTextfield.text = [pickerArr objectAtIndex:currentRow];
                if ([selTextfield.text isEqualToString:@"Male"])
                {
                    [loanApplicationObj setValue:@"Male" forKey:@"gender"];
                    [serverLoanObj setValue:@"m" forKey:@"gender"];
                    selTextfield.text = @"Male";
                }
                else if ([selTextfield.text isEqualToString:@"Female"])
                {
                    [loanApplicationObj setValue:@"Female" forKey:@"gender"];
                    [serverLoanObj setValue:@"f" forKey:@"gender"];
                    selTextfield.text = @"Female";
                }
            }
            else {
                NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"dd-MM-YYYY"];
                NSString *dateStr = [dateFormatter stringFromDate:date.date];
                NSLog(@"%@",dateStr);
                selTextfield.text = [dateFormatter stringFromDate:date.date];
                [loanApplicationObj setValue:selTextfield.text forKey:@"birthDate"];
                [serverLoanObj setValue:selTextfield.text forKey:@"birthDate"];
            }
           
            
        }
        else if (selTextfield.tag == 10)
        {
            selTextfield.text = [pickerArr objectAtIndex:currentRow];
            [loanApplicationObj setValue:selTextfield.text forKey:@"occupiedSince"];
            [serverLoanObj setValue:selTextfield.text forKey:@"occupiedSince"];
        }
    }
    else if (signupStep == 3)
    {
        if (selTextfield.tag == 0)
        {
            EducationPicker *edPicker = [[EducationPicker alloc]init];
            edPicker = [pickerArr objectAtIndex:currentRow];
            [pfobj setValue:edPicker.education_name forKey:@"highesteducation"];
            selTextfield.text = edPicker.education_name;

            // [pfobj setValue:edPicker.id_education forKey:@"highesteducation"];
        }
        else if (selTextfield.tag == 2)
        {
            selTextfield.text = [pickerArr objectAtIndex:currentRow];
            [pfobj setValue:selTextfield.text forKey:@"workStartYear"];
        }
    }
    
    [self.view endEditing:YES];
    currentRow = 0;
}

-(void)cancelAction:(UIBarButtonItem *)sender
{
    selTextfield.text =@"";
    [selTextfield resignFirstResponder];
    [self.view endEditing:YES];

}

- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker
{
    date = datePicker;

}
#pragma mark - PickerView Delegates
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerArr.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ( signupStep == 1 )
    {
        return [pickerArr objectAtIndex:row];
    }
    else if (signupStep == 2)
    {
        if (selTextfield.tag == 1)
        {
            Pickers *loanObj = [[Pickers alloc]init];
            loanObj = [pickerArr objectAtIndex:row];
            return  loanObj.loanreason;
        }
        else if (selTextfield.tag == 7) {
            Pickers *salObj = [[Pickers alloc]init];
            salObj = [pickerArr objectAtIndex:row];
            return  salObj.salmode;
        }
        else if (selTextfield.tag == 11) {
            Pickers *resObj = [[Pickers alloc]init];
            resObj = [pickerArr objectAtIndex:row];
            return  resObj.owner_type;
        }
        else if (selTextfield.tag == 2 || selTextfield.tag == 8 || selTextfield.tag == 10)
        {
            return [pickerArr objectAtIndex:row];
        }
        
    }
    else if (signupStep == 3)
    {
        if (selTextfield.tag == 0)
        {
            EducationPicker *epiker = [[EducationPicker alloc]init];
            epiker = [pickerArr objectAtIndex:row];
            return epiker.education_name;
        }
        else {
            return [pickerArr objectAtIndex:row];
        }
    }
   
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (  signupStep == 1 )
    {
        selTextfield.text = [marrCity objectAtIndex:row] ;
        NSArray *keysarr = [basicInfoModalObj giveKeysArray];
        NSString *key = [keysarr objectAtIndex:selTextfield.tag];
        [basicInfoModalObj setValue:selTextfield.text forKey:key];
    }
    
    currentRow = (int)row;

//     else
//    {
//        City *cobject = [marrCity objectAtIndex:row];
//        if ([selTextfield.placeholder isEqualToString:@"City"] && signupStep == 2)
//        {
//            selTextfield.text = cobject.cityName ;
//            NSArray *keysarr = [basicInfoModalObj giveKeysArray];
//            NSString *key = [keysarr objectAtIndex:selTextfield.tag];
//            [basicInfoModalObj setValue:cobject.cityid forKey:key];
//        }
//        currentRow = (int)row;
//    }
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
- (void)navigateToDashboard
{
    ViewController *vc = (ViewController *) [self.storyboard instantiateViewControllerWithIdentifier:@"rootController"];
    [self.navigationController pushViewController:vc animated:YES];

    /*ViewController *vc = (ViewController *) [[UIStoryboard storyboardWithName:@"iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"rootController"] ;
    UINavigationController *navigationController = [Utilities getNavigationControllerForViewController:vc];
    navigationController.viewControllers = @[vc];
    navigationController.navigationBar.hidden = YES;
    navigationController.interactivePopGestureRecognizer.enabled = NO;
    appDelegate.window.rootViewController = navigationController;*/
    
}

#pragma mark Helper Method
- (void)populateDocumentDetail:(NSDictionary *)response
{
    NSDictionary *dictDocs = response[@"docs"];
    marrAddress = response[@"address_proof_document_types"];
    marrIDProof = response[@"id_proof_document_types"];
    marrOther = response[@"other_selected_docs"];
    
    [ marrDocs addObject:dictDocs[@"pan_proof"] ];
    [ marrDocs addObject:dictDocs[@"id_proof"] ];
    [ marrDocs addObject:dictDocs[@"address_proof"] ];
    [ marrDocs addObject:dictDocs[@"employee_id"] ];
    [ marrDocs addObject:dictDocs[@"salary_slip1"] ];
    [ marrDocs addObject:dictDocs[@"salary_slip2"] ];
    [ marrDocs addObject:dictDocs[@"salary_slip3"] ];
    [ marrDocs addObject:dictDocs[@"office_id"] ];
    
    if ( marrOther.count > 0 )
    {
        for ( NSDictionary *temp in marrOther)
        {
            [ marrDocTitle addObject:temp[@"document_name"] ];
            [marrDocs addObject:temp[@"document_path"]];
        }
    }
    
    [ marrDocTitle addObject:@"Any other document" ];// For last cell
    [marrDocs addObject:@""];
    [ _signupTableview reloadData ];
}
- (void)checkIsOtpVerified:(int)value
{
    if ( value == 0 )
    {
        [ self serverCallToGenerateOTP ];
    }
}
- (void)startTimer
{
    time = 60;

    _btnResend.userInteractionEnabled = NO;
    _btnResend.enabled = NO;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    [ _btnResend setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
    
}
- (void)updateTime
{
    if (time == 0 )
    {
        time = 60;
        [ _btnResend setTitle:@"RESEND OTP" forState:UIControlStateNormal];
        [ timer invalidate ];
        _btnResend.userInteractionEnabled = YES;
        _btnResend.enabled = YES;
        [ _btnResend setTitleColor:[UIColor redColor] forState:UIControlStateNormal ];
        [ timer invalidate ];
    }
    else
    {
        [ _btnResend setTitle:[NSString stringWithFormat:@"RESEND OTP(%ld)",(long)time] forState:UIControlStateNormal];

        time--;
    }
}
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
    [self hidePopupView:_viewOtpVerify fromViewController:self];
    isOtpGenerate = NO;
    [ self.navigationController popViewControllerAnimated:YES ];
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
#pragma mark Server Call
- (void)serverCallForDocUpload
{
    NSString *base64String = [ NSString stringWithFormat:@"data:image/jpg;base64,%@",[Utilities getBase64EncodedStringOfImage:selectedImage]];
    
    NSDictionary *param = [NSMutableDictionary new];
    [ param setValue:@"uploadDocument" forKey:@"mode" ];
    [ param setValue:strDocName forKey:@"document_name" ];
    [ param setValue:base64String forKey:@"image" ];
    [ param setValue:strDocID forKey:@"docId" ];
    
    [ ServerCall getServerResponseWithParameters:param withHUD:YES withCompletion:^(id response)
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
                 [ marrDocs replaceObjectAtIndex:btnTag withObject:response[@"file_url"] ];
                 
                 if ( isOtherDoc )
                 {
                     [ marrDocTitle insertObject:strDocName atIndex:btnTag ];
                 }
                 
                 isDocPickDone = YES;
                 [Utilities showAlertWithMessage:@"Document uoloaded successfully!" ];
                 [ _signupTableview reloadData];
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
     } ];
    
}
- (void)serverCallForOtherDocUpload
{
    NSString *base64String = [ NSString stringWithFormat:@"data:image/jpg;base64,%@",[Utilities getBase64EncodedStringOfImage:selectedImage]];
    
    NSDictionary *param = [NSMutableDictionary new];
    [ param setValue:@"uploadOtherDocument" forKey:@"mode" ];
    [ param setValue:strDocName forKey:@"document_name" ];
    [ param setValue:base64String forKey:@"image" ];
    [ param setValue:strDocID forKey:@"docId" ];
    
    [ ServerCall getServerResponseWithParameters:param withHUD:YES withCompletion:^(id response)
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
                 [ marrDocs replaceObjectAtIndex:btnTag withObject:response[@"file_url"] ];
                 
                 if ( isOtherDoc )
                 {
                     [ marrDocTitle insertObject:strDocName atIndex:btnTag ];
                     [ marrDocTitle addObject:@"Any other document"];
                     [ marrDocs addObject:@""];
                 }
                 
                 isDocPickDone = YES;
                 [Utilities showAlertWithMessage:@"Document uoloaded successfully!" ];
                 [ _signupTableview reloadData];
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
     } ];
    
}
- (void)serverCallForDocDetail
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"documentsFormDetails",@"mode", nil ];
    [ ServerCall getServerResponseWithParameters:param withHUD:NO withCompletion:^(id response)
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
                 [ self populateDocumentDetail:response ];
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
         
     } ];
}
- (void)serverCallToGetLoginData
{
    NSDictionary *dictParam = [NSDictionary dictionaryWithObject:@"getLoginData" forKey:@"mode"];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withCompletion:^(id response)
     {
         NSLog(@"response === %@", response);
         if ([response isKindOfClass:[NSDictionary class]])
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
//                 [Utilities showAlertWithMessage:errorStr];
             }
             else
             {
                 if ( isDocUpload )
                 {
                     [Utilities setUserDefaultWithObject:@"1" andKey:@"islogin"];
                     [Utilities setUserDefaultWithObject:@"0" andKey:@"isLoanDisbursed"];
                     [Utilities setUserDefaultWithObject:[ response objectForKey:@"auth_token"] andKey:@"auth_token"];
                     appDelegate.dictCustomer = [NSDictionary dictionaryWithDictionary:response];
                     appDelegate.isLoanDisbursed = NO;
                     
                     [ self navigateToDashboard ];
                 }
                 
                 else
                 {
                     if ( [response[@"landing_page"] isEqualToString:@"otp_verification"])
                     {
                         [ self serverCallToGenerateOTP ];
                     }
                     
                     strPhoneNo = [ NSString stringWithFormat:@"%@", response[@"phone"] ];
                     loanID = [NSString stringWithFormat:@"%@",response[@"loan_id"]];
                     
                 }
             }
         }
         else
         {

         }
         
         [ SVProgressHUD dismiss ];
     }];
}

-(void)serverCallForBasicInfo
{
    NSString *fullname = [NSString stringWithFormat:@"%@ %@",[basicInfoModalObj valueForKey:@"fname"],[basicInfoModalObj valueForKey:@"lname"]];

    NSDictionary *param = [NSMutableDictionary new];
    [ param setValue:@"registration" forKey:@"mode" ];
    [ param setValue:fullname forKey:@"name" ];
    [ param setValue:[basicInfoModalObj valueForKey:@"email"] forKey:@"email" ];
    [ param setValue:[basicInfoModalObj valueForKey:@"phone"] forKey:@"phone" ];
    [ param setValue:[basicInfoModalObj valueForKey:@"company"] forKey:@"company" ];
    [ param setValue:[basicInfoModalObj valueForKey:@"salary"] forKey:@"salary" ];
    [ param setValue:[basicInfoModalObj valueForKey:@"employmentType"] forKey:@"employmentType" ];
    [ param setValue:@"" forKey:@"referralCode" ];
    [ param setValue:@"IOS" forKey:@"device" ];
    [ param setValue:@"" forKey:@"card" ];
    [ param setValue:@"" forKey:@"utm_source" ];
    [ param setValue:@"" forKey:@"utm_medium" ];
    [ param setValue:@"" forKey:@"utm_content" ];
    [ param setValue:@"" forKey:@"utm_term" ];
    [ param setValue:@"" forKey:@"utm_campaign" ];
    [ param setValue:[basicInfoModalObj valueForKey:@"city"] forKey:@"city" ];
    [ param setValue:[Utilities getDeviceUDID] forKey:@"device_id" ];


    [ ServerCall getServerResponseWithParameters:param withHUD:YES withCompletion:^(id response)
     {
         NSLog(@"registration response === %@", response);
         if ([response isKindOfClass:[NSDictionary class]])
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [self showAlertWithTitle:@"Stashfin" withMessage:errorStr];
             }
             else
             {
                 [Utilities setUserDefaultWithObject: response[@"auth_token"] andKey:@"auth_token"];
                 [Utilities setUserDefaultWithObject:@"0" andKey:@"islogin"];
                 [Utilities setUserDefaultWithObject:@"0" andKey:@"isLoanDisbursed"];
                 [Utilities setUserDefaultWithObject:@"2" andKey:@"signupStep"];
                 [Utilities setUserDefaultWithObject:response andKey:@"userinfo"];
                 [self changeStepColour:basicInfo];
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
     } ];
    
    
    /*if ([CommonFunctions reachabiltyCheck])
    {
        NSString *fullname = [NSString stringWithFormat:@"%@ %@",[basicInfoModalObj valueForKey:@"fname"],[basicInfoModalObj valueForKey:@"lname"]];
        
        //        [CommonFunctions showActivityIndicatorWithText:@"Wait..."];
        
        NSString *post =[NSString stringWithFormat:@"mode=registration&name=%@&email=%@&phone=%@&company=%@&salary=%@&employmentType=%@&referralCode=""&device=IOS&card=""&utm_source=""&utm_medium=""&utm_content=""&utm_term=""&utm_campaign=""&city=%@",fullname,[basicInfoModalObj valueForKey:@"email"],[basicInfoModalObj valueForKey:@"phone"],[basicInfoModalObj valueForKey:@"company"],[basicInfoModalObj valueForKey:@"salary"],[basicInfoModalObj valueForKey:@"employmentType"],[basicInfoModalObj valueForKey:@"city"]];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://devapi.Stashfin.com/webServicesMobile/StashfinApp"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
          {
              dispatch_async (dispatch_get_main_queue(), ^
              {
                  [CommonFunctions removeActivityIndicator];
                  NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                  NSLog(@"%@",responseDic);
                  NSString *errorStr = [responseDic objectForKey:@"error"];
                  
                  if ( errorStr.length> 0)
                  {
                      [self showAlertWithTitle:@"Stashfin" withMessage:errorStr];
                  }
                  else
                  {
                      [Utilities setUserDefaultWithObject: responseDic[@"auth_token"] andKey:@"auth_token"];
                      [Utilities setUserDefaultWithObject:@"0" andKey:@"islogin"];
                      [Utilities setUserDefaultWithObject:@"2" andKey:@"signupStep"];
                      [Utilities setUserDefaultWithObject:responseDic andKey:@"userinfo"];
                      [self changeStepColour:signupStep];
                  }
              });
          }]
         
         resume
         ];
    } else {
        [self showAlertWithTitle:@"Stashfin" withMessage:@"Please check internet"];
    }*/
    
}
-(void)serverCallForLoanApplication
{
    
    NSDictionary *dictParam = [NSDictionary dictionaryWithObjectsAndKeys:@"loanApplicationDetails",@"mode", nil];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:NO withCompletion:^(id response)
     {
         NSLog(@"loanApplicationDetails response == %@", response);
         
         if ( [response isKindOfClass:[NSDictionary class]] )
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
//                 [ Utilities showAlertWithMessage:errorStr ];
             }
             else
             {
                 pickerObj.responseDic = response;
             }
         }
         else
         {
             [ Utilities showAlertWithMessage:response ];
         }
     }];
    
    
    /*if ([CommonFunctions reachabiltyCheck])
    {
//        [CommonFunctions showActivityIndicatorWithText:@"Wait..."];
        
        NSString *post =[NSString stringWithFormat:@"mode=loanApplicationDetails"];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://devapi.Stashfin.com/webServicesMobile/StashfinApp"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async (dispatch_get_main_queue(), ^
        {
            [CommonFunctions removeActivityIndicator];
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",responseDic);
            NSString *errorStr = [responseDic objectForKey:@"error"];
            if ( errorStr.length > 0 )
            {
                [self showAlertWithTitle:@"Stashfin" withMessage:errorStr];
            }
            else
            {
                pickerObj.responseDic = responseDic;
            }
        });
        }]
         
         resume
         ];
    } else {
        [self showAlertWithTitle:@"Stashfin" withMessage:@"Please check internet"];
    }*/
    
}

-(void)statesWebserviceCall
{
    
    if ([CommonFunctions reachabiltyCheck]) {
        //        [CommonFunctions showActivityIndicatorWithText:@"Wait..."];
        
        NSString *post =[NSString stringWithFormat:@"mode=getStates&operational=0"];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://devapi.Stashfin.com/webServicesMobile/StashfinApp"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async (dispatch_get_main_queue(), ^{
                [CommonFunctions removeActivityIndicator];
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",responseDic);
                NSString *errorStr = [responseDic objectForKey:@"error"];
                if (errorStr.length>0)
                {
                    [self showAlertWithTitle:@"Stashfin" withMessage:errorStr];
                }
                else
                {
                    pickerObj.responseDic = responseDic;
                    NSLog(@"success");
                }
            });
        }]
         
         resume
         ];
    } else {
        [self showAlertWithTitle:@"Stashfin" withMessage:@"Please check internet"];
    }
}

- (void)serverCallForSaveloanApplication
{
    NSMutableDictionary *param = [NSMutableDictionary new ];
    
    [ param setObject:@"saveLoanApplication" forKey:@"mode" ];
    [ param setObject:[serverLoanObj valueForKey:@"birthDate"] forKey:@"dob" ];
    [ param setObject:[serverLoanObj valueForKey:@"gender"] forKey:@"gender" ];
    [ param setObject:[serverLoanObj valueForKey:@"panNumber"] forKey:@"pan_number" ];
    [ param setObject:[serverLoanObj valueForKey:@"adharNumber"] forKey:@"aadhar_number" ];
    [ param setObject:[serverLoanObj valueForKey:@"adharName"] forKey:@"name_in_aadhar" ];
    [ param setObject:[serverLoanObj valueForKey:@"salary_mode"] forKey:@"salary_mode" ];
    [ param setObject:[serverLoanObj valueForKey:@"salary"] forKey:@"salary" ];
    [ param setObject:[serverLoanObj valueForKey:@"residenceType"] forKey:@"comm_ownership_type" ];
    [ param setObject:[serverLoanObj valueForKey:@"occupiedSince"] forKey:@"comm_occupied_since" ];
    [ param setObject:[serverLoanObj valueForKey:@"address"] forKey:@"res_address" ];
    [ param setObject:appDelegate.stateid forKey:@"res_state" ];
    [ param setObject:appDelegate.cityId forKey:@"res_city" ];
    [ param setObject:appDelegate.residencePin forKey:@"res_pin" ];
    [ param setObject:[serverLoanObj valueForKey:@"loanAmount"] forKey:@"loan_amount" ];
    [ param setObject:[serverLoanObj valueForKey:@"tenure"] forKey:@"loan_tenure" ];
    [ param setObject:[serverLoanObj valueForKey:@"reason"] forKey:@"loan_reason" ];
    [ param setObject:loanID forKey:@"loan_id" ];
    
    
    [ ServerCall getServerResponseWithParameters:param withHUD:YES withCompletion:^(id response)
    {
        NSLog(@"saveLoanApplication response == %@", response);
        
        if ( [response isKindOfClass:[NSDictionary class]] )
        {
            NSString *errorStr = [response objectForKey:@"error"];
            if ( errorStr.length > 0 )
            {
                [ Utilities showAlertWithMessage:errorStr ];
            }
            else
            {
                [Utilities setUserDefaultWithObject:@"3" andKey:@"signupStep"];
                [self changeStepColour:idDetails];
            }
        }
        else
        {
            [ Utilities showAlertWithMessage:response ];
        }
    } ];
    
    /*if ([CommonFunctions reachabiltyCheck])
    {
        [CommonFunctions showActivityIndicatorWithText:@"Wait..."];
        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSDictionary *userInfo = [defaults valueForKey:@"userinfo"];
        NSString *loanId =  [Utilities getUserDefaultValueFromKey:@"loan_id"];
        NSString *authTokenStr = [Utilities getUserDefaultValueFromKey:@"auth_token"];
        NSString *post =[NSString stringWithFormat:@"mode=saveLoanApplication&dob=%@&gender=%@&pan_number=%@&aadhar_number=%@&name_in_aadhar=%@&salary_mode=%@&salary=%@&comm_ownership_type=%@&comm_occupied_since=%@&res_address=%@&res_state=%@&res_city=%@&res_pin=%@&loan_amount=%@&loan_tenure=%@&loan_reason=%@&loan_id=%@",[serverLoanObj valueForKey:@"birthDate"],[serverLoanObj valueForKey:@"gender"],[serverLoanObj valueForKey:@"panNumber"],[serverLoanObj valueForKey:@"adharNumber"],[serverLoanObj valueForKey:@"adharName"],[serverLoanObj valueForKey:@"salary_mode"],[serverLoanObj valueForKey:@"salary"],[serverLoanObj valueForKey:@"residenceType"],[serverLoanObj valueForKey:@"occupiedSince"],[serverLoanObj valueForKey:@"address"],appDelegate.stateid,appDelegate.cityId,appDelegate.residencePin,[serverLoanObj valueForKey:@"loanAmount"],[serverLoanObj valueForKey:@"tenure"],[serverLoanObj valueForKey:@"reason"],loanId];
        
        NSLog(@"post === %@", post);
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://devapi.Stashfin.com/webServicesMobile/StashfinApp"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:authTokenStr forHTTPHeaderField:@"auth_token"];
        [request setHTTPBody:postData];
        
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async (dispatch_get_main_queue(), ^
            {
                [CommonFunctions removeActivityIndicator];
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",responseDic);
                NSString *errorStr = [responseDic objectForKey:@"error"];
                if (errorStr.length>0) {
                    [self showAlertWithTitle:@"Stashfin" withMessage:errorStr];
                }
                else {
                    NSLog(@"success");
                    [self changeStepColour:idDetails];
                }
            });
        }]
         
         resume
         ];
    } else {
        [self showAlertWithTitle:@"Stashfin" withMessage:@"Please check internet"];
    }*/
    
}


-(void)professionalDetailsServiceCall
{
    NSDictionary *dictParam = [NSDictionary dictionaryWithObjectsAndKeys:@"professionalFormDetails",@"mode", nil];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:NO withCompletion:^(id response)
     {
         NSLog(@"professionalFormDetails response == %@", response);
         
         if ( [response isKindOfClass:[NSDictionary class]] )
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [ Utilities showAlertWithMessage:errorStr ];
             }
             else
             {
                 eduPicker.responseDic = response;
             }
         }
         else
         {
             [ Utilities showAlertWithMessage:response ];
         }
     }];
    
    
    /*if ([CommonFunctions reachabiltyCheck]) {
        [CommonFunctions showActivityIndicatorWithText:@"Wait..."];
        
        NSString *post =[NSString stringWithFormat:@"mode=professionalFormDetails"];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://devapi.Stashfin.com/webServicesMobile/StashfinApp"]];
        [request setHTTPMethod:@"POST"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *userInfo = [defaults valueForKey:@"userinfo"];
        NSString *authTokenStr = [userInfo objectForKey:@"auth_token"];
        
        NSLog(@"%@", [ Utilities getUserDefaultValueFromKey:@"auth_token"]);
        
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:[ Utilities getUserDefaultValueFromKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async (dispatch_get_main_queue(), ^{
                [CommonFunctions removeActivityIndicator];
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",responseDic);
                NSString *errorStr = [responseDic objectForKey:@"error"];
                if (errorStr.length>0) {
                    [self showAlertWithTitle:@"Stashfin" withMessage:errorStr];
                }
                else {
                    NSLog(@"success");
                    eduPicker.responseDic = responseDic;
                }
            });
        }]
         
         resume
         ];
    } else {
        [self showAlertWithTitle:@"Stashfin" withMessage:@"Please check internet"];
    }*/
    
    
}

-(void)serverCallToSubmitProfessionDetails
{
    NSMutableDictionary *param = [NSMutableDictionary new ];
    [ param setObject:@"saveProfessionalDetails" forKey:@"mode" ];
    [ param setObject:[pfobj valueForKey:@"designation"] forKey:@"designation" ];
    [ param setObject:[pfobj valueForKey:@"highesteducation"] forKey:@"highesteducation" ];
    [ param setObject:[pfobj valueForKey:@"experienceYears"] forKey:@"eduCompYear" ];
    [ param setObject:[pfobj valueForKey:@"workStartYear"] forKey:@"workStartYear" ];
    [ param setObject:[pfobj valueForKey:@"experienceYears"] forKey:@"experienceYears" ];
    [ param setObject:[pfobj valueForKey:@"company_name"] forKey:@"company_name" ];
    [ param setObject:[pfobj valueForKey:@"officeemail"] forKey:@"officeemail" ];
    [ param setObject:[pfobj valueForKey:@"officephone"] forKey:@"officephone" ];
    [ param setObject:appDelegate.stateid forKey:@"prof_address" ];
    [ param setObject:appDelegate.stateid forKey:@"prof_state" ];
    [ param setObject:appDelegate.cityId forKey:@"prof_city" ];
    [ param setObject:appDelegate.residencePin forKey:@"prof_pin" ];

    [ ServerCall getServerResponseWithParameters:param withHUD:YES withCompletion:^(id response)
     {
         NSLog(@"saveProfessionalDetails response == %@", response);
         
         if ( [response isKindOfClass:[NSDictionary class]] )
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [ Utilities showAlertWithMessage:errorStr ];
             }
             else
             {
                 [Utilities setUserDefaultWithObject:@"4" andKey:@"signupStep"];
                 [self changeStepColour:personalInfo];
             }
         }
         else
         {
             [ Utilities showAlertWithMessage:response ];
         }
     } ];
    
 
   /* if ([CommonFunctions reachabiltyCheck])
    {
        [CommonFunctions showActivityIndicatorWithText:@"Wait..."];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *userInfo = [defaults valueForKey:@"userinfo"];
        NSString *authTokenStr = [userInfo objectForKey:@"auth_token"];
        NSString *post =[NSString stringWithFormat:@"mode=saveProfessionalDetails&designation=%@&highesteducation=%@&eduCompYear=%@&workStartYear=%@&experienceYears=%@&company_name=%@&officeemail=%@&officephone=%@&prof_address=%@&prof_state=%@&prof_city=%@&prof_pin=%@",[pfobj valueForKey:@"designation"],[pfobj valueForKey:@"highesteducation"],@"",[pfobj valueForKey:@"workStartYear"],[pfobj valueForKey:@"experienceYears"],[pfobj valueForKey:@"company_name"],[pfobj valueForKey:@"officeemail"],[pfobj valueForKey:@"officephone"],[pfobj valueForKey:@"prof_address"],appDelegate.stateid,appDelegate.cityId,appDelegate.residencePin];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://devapi.Stashfin.com/webServicesMobile/StashfinApp"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:authTokenStr forHTTPHeaderField:@"auth_token"];
        [request setHTTPBody:postData];
        
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async (dispatch_get_main_queue(), ^{
                [CommonFunctions removeActivityIndicator];
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",responseDic);
                NSString *errorStr = [responseDic objectForKey:@"error"];
                if (errorStr.length>0) {
                    [self showAlertWithTitle:@"Stashfin" withMessage:errorStr];
                }
                else {
                    NSLog(@"success");
                    [self changeStepColour:personalInfo];
                }
            });
        }]
         
         resume
         ];
    } else {
        [self showAlertWithTitle:@"Stashfin" withMessage:@"Please check internet"];
    }*/
    
}
- (void)getStateFromServer
{
    NSDictionary *dictParam = [NSDictionary dictionaryWithObjectsAndKeys:@"getStates",@"mode",@"1",@"operational", nil];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:NO withCompletion:^(id response)
     {
         NSLog(@"state response == %@", response);
         
         if ( [response isKindOfClass:[NSDictionary class]] )
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [ Utilities showAlertWithMessage:errorStr ];
             }
             else
             {
                 pickerObj.responseDic = response;
             }
         }
         else
         {
             
         }
     }];
}
- (void)serverCallToGenerateOTP
{
    NSMutableDictionary *dictParam = [ NSMutableDictionary dictionary ];
    [ dictParam setObject:@"generateOtp" forKey:@"mode" ];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:NO withCompletion:^(id response)
     {
         NSLog(@" generateOtp response === %@", response);
         
         if ([response isKindOfClass:[NSDictionary class]])
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [Utilities showAlertWithMessage:errorStr];
             }
             else
             {
                 if ( !isOtpGenerate )
                 {
                     isOtpGenerate = YES;
                     [ self showPopupView:_viewOtpVerify onViewController:self ];
                     [ self startTimer ];
                 }
                 
                 _lblMobileNo.text = strPhoneNo;
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
     }];
}
- (void)serverCallToSubmitOTP
{
    NSMutableDictionary *dictParam = [ NSMutableDictionary dictionary ];
    [ dictParam setObject:@"submitOtp" forKey:@"mode" ];
    [ dictParam setObject:_txtOTP.text forKey:@"otp" ];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withCompletion:^(id response)
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
                 [ self hidePopupView:_viewOtpVerify fromViewController:self ];
                 [Utilities setUserDefaultWithObject:@"1" andKey:@"isOtpVerify"];
                 [ Utilities showAlertWithMessage:response[@"msg"]];
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
     }];
    
}
@end
