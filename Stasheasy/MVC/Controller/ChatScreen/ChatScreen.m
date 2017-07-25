//
//  ChatScreen.m
//  Stasheasy
//
//  Created by Tushar  on 21/06/17.
//  Copyright © 2017 duke. All rights reserved.
//

#import "ChatScreen.h"
#import "ChatLeftCell.h"
#import "RightChatCell.h"
#import "CommonFunctions.h"

@interface ChatScreen ()
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;

@end

@implementation ChatScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Chat";
    
    UIImage *backImage = [UIImage imageNamed:@"back_arrow"];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f,50, 44)];
    
    [backButton setImage:backImage forState:UIControlStateNormal];
    
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    
    
    // backButton.backgroundColor = [UIColor redColor];
    UIBarButtonItem *barButtonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20.f;

    UIImageView *leftBtn = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftBtn setImage:[UIImage imageNamed:@"sampleimg"]];
    leftBtn.layer.cornerRadius = 20;
    leftBtn.clipsToBounds =YES;
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,barButtonBack,leftBtnItem,nil]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (50.0f/320.0f)*[UIApplication sharedApplication].keyWindow.frame.size.width;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ChatLeftCell";
    if (indexPath.row ==0) {
        ChatLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            [self.chatTableView registerNib:[UINib nibWithNibName:@"ChatLeftCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;

    }
    else {
        static NSString *simpleTableIdentifier = @"RightChatCell";

        RightChatCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            [self.chatTableView registerNib:[UINib nibWithNibName:@"RightChatCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
