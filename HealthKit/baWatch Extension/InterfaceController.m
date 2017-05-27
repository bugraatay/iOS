//
//  InterfaceController.m
//  baWatch Extension
//
//  Created by M. Buğra Atay on 30/04/2017.
//  Copyright © 2017 M. Buğra Atay. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@end

@interface HKUnit (HKManager)
+ (HKUnit *)heartBeatsPerMinuteUnit;
@end
@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)btn_CheckHearthRate {
    [self atay];
}

-(void) atay{
    
        self.comps = [[NSDateComponents alloc]init];
        self.calendar = [NSCalendar currentCalendar];
    
        if (NSClassFromString(@"HKHealthStore") && [HKHealthStore isHealthDataAvailable]) {//cihaz ve konumumuz healthkit için uygun mu ona baktık.
    
            self.healthStore = [HKHealthStore new];
            self.comps.day = 1;
//            self.comps.month = 5;
//            self.comps.year = 2017;
            self.startDate = [self.calendar dateFromComponents:self.comps];
            self.endDate = [NSDate date];
    
            HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
            NSPredicate *predicate = [HKQuery
                                      predicateForSamplesWithStartDate:self.startDate
                                      endDate:self.endDate
                                      options:HKQueryOptionStrictStartDate];
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:YES];
    
    
            HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType
                                                                         predicate:predicate
                                                                             limit:5 //HKObjectQueryNoLimit
                                                                   sortDescriptors:@[sortDescriptor]
                                                                    resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
                                                                        
                                                                        if(!error && results)
                                                                        {
                                                                            for(HKQuantitySample *samples in results)
                                                                            {
                                                                            
                                                                                int hbpm = [samples.quantity doubleValueForUnit:[[HKUnit countUnit]unitDividedByUnit:[HKUnit minuteUnit]]];
                                                                                NSLog(@"Bulgular: %d", hbpm);
                                                                                if (hbpm > 70) {
                                                                                    [self.lbl_HearthRate setTextColor:[UIColor redColor]];
                                                                                }
                                                                                else{
                                                                                    [self.lbl_HearthRate setTextColor:[UIColor greenColor]];
                                                                                }
                                                                                
                                                                                self.lbl_HearthRate.text =  [NSString stringWithFormat:@"%d\nKardeş nabıyon? %@", hbpm , (hbpm <= 50) ? @"Yaşıyon mu?" : @"Sakin ol"];
                                                                            }
                                                                        }
                                                                        else {
                                                                            NSLog(@"Buğra, verileri alamıyorum.");
                                                                        }
    
                                                                    }];
            
            
            [self.healthStore executeQuery:sampleQuery];
            
        }
    
}
@end



