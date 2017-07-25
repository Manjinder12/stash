//
//  CityVC.m
//  Stasheasy
//
//  Created by Tushar  on 04/07/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "CityVC.h"
#import "CommonFunctions.h"
#import "City.h"
#import "SignupScreen.h"
#import "AppDelegate.h"
#import "ResidencePinVC.h"


@interface CityVC () {
    NSMutableArray *cityArray;
    City *cityObj;
}
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;
- (IBAction)backBtntapped:(id)sender;

@end

@implementation CityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    cityArray = [NSMutableArray array];
    cityObj = [[City alloc]init];
    [self cityWebserviceCallwithStateId:self.stateId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backBtntapped:(id)sender {
    NSArray *vcArr = [self.navigationController viewControllers];
    for (UIViewController *controller in vcArr) {
        if ([controller isKindOfClass:[SignupScreen  class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

-(void)showAlertWithTitle:(NSString *)atitle withMessage:(NSString *)message {
    UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:atitle message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (50.0f/320.0f)*[UIApplication sharedApplication].keyWindow.frame.size.width;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"citycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }
    UILabel *citylbl = [cell viewWithTag:55];
    City *cobj  = [cityArray objectAtIndex:indexPath.row];
    citylbl.text = cobj.cityName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    City *cobj  = [cityArray objectAtIndex:indexPath.row];
//    NSArray *vcArr = [self.navigationController viewControllers];
//    for (UIViewController *controller in vcArr) {
//        if ([controller isKindOfClass:[SignupScreen  class]]) {
//            [self.navigationController popToViewController:controller animated:YES];
//        }
//    }
    
    ResidencePinVC *rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ResidencePinVC"];
    rvc.cityid = cobj.cityid;
    rvc.cityName = cobj.cityName;
    rvc.stateId =  self.stateId;
    rvc.stateName = self.stateName;
    [self.navigationController pushViewController:rvc animated:YES];
}


#pragma mark - Webservice

-(void)cityWebserviceCallwithStateId:(NSString *)stateId {
    
    if ([CommonFunctions reachabiltyCheck]) {
        //        [CommonFunctions showActivityIndicatorWithText:@"Wait..."];
        
        NSString *post =[NSString stringWithFormat:@"state_id=%@&operational=0&mode=getCities",stateId];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://devapi.stasheasy.com/webServicesMobile/StasheasyApp"]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async (dispatch_get_main_queue(), ^{
                //                [CommonFunctions removeActivityIndicator];
                NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",responseDic);
//                NSString *errorStr = [responseDic objectForKey:@"error"];
//                if (errorStr.length>0) {
//                    [self showAlertWithTitle:@"stasheasy" withMessage:errorStr];
//                }
//                else {
//                    NSLog(@"success");
                    cityArray =  [cityObj getCityModalArray:[responseDic objectForKey:@"cities"]];
                    [self.cityTableView reloadData];
//                }
            });
        }]
         
         resume
         ];
    } else {
        //        [self showAlertWithTitle:@"Stasheasy" withMessage:@"Please check internet"];
    }
    
}

@end
