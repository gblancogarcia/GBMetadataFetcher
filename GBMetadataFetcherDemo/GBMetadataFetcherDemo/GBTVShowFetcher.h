//
//  GBTVShowsFetcher.h
//  GBMetadataFetcherDemo
//
//  Created by Gerardo Blanco García on 12/10/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GBTVShowRecord.h"

@protocol GBTVShowFetcherDelegate;

@interface GBTVShowFetcher : NSOperation

@property (nonatomic, readonly, strong) NSString *showName;
@property (nonatomic, readonly, strong) NSArray *shows;
@property (nonatomic, assign) id <GBTVShowFetcherDelegate> delegate;

- (id)initWithShowName:(NSString *)showName delegate:(id <GBTVShowFetcherDelegate>)delegate;

@end

@protocol GBTVShowFetcherDelegate <NSObject>

- (void)tvShowFetchDidFinish:(GBTVShowFetcher *)fetcher;

@end
