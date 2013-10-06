//
//  GBTVDBGetBanners.m
//  TVShows
//
//  Created by Gerardo Blanco García on 21/07/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import "GBTVDBGetBannersParser.h"

#import "GBMetadataTags.h"
#import "GBTVDBFetcher.h"


@interface GBTVDBGetBannersParser ()

@property (nonatomic, strong) NSMutableArray *banners;
@property (nonatomic, strong) NSMutableDictionary *currentBanner;
@property (nonatomic, strong) NSMutableString *currentString;
@property (nonatomic) BOOL storingCharacters;
@property (nonatomic) BOOL parsingBanner;
@property (nonatomic) NSString *language;
@property (nonatomic, strong) NSError *errorPointer;

@end

@implementation GBTVDBGetBannersParser

+ (NSArray *)arrayForXMLData:(NSData *)data inLanguage:(NSString *)language error:(NSError **)error
{
    GBTVDBGetBannersParser *tvdbParser = [[GBTVDBGetBannersParser alloc] initWithLanguage:language error:error];
    return [tvdbParser parseWithData:data];
}

- (id)initWithLanguage:(NSString *)language error:(NSError **)error
{
    if ((self = [super init])) {
        self.language = language;
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
        return [self.banners copy];
    }
    
    return nil;
}

#pragma mark NSXMLParser Parsing Callbacks

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *) qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([[elementName lowercaseString] isEqualToString:TVDB_BANNERS]) {
        self.banners = [[NSMutableArray alloc] init];
        
    } if ([[elementName lowercaseString] isEqualToString:TVDB_BANNER]) {
        self.parsingBanner = YES;
        self.currentBanner = [[NSMutableDictionary alloc] init];
        
    } if ([[elementName lowercaseString] isEqualToString:TVDB_BANNER_PATH] ||
          [[elementName lowercaseString] isEqualToString:TVDB_BANNER_TYPE] ||
          [[elementName lowercaseString] isEqualToString:TVDB_IDENTIFICATOR] ||
          [[elementName lowercaseString] isEqualToString:TVDB_LANGUAGE]) {
        self.currentString.string = @"";
        self.storingCharacters = YES;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([[elementName lowercaseString] isEqualToString:TVDB_BANNER]) {
        self.parsingBanner = NO;
        
        NSString *language = (self.currentBanner)[LANGUAGE];
        
        if ([language isEqualToString:self.language]) {
            NSURL *url = (self.currentBanner)[BANNER_URL];
            if (url) {
                [self.banners addObject:self.currentBanner];
            }
        }
    }
    
    if (self.parsingBanner) {
        if ([[elementName lowercaseString] isEqualToString:TVDB_BANNER_PATH]) {
            if ([[self.currentString copy] length] != 0) {
                NSURL *url = [NSURL URLWithString:[TVDB_BANNERS_URI stringByAppendingPathComponent:[self.currentString copy]]];
                (self.currentBanner)[BANNER_URL] = url;
            }
            
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_BANNER_TYPE]) {
            (self.currentBanner)[TYPE] = [self.currentString copy];

        } else if ([[elementName lowercaseString] isEqualToString:TVDB_IDENTIFICATOR]) {
            (self.currentBanner)[IDENTIFICATOR] = [self.currentString copy];
            
        } else if ([[elementName lowercaseString] isEqualToString:TVDB_LANGUAGE]) {
            (self.currentBanner)[LANGUAGE] = [self.currentString copy];
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

