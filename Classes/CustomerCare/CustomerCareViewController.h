//
//  CustomerCareViewController.h
//  StashFin
//
//  Created by sachin khard on 13/10/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@interface CustomerCareViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    NSArray *topicsArray;
    int imageCount;
}

@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@property (weak, nonatomic) IBOutlet UIView *topicView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *textView;
@property (weak, nonatomic) IBOutlet UIView *attachmentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attachmentViewHeight;

- (IBAction)topicsButtonAction:(id)sender;
- (IBAction)submitButtonAction:(id)sender;
- (IBAction)addButtonAction:(id)sender;


@end
