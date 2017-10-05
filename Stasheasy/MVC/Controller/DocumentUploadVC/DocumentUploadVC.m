//
//  DocumentUploadVC.m
//  Stasheasy
//
//  Created by Mohd Ali Khan on 26/09/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "DocumentUploadVC.h"
#import "ServerCall.h"
#import "REFrostedViewController.h"
#import "UploadCell.h"
#import "Utilities.h"

@interface DocumentUploadVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    NSMutableArray *marrDocTitle, *marrIDProof, *marrAddress, *marrDocs, *marrOther;
    NSDictionary *dictDocs;
    UIImagePickerController *imagePicker;
    BOOL isIdProof, isAddreesProof, isOtherDoc, isOtherPopUP;
    NSInteger selectedIndex, btnTag;
    UIImage *selectedImage;
    NSString *strDocID, *strDocName;
}

@property (weak, nonatomic) IBOutlet UITableView *tblDocument;
@property (weak, nonatomic) IBOutlet UITableView *tblOptions;

@property (weak, nonatomic) IBOutlet UIView *viewPopUp;
@property (weak, nonatomic) IBOutlet UIView *viewOtherPopUp;

@property (weak, nonatomic) IBOutlet UITextField *txtOther;


@end

@implementation DocumentUploadVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [ self customInitialization ];
}
- (void)customInitialization
{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    isIdProof = NO;
    isAddreesProof = NO;
    isOtherDoc = NO;
    isOtherPopUP = NO;
    
    _viewPopUp.hidden = YES;
    _viewOtherPopUp.hidden = YES;
    selectedIndex = 0;
    
    marrAddress = [ NSMutableArray new ];
    marrIDProof = [ NSMutableArray new ];
    marrDocs = [ NSMutableArray new ];
    marrOther = [ NSMutableArray new ];
    marrDocTitle = [[ NSMutableArray alloc ] initWithObjects:@"PAN Card",@"ID Proof",@"Address Proof",@"Employee ID",@"Salary Slip1",@"Salary Slip2",@"Salary Slip3",@"Office ID", nil];
    
    imagePicker = [[UIImagePickerController alloc] init];
    
    _tblDocument.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tblOptions.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [ self serverCallForDocDetail ];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    selectedImage = [info valueForKey:UIImagePickerControllerEditedImage];

    [ picker dismissViewControllerAnimated:YES completion:nil ];
    [ self serverCallForDocUpload ];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [ imagePicker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark Button Action
- (IBAction)menuAction:(id)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
}
- (IBAction)doneAction:(id)sender
{
    [ self.navigationController popViewControllerAnimated:YES ];
}
- (IBAction)okAction:(id)sender
{
    if ( !isOtherDoc )
    {
        [ Utilities hidePopupView:_viewPopUp fromViewController:self ];
    }
    else
    {
        if ( [_txtOther.text isEqualToString:@""] )
        {
            [ Utilities showAlertWithMessage:@"Enter document name" ];
        }
        else
        {
            [ Utilities hidePopupView:_viewOtherPopUp fromViewController:self ];
        }
    }
    
    [ self.view endEditing:YES ];
    
    UIActionSheet *imagePop = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose From Library", nil];
    [imagePop showInView:self.view];
}
- (IBAction)cancelAction:(id)sender
{
    [ self.view endEditing:YES ];
    
    if ( !isOtherDoc )
    {
        [ Utilities hidePopupView:_viewPopUp fromViewController:self ];
    }
    else
    {
        [ Utilities hidePopupView:_viewOtherPopUp fromViewController:self ];
    }
    
}
#pragma mark Tableview Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( tableView == _tblDocument )
    {
        return marrDocs.count;
    }
    else
    {
        if ( isIdProof )
        {
            return marrIDProof.count;
        }
        else if ( isAddreesProof )
        {
            return marrAddress.count;
        }
        return 0;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( tableView ==  _tblDocument )
    {
        UploadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UploadCell"];
        
        if ( !cell )
        {
            [_tblDocument registerNib:[UINib nibWithNibName:@"UploadCell" bundle:nil] forCellReuseIdentifier:@"UploadCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"UploadCell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *path = [ marrDocs objectAtIndex:indexPath.row ];
        
        if ( path.length > 0 )
        {
            [cell.checkBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
            cell.uploadLbl.textColor = [UIColor redColor];
            [cell.uploadBtn setBackgroundImage:[UIImage imageNamed:@"uploadBtn"] forState:UIControlStateNormal];
        }
        else
        {
            NSLog(@"path ===== %@ and length %lu", path,(unsigned long)path.length);
        }
        
        cell.uploadBtn.tag = indexPath.row;
        cell.checkBtn.tag = indexPath.row;
        
        cell.uploadLbl.text = [ marrDocTitle objectAtIndex:indexPath.row ];
        
        [cell.checkBtn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.uploadBtn addTarget:self action:@selector(uploadAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else
    {
        UITableViewCell *cell = [ tableView dequeueReusableCellWithIdentifier:@"OptionCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *leftImage = (UIImageView *)[cell viewWithTag:111];
        
        if ( selectedIndex == indexPath.row )
        {
            leftImage.image = [UIImage imageNamed:@"checked"];
        }
        else
        {
            leftImage.image = [UIImage imageNamed:@"unchecked"];
        }
        
        UILabel *lblTitle = (UILabel *)[cell viewWithTag:222];
    
        NSDictionary *dict;
        if ( isIdProof )
        {
            dict = [marrIDProof objectAtIndex:indexPath.row];
            lblTitle.text = [NSString stringWithFormat:@"%@",dict[@"document_name"]];
        }
        if ( isAddreesProof )
        {
            dict = [marrAddress objectAtIndex:indexPath.row];
            lblTitle.text = [NSString stringWithFormat:@"%@",dict[@"document_name"]];
        }
        
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( tableView == _tblDocument )
    {
        UploadCell *cell = [ tableView cellForRowAtIndexPath:indexPath ];
        if ( cell.uploadLbl.textColor != [UIColor redColor])
        {
            
        }
    }
    else
    {
        NSDictionary *dict;
        selectedIndex = indexPath.row;
        
        if ( isIdProof )
        {
            dict = [marrIDProof objectAtIndex:indexPath.row];
            strDocID = [NSString stringWithFormat:@"%d",[dict[@"id"] intValue]];
        }
        else if( isAddreesProof )
        {
            dict = [marrAddress objectAtIndex:indexPath.row];
            strDocID = [NSString stringWithFormat:@"%d",[dict[@"id"] intValue]];
        }
        else
        {
            strDocID = @"";
        }
        [ _tblOptions reloadData ];

    }
}
#pragma mark Helper Method
- (void)takePhoto
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Device has no camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}
- (void)choosePhotoFromLibrary
{
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)checkAction:(UIButton *)btn
{
    
}
- (void)uploadAction:(UIButton *)btn
{
    btnTag = btn.tag;
    NSString *path = [ marrDocs objectAtIndex:btn.tag ];
    strDocName = [ marrDocTitle objectAtIndex:btn.tag ];
    
    if ( [path isEqualToString:@""] )
    {
        NSString *title = [ marrDocTitle objectAtIndex:btn.tag ];
        if ( [title isEqualToString:@"ID Proof"] )
        {
            isIdProof = YES;
            isAddreesProof = NO;
            isOtherDoc = NO;
            isOtherPopUP  = NO;
            
            [ Utilities showPopupView:_viewPopUp onViewController:self];
            [ _tblOptions reloadData ];

        }
        else if ( [title isEqualToString:@"Address Proof"] )
        {
            isAddreesProof = YES;
            isIdProof = NO;
            isOtherDoc = NO;
            isOtherPopUP  = NO;

            [ Utilities showPopupView:_viewPopUp onViewController:self];
            [ _tblOptions reloadData ];
        }
        else if ( [title isEqualToString:@"Any other document"] )
        {
            isOtherDoc = YES;
            isAddreesProof = NO;
            isIdProof = NO;
            
            _txtOther.text = @"";
            
            [ Utilities showPopupView:_viewOtherPopUp onViewController:self];
            [ _tblOptions reloadData ];
        }

        else
        {
            isIdProof = NO;
            isAddreesProof = NO;
            isOtherDoc = NO;

            UIActionSheet *imagePop = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose From Library", nil];
            [imagePop showInView:self.view];
        }
    }
}

#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self choosePhotoFromLibrary];
            break;
        default:
            break;
    }
}

#pragma marl Server Call
- (void)serverCallForDocDetail
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"documentsFormDetails",@"mode", nil ];
    [ ServerCall getServerResponseWithParameters:param withHUD:nil withCompletion:^(id response)
    {
        NSLog(@"response === %@", response);
        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSString *errorStr = [response objectForKey:@"error"];
            if ( errorStr.length > 0 )
            {
                [Utilities showAlertWithMessage:errorStr];
            }
            else
            {
                [ self populateDocumentDetail:response ];
            }
        }
        else
        {
            [Utilities showAlertWithMessage:response];
        }
        
    } ];
}
- (void)populateDocumentDetail:(NSDictionary *)response
{
    dictDocs = response[@"docs"];
    marrAddress = response[@"address_proof_document_types"];
    marrIDProof = response[@"id_proof_document_types"];
    marrOther = response[@"other_selected_docs"];
    
    for (NSDictionary *temp in marrOther)
    {
        [marrDocTitle addObject:temp[@"document_name"]];
    }
    
    [ marrDocTitle addObject:@"Any other document"];
    
    for ( id key in dictDocs)
    {
        if ( [key isEqualToString:@"pan_proof"] )
        {
            [ marrDocs addObject:dictDocs[@"pan_proof"] ];
        }
        else if ( [key isEqualToString:@"id_proof"] )
        {
            [ marrDocs addObject:dictDocs[@"id_proof"] ];
        }
        else if ( [key isEqualToString:@"address_proof"] )
        {
            [ marrDocs addObject:dictDocs[@"address_proof"] ];
        }
        else if ( [key isEqualToString:@"employee_id"] )
        {
            [ marrDocs addObject:dictDocs[@"employee_id"] ];
        }
        else if ( [key isEqualToString:@"salary_slip1"] )
        {
            [ marrDocs addObject:dictDocs[@"salary_slip1"] ];
        }
        else if ( [key isEqualToString:@"salary_slip2"] )
        {
            [ marrDocs addObject:dictDocs[@"salary_slip2"] ];
        }
        else if ( [key isEqualToString:@"salary_slip3"] )
        {
            [ marrDocs addObject:dictDocs[@"salary_slip3"] ];
        }
        else if ( [key isEqualToString:@"office_id"] )
        {
            [ marrDocs addObject:dictDocs[@"office_id"] ];
        }
    }
    
    for ( NSDictionary *temp in marrOther)
    {
        [marrDocs addObject:temp[@"document_path"]];
    }
    
    [marrDocs addObject:@""];

    
    [ _tblDocument reloadData ];
}
- (void)serverCallForDocUpload
{
    NSString *base64String = [Utilities getBase64EncodedStringOfImage:selectedImage];
    
    NSDictionary *param = [NSMutableDictionary new];
    [ param setValue:@"uploadDocument" forKey:@"mode" ];
    [ param setValue:strDocName forKey:@"document_name" ];
    [ param setValue:base64String forKey:@"image" ];
    [ param setValue:strDocID forKey:@"docId" ];
    
    [ ServerCall getServerResponseWithParameters:param withHUD:YES withCompletion:^(id response)
     {
         NSLog(@"response === %@", response);
         if ([response isKindOfClass:[NSDictionary class]])
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [Utilities showAlertWithMessage:errorStr];
             }
             else
             {
                 [ marrDocs replaceObjectAtIndex:btnTag withObject:_txtOther.text ];
                 [ marrDocTitle replaceObjectAtIndex:btnTag withObject:_txtOther.text ];

                 [Utilities showAlertWithMessage:@"Document uoloaded successfully!" ];
                 [ _tblDocument reloadData];
             }
         }
         else
         {
             [Utilities showAlertWithMessage:response];
         }
     } ];

}
@end
