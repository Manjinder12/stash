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
    NSMutableArray *marrDocTitle, *marrIDProof, *marrAddress, *marrDocs, *marrOther , *marrDocName;
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
    
    marrDocTitle = [[ NSMutableArray alloc ] initWithObjects:@"PAN Card",@"ID Proof",@"Address Proof",@"Employee ID",@"Salary Slip1",@"Salary Slip2",@"Salary Slip3",@"Office ID",nil];
    
    marrDocName = [[ NSMutableArray alloc ] initWithObjects:@"pan_proof",@"id_proof",@"address_proof",@"employee_id",@"salary_slip1",@"salary_slip2",@"salary_slip3",@"office_id",nil];
    
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
    selectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];

    [ picker dismissViewControllerAnimated:YES completion:nil ];
    
    if ( !isOtherDoc )
    {
        [ self serverCallForDocUpload ];
    }
    else
    {
        [ self serverCallForOtherDocUpload ];
    }
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
    selectedIndex = 0;
    NSDictionary *dict;
    
    if ( !isOtherDoc )
    {
        if ( isIdProof )
        {
            dict = [marrIDProof objectAtIndex:selectedIndex];
            strDocID = [NSString stringWithFormat:@"%d",[dict[@"id"] intValue]];
            strDocName = @"id_proof";
        }
        else if( isAddreesProof )
        {
            dict = [marrAddress objectAtIndex:selectedIndex];
            strDocID = [NSString stringWithFormat:@"%d",[dict[@"id"] intValue]];
            strDocName = @"address_proof";
        }
        
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
            strDocID = @"";
            strDocName = _txtOther.text;

            [ Utilities hidePopupView:_viewOtherPopUp fromViewController:self ];
            [ self.view endEditing:YES ];
        }
    }
    
    UIActionSheet *imagePop = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose From Library", nil];
    [imagePop showInView:self.view];

}
- (IBAction)cancelAction:(id)sender
{
    [ self.view endEditing:YES ];
    selectedIndex = 0;

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
        if ( path.length > 0 || ![ path isEqualToString:@""])
        {
            [cell.checkBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
            cell.uploadLbl.textColor = [UIColor redColor];
            [cell.uploadBtn setBackgroundImage:[UIImage imageNamed:@"uploadBtn"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.checkBtn setBackgroundImage:[UIImage imageNamed:@"checkoff"] forState:UIControlStateNormal];
            cell.uploadLbl.textColor = [UIColor lightGrayColor];
            [cell.uploadBtn setBackgroundImage:[UIImage imageNamed:@"upload"] forState:UIControlStateNormal];

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
        selectedIndex = indexPath.row;
    }
    else
    {
        selectedIndex = indexPath.row;
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

            strDocID = @"";
            strDocName = [ marrDocName objectAtIndex:btnTag ];
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

#pragma mark Server Call
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
    
    [ marrDocs addObject:dictDocs[@"pan_proof"] ];
    [ marrDocs addObject:dictDocs[@"id_proof"] ];
    [ marrDocs addObject:dictDocs[@"address_proof"] ];
    [ marrDocs addObject:dictDocs[@"employee_id"] ];
    [ marrDocs addObject:dictDocs[@"salary_slip1"] ];
    [ marrDocs addObject:dictDocs[@"salary_slip2"] ];
    [ marrDocs addObject:dictDocs[@"salary_slip3"] ];
    [ marrDocs addObject:dictDocs[@"office_id"] ];
    
    if ( marrOther.count > 0 )
    {
        for ( NSDictionary *temp in marrOther)
        {
            [ marrDocTitle addObject:temp[@"document_name"] ];
            [marrDocs addObject:temp[@"document_path"]];
        }
    }
    
    [ marrDocTitle addObject:@"Any other document" ];// For last cell
    [marrDocs addObject:@""];
    
    [ _tblDocument reloadData ];
}
- (void)serverCallForDocUpload
{
    NSString *base64String = [ NSString stringWithFormat:@"data:image/jpg;base64,%@",[Utilities getBase64EncodedStringOfImage:selectedImage]];
    
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
                 [ marrDocs replaceObjectAtIndex:btnTag withObject:response[@"file_url"] ];
                 
                 if ( isOtherDoc )
                 {
                     [ marrDocTitle insertObject:strDocName atIndex:btnTag ];
                 }
                 
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
- (void)serverCallForOtherDocUpload
{
    NSString *base64String = [ NSString stringWithFormat:@"data:image/jpg;base64,%@",[Utilities getBase64EncodedStringOfImage:selectedImage]];
    
    NSDictionary *param = [NSMutableDictionary new];
    [ param setValue:@"uploadOtherDocument" forKey:@"mode" ];
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
                 [ marrDocs replaceObjectAtIndex:btnTag withObject:response[@"file_url"] ];
                 
                 if ( isOtherDoc )
                 {
                     [ marrDocTitle insertObject:strDocName atIndex:btnTag ];
                     [ marrDocTitle addObject:@"Any other document"];
                     [ marrDocs addObject:@""];
                 }
                 
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
