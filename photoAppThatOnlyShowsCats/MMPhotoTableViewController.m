//
//  MMPhotoTableViewController.m
//  photoAppThatOnlyShowsCats
//
//  Created by StopBitingMe on 2/20/13.
//  Copyright (c) 2013 StopBitingMe. All rights reserved.
//

#import "MMPhotoTableViewController.h"

@interface MMPhotoTableViewController ()
{
    NSDictionary *flickrPhotoADictionary;
    NSArray *arrayOfSingularPhotos;
    IBOutlet UITableView *photoTableViewController;
}
@end

@implementation MMPhotoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *baseAPI = @"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=8ee0fab323e06c0f242ddc5e43e5ef2d&tags=cat&format=json&nojsoncallback=1";
    NSURL *flickrAPIURL = [NSURL URLWithString:baseAPI];
    NSMutableURLRequest *flickrURLRequest = [NSMutableURLRequest requestWithURL:flickrAPIURL];
    flickrURLRequest.HTTPMethod = @"GET";
    [NSURLConnection sendAsynchronousRequest:flickrURLRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^void (NSURLResponse *urlResponse, NSData *myData, NSError *theirError)
                         {
                             if (theirError) {
                                 NSLog(@"%@", theirError.localizedDescription);
                             }
                             NSError *jsonError;
                             id jsonObject =[NSJSONSerialization JSONObjectWithData:myData
                                                                            options:NSJSONReadingAllowFragments
                                                                              error:&jsonError];
                             flickrPhotoADictionary = (NSDictionary*)jsonObject;
                             NSDictionary *listingPhotoDictionary = [flickrPhotoADictionary valueForKey:@"photos"];
                             arrayOfSingularPhotos = [listingPhotoDictionary valueForKey:@"photo"];
                             [photoTableViewController reloadData];
                             //NSLog(@"%@", flickrPhotoArray);
                             
                         }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"%@", flickrPhotoADictionary);
    if (arrayOfSingularPhotos==nil) {
        return 0;
    }
    return arrayOfSingularPhotos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"photoCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *photoMetaData = [arrayOfSingularPhotos objectAtIndex:indexPath.row];

    //grab all the items in the photoMetaData dictionary
    NSString *photoID = [photoMetaData valueForKey:@"id"];
    NSString *photoOwner = [photoMetaData valueForKey:@"owner"];
    NSString *photoSecret = [photoMetaData valueForKey:@"secret"];
    NSString *photoServer = [photoMetaData valueForKey:@"server"];
    NSString *photoFarm = [photoMetaData valueForKey:@"farm"];
    NSString *photoTitle = [photoMetaData valueForKey:@"title"];

    //create a mutable array and store all the parts of the url
    NSMutableArray *urlArrayofStrings = [[NSMutableArray alloc]init];
    [urlArrayofStrings addObject:@"http://farm"];
    [urlArrayofStrings addObject:photoFarm];
    [urlArrayofStrings addObject:@".staticflickr.com/"];
    [urlArrayofStrings addObject:photoServer];
    [urlArrayofStrings addObject:@"/"];
    [urlArrayofStrings addObject:photoID];
    [urlArrayofStrings addObject:@"_"];
    [urlArrayofStrings addObject:photoSecret];
    [urlArrayofStrings addObject:@"_s"];
    [urlArrayofStrings addObject:@".jpg"];
    
    //
    //TitleLabel
    //
    UIView *viewFromTitleTag = [cell viewWithTag:100];
    UILabel *labelOfTitle = (UILabel*) viewFromTitleTag;
    labelOfTitle.text = photoTitle;
    
    //
    //OwnerLabel
    //
    UIView *viewFromOwnersTag = [cell viewWithTag:101];
    UILabel *labelOfOwner = (UILabel*) viewFromOwnersTag;
    labelOfOwner.text = photoOwner;
    
    //
    //UIImageView
    //
    //smoosh the rows in the array together
    NSString *concatenatedStringsInArray = [urlArrayofStrings componentsJoinedByString:@""];
    NSURL *photoURL = [NSURL URLWithString:concatenatedStringsInArray];
    NSData *photoData = [NSData dataWithContentsOfURL:photoURL];
    UIImage *actualPhoto = [UIImage imageWithData:photoData];
    
    //connect the UIImage to the tag 102
    UIView *viewOfUIImageView = [cell viewWithTag:102];
    UIImageView *interfaceBuilderImageView = (UIImageView*)viewOfUIImageView;
    interfaceBuilderImageView.image = actualPhoto;
    
    
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
