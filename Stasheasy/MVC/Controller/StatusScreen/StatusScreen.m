//
//  StatusScreen.m
//  Stasheasy
//
//  Created by Duke on 07/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "StatusScreen.h"
#import "ChatScreen.h"

@interface StatusScreen (){
    ActionView *actionView;
}

@property (weak, nonatomic) IBOutlet UIView *outerView;
@property (weak, nonatomic) IBOutlet UILabel *emiLbl;


- (IBAction)actionTapped:(id)sender;
- (IBAction)thirdTapped:(id)sender;

@end

@implementation StatusScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _outerView.layer.cornerRadius = 5.0f;
    _outerView.layer.borderWidth =1.0f;
    _outerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _emiLbl.layer.cornerRadius = 5.0f;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionTapped:(id)sender {
    actionView = [[[NSBundle mainBundle] loadNibNamed:@"ActionView" owner:self options:nil] objectAtIndex:0];
    actionView.frame =CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.frame.size.width, [UIApplication sharedApplication].keyWindow.frame.size.height);
    UIButton *crossBtn = [actionView viewWithTag:5];
    UIButton *chatBtn = [actionView viewWithTag:111];
    [chatBtn addTarget:self action:@selector(chatBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [crossBtn addTarget:self action:@selector(crossbuttonTapped) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:actionView];
}

- (IBAction)thirdTapped:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"change3" object:nil];

}

- (void)crossbuttonTapped {
    [actionView removeFromSuperview];
}

-(void)chatBtnTapped
{
    [actionView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chat" object:nil];
    
}


@end
