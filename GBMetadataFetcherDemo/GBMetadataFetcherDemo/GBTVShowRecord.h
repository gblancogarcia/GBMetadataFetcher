//
//  GBTVShowRecord.h
//  GBMetadataFetcherDemo
//
//  Created by Gerardo Blanco García on 12/10/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GBTVShowRecord : NSObject

@property (nonatomic, retain) NSString *imdbId;
@property (nonatomic, retain) NSString *language;
@property (nonatomic, retain) NSString *network;
@property (nonatomic, retain) NSString *showId;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *tvdbId;
@property (nonatomic) NSUInteger year;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end