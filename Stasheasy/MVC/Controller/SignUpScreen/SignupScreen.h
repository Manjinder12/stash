//
//  SignupScreen.h
//  Stasheasy
//
//  Created by Duke on 01/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import <UIKit/UIKit.h>

enum signupStep
{
    basicInfo = 1,
    idDetails = 2,
    personalInfo = 3,
    docUpload = 4
};

@interface SignupScreen : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property int signupStep;

@end
