//
//  GBMetadataFetcher.m
//  GBMetadataFetcher
//
//  Created by Gerardo Blanco García on 01/10/2013.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import "GBMetadataFetcher.h"
#import "GBTVDBFetcher.h"

@implementation GBMetadataFetcher

+ (id <GBMetadataFetching>)metadataFetcher
{
    return [GBMetadataFetcher metadataFetcherWithType:TVDB];
}

+ (id <GBMetadataFetching>)metadataFetcherWithType:(GBMetadataFetcherType)type
{
    id<GBMetadataFetching> metadataFetcher;
    
    switch(type) {
        case TVDB:
            metadataFetcher = [[GBTVDBFetcher alloc] init];
            break;

        default:
            metadataFetcher = [[GBTVDBFetcher alloc] init];
            break;
    }
    
    return metadataFetcher;
}

@end
