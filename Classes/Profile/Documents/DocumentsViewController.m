//
//  DocumentsViewController.m
//  StashFin
//
//  Created by sachin khard on 12/09/18.
//  Copyright © 2018 StashFin. All rights reserved.
//

#import "DocumentsViewController.h"
#import "ViewPDFViewController.h"
#import "GalleryCell.h"
#import "FullScreenImageView.h"


@interface DocumentsViewController ()

@property (strong, nonatomic) FullScreenImageView *fullScreenView;

@end

@implementation DocumentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.segmentControl setTintColor:ROSE_PINK_COLOR];
    self.pdfTableView.tableFooterView = [UIView new];
    
    [self.galleryCollectionView registerNib:[UINib nibWithNibName:@"GalleryCell" bundle:nil] forCellWithReuseIdentifier:@"GalleryCell"];
    
    self.fullScreenView = [[FullScreenImageView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60)];
    self.fullScreenView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.fullScreenView];
    
    self.pdfArray = [NSMutableArray new];
    self.galleryArray = [NSMutableArray new];
    
    NSDictionary *tempDic = self.userInfoDic[@"docs"];
    NSArray *docsValuesArray = [tempDic allValues];
    
    for (NSString *path in docsValuesArray)
    {
        if ([[path lowercaseString] containsString:@".pdf"])
        {
            NSArray *allMatchedKeys = [tempDic allKeysForObject:path];
            NSDictionary *tDic = @{@"documentName":[allMatchedKeys lastObject],
                                   @"documentPath":path
                                   };
            
            [self.pdfArray addObject:tDic];
        }
        else if ([[path lowercaseString] containsString:@".jpg"] || [[path lowercaseString] containsString:@".png"] || [[path lowercaseString] containsString:@".jpeg"])
        {
            NSArray *allMatchedKeys = [tempDic allKeysForObject:path];
            NSDictionary *tDic = @{@"documentName":[allMatchedKeys lastObject],
                                   @"documentPath":path
                                   };
            
            [self.galleryArray addObject:tDic];
        }
    }
    
    
    for (NSDictionary *tDic in self.userInfoDic[@"other_selected_docs"])
    {
        NSString *path = tDic[@"document_path"];
        
        if ([[path lowercaseString] containsString:@".pdf"])
        {
            [self.pdfArray addObject:@{@"documentName":tDic[@"document_name"],
                                       @"documentPath":path
                                       }];
        }
        else if ([[path lowercaseString] containsString:@".jpg"] || [[path lowercaseString] containsString:@".png"] || [[path lowercaseString] containsString:@".jpeg"])
        {
            [self.galleryArray addObject:@{@"documentName":tDic[@"document_name"],
                                           @"documentPath":path
                                           }];
        }
    }
    
    [self segmentControlAction:self.segmentControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Documents";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    ViewPDFViewController *vc = [segue destinationViewController];
    vc.pdfURL = sender[@"documentPath"];
    vc.title = [self getFormattedFileNameFromDic:sender];
}

- (IBAction)segmentControlAction:(id)sender {
    if (self.segmentControl.selectedSegmentIndex == 0) {
        [self.pdfTableView setHidden:YES];
        [self.galleryCollectionView setHidden:NO];
    }
    else {
        [self.pdfTableView setHidden:NO];
        [self.galleryCollectionView setHidden:YES];
    }
}

#pragma mark -  Tableview Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pdfArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDFCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PDFCell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = nil;
    cell.textLabel.text = [self getFormattedFileNameFromDic:self.pdfArray[indexPath.row]];
    cell.textLabel.font = [ApplicationUtils GETFONT_MEDIUM_ITALIC:18];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"ViewPDFViewController" sender:self.pdfArray[indexPath.row]];
}


#pragma mark - UICollectionView DataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.galleryArray count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GalleryCell* cell = (GalleryCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryCell" forIndexPath:indexPath];
    cell.contentView.layer.cornerRadius = 5.0f;
    cell.contentView.layer.borderWidth = 1.0f;
    cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    cell.contentView.layer.masksToBounds = YES;
    [cell.documentNameLabel setFont:[ApplicationUtils GETFONT_BOLD:16]];
    
    NSDictionary *tDic = [self.galleryArray objectAtIndex:indexPath.row];
    cell.documentNameLabel.text = [self getFormattedFileNameFromDic:tDic];
    [cell.documentImageView sd_setImageWithURL:[NSURL URLWithString:[ApplicationUtils validateStringData:tDic[@"documentPath"]]] placeholderImage:[UIImage imageNamed:@""]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *tDic = [self.galleryArray objectAtIndex:indexPath.row];
    [self.fullScreenView showLargeImageView:[ApplicationUtils validateStringData:tDic[@"documentPath"]]];
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((CGRectGetWidth(collectionView.frame)-20)/2, (CGRectGetWidth(collectionView.frame)-20)/2);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (NSString *)getFormattedFileNameFromDic:(NSDictionary *)tDic {
    return [[tDic[@"documentName"] stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString];
}

@end
