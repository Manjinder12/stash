//
//  RequestCardVC.m
//  Stasheasy
//
//  Created by Mohd Ali Khan on 10/10/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "RequestCardVC.h"
#import "ServerCall.h"
#import "AppDelegate.h"
#import "Utilities.h"

@interface RequestCardVC ()<UIAlertViewDelegate>
{
    AppDelegate *appDelegate;
    NSArray *arrImages;

}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionImage;
@property (weak, nonatomic) IBOutlet UIButton *btnProceed;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@end

@implementation RequestCardVC
@synthesize isFromMenu;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    appDelegate = [ AppDelegate sharedDelegate ];
    arrImages = [[ NSArray alloc] initWithObjects:@"Card1",@"Card2",@"Card3",@"Card4",@"Card5", nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)cancelAction:(id)sender
{
    if ( !isFromMenu )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [ self.navigationController popToViewController:appDelegate.currentVC animated:YES ];
    }
}
- (IBAction)proceedAction:(id)sender
{
    [ self serverCallToRequestCard ];
}

#pragma mark Collectionview Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = collectionView.frame.size.height;
    CGFloat width  = collectionView.frame.size.width;
    return CGSizeMake( width * 1.0, height * 1.0);
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ImageCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView *image  = [cell viewWithTag:100];
    image.image = [UIImage imageNamed:[arrImages objectAtIndex:indexPath.row]];
    return cell;
}
#pragma mark Server Call
- (void)serverCallToRequestCard
{
    NSDictionary *param = [ NSDictionary dictionaryWithObjectsAndKeys:@"requestForCardExistingCustomer",@"mode",appDelegate.dictCustomer[@"phone"],@"phone_no", nil ];
    
    [ServerCall getServerResponseWithParameters:param withHUD:NO withCompletion:^(id response)
     {
         if ( [response isKindOfClass:[NSDictionary class]] )
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 
             }
             else
             {
                 [ Utilities setUserDefaultWithObject:@"1" andKey:@"cardRequested" ];
                 
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Stashfin" message:response[@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
                
             }
         }
         else
         {
             [ Utilities showAlertWithMessage:response ];
         }
         
     }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [ self.navigationController popViewControllerAnimated:YES ];
}

@end
