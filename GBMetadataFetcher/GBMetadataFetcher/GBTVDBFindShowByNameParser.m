//
//  GBTVDBFindShowByNameParser.m
//  TVShows
//
//  Created by Gerardo Blanco García on 02/03/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import "GBTVDBFindShowByNameParser.h"
#import "GBTVDBFetcher.h"
#import "GBMetadataTags.h"

@interface GBTVDBFindShowByNameParser ()

@property (nonatomic, strong) NSMutableArray *shows;
@property (nonatomic, strong) NSMutableDictionary *currentShow;
@property (nonatomic, strong) NSMutableString *currentString;
@property (nonatomic) BOOL storingCharacters;
@property (nonatomic, strong) NSError *errorPointer;

@end

@implementation GBTVDBFindShowByNameParser

+ (NSArray *)arrayForXMLData:(NSData *)data error:(NSError **)error
{    
    GBTVDBFindShowByNameParser *tvdbParser = [[GBTVDBFindShowByNameParser alloc] initWithError:error];
    return [tvdbParser parseWithData:data];
}

- (id)initWithError:(NSError **)error
{
    if ((self = [super init])) {
        self.errorPointer = *error;
    }
    
    return self;
}

- (NSArray *)parseWithData:(NSData *)data
{
    self.currentString = [NSMutableString string];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    BOOL success = [parser parse];
    
    if (success) {
        return [self.shows copy];
    }
    
    return nil;
}

#pragma mark NSXMLParser Parsing Callbacks

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *) qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([[elementName lowercaseString] isEqualToString:TVDB_DATA]) {
        self.shows = [[NSMutableArray alloc] init];
    } else if ([[elementName lowercaseString] isEqualToString:TVDB_SERIES]) {
        self.currentShow = [[NSMutableDictionary alloc] init];
    } else if ([[elementName lowercaseString] isEqualToString:TVDB_FIRST_AIRED] ||
               [[elementName lowercaseString] isEqualToString:TVDB_IDENTIFICATOR] ||
               [[elementName lowercaseString] isEqualToString:TVDB_IMDB_ID] ||
               [[elementName lowercaseString] isEqualToString:TVDB_LANGUAGE] ||
               [[elementName lowercaseString] isEqualToString:TVDB_OVERVIEW] ||
               [[elementName lowercaseString] isEqualToString:TVDB_SERIES_NAME] ||
               [[elementName lowercaseString] isEqualToString:TVDB_NETWORK]) {
        self.currentString.string = @"";
        self.storingCharacters = YES;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([[elementName lowercaseString] isEqualToString:TVDB_SERIES]) {
        [self.shows addObject:[self.currentShow copy]];
    } else if ([[elementName lowercaseString] isEqualToString:TVDB_FIRST_AIRED]) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *premiereDate = [dateFormat dateFromString:self.currentString];
        
        if (premiereDate) {
            (self.currentShow)[PREMIERE_DATE] = premiereDate;
            
            NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
            NSDateComponents *components = [[NSCalendar currentCalendar] components:unitFlags fromDate:premiereDate];
            
            NSString *year = [NSString stringWithFormat:@"%ld", (long)[components year]];
            
            (self.currentShow)[YEAR] = year;
        }
    } else if ([[elementName lowercaseString] isEqualToString:TVDB_IDENTIFICATOR]) {
        (self.currentShow)[SHOW_ID] = [self.currentString copy];
        (self.currentShow)[TVDB_ID] = [self.currentString copy];
    } else if ([[elementName lowercaseString] isEqualToString:TVDB_IMDB_ID]) {
        (self.currentShow)[IMDB_ID] = [self.currentString copy];
    } else if ([[elementName lowercaseString] isEqualToString:TVDB_LANGUAGE]) {
        (self.currentShow)[LANGUAGE] = [self.currentString copy];
    } else if ([[elementName lowercaseString] isEqualToString:TVDB_OVERVIEW]) {
        (self.currentShow)[SUMMARY] = [self.currentString copy];
    } else if ([[elementName lowercaseString] isEqualToString:TVDB_SERIES_NAME]) {
        (self.currentShow)[TITLE] = [self.currentString copy];
    }
    
    self.storingCharacters = NO;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.storingCharacters) {
       [self.currentString appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    self.errorPointer = parseError;
}

@end
