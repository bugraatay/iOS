//
//  Add or Update ViewController.m
//  AFNetworking
//
//  Created by M. Buğra Atay on 01/08/16.
//  Copyright © 2016 M. Buğra Atay. All rights reserved.
//

#import "Add or Update ViewController.h"

@interface Add_or_Update_ViewController ()

@end

@implementation Add_or_Update_ViewController

- (void)viewDidLoad {
    [super viewDidLoad]; // Do any additional setup after loading the view.
    self.dicPerson = [[NSMutableDictionary alloc] init];
    if (!_sendedPerson) {
     self.title = @"Add";
     }else {
     self.title = @"Update";
         //NSLog(@"%@", _sendedPerson);
        _txtFirstName.text = [[_sendedPerson valueForKey:@"kisi" ] valueForKey:@"firstName"];
         _txtLastName.text = [[_sendedPerson valueForKey:@"kisi" ]  valueForKey:@"lastName"];
         _txtMail.text = [[_sendedPerson valueForKey:@"kisi" ]  valueForKey:@"mail"];
         
     }
     
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void) managePerson{
    NSDictionary *person = @{
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
-(void) addContact{
    
  //  _baseURL = [NSURL URLWithString:@"https://api.myjson.com/"];
    
    NSDictionary *person = @{
                             @"firstName":_txtFirstName.text,
                             @"lastName":_txtLastName.text,
                             @"mail":_txtMail.text
                             };
    [_txtFirstName resignFirstResponder];
    [_txtMail resignFirstResponder];
    [_txtLastName resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"contactAdded" object:nil userInfo:person];
    
    [self.navigationController popViewControllerAnimated:YES];
    }

-(void) updateContact{
    NSDictionary *person = @{
                             @"firstName":_txtFirstName.text,
                             @"lastName":_txtLastName.text,
                             @"mail":_txtMail.text
                             };
    [_txtFirstName resignFirstResponder];
    [_txtMail resignFirstResponder];
    [_txtLastName resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"contactUpdating" object:nil userInfo:person];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)btnSave:(id)sender {
    [self managePerson];
}
@end
