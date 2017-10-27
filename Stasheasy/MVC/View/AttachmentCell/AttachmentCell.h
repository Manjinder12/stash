//
//  AttachmentCell.h
//  Xpressions
//
//  Created by Shivam Sevarik on 12/08/17.
//  Copyright © 2017 6degreesit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttachmentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@end
