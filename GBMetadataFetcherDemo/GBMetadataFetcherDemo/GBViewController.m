//
//  GBViewController.m
//  GBMetadataFetcherDemo
//
//  Created by Gerardo Blanco García on 12/10/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import "GBViewController.h"

#import "GBLayout.h"
#import "GBPendingOperations.h"
#import "GBTVShowRecord.h"

@interface GBViewController ()

// Search bar.
@property (nonatomic, retain) UISearchBar *searchBar;

// Table view.
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Data.
@property (nonatomic, retain) NSMutableArray *data;

// Pending operations queue.
@property (nonatomic, retain) GBPendingOperations *pendingOperations;

@end

@implementation GBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self cancelAllOperations];
}

#pragma mark - Setup

- (void)setup
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.placeholder = NSLocalizedString(@"Tap to search for TV Shows", nil);
    self.searchBar.delegate = self;
    
    self.navigationItem.titleView = self.searchBar;
    self.navigationController.navigationBar.barTintColor = [GBLayout strongCyan];
    self.navigationController.navigationBar.translucent = NO;
    
    self.data = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Lazy instantiation

- (GBPendingOperations *)pendingOperations {
    if (!_pendingOperations) {
        _pendingOperations = [[GBPendingOperations alloc] init];
    }
    return _pendingOperations;
}

#pragma mark - Loading

- (void)startLoading
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)stopLoading
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - UITableViewDataSource protocol methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"searchResultCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    GBTVShowRecord *record = (self.data)[indexPath.row];
    
    cell.textLabel.text = record.title;
    cell.detailTextLabel.text = record.summary;
    
    return cell;
}

#pragma mark - UISearchBarDelegate protocol methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self startFechingShowByName:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    [self cancelAllOperations];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self clearResults];
    [self cancelAllOperations];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{

}

- (void)clearResults
{
    self.data = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
}

#pragma mark - Operations

- (void)startFechingShowByName:(NSString *)showName
{
    if (![self.pendingOperations.fetchOperationsInProgress.allKeys containsObject:showName]) {
        GBTVShowFetcher *fetcher = [[GBTVShowFetcher alloc] initWithShowName:showName delegate:self];
        (self.pendingOperations.fetchOperationsInProgress)[showName] = fetcher;
        [self.pendingOperations.fetchQueue addOperation:fetcher];
        [self startLoading];
    }
}

#pragma mark - GBTVShowFetcherDelegate protocol methods

- (void)tvShowFetchDidFinish:(GBTVShowFetcher *)fetcher
{
    [self.pendingOperations.fetchOperationsInProgress removeObjectForKey:fetcher.showName];
    
    NSArray *results = fetcher.shows;
    
    if ([results count] != 0) {
        for (id result in results) {
            if ([result isKindOfClass:[NSDictionary class]]) {
                GBTVShowRecord *record = [[GBTVShowRecord alloc] initWithDictionary:result];
                [self.data addObject:record];
            }
        }
    } else {
        NSLog(@"TV Shows not found with the name \"%@\".", fetcher.showName);
    }
    
    [self.tableView reloadData];
    [self stopLoading];
}

#pragma mark - Cancelling queue operation.

- (void)cancelAllOperations
{
    [self stopLoading];
    [self.pendingOperations.fetchQueue cancelAllOperations];
}

@end
