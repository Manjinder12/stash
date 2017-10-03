//
//  PreCardScreen.m
//  Stasheasy
//
//  Created by Duke  on 03/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "PreCardScreen.h"
#import "Utilities.h"
#import <AVFoundation/AVFoundation.h>
#import "LoginScreen.h"

@interface PreCardScreen ()<UIImagePickerControllerDelegate>
{
    AppDelegate *appDelegate;
    UIImagePickerController *imagePicker;
    UIImage *selectedImage;
    
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    NSMutableDictionary *mdict;
    NSString *strBarcodeValue;
    UILabel *lblScanLine;
    BOOL isScanDone;
    NSString *strScan;
}

@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblCard;
@property (weak, nonatomic) IBOutlet UILabel *lblLine;

@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (weak, nonatomic) IBOutlet UIButton *btnScan;
@property (weak, nonatomic) IBOutlet UIView *viewBarcodeScanner;

- (IBAction)flashBtnTapped:(id)sender;

@end

@implementation PreCardScreen

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customInitialization];
}
- (void)customInitialization
{
    self.navigationController.navigationBar.hidden = YES;
    
    appDelegate = [AppDelegate  sharedDelegate];
    
    imagePicker = [[ UIImagePickerController alloc ] init];
    isScanDone = NO;
    
    _lblLine.backgroundColor = [ UIColor whiteColor ];
    
    [ self addBarcodeScanner ];
    _orLabel.layer.cornerRadius = 15.0f;
    _orLabel.layer.masksToBounds = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    selectedImage  = [ info valueForKey:UIImagePickerControllerEditedImage ];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark Helper Method
- (NSString *)setCardNumber:(NSString *)strcard
{
    NSMutableString *result = [NSMutableString string];
    int count = 0;
    int length = 0;
    
    for ( int i = 0; i < [ strcard length ] / 4 ; i++)
    {
        NSUInteger fromIndex = i * 4;
        NSUInteger len = [ strcard length ] - fromIndex;
        if (len > 4 )
        {
            len = 4;
        }
        
        [ result appendFormat:@"%@ ",[ strcard substringWithRange:NSMakeRange(fromIndex, len)]];
    
        count ++;
        length = [ strcard length] - ( [ result length] - count);
    }
    
    if ( count > 0 )
    {
        [ result appendFormat:@"%@",[ strcard substringWithRange:NSMakeRange((count*4), length)]];

    }
    return result;
}
- (void)scanImage
{
    if ( ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
    {
        [ Utilities showAlertWithMessage:@"Device has no camera." ];
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
- (void)setFlash :(BOOL)flash
{
    AVCaptureDevice *device = [ AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo ];
    if ( [device hasTorch] )
    {
        [ device lockForConfiguration:nil ];
        [ device setTorchMode:flash ? AVCaptureTorchModeOn : AVCaptureTorchModeOff ];
        [ device unlockForConfiguration ];
    }
}
- (void)addBarcodeScanner
{
    lblScanLine = [[UILabel alloc] init];
    lblScanLine.backgroundColor = [UIColor clearColor];
    [_viewBarcodeScanner addSubview:lblScanLine];
    
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input)
    {
        [_session addInput:_input];
    }
    else
    {
        NSLog(@"Error: %@", error);
    }
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = _viewBarcodeScanner.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_viewBarcodeScanner.layer addSublayer:_prevLayer];
    
    [_session startRunning];
//    _viewBarcode.hidden = NO;
//    [self.view bringSubviewToFront:_viewBarcode];
    [_viewBarcodeScanner bringSubviewToFront:lblScanLine];
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    for (AVMetadataObject *metadata in metadataObjects)
    {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        NSLog(@"detectionString is === %@", detectionString);
        
        if (detectionString != nil)
        {
            if ( !isScanDone )
            {
                strScan = detectionString;
                isScanDone = YES;
                [ self serverCallToGetProspectCard ];
            }
            break;
        }
    }
    lblScanLine.frame = highlightViewRect;
}

#pragma mark Button Action
- (IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)scanImageAction:(id)sender
{
    
}
- (IBAction)flashBtnTapped:(id)sender
{
    if (_flashButton.tag == 0)
    {
        [ self setFlash:YES ];
        [_flashButton setBackgroundImage:[UIImage imageNamed:@"flashon"] forState:UIControlStateNormal];
        _flashButton.tag =1;
    }
    else
    {
        [ self setFlash:NO ];
        [_flashButton setBackgroundImage:[UIImage imageNamed:@"flashoff"] forState:UIControlStateNormal];
        _flashButton.tag = 0;
    }
}

#pragma mark Server Call
- (void)serverCallToGetProspectCard
{
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"getProspectCardCustomer" forKey:@"mode"];

    [ServerCall getServerResponseWithParameters:param withHUD:YES withCompletion:^(id response)
     {
         NSLog(@"response === %@", response);
         
         if ([response isKindOfClass:[NSDictionary class]])
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 if ( strScan.length > 16 )
                 {
                     [Utilities showAlertWithMessage:@"Invalid card"];
                 }
                 else
                 {
                     [Utilities showAlertWithMessage:errorStr];
                     _viewBarcodeScanner.hidden = YES;
                     _lblCard.text = [ self setCardNumber:strScan ];
                     _lblLine.backgroundColor = [ UIColor redColor ];
                 }
             }
             else
             {
                 appDelegate.isPreApproved = YES;
                 _lblCard.text = [ self setCardNumber:strScan ];
                 _lblLine.backgroundColor = [ UIColor redColor ];
                 
                 LoginScreen *login = [ self.storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
                 [self.navigationController pushViewController:login animated:YES];
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
     }];
}

@end
