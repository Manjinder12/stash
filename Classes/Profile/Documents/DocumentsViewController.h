//
//  DocumentsViewController.h
//  StashFin
//
//  Created by sachin khard on 12/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocumentsViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *pdfArray;
@property (strong, nonatomic) NSMutableArray *galleryArray;

@property (strong, nonatomic) NSDictionary *userInfoDic;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITableView *pdfTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *galleryCollectionView;

- (IBAction)segmentControlAction:(id)sender;

@end
