//
//  Contacts TableViewController.h
//  AFNetworking
//
//  Created by M. Buğra Atay on 01/08/16.
//  Copyright © 2016 M. Buğra Atay. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Add or Update ViewController.h"
@interface Contacts_TableViewController : UITableViewController

@property (strong, nonatomic) NSString *sourceURL;
@property (strong, nonatomic) NSMutableDictionary *people;
@property (strong, nonatomic) NSMutableDictionary *dicPerson;
@property (strong, nonatomic) NSString *personId;
@property (strong, nonatomic) NSString *dicPersonKey;
@end
