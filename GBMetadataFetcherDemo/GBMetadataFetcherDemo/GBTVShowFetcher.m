//
//  GBTVShowsFetcher.m
//  GBMetadataFetcherDemo
//
//  Created by Gerardo Blanco García on 12/10/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import "GBTVShowFetcher.h"

#import <GBMetadataFetcher/GBMetadataFetcher.h>

NSString * const GBTVDBApiKey = @"96E090AC5181B1B4";

@interface GBTVShowFetcher ()

@property (nonatomic, readwrite, strong) NSString *showName;
@property (nonatomic, readwrite, strong) NSArray *shows;

@end

@implementation GBTVShowFetcher

#pragma mark - Life Cycle

- (id)initWithShowName:(NSString *)showName delegate:(id <GBTVShowFetcherDelegate>)delegate
{
    if (self = [super init]) {
        self.showName = showName;
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - Downloading TVShow cover

- (void)main
{
    @autoreleasepool {
        if (self.isCancelled) {
            return;
        }
        
        id <GBMetadataFetching> metadataFetcher = [GBMetadataFetcher metadataFetcherWithType:TVDB];
        
        if ([metadataFetcher respondsToSelector:@selector(setApiKey:)]) {
            [metadataFetcher setApiKey:GBTVDBApiKey];
        }

        self.shows = [metadataFetcher findShowByName:self.showName inLanguage:nil];
        
        if (self.isCancelled) {
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(tvShowFetchDidFinish:)]) {
            [(NSObject *)self.delegate performSelectorOnMainThread:@selector(tvShowFetchDidFinish:)
                                                        withObject:self
                                                     waitUntilDone:NO];
        }
    }
}

@end
