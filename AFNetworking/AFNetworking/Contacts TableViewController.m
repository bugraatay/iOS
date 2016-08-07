//
//  Contacts TableViewController.m
//  AFNetworking
//
//  Created by M. Buğra Atay on 01/08/16.
//  Copyright © 2016 M. Buğra Atay. All rights reserved.
//

#import "Contacts TableViewController.h"

@interface Contacts_TableViewController () <UIAlertViewDelegate>

@end

@implementation Contacts_TableViewController

- (void)viewDidLoad {
    _sendedPerson = [NSMutableArray array];
    _people = [NSMutableArray array];
    _sourceURL = @"https://api.myjson.com/bins//52dgv";
    [self getContacts];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"personSended"
                                               object:nil];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
          self.refreshControl = refresh;
    
    [refresh addTarget:self
                action:@selector(yenile)
      forControlEvents:UIControlEventValueChanged];
    
    [super viewDidLoad];
}

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
    
    cell.textLabel.text =[NSString stringWithFormat:@"%@ %@",
                           [[_people valueForKey:@"firstName"] objectAtIndex:indexPath.row],
                            [[_people valueForKey:@"lastName"] objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text = [[_people valueForKey:@"mail"] objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Oopps!"
                                  message:@"Data is deleting..."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                         {
                             
                             //silinecek
                             [self.tableView reloadData];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                             {
                                 NSLog(@"OK. i did not delete.");
                                 
                             }];
    [alert addAction:ok];
    [alert addAction:cancel];
    
}


-(void) receiveNotification:(NSNotification *) notification{

    NSString *idsi = [NSString string];
    if (![[notification.userInfo objectForKey:@"personId"] isEqualToString:@"0"])
        idsi =[NSString stringWithFormat:@"%@",[notification.userInfo objectForKey:@"personId"]];
    
    else
        idsi = [NSString stringWithFormat:@"%lu",[_people count] + 1];
    
    NSDictionary *kisi =@{
                          @"personId" : idsi,
                          @"firstName":[NSString stringWithFormat:@"%@", [notification.userInfo objectForKey:@"firstName"]],
                           @"lastName":[NSString stringWithFormat:@"%@", [notification.userInfo objectForKey:@"lastName"]],
                               @"mail":[NSString stringWithFormat:@"%@", [notification.userInfo objectForKey:@"mail"]]
                          };
   if (![_people count] ) {
        _sendedPerson = [NSMutableArray arrayWithObject:kisi];
    }
    else
    {
        _sendedPerson =[NSMutableArray arrayWithArray:_people];
        if (![[notification.userInfo objectForKey:@"personId"] isEqualToString:@"0"]) {
            NSIndexPath *index = [self.tableView indexPathForSelectedRow];
            [_sendedPerson removeObject:[_sendedPerson objectAtIndex:index.row]];
        }
        [_sendedPerson addObject:kisi];
    }
    
    [self managePerson];
}
- (void)managePerson
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:_sendedPerson
                                   options:NSJSONWritingPrettyPrinted
                                     error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"PUT"
                                                                             URLString:@"https://api.myjson.com/bins//52dgv"
                                                                            parameters:nil
                                                                                 error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            _sourceURL = [NSString stringWithFormat:@"%@", response.URL];
            NSLog(@"response %@", responseObject);
            [self getContacts];
            
        } else
            NSLog(@"managePerson metodunda bi hata var: %@, %@, %@", error, response, responseObject);
        
    }] resume];
}

-(void) getContacts {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:@"https://api.myjson.com/bins//52dgv"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager
                                      dataTaskWithRequest:request
                                      completionHandler:^(NSURLResponse *response, id responseObjects, NSError *error) {
                                          if (!error) {
                                              _people = responseObjects;
                                              [self.tableView reloadData];
                                              
                                          } else
                                              NSLog(@"getContacts  metodunda bi hata var: %@", error);
                                      }
                                      ];
    [dataTask resume];
}
-(void) yenile{
    [self getContacts];
    [self.refreshControl endRefreshing];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"updateSegue" ]) {
        Add_or_Update_ViewController *addVC = [segue destinationViewController];
        addVC.sendedPerson = [NSMutableDictionary dictionary];
        NSIndexPath *index = [self.tableView indexPathForSelectedRow];
        [addVC.sendedPerson setObject:_sourceURL forKey:@"url"];
        [addVC.sendedPerson setObject:[_people objectAtIndex:index.row] forKey:@"kisi"];
    }
}

- (IBAction)btnDelete:(id)sender {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Oopps!"
                                                   message:@"Tüm kişiler silinsin mi?"
                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                         {
                             [_sendedPerson removeAllObjects];
                             [self managePerson];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                             {
                                 NSLog(@"silmedim");
                                 
                             }];
    [alert addAction:ok];
    [alert addAction:cancel];
    
}

@end

/*
 -(void) addPerson{
 
 NSError *error;
 NSData *jsonData = [NSJSONSerialization
 dataWithJSONObject:_sendedPerson
 options:NSJSONWritingPrettyPrinted
 error:&error];
 NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
 AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
 
 NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
 URLString:_sourceURL
 parameters:nil
 error:nil];
 
 req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
 [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
 [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
 
 
 [[manager dataTaskWithRequest:req
 completionHandler:^(NSURLResponse * _Nonnull response,
 id  _Nullable responseObject,
 NSError * _Nullable error) {
 
 if (!error) {
 _sourceURL = [[[NSString alloc] initWithFormat:@"%@",
 (NSDictionary *) responseObject]substringWithRange:NSMakeRange(13,34)];
 NSLog(@"add source %@", _sourceURL);
 [self getContacts];
 
 } else {
 NSLog(@"addPerson metodunda bi hata var: %@, %@, %@", error, response, responseObject);
 }
 }] resume];
 }*/




