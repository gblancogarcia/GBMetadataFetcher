//
//  TVDBShowParser.m
//  TVShows
//
//  Created by Gerardo Blanco García on 02/03/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import "GBTVDBFindShowByIdParser.h"
#import "GBTVDBFetcher.h"
#import "GBMetadataTags.h"

@interface GBTVDBFindShowByIdParser ()

@property (nonatomic, strong) NSMutableDictionary *show;
@property (nonatomic, strong) NSMutableArray *episodes;
@property (nonatomic, strong) NSMutableDictionary *currentEpisode;
@property (nonatomic, strong) NSMutableString *currentString;
@property (nonatomic) BOOL storingCharacters;
@property (nonatomic) BOOL parsingShow;
@property (nonatomic) BOOL parsingEpisode;
@property (nonatomic, strong) NSError *errorPointer;

@end

@implementation GBTVDBFindShowByIdParser

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)error
{
    GBTVDBFindShowByIdParser *tvdbParser = [[GBTVDBFindShowByIdParser alloc] initWithError:error];
    return [tvdbParser parseWithData:data];
}

- (id)initWithError:(NSError **)error
{
    if ((self = [super init])) {
        self.errorPointer = *error;
    }
    
    return self;
}

- (NSMutableDictionary *)parseWithData:(NSData *)data
{
    self.currentString = [NSMutableString string];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    BOOL success = [parser parse];
    
    if (success) {
        return [self.show copy];
    }
    
    return nil;
}

#pragma mark NSXMLParser Parsing Callbacks

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *) qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([[elementName lowercaseString] isEqualToString:TVDB_DATA]) {
        self.show = [[NSMutableDictionary alloc] init];
    } if ([[elementName lowercaseString] isEqualToString:TVDB_SERIES]) {
        self.parsingShow = YES;
    } if ([[elementName lowercaseString] isEqualToString:TVDB_EPISODE]) {
        self.parsingEpisode = YES;
        self.currentEpisode = [[NSMutableDictionary alloc] init];
    } if ([[elementName lowercaseString] isEqualToString:TVDB_AIRS_DAY_OF_WEEK] ||
          [[elementName lowercaseString] isEqualToString:TVDB_AIRS_TIME] ||
          [[elementName lowercaseString] isEqualToString:TVDB_CONTENT_RATING] ||
          [[elementName lowercaseString] isEqualToString:TVDB_EPISODE_NAME] ||
          [[elementName lowercaseString] isEqualToString:TVDB_EPISODE_NUMBER] ||
          [[elementName lowercaseString] isEqualToString:TVDB_FILENAME] ||
          [[elementName lowercaseString] isEqualToString:TVDB_FIRST_AIRED] ||
          [[elementName lowercaseString] isEqualToString:TVDB_GENRE] ||
          [[elementName lowercaseString] isEqualToString:TVDB_IDENTIFICATOR] ||
          [[elementName lowercaseString] isEqualToString:TVDB_IMDB_ID] ||
          [[elementName lowercaseString] isEqualToString:TVDB_LANGUAGE] ||
          [[elementName lowercaseString] isEqualToString:TVDB_NETWORK] ||
          [[elementName lowercaseString] isEqualToString:TVDB_OVERVIEW] ||
          [[elementName lowercaseString] isEqualToString:TVDB_POSTER] ||
          [[elementName lowercaseString] isEqualToString:TVDB_RATING] ||
          [[elementName lowercaseString] isEqualToString:TVDB_RUNTIME] ||
          [[elementName lowercaseString] isEqualToString:TVDB_SEASON_NUMBER] ||
          [[elementName lowercaseString] isEqualToString:TVDB_SERIES_NAME] ||
          [[elementName lowercaseString] isEqualToString:TVDB_STATUS]) {
            self.currentString.string = @"";
            self.storingCharacters = YES;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([[elementName lowercaseString] isEqualToString:TVDB_DATA]) {
        (self.show)[EPISODES] = [self.episodes copy];
    } if ([[elementName lowercaseString] isEqualToString:TVDB_SERIES]) {
        self.parsingShow = NO;
        self.episodes = [[NSMutableArray alloc] init];
    }  if ([[elementName lowercaseString] isEqualToString:TVDB_EPISODE]) {
        self.parsingEpisode = NO;
        [self.episodes addObject:[self.currentEpisode copy]];
    }
    
    if (self.parsingShow) {
        if ([[elementName lowercaseString] isEqualToString:TVDB_AIRS_DAY_OF_WEEK]) {
            (self.show)[AIR_DAY] = [self.currentString copy];
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_AIRS_TIME]) {
            (self.show)[AIR_TIME] = [self.currentString copy];
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_CONTENT_RATING]) {
            (self.show)[CONTENT_RATING] = [self.currentString copy];
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_FIRST_AIRED]) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            
            NSDate *premiereDate = [dateFormat dateFromString:self.currentString];
            
            if (premiereDate) {
                (self.show)[PREMIERE_DATE] = premiereDate;
                
                NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
                NSDateComponents *components = [[NSCalendar currentCalendar] components:unitFlags fromDate:premiereDate];
                
                NSString *year = [NSString stringWithFormat:@"%ld", (long)[components year]];
                
                (self.show)[YEAR] = year;
            }
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_GENRE]) {
            (self.show)[GENRE] = [self.currentString copy];
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_IDENTIFICATOR]) {
            (self.show)[SHOW_ID] = [self.currentString copy];
            (self.show)[TVDB_ID] = [self.currentString copy];
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_IMDB_ID]) {
            (self.show)[IMDB_ID] = [self.currentString copy];
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_LANGUAGE]) {
            (self.show)[LANGUAGE] = [self.currentString copy];
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_NETWORK]) {
            (self.show)[NETWORK] = [self.currentString copy];
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_OVERVIEW]) {
            (self.show)[SUMMARY] = [self.currentString copy];
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_POSTER]) {
            if ([[self.currentString copy] length] != 0) {
                NSURL *url = [NSURL URLWithString:[TVDB_BANNERS_URI stringByAppendingPathComponent:[self.currentString copy]]];
                (self.show)[COVER_URL] = [url absoluteString];
            }
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_RATING]) {
            double rating;
            NSScanner *scanner = [NSScanner scannerWithString:[self.currentString copy]];
            [scanner scanDouble:&rating];
            (self.show)[RATING] = @(rating);
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_RUNTIME]) {
            (self.show)[RUNTIME] = [self.currentString copy];
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_SERIES_NAME]) {
            (self.show)[TITLE] = [self.currentString copy];
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_STATUS]) {
            (self.show)[STATUS] = [self.currentString copy];
        }
    }
    
    if (self.parsingEpisode) {
        if ([[elementName lowercaseString] isEqualToString:TVDB_EPISODE_NAME]) {
            (self.currentEpisode)[TITLE] = [self.currentString copy];
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_EPISODE_NUMBER]) {
            (self.currentEpisode)[EPISODE_NUMBER] = [self.currentString copy];
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_IDENTIFICATOR]) {
            (self.currentEpisode)[EPISODE_ID] = [self.currentString copy];
            (self.currentEpisode)[TVDB_ID] = [self.currentString copy];
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_FILENAME]) {
            if ([[self.currentString copy] length] != 0) {
                NSURL *url = [NSURL URLWithString:[TVDB_BANNERS_URI stringByAppendingPathComponent:[self.currentString copy]]];
                (self.currentEpisode)[BANNER_URL] = [url absoluteString];
            }
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_FIRST_AIRED]) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            NSDate *premiereDate = [dateFormat dateFromString:self.currentString];
            if (premiereDate) {
                (self.currentEpisode)[PREMIERE_DATE] = premiereDate;
            }
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_IMDB_ID]) {
            (self.currentEpisode)[IMDB_ID] = [self.currentString copy];
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_LANGUAGE]) {
            (self.currentEpisode)[LANGUAGE] = [self.currentString copy];
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_OVERVIEW]) {
            (self.currentEpisode)[SUMMARY] = [self.currentString copy];
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_RATING]) {
            double rating;
            NSScanner *scanner = [NSScanner scannerWithString:[self.currentString copy]];
            [scanner scanDouble:&rating];
            (self.currentEpisode)[RATING] = @(rating);
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_SEASON_NUMBER]) {
            (self.currentEpisode)[SEASON_NUMBER] = [self.currentString copy];
        }
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
