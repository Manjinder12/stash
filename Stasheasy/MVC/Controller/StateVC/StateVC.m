//
//  StateVC.m
//  Stasheasy
//
//  Created by Tushar  on 04/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "StateVC.h"
#import "Pickers.h"
#import "CityVC.h"
#import "ServerCall.h"
#import "Pickers.h"

@interface StateVC ()
{
    NSMutableArray *marrState;
    Pickers *pickerObj;
}
@property (weak, nonatomic) IBOutlet UITableView *stateTableView;
- (IBAction)backBtntapped:(id)sender;

@end

@implementation StateVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    marrState = [ NSMutableArray new ];
    pickerObj = [ [ Pickers alloc ] init];
    
    _stateTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];;
    
    [ self getStateFromServer ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (50.0f/320.0f)*[UIApplication sharedApplication].keyWindow.frame.size.width;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"statecell";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        }
        UILabel *statelbl = [cell viewWithTag:44];
        Pickers *pickerObj = [self.statesArray objectAtIndex:indexPath.row];
        statelbl.text = pickerObj.stateName;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Pickers *pobj = [self.statesArray objectAtIndex:indexPath.row];
    CityVC *cityVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"CityVC"];
    cityVC.stateId = pobj.id_state;
    cityVC.stateName = pobj.stateName;
    [self.navigationController pushViewController:cityVC animated:YES];
}


- (IBAction)backBtntapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Serverc Call
- (void)getStateFromServer
{
    NSDictionary *dictParam = [NSDictionary dictionaryWithObjectsAndKeys:@"getStates",@"mode",@"1",@"operational", nil];
    
    [ServerCall getServerResponseWithParameters:dictParam withHUD:NO withCompletion:^(id response)
     {
         NSLog(@"state response == %@", response);
         
         if ( [response isKindOfClass:[NSDictionary class]] )
         {
             NSString *errorStr = [response objectForKey:@"error"];
             if ( errorStr.length > 0 )
             {
                 [ Utilities showAlertWithMessage:errorStr ];
             }
             else
             {
                 pickerObj.responseDic = response;
                 self.statesArray = [ pickerObj giveStatesPickerArr ];
                 [self.stateTableView reloadData];
             }
         }
         else
         {
         }
         
     }];
}
@end
