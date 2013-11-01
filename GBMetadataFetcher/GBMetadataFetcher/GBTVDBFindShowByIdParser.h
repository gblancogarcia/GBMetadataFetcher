//
//  GBTVDBFindShowByIdParser.h
//  TVShows
//
//  Created by Gerardo Blanco García on 02/03/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import "GBMetadataFetcher.h"

#import <Foundation/Foundation.h>

@interface GBTVDBFindShowByIdParser : NSObject <NSXMLParserDelegate>

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)error;

@end
