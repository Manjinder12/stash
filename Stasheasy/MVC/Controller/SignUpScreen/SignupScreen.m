//
//  SignupScreen.m
//  Stasheasy
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



@interface SignupScreen ()<UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    AppDelegate *appdelagate;
    UserServices *userService;
    LoanApplication *loanApplicationObj;
    EducationPicker *eduPicker;
    ProfessionalEducation *pfobj;
    BasicInfo *basicInfoModalObj;
    Pickers *pickerObj;
    City *cityObj;
    
    UIPickerView * picker;
    NSArray *basicInfoArray, *idDetailArray, *professionalArray, *docArray;
    
    NSMutableDictionary *basicInfoDic;
    NSMutableArray *marrCity, *pickerArr, *marrState;
    UITextField *selTextfield;
    UIDatePicker *datePickerView;
    int currentRow;
    UIDatePicker *date;
    UIImage *checkImage, *checkoffImage, *uploadActive, *uploadDeactive, *selectedImage;
    UIImagePickerController *imagePicker;
    UIButton *btnUpload;
}

@property (weak, nonatomic) IBOutlet UIButton *btnFirst;
@property (weak, nonatomic) IBOutlet UIButton *btnSecond;
@property (weak, nonatomic) IBOutlet UIButton *btnThird;
@property (weak, nonatomic) IBOutlet UIButton *btnFourth;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;

@property (weak, nonatomic) IBOutlet UITableView *signupTableview;

@property (weak, nonatomic) IBOutlet UILabel *basicinfoLbl;
@property (weak, nonatomic) IBOutlet UILabel *idDetailLbl;
@property (weak, nonatomic) IBOutlet UILabel *personalInfoLbl;
@property (weak, nonatomic) IBOutlet UILabel *docLbl;

@end

@implementation SignupScreen
@synthesize signupStep;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customInitialization];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupAddress) name:@"address" object:nil];
}
- (void)customInitialization
{
    checkImage = [UIImage imageNamed:@"check"];
    checkoffImage = [UIImage imageNamed:@"checkoff"];
    uploadDeactive = [UIImage imageNamed:@"upload"];
    uploadActive = [UIImage imageNamed:@"uploadBtn"];
    
    imagePicker = [[UIImagePickerController alloc] init];
    
    appdelagate = [AppDelegate sharedDelegate];
    userService = [[UserServices alloc]init];
    
    basicInfoDic = [NSMutableDictionary dictionary];
    
    [self setupView];

    if (signupStep > 1)
    {
        [self setSignUpStepView];
    }
    
    [self.signupTableview reloadData];
    
    [ self getStateFromServer ];

}
#pragma mark UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    selectedImage = [info valueForKey:UIImagePickerControllerEditedImage];

    if (selectedImage != nil )
    {
        [btnUpload setBackgroundImage:uploadActive forState:UIControlStateNormal];
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
    NSDictionary *loanDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Loan Amount",@"First",@"Tenure im months",@"Second",nil];
    NSDictionary *dobDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Date of birth",@"First",@"Gender",@"Second",nil];
    NSDictionary *eduDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Linkedin",@"First",@"Education",@"Second",nil];
    NSDictionary *desDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Designation",@"First",@"Since",@"Second",nil];
    NSDictionary *expDic = [NSDictionary dictionaryWithObjectsAndKeys:@"Total Exp",@"First",@"Official Email ID",@"Second",nil];
    
    basicInfoArray = [NSArray arrayWithObjects:@"First Name",@"Last Name",@"Email",@"Mobile Number",@"Company Name",@"check",@"Monthly Salary in Hand",@"City", nil];
   
    idDetailArray = [NSArray arrayWithObjects:loanDic,@"Select reason of Loan",dobDic,@"PAN Number",@"Aadhaar Number",@"Name in Aadhar Card",@"Salary",@"Select Salary Modes",@"Current Address(State,City,Pin)",@"Select Occupied Since",@"Select Residence Since", nil];
    
    professionalArray = [NSArray arrayWithObjects:eduDic,@"Company Name",desDic,expDic,@"Office Landline No.",@"Office Address(State,City,Pin)", nil];
    
    docArray = [NSArray arrayWithObjects:@"PAN Card",@"ID Proof",@"Address Proof",@"Employee ID",@"Salary Slip 1",@"Salary Slip 2",@"Salary Slip 3",@"Office ID",@"Another Document",@"Mention", nil];
  
    
    marrState = [NSMutableArray array];
    pickerArr = [NSMutableArray array];
    
    marrCity = [[NSMutableArray alloc] initWithObjects:@"Delhi",@"Ghaziabad", @"Bombay",@"Pune",@"Banglore",@"Patna",@"Kolkata",@"Kanpur",@"Lucknow",@"Jaipur",nil ];

    
//    marrCity = [NSMutableArray arrayWithObjects:@"PAN Card",@"ID Proof",@"Address Proof",@"Employee ID",@"Salary Slip 1",@"Salary Slip 2",@"Salary Slip 3",@"Office ID",@"Another Document",@"Mention", nil];

    
    // modal basic info initlization
    basicInfoModalObj = [[BasicInfo alloc]init];
    loanApplicationObj = [[LoanApplication alloc]init];
    cityObj = [[City alloc]init];
    pickerObj = [[Pickers alloc]init];
    eduPicker = [[EducationPicker alloc]init];
    pfobj = [[ProfessionalEducation alloc]init];
}

#pragma mark Button Action
- (IBAction)backAAction:(id)sender
{
    [Utilities popToNumberOfControllers:2 withNavigation:self.navigationController];
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
            [self changeStepColour:docUpload];
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
                        }
                        else
                        {
                            [loanApplicationObj setValue:txtInput.text forKey:@"tenure"];
                        }
                    }
                }
                else
                {
                    NSString *keyStr = (NSString *)key;
                    [loanApplicationObj setValue:txtInput.text forKey:keyStr];
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
            UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"Stashfin" message:[error.userInfo objectForKey:NSLocalizedDescriptionKey] preferredStyle:UIAlertControllerStyleAlert];
            
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
                    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"Stashfin" message:[error.userInfo objectForKey:NSLocalizedDescriptionKey] preferredStyle:UIAlertControllerStyleAlert];
                    
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
                    UIAlertController *alert  = [UIAlertController alertControllerWithTitle:@"Stashfin" message:[error.userInfo objectForKey:NSLocalizedDescriptionKey] preferredStyle:UIAlertControllerStyleAlert];
                    
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
            break;
        }
        case idDetails:
        {
            _secondView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            [_btnSecond setBackgroundImage:[UIImage imageNamed:@"greenBtn"] forState:UIControlStateNormal];
            self.idDetailLbl.textColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            [_btnThird setBackgroundImage:[UIImage imageNamed:@"three"] forState:UIControlStateNormal];
            self.personalInfoLbl.textColor = [UIColor blackColor];
            [self serverCallForLoanApplication];
            break;
        }
        case personalInfo:
        {
            _thirdView.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            [_btnThird setBackgroundImage:[UIImage imageNamed:@"greenBtn"] forState:UIControlStateNormal];
            self.personalInfoLbl.textColor = [UIColor colorWithRed:0.0f/255.0f green:184.0f/255.0f blue:73.0f/255.0f alpha:1.0f];
            [_btnFourth setBackgroundImage:[UIImage imageNamed:@"three"] forState:UIControlStateNormal];
            self.docLbl.textColor = [UIColor blackColor];
            [self professionalDetailsServiceCall];
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
        if (signupStep == 3)
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
        else if (textField.tag == 6)
        {
            pickerArr = [pickerObj giveSalPickerArr];
        }
        else if (textField.tag == 9)
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

-(void)setupAddress
{
    NSString *addressString = [NSString stringWithFormat:@"%@,%@,%@",appdelagate.stateName,appdelagate.cityName,appdelagate.residencePin];
    selTextfield.text = addressString;
    [loanApplicationObj setValue:addressString forKey:@"address"];
}

#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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
            return docArray.count;
            break;
        }
        default:
            break;
    }
    return 0;
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
                
                if ([[rowDic objectForKey:@"first"] isEqualToString:@"DOB"]) {
                    doubleCell.calendarBtn.hidden = NO;
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
                if (valStr.length>0) {
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
            if ([[docArray objectAtIndex:indexPath.row]isEqualToString:@"Mention"])
            {
                static NSString *singleTableIdentifier = @"SingleTableViewCell";
                SingleTableViewCell *singleCell  =  [tableView dequeueReusableCellWithIdentifier:singleTableIdentifier];
                if (singleCell == nil) {
                    singleCell =[[[NSBundle mainBundle] loadNibNamed:@"SingleTableViewCell" owner:self options:nil] objectAtIndex:0];
                }
                singleCell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIColor *color = [UIColor lightGrayColor];
                singleCell.singleTextField.font = [UIFont systemFontOfSize:14];
                singleCell.singleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Mention That they can also do this from web" attributes:@{NSForegroundColorAttributeName: color}];
                return singleCell;

            }
            else
            {
                static NSString *uploadTableIdentifier = @"UploadCell";
                UploadCell *uploadCell  =  [tableView dequeueReusableCellWithIdentifier:uploadTableIdentifier];
                if (uploadCell == nil) {
                    uploadCell =[[[NSBundle mainBundle] loadNibNamed:@"UploadCell" owner:self options:nil] objectAtIndex:0];
                }
                uploadCell.uploadLbl.text = [docArray objectAtIndex:indexPath.row];
                uploadCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                uploadCell.checkBtn.tag = indexPath.row;
                [uploadCell.checkBtn addTarget:self action:@selector(checkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                uploadCell.uploadBtn.tag = indexPath.row;
                [uploadCell.uploadBtn addTarget:self action:@selector(uploadButtonAction:) forControlEvents:UIControlEventTouchUpInside];

                return uploadCell;

            }
            
            break;
        }
        default:
            break;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (signupStep == 4)
    {
//        UploadCell *uploadCell = [tableView cellForRowAtIndexPath:indexPath];
//        [uploadCell.uploadBtn setBackgroundImage:[UIImage imageNamed:@"uploadBtn"] forState:UIControlStateNormal];
//        uploadCell.uploadLbl.textColor = [UIColor blackColor];
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
- (void)uploadButtonAction:(id)sender
{
    btnUpload = (UIButton *)sender;
    
    UIActionSheet *imagePop = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose From Library", nil];
    [imagePop showInView:self.view];
    
}
#pragma mark TextField Delegate

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if (signupStep == 1 )
    {
        if ( textField.tag == 2 )
        {
             [ textField setKeyboardType:UIKeyboardTypeEmailAddress ];
             return YES;
        }
        else if ( textField.tag == 3 || textField.tag == 6 )
        {
            [ textField setKeyboardType:UIKeyboardTypeNumberPad ];
            return YES;
        }
        
        /*if ( textField.tag == 7 )
        {
            StateVC *statvc = [self.storyboard instantiateViewControllerWithIdentifier:@"StateVC"];
            statvc.statesArray = [pickerObj giveStatesPickerArr];
            selTextfield = textField;
            [self.navigationController pushViewController:statvc animated:YES];
            return NO;
        }*/
        
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
    else if (signupStep == 2  && (textField.tag == 1 || textField.tag == 6 || textField.tag == 9 || textField.tag == 2 || textField.tag == 8))
    {
        if ((textField.tag == 1 || textField.tag == 6 || textField.tag == 9))
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
                textField.inputView = datePickerView;
                selTextfield = textField;
                return YES;
            }
        }
        else if (textField.tag == 8)
        {
            [pickerArr removeAllObjects];
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy"];
            int i2  = [[formatter stringFromDate:[NSDate date]] intValue];
            //Create Years Array from 1960 to This year
            for (int i=1960; i<=i2; i++) {
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
    else if (signupStep == 2 && textField.tag == 7)
    {
        StateVC *statvc = [self.storyboard instantiateViewControllerWithIdentifier:@"StateVC"];
        statvc.statesArray = [pickerObj giveStatesPickerArr];
        selTextfield = textField;
        [self.navigationController pushViewController:statvc animated:YES];
        return NO;
    }
    else if (signupStep == 3 && (textField.tag == 0 || textField.tag == 2 || textField.tag == 5))
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
        else if (textField.tag == 5) {
            StateVC *statvc = [self.storyboard instantiateViewControllerWithIdentifier:@"StateVC"];
            statvc.statesArray = [eduPicker giveStatesPickerArr];
            selTextfield = textField;
            [self.navigationController pushViewController:statvc animated:YES];
            return NO;
        }
    }
    else
    {
        pickerArr = [NSMutableArray arrayWithArray:[NSArray arrayWithObjects:@"Male",@"Female", nil]];

    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ((signupStep == 2 && (textField.tag == 1 || textField.tag == 6 || textField.tag == 9 || textField.tag == 2 || textField.tag == 8 ) )|| (signupStep == 3 && (textField.tag == 0 || textField.tag == 2))) {
        [textField addCancelDoneOnKeyboardWithTarget:self cancelAction:@selector(cancelAction:) doneAction:@selector(doneAction:)];
    }
}


-(void)doneAction:(id)baritem
{
    
    if (signupStep ==2) {
        
        if (selTextfield.tag == 1) {
            Pickers *loanObj = [[Pickers alloc]init];
            loanObj = [pickerArr objectAtIndex:currentRow];
            [loanApplicationObj setValue:loanObj.id_loaon_reason forKey:@"reason"];
            selTextfield.text = loanObj.loanreason;
        }
        else if (selTextfield.tag == 6) {
            Pickers *salObj = [[Pickers alloc]init];
            salObj = [pickerArr objectAtIndex:currentRow];
            [loanApplicationObj setValue:salObj.id_sal forKey:@"salary"];
            selTextfield.text = salObj.salmode;
        }
        else if (selTextfield.tag == 9) {
            Pickers *resObj = [[Pickers alloc]init];
            resObj = [pickerArr objectAtIndex:currentRow];
            [loanApplicationObj setValue:resObj.id_owner forKey:@"residenceType"];
            selTextfield.text = resObj.owner_type;
            
        }
        else if (selTextfield.tag == 2) {
            if ([selTextfield.placeholder isEqualToString:@"Gender"]) {
                selTextfield.text = [pickerArr objectAtIndex:currentRow];
                if ([selTextfield.text isEqualToString:@"Male"]) {
                    [loanApplicationObj setValue:@"m" forKey:@"gender"];
                    selTextfield.text = @"Male";
                }
                else if ([selTextfield.text isEqualToString:@"Female"]){
                    [loanApplicationObj setValue:@"f" forKey:@"gender"];
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
            }
           
            
        }
        else if (selTextfield.tag == 8) {
            [loanApplicationObj setValue:selTextfield.text forKey:@"occupiedSince"];
            selTextfield.text = [pickerArr objectAtIndex:currentRow];
        }
    }
    else if (signupStep == 3) {
        if (selTextfield.tag == 0) {
            EducationPicker *edPicker = [[EducationPicker alloc]init];
            edPicker = [pickerArr objectAtIndex:currentRow];
            [pfobj setValue:edPicker.id_education forKey:@"highesteducation"];
            selTextfield.text = edPicker.education_name;
        }
        else if (selTextfield.tag == 2) {
            [pfobj setValue:selTextfield.text forKey:@"workStartYear"];
            selTextfield.text = [pickerArr objectAtIndex:currentRow];
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
        else if (selTextfield.tag == 6) {
            Pickers *salObj = [[Pickers alloc]init];
            salObj = [pickerArr objectAtIndex:row];
            return  salObj.salmode;
        }
        else if (selTextfield.tag == 9) {
            Pickers *resObj = [[Pickers alloc]init];
            resObj = [pickerArr objectAtIndex:row];
            return  resObj.owner_type;
        }
        else if (selTextfield.tag == 2 || selTextfield.tag == 8) {
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
    else
    {
        City *cobject = [marrCity objectAtIndex:row];
        if ([selTextfield.placeholder isEqualToString:@"City"] && signupStep == 2)
        {
            selTextfield.text = cobject.cityName ;
            NSArray *keysarr = [basicInfoModalObj giveKeysArray];
            NSString *key = [keysarr objectAtIndex:selTextfield.tag];
            [basicInfoModalObj setValue:cobject.cityid forKey:key];
        }
        currentRow = (int)row;
    }
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

#pragma mark Server Call
-(void)serverCallForBasicInfo
{
    if ([CommonFunctions reachabiltyCheck])
    {
        NSString *fullname = [NSString stringWithFormat:@"%@ %@",[basicInfoModalObj valueForKey:@"fname"],[basicInfoModalObj valueForKey:@"lname"]];
        
        //        [CommonFunctions showActivityIndicatorWithText:@"Wait..."];
        
        NSString *post =[NSString stringWithFormat:@"mode=registration&name=%@&email=%@&phone=%@&company=%@&salary=%@&employmentType=%@&referralCode=""&device=IOS&card=""&utm_source=""&utm_medium=""&utm_content=""&utm_term=""&utm_campaign=""&city=%@",fullname,[basicInfoModalObj valueForKey:@"email"],[basicInfoModalObj valueForKey:@"phone"],[basicInfoModalObj valueForKey:@"company"],[basicInfoModalObj valueForKey:@"salary"],[basicInfoModalObj valueForKey:@"employmentType"],[basicInfoModalObj valueForKey:@"city"]];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://devapi.stasheasy.com/webServicesMobile/StasheasyApp"]];
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
        [self showAlertWithTitle:@"Stasheasy" withMessage:@"Please check internet"];
    }
    
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
                 [ Utilities showAlertWithMessage:errorStr ];
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
        [request setURL:[NSURL URLWithString:@"https://devapi.stasheasy.com/webServicesMobile/StasheasyApp"]];
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
        [request setURL:[NSURL URLWithString:@"https://devapi.stasheasy.com/webServicesMobile/StasheasyApp"]];
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
                    [self showAlertWithTitle:@"stasheasy" withMessage:errorStr];
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
        [self showAlertWithTitle:@"Stasheasy" withMessage:@"Please check internet"];
    }
}

- (void)serverCallForSaveloanApplication
{
    if ([CommonFunctions reachabiltyCheck])
    {
//        [CommonFunctions showActivityIndicatorWithText:@"Wait..."];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *userInfo = [defaults valueForKey:@"userinfo"];
        NSString *loanId = [userInfo objectForKey:@"loanID"];
        NSString *authTokenStr = [userInfo objectForKey:@"auth_token"];
        NSString *post =[NSString stringWithFormat:@"mode=saveLoanApplication&dob=%@&gender=%@&pan_number=%@&aadhar_number=%@&name_in_aadhar=%@&salary_mode=%@&salary=%@&comm_ownership_type=%@&comm_occupied_since=%@&res_address=%@&res_state=%@&res_city=%@&res_pin=%@&loan_amount=%@&loan_tenure=%@&loan_reason=%@&loan_id=%@",[loanApplicationObj valueForKey:@"birthDate"],[loanApplicationObj valueForKey:@"gender"],[loanApplicationObj valueForKey:@"panNumber"],[loanApplicationObj valueForKey:@"adharNumber"],[loanApplicationObj valueForKey:@"adharName"],[loanApplicationObj valueForKey:@"salary"],[basicInfoModalObj valueForKey:@"salary"],[loanApplicationObj valueForKey:@"residenceType"],[loanApplicationObj valueForKey:@"occupiedSince"],[loanApplicationObj valueForKey:@"address"],appdelagate.stateid,appdelagate.cityId,appdelagate.residencePin,[loanApplicationObj valueForKey:@"loanAmount"],[loanApplicationObj valueForKey:@"tenure"],[loanApplicationObj valueForKey:@"reason"],loanId];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://devapi.stasheasy.com/webServicesMobile/StasheasyApp"]];
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
                    [self showAlertWithTitle:@"stasheasy" withMessage:errorStr];
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
        [self showAlertWithTitle:@"Stasheasy" withMessage:@"Please check internet"];
    }
    
}


-(void)professionalDetailsServiceCall
{
    if ([CommonFunctions reachabiltyCheck]) {
        [CommonFunctions showActivityIndicatorWithText:@"Wait..."];
        
        NSString *post =[NSString stringWithFormat:@"mode=professionalFormDetails"];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://devapi.stasheasy.com/webServicesMobile/StasheasyApp"]];
        [request setHTTPMethod:@"POST"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *userInfo = [defaults valueForKey:@"userinfo"];
        NSString *authTokenStr = [userInfo objectForKey:@"auth_token"];
        
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:authTokenStr forHTTPHeaderField:@"auth_token"];
        
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
        [self showAlertWithTitle:@"Stasheasy" withMessage:@"Please check internet"];
    }
    
    
}

-(void)serverCallToSubmitProfessionDetails
{
    if ([CommonFunctions reachabiltyCheck])
    {
        [CommonFunctions showActivityIndicatorWithText:@"Wait..."];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *userInfo = [defaults valueForKey:@"userinfo"];
        NSString *authTokenStr = [userInfo objectForKey:@"auth_token"];
        NSString *post =[NSString stringWithFormat:@"mode=saveProfessionalDetails&designation=%@&highesteducation=%@&eduCompYear=%@&workStartYear=%@&experienceYears=%@&company_name=%@&officeemail=%@&officephone=%@&prof_address=%@&prof_state=%@&prof_city=%@&prof_pin=%@",[pfobj valueForKey:@"designation"],[pfobj valueForKey:@"highesteducation"],@"",[pfobj valueForKey:@"workStartYear"],[pfobj valueForKey:@"experienceYears"],[pfobj valueForKey:@"company_name"],[pfobj valueForKey:@"officeemail"],[pfobj valueForKey:@"officephone"],[pfobj valueForKey:@"prof_address"],appdelagate.stateid,appdelagate.cityId,appdelagate.residencePin];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://devapi.stasheasy.com/webServicesMobile/StasheasyApp"]];
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
                    [self showAlertWithTitle:@"stasheasy" withMessage:errorStr];
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
        [self showAlertWithTitle:@"Stasheasy" withMessage:@"Please check internet"];
    }
    
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

@end
