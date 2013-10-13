//
//  GBPendingOperations.m
//  GBMetadataFetcherDemo
//
//  Created by Gerardo Blanco García on 12/10/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import "GBPendingOperations.h"

@implementation GBPendingOperations

- (NSMutableDictionary *)fetchOperationsInProgress
{
    if (!_fetchOperationsInProgress) {
        _fetchOperationsInProgress = [[NSMutableDictionary alloc] init];
    }
    return _fetchOperationsInProgress;
}

- (NSOperationQueue *)fetchQueue
{
    if (!_fetchQueue) {
        _fetchQueue = [[NSOperationQueue alloc] init];
        _fetchQueue.name = @"Fetch Queue";
        _fetchQueue.maxConcurrentOperationCount = 2;
    }
    return _fetchQueue;
}

@end