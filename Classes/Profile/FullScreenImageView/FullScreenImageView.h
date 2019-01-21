//
//  FullScreenImageView.h
//  StashFin
//
//  Created by sachin khard on 12/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullScreenImageView : UIView

@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;

- (IBAction)closeButtonClicked:(id)sender;
- (void)showLargeImageView:(NSString *)imageURL;

@end
