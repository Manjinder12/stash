//
//  Status2Screen.m
//  Stasheasy
//
//  Created by tushar on 19/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "Status2Screen.h"
#import "ChatScreen.h"

@interface Status2Screen (){
    ActionView *actionView;
}

@property (weak, nonatomic) IBOutlet UIView *outerView;
@property (weak, nonatomic) IBOutlet UILabel *emiLbl;


- (IBAction)actionTapped:(id)sender;
- (IBAction)fourTapped:(id)sender;


@end

@implementation Status2Screen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _outerView.layer.cornerRadius = 5.0f;
    _outerView.layer.borderWidth =1.0f;
    _outerView.layer.borderColor = [UIColor lightGrayColor].CGColor;

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

- (IBAction)fourTapped:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:nil];
}

- (void)crossbuttonTapped {
    [actionView removeFromSuperview];
}

-(void)chatBtnTapped {
    [actionView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chat" object:nil];

}

@end
