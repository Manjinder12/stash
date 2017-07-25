//
//  ViewController.m
//  Stasheasy
//
//  Created by Duke on 31/05/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.frostedViewController.limitMenuViewSize = YES;
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftScreen"];
}


@end
