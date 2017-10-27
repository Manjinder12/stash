//
//  AttachmentListVC.m
//  Xpressions
//
//  Created by Shivam Sevarik on 12/08/17.
//  Copyright © 2017 6degreesit. All rights reserved.
//

#import "AttachmentListVC.h"
#import "DBAttachmentPickerController.h"
#import "DBAttachment.h"
#import "AttachmentCell.h"
#import "Utilities.h"
#import "AppDelegate.h"

@interface AttachmentListVC ()< UITableViewDelegate,UITableViewDataSource >
{
    NSMutableDictionary *tempDict;
    AppDelegate *appdelegate;
}
@property ( weak, nonatomic ) IBOutlet UITableView *tblAttachments;
@property (strong, nonatomic) NSMutableArray *attachmentArray;
@property (strong, nonatomic) DBAttachmentPickerController *pickerController;

@end

@implementation AttachmentListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tempDict = [[NSMutableDictionary alloc]init];
    self.attachmentArray = [[NSMutableArray alloc] initWithCapacity:100];
    self.navigationController.navigationBarHidden = YES;
    self.title = @"Add Document";
    
    appdelegate = [ AppDelegate sharedDelegate ];
    UIButton *btn = [ UIButton buttonWithType:UIButtonTypeCustom ];
    [ btn setFrame:CGRectMake(0, 0, 30, 30) ];
    [ btn setImage:[ UIImage imageNamed:@"AttachFileIcon.png" ] forState:UIControlStateNormal ];
    [ btn addTarget:self action:@selector(addAttachmentButtonDidSelect:) forControlEvents:UIControlEventTouchUpInside ];
    
    UIButton *btnback = [ UIButton buttonWithType:UIButtonTypeCustom ];
    [ btnback setFrame:CGRectMake(0, 0, 30, 30) ];
    [ btnback setImage:[ UIImage imageNamed:@"back_arrow.png" ] forState:UIControlStateNormal ];
//    [ btnback addTarget:self action:@selector(btnBackAction) forControlEvents:UIControlEventTouchUpInside ];
    
    UIBarButtonItem *barBtn = [[ UIBarButtonItem alloc ] initWithCustomView:btn ];
    UIBarButtonItem *barBtnBack = [[ UIBarButtonItem alloc ] initWithCustomView:btn ];
    self.navigationItem.rightBarButtonItem = barBtn;
    self.navigationItem.leftBarButtonItem = barBtnBack;
}
#pragma mark -
- (IBAction)btnBackAction:(id)sender
{
    appdelegate.strFilePath = @"";
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnAttachmentAction:(id)sender
{
    __weak typeof(self) weakSelf = self;
    DBAttachmentPickerController *attachmentPickerController = [DBAttachmentPickerController attachmentPickerControllerFinishPickingBlock:^(NSArray<DBAttachment *> * _Nonnull attachmentArray)
                                                                {
                                                                    NSMutableArray *indexPathArray = [ NSMutableArray arrayWithCapacity:attachmentArray.count ];
                                                                    NSUInteger currentIndex = weakSelf.attachmentArray.count;
                                                                    for (NSUInteger i = 0; i < attachmentArray.count; i++)
                                                                    {
                                                                        NSIndexPath *indexPath = [ NSIndexPath indexPathForRow:currentIndex+i inSection:0 ];
                                                                        [ indexPathArray addObject:indexPath ];
                                                                    }
                                                                    [ weakSelf.attachmentArray addObjectsFromArray:attachmentArray ];
                                                                    [ weakSelf.tblAttachments insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic ];
                                                                    
                                                                } cancelBlock:nil];
    
    attachmentPickerController.mediaType = DBAttachmentMediaTypeOther;
    attachmentPickerController.capturedVideoQulity = UIImagePickerControllerQualityTypeHigh;
    attachmentPickerController.senderView = nil;
    attachmentPickerController.allowsMultipleSelection = YES;
    attachmentPickerController.allowsSelectionFromOtherApps = YES;
    
    [attachmentPickerController presentOnViewController:self];
}
- (void)addAttachmentButtonDidSelect:(UIBarButtonItem *)sender
{
    __weak typeof(self) weakSelf = self;
    DBAttachmentPickerController *attachmentPickerController = [DBAttachmentPickerController attachmentPickerControllerFinishPickingBlock:^(NSArray<DBAttachment *> * _Nonnull attachmentArray)
    {
        NSMutableArray *indexPathArray = [ NSMutableArray arrayWithCapacity:attachmentArray.count ];
        NSUInteger currentIndex = weakSelf.attachmentArray.count;
        for (NSUInteger i = 0; i < attachmentArray.count; i++)
        {
            NSIndexPath *indexPath = [ NSIndexPath indexPathForRow:currentIndex+i inSection:0 ];
            [ indexPathArray addObject:indexPath ];
        }
        [ weakSelf.attachmentArray addObjectsFromArray:attachmentArray ];
        [ weakSelf.tblAttachments insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic ];
        
    } cancelBlock:nil];
    
    attachmentPickerController.mediaType = DBAttachmentMediaTypeOther;
    attachmentPickerController.capturedVideoQulity = UIImagePickerControllerQualityTypeHigh;
    attachmentPickerController.senderView = nil;
    attachmentPickerController.allowsMultipleSelection = YES;
    attachmentPickerController.allowsSelectionFromOtherApps = YES;
    
    [attachmentPickerController presentOnViewController:self];
}

#pragma mark - UITableView DataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.attachmentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttachmentCell"];
    if (cell == nil)
    {
        cell = [ [ AttachmentCell alloc ] init ];
    }
    [ self configureCell:cell atIndexPath:indexPath ];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBAttachment *attachment = self.attachmentArray[indexPath.row];
    NSString *path = attachment.originalFileResource;
    NSURL *url = [ NSURL fileURLWithPath:path ];
    NSString *strExtension =  [NSString stringWithFormat:@"%@",[url pathExtension]];
    
    if ( [strExtension isEqualToString:@"jpeg"]||
         [strExtension isEqualToString:@"jpg"]||
         [strExtension isEqualToString:@"png"] )
    {
        appdelegate.strFilePath = path;
        appdelegate.isDocFile = NO;
        [ self.navigationController popViewControllerAnimated:YES ];
    }
    else if ( [strExtension isEqualToString:@"pdf"] )
    {
        appdelegate.strFilePath = path;
        appdelegate.isDocFile = YES;
        [ self.navigationController popViewControllerAnimated:YES ];
    }
    else
    {
        [Utilities showAlertWithMessage:@"Invalid File Format"];
    }
}
- (NSString *)getBase64EncodedStringOfObjectByPath:(NSString *)objectPath
{
    
    NSData *dataaaa = [ NSData dataWithContentsOfFile:objectPath ];
    
    NSString *strencoded = [dataaaa base64EncodedStringWithOptions:kNilOptions];
    
    return strencoded;
}
- (void)configureCell:(AttachmentCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    DBAttachment *attachment = self.attachmentArray[indexPath.row];
    
    cell.titleLabel.text = attachment.fileName;
    cell.sizeLabel.text = attachment.fileSizeStr;
//    cell.dateLabel.text = [[NSDateFormatter localizedDateTimeFormatter] stringFromDate:attachment.creationDate];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize scaledThumbnailSize = CGSizeMake( 80.f * scale, 80.f * scale );
    
    [attachment loadThumbnailImageWithTargetSize:scaledThumbnailSize completion:^(UIImage *resultImage) {
        cell.thumbnailImageView.image = resultImage;
    }];
}
@end
