//
//  Contacts TableViewController.m
//  AFNetworking
//
//  Created by M. Buğra Atay on 01/08/16.
//  Copyright © 2016 M. Buğra Atay. All rights reserved.
//

#import "Contacts TableViewController.h"

@interface Contacts_TableViewController ()

@end

@implementation Contacts_TableViewController

- (void)viewDidLoad {
    _dicPerson =[NSMutableDictionary dictionary];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(maganePerson:)
                                                 name:@"personSended" object:nil];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    self.refreshControl = refresh;
    [refresh addTarget:self action:@selector(yenile) forControlEvents:UIControlEventValueChanged];
    
    [super viewDidLoad];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.people count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",
                                [[[self.people allValues] valueForKey:@"firstName"]objectAtIndex:indexPath.row],
                                [[[self.people allValues] valueForKey:@"lastName"]objectAtIndex:indexPath.row] ];
    cell.detailTextLabel.text = [[[self.people allValues] valueForKey:@"mail"] objectAtIndex:indexPath.row];
    return cell;
}
#pragma mark - Navigation

-(void) maganePerson:(NSNotification *)notification{
  
    [_dicPerson addEntriesFromDictionary:[NSMutableDictionary dictionaryWithObjectsAndKeys: notification.userInfo,_dicPersonKey, nil]];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:_dicPerson
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                             URLString:@"https://api.myjson.com/bins/"
                                                                            parameters:nil
                                                                                 error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            _sourceURL = [[[NSString alloc] initWithFormat:@"%@", (NSDictionary *) responseObject]substringWithRange:NSMakeRange(13,34)];
            [self getContacts];
            
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
        }
    }] resume];
}
-(void) getContacts {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:_sourceURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager
                                      dataTaskWithRequest:request
                                      completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            self.people = [[NSMutableDictionary alloc] initWithDictionary:responseObject copyItems:YES];
            [self.tableView reloadData];
        }
    }];
    [dataTask resume];
}
-(void) yenile{
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"updateSegue" ]) {
        Add_or_Update_ViewController *addVC = [segue destinationViewController];
        addVC.sendedPerson = [NSMutableDictionary dictionary];
        NSIndexPath *index = [self.tableView indexPathForSelectedRow];
        [addVC.sendedPerson setObject:_sourceURL forKey:@"url"];
        _dicPersonKey = [[_people allKeys] objectAtIndex:index.row];
        [addVC.sendedPerson setObject:[[_people allValues]  objectAtIndex:index.row] forKey:@"kisi"];
          }else  {
              _dicPersonKey = [NSString stringWithFormat:@"%d", _dicPerson.count+1];
    }
}

@end
