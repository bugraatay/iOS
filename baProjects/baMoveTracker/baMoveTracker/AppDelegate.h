//
//  AppDelegate.h
//  baMoveTracker
//
//  Created by M. Buğra Atay on 27/05/2017.
//  Copyright © 2017 M. Buğra Atay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

