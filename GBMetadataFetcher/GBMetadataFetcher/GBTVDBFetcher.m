//
//  GBTVDBFetcher.m
//  TVShows
//
//  Created by Gerardo Blanco García on 02/03/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import "GBTVDBFetcher.h"

#import "GBTVDBFindShowByNameParser.h"
#import "GBTVDBFindShowByIdParser.h"
#import "GBTVDBGetBannersParser.h"

@implementation GBTVDBFetcher

- (NSArray *)findShowByName:(NSString *)showName inLanguage:(NSString *)language
{
    if (showName == nil) {
        return nil;
    }
    
    if (language == nil) {
        language = TVDB_DEFAULT_LANGUAGE;
    }
    
    NSString *searchTerm = [showName stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *searchTermUrl = [NSString stringWithFormat:@"GetSeries.php?seriesname=%@&language=%@", searchTerm, language];
    NSURL *url = [NSURL URLWithString:[TVDB_BASE_URI stringByAppendingPathComponent:searchTermUrl]];
    
    NSData *data = [self requestURL:url];
    NSError *error;
        
    return [GBTVDBFindShowByNameParser arrayForXMLData:data error:&error];
}

- (NSDictionary *)findShowById:(NSString *)showId inLanguage:(NSString *)language
{
    if (showId == nil) {
        return nil;
    }
    
    if (language == nil) {
        language = TVDB_DEFAULT_LANGUAGE;
    }
    
    NSString *searchTermUrl = [NSString stringWithFormat:@"%@/series/%@/all/%@.xml", self.apiKey, showId, language];
    NSURL *url = [NSURL URLWithString:[TVDB_BASE_URI stringByAppendingPathComponent:searchTermUrl]];
    
    NSData *data = [self requestURL:url];
    NSError *error;
    NSDictionary *dictionary;
        
    dictionary = [GBTVDBFindShowByIdParser dictionaryForXMLData:data error:&error];

    return dictionary;
}

- (NSArray *)getBannersById:(NSString *)showId inLanguage:(NSString *)language
{
    if (showId == nil) {
        return nil;
    }
    
    if (language == nil) {
        language = TVDB_DEFAULT_LANGUAGE;
    }
    
    NSString *searchTermUrl = [NSString stringWithFormat:@"%@/series/%@/banners.xml", self.apiKey, showId];
    NSURL *url = [NSURL URLWithString:[TVDB_BASE_URI stringByAppendingPathComponent:searchTermUrl]];
        
    NSData *data = [self requestURL:url];
    NSError *error;
    NSArray *array;
    
    array = [GBTVDBGetBannersParser arrayForXMLData:data inLanguage:language error:&error];
    
    return array;
}

- (NSData *)requestURL:(NSURL *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse *response = [[NSURLResponse alloc] init];
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    return responseData;
}

@end
