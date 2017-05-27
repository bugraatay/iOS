//
//  ViewController.m
//  HealthKit
//
//  Created by M. Buğra Atay on 30/04/2017.
//  Copyright © 2017 M. Buğra Atay. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    
//    [self signInAccountWithUserName:@"Bob"
//                           password:@"BobsPassword"
//                         completion:^(BOOL success) {
//                             if (success) {
//                                 [self displayBalance];
//                             } else {
//                                 // Could not log in. Display alert to user.
//                             }
//                         }];
    
    
    [self.healthStore saveObject:self.startDate withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"Error while saving weight (%@) to Health Store: %@.", self.startDate, error);
        }
        else{
            NSLog(@"başarısız.");
        }
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
@end
