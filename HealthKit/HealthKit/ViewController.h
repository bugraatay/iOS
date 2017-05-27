//
//  ViewController.h
//  HealthKit
//
//  Created by M. Buğra Atay on 30/04/2017.
//  Copyright © 2017 M. Buğra Atay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HealthKit/HealthKit.h>

@interface ViewController : UIViewController

@property HKHealthStore *healthStore;
@property NSSet *readObjectType;
@property NSSet *sharedObjectType;
@property NSDateComponents* comps;
@property NSDate *startDate;
@property NSDate *endDate;
@property NSCalendar* calendar;
@end

