//
//  SimpleListViewController.m
//  StashFin
//
//  Created by Mac on 16/02/18.
//  Copyright © 2018 Mac. All rights reserved.
//

#import "SimpleListViewController.h"

@interface SimpleListViewController ()

@end

@implementation SimpleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.trendingLabel.font = [ApplicationUtils GETFONT_MEDIUM:17];
    self.trendingLabel.text = self.headerTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
    }
    [cell.textLabel setFont:[ApplicationUtils GETFONT_REGULAR:16]];
    [cell.textLabel setTextAlignment:NSTextAlignmentLeft];
    
    cell.textLabel.text = [self.listArray objectAtIndex:indexPath.row];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate selectedListOption:indexPath.row WithDropdownTag:self.dropdowntag];
}

@end
