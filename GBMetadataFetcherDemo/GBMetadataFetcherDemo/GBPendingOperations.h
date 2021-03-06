//
//  GBPendingOperations.h
//  GBMetadataFetcherDemo
//
//  Created by Gerardo Blanco García on 12/10/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBPendingOperations : NSObject

@property (nonatomic, strong) NSMutableDictionary *fetchOperationsInProgress;
@property (nonatomic, strong) NSOperationQueue *fetchQueue;

@end
