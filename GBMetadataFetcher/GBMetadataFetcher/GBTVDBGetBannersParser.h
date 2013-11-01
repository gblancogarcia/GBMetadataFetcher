//
//  GBTVDBGetBanners.h
//  TVShows
//
//  Created by Gerardo Blanco García on 21/07/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import "GBMetadataFetcher.h"

#import <Foundation/Foundation.h>

@interface GBTVDBGetBannersParser : NSObject <NSXMLParserDelegate>

+ (NSArray *)arrayForXMLData:(NSData *)data inLanguage:(NSString *)language error:(NSError **)error;

@end
