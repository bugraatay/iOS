//
//  Add or Update ViewController.h
//  AFNetworking
//
//  Created by M. Buğra Atay on 01/08/16.
//  Copyright © 2016 M. Buğra Atay. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFHTTPSessionManager.h"
#import "AFURLSessionManager.h"
#import "Contacts TableViewController.h"
@interface Add_or_Update_ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtMail;
- (IBAction)btnSave:(id)sender;
@property (strong, nonatomic) NSMutableDictionary *sendedPerson;
//@property (strong, nonatomic) NSMutableArray *sendedPerson;

@end
