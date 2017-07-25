//
//  PreCardScreen.m
//  Stasheasy
//
//  Created by Duke  on 03/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "PreCardScreen.h"

@interface PreCardScreen ()
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;
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
    _orLabel.layer.cornerRadius = 15.0f;
    _orLabel.layer.masksToBounds = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Button Action
- (IBAction)btnBackPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)flashBtnTapped:(id)sender {
    if (_flashButton.tag == 0)
    {
        [_flashButton setBackgroundImage:[UIImage imageNamed:@"flashon"] forState:UIControlStateNormal];
        _flashButton.tag =1;
    }
    else
    {
        [_flashButton setBackgroundImage:[UIImage imageNamed:@"flashoff"] forState:UIControlStateNormal];
        _flashButton.tag = 0;
    }
}
@end
