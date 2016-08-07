//
//  Add or Update ViewController.m
//  AFNetworking
//
//  Created by M. Buğra Atay on 01/08/16.
//  Copyright © 2016 M. Buğra Atay. All rights reserved.
//

#import "Add or Update ViewController.h"

@interface Add_or_Update_ViewController ()
@property NSString *idsi;
@end

@implementation Add_or_Update_ViewController

- (void)viewDidLoad {
    [super viewDidLoad]; // Do any additional setup after loading the view.
    
    if (!_sendedPerson) {
        _idsi = @"0";
     self.title = @"Add";
     }else {
         self.title = @"Update";
         
         _idsi =[NSString stringWithFormat:@"%@",[[_sendedPerson valueForKey:@"kisi"] valueForKey:@"personId"]];
        _txtFirstName.text = [[_sendedPerson valueForKey:@"kisi" ] valueForKey:@"firstName"];
         _txtLastName.text = [[_sendedPerson valueForKey:@"kisi" ]  valueForKey:@"lastName"];
         _txtMail.text = [[_sendedPerson valueForKey:@"kisi" ]  valueForKey:@"mail"];
     }
     
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) sendPerson{
    NSDictionary *person = @{
                             @"personId" : _idsi,
                             @"firstName":_txtFirstName.text,
                             @"lastName":_txtLastName.text,
                             @"mail":_txtMail.text
                             };
    [_txtFirstName resignFirstResponder];
    [_txtMail resignFirstResponder];
    [_txtLastName resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"personSended" object:nil userInfo:person];
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)btnSave:(id)sender {
    [self sendPerson];
}
@end
