//
//  PreApprovedCardViewController.m
//  StashFin
//
//  Created by Mac on 09/05/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "PreApprovedCardViewController.h"
#import "SignupViewController.h"
#import "EmailLoginViewController.h"
#import "LoginViaOTP.h"


@interface PreApprovedCardViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureMetadataOutputObjectsDelegate>
{
    UIImagePickerController *imagePicker;
    UIImage *selectedImage;
    NSString *strScan;
}
@end

@implementation PreApprovedCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _isReading = NO;
    
    [self performSelector:@selector(startReading) withObject:nil afterDelay:0.0];
    
    [self.orLabel setFont:[ApplicationUtils GETFONT_BOLD:17]];
    [self.scanLabel setFont:[ApplicationUtils GETFONT_MEDIUM:18]];
    [self.enterLabel setFont:[ApplicationUtils GETFONT_REGULAR:19]];
    [self.lblCard setFont:[ApplicationUtils GETFONT_ITALIC:18]];
    [self.txtCardNo setFont:[ApplicationUtils GETFONT_MEDIUM:21]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)startReading {
    [self loadBeepSound];

    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    _txtCardNo.text = @"";
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewBarcodeScanner.layer.bounds];
    [_viewBarcodeScanner.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    [_lblCard setText:@"Scanning for QR Code..."];
    _isReading = YES;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            strScan = [metadataObj stringValue];
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            
            NSLog(@"strScan is === %@", strScan);
            
            if (_audioPlayer) {
                [_audioPlayer play];
            }
            
            if ([strScan isNumeric] && strScan.length == 16) {
                [_txtCardNo performSelectorOnMainThread:@selector(setText:) withObject:[self setCardNumber:strScan] waitUntilDone:NO];
                [self serverCallToGetProspectCard:strScan];
            }
            else {
                [_lblCard performSelectorOnMainThread:@selector(setText:) withObject:@"Invalid card number!" waitUntilDone:NO];
            }
        }
    }
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    _isReading = NO;
    
    [_videoPreviewLayer removeFromSuperlayer];
}

-(void)loadBeepSound{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSError *error;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:beepFilePath] error:&error];
    if (error) {
        NSLog(@"Could not play beep file = %@", [error localizedDescription]);
    }
    else {
        [_audioPlayer prepareToPlay];
    }
}

#pragma mark - Textfield Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _txtCardNo)
    {
        NSUInteger newLength = [[textField.text stringByReplacingOccurrencesOfString:@" " withString:@""] length] + [string length] - range.length;
        
        if (newLength >= 16) {
            if (newLength == 16) {
                self.txtCardNo.text = [self.txtCardNo.text stringByAppendingString:string];
                [self serverCallToGetProspectCard:self.txtCardNo.text];
                return YES;
            }
            else {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    selectedImage  = [info valueForKey:UIImagePickerControllerEditedImage];
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    if (detector)  {
        NSArray* featuresR = [detector featuresInImage:[[CIImage alloc] initWithCGImage: selectedImage.CGImage]];
        
        for (CIQRCodeFeature* featureR in featuresR)  {
            strScan = featureR.messageString;
        }
    }
    
    if ([strScan isNumeric] && strScan.length == 16) {
        _txtCardNo.text = [self setCardNumber:strScan];
        [self serverCallToGetProspectCard:strScan];
    }
    else {
        [_lblCard performSelectorOnMainThread:@selector(setText:) withObject:@"Invalid card number!" waitUntilDone:NO];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper Method

- (NSString *)setCardNumber:(NSString *)strcard
{
    NSMutableString *result = [NSMutableString string];
    NSInteger count = 0;
    NSInteger length = 0;
    
    for (int i = 0; i < [strcard length] / 4 ; i++)
    {
        NSUInteger fromIndex = i * 4;
        NSUInteger len = [strcard length] - fromIndex;
        
        if (len > 4) {
            len = 4;
        }
        
        [result appendFormat:@"%@ ",[strcard substringWithRange:NSMakeRange(fromIndex, len)]];
        
        count ++;
        length = [strcard length] - ([result length] - count);
    }
    
    if (count > 0)
    {
        [result appendFormat:@"%@",[strcard substringWithRange:NSMakeRange((count*4), length)]];
    }
    return result;
}


#pragma mark - Button Action

- (IBAction)scanImageAction:(id)sender
{
    _txtCardNo.text = @"";
    [_lblCard setText:@""];
    [self stopReading];

    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)btnScanAction:(id)sender {
    if (!_isReading) {
        [self startReading];
        [_lblCard setText:@"Scanning for QR Code..."];
    }
}

- (IBAction)flashBtnTapped:(id)sender
{
    if (_flashButton.tag == 0)
    {
        [self setFlash:YES];
        [_flashButton setBackgroundImage:[UIImage imageNamed:@"flashon"] forState:UIControlStateNormal];
        _flashButton.tag =1;
    }
    else
    {
        [self setFlash:NO];
        [_flashButton setBackgroundImage:[UIImage imageNamed:@"flashoff"] forState:UIControlStateNormal];
        _flashButton.tag = 0;
    }
}

- (void)setFlash:(BOOL)flash
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch])
    {
        [device lockForConfiguration:nil];
        [device setTorchMode:flash ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
    else {
        [ApplicationUtils showMessage:@"Sorry! flashlight is not available" withTitle:@"" onView:self.view];
    }
}

#pragma mark - Server Call

- (void)serverCallToGetProspectCard:(NSString *)cardNo
{
    [self.view endEditing:YES];
    
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setValue:@"getProspectCardCustomer"      forKey:@"mode"];
    [dictParam setValue:cardNo                          forKey:@"token"];

    [ServerCall getServerResponseWithParameters:dictParam withHUD:YES withHudBgView:self.view withCompletion:^(id response) {
         if ([[response class] isSubclassOfClass:[NSString class]]) {
             [_lblCard setText:response];
         }
         else {
             //check already registred  true --> Login // false --> signup //send utm_source value as well
             
             _txtCardNo.text = [self setCardNumber:strScan];
             _lblCard.text = _txtCardNo.text;
             
             if (![[ApplicationUtils validateStringData:response[@"already_registered"]] boolValue]) {
                 
                 [ApplicationUtils save:[ApplicationUtils validateStringData:response[@"auth_token"]] :@"auth_token"];
                 
                 NSDictionary *cardData = response[@"card"];
                 NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.prefilledDic];

                 if (cardData && cardData.count) {
                     
                     NSMutableArray *nameArray = [NSMutableArray arrayWithArray:[cardData[@"name"] componentsSeparatedByString:@" "]];
                     NSString *lastName = [nameArray lastObject];
                     [nameArray removeLastObject];
                     NSString *firstName = [nameArray componentsJoinedByString:@" "];
                     
                     [dic setObject:[ApplicationUtils validateStringData:firstName]                forKey:FIRST_NAME_KEY];
                     [dic setObject:[ApplicationUtils validateStringData:lastName]                 forKey:LAST_NAME_KEY];
                     [dic setObject:[ApplicationUtils validateStringData:cardData[@"email"]]       forKey:EMAIL_KEY];
                     [dic setObject:[ApplicationUtils validateStringData:cardData[@"mobileNo"]]    forKey:MOBILE_NUMBER_KEY];
                     [dic setObject:[ApplicationUtils validateStringData:cardData[@"companyName"]] forKey:COMPANY_KEY];
                     [dic setObject:[ApplicationUtils validateStringData:cardData[@"salary"]]      forKey:SALARY_KEY];
                 }
                 
                 LoginViaOTP *obj = [[LoginViaOTP alloc] init];
                 [obj setIsFromRegisteration:YES];
                 [obj setPrefilledDic:dic];
                 [obj setCardScanDic:response];
                 [self.navigationController popViewControllerAnimated:NO];
                 [ApplicationUtils pushVCWithFadeAnimation:obj andNavigationController:[AppDelegate instance].homeNavigationControler];
             }
             else {
                 [AlertViewManager sharedManager].alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"", nil) message:@"You are already registered with us. kindly login to continue."
                                                                                cancelButtonItem:[RIButtonItem itemWithLabel:NSLocalizedString(@"OK", nil) action:^{
                     
                     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                     EmailLoginViewController *obj = [storyboard instantiateViewControllerWithIdentifier:@"EmailLoginViewController"];
                     [self.navigationController popViewControllerAnimated:NO];
                     [[AppDelegate instance].homeNavigationControler pushViewController:obj animated:YES];

                 }] otherButtonItems: nil];
                 [[AlertViewManager sharedManager].alertView show];
                 
             }
         }
     }];
}

/*
 {
 "already_registered" = 0;
 campaign =     {
 "campaign_code" = COKHLA01;
 "utm_campaign" = "offline campaign";
 "utm_content" = "persoanl loan";
 "utm_medium" = campaign;
 "utm_source" = "Campaign_Okhala_Pahse1";
 "utm_term" = "Apply for perosnal loan";
 };
 card =     {
 campaignCode = COKHLA01;
 cardNo = 9800000000000001;
 companyName = Bluent;
 createTime = "";
 email = "abdul.raziq@stashfin.com";
 kitNo = "";
 mobileNo = 9000004000;
 name = "test singh  cards";
 salary = 37000;
 };
 }
 */


@end
