//
//  InterfaceController.h
//  baWatch Extension
//
//  Created by M. Buğra Atay on 30/04/2017.
//  Copyright © 2017 M. Buğra Atay. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

@interface InterfaceController : WKInterfaceController
- (IBAction)btn_CheckHearthRate;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *lbl_HearthRate;
@property HKHealthStore *healthStore;
@property NSSet *readObjectType;
@property NSSet *sharedObjectType;
@property NSDateComponents* comps;
@property NSDate *startDate;
@property NSDate *endDate;
@property NSCalendar* calendar;
@end
