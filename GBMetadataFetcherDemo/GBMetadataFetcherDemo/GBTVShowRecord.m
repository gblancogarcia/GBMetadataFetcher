//
//  GBTVShowRecord.m
//  GBMetadataFetcherDemo
//
//  Created by Gerardo Blanco García on 12/10/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import "GBTVShowRecord.h"

#import <GBMetadataFetcher/GBMetadataTags.h>

@implementation GBTVShowRecord

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self) {
        self.imdbId = dictionary[IMDB_ID];
        self.language = dictionary[LANGUAGE];
        self.network = dictionary[NETWORK];
        self.showId = dictionary[SHOW_ID];
        self.summary = dictionary[SUMMARY];
        self.title = dictionary[TITLE];
        self.tvdbId = dictionary[TVDB_ID];
    }
    
    return self;
}

@end
