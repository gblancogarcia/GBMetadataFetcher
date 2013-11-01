//
//  GBMetadataFetching.h
//  GBMetadataFetcher
//
//  Created by Gerardo Blanco García on 01/10/2013.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GBMetadataFetching <NSObject>

// Finds the id of a series in a language based on its name. Returns an array of NSDictionary objects containing the
// following possible keys: 'imdbId', 'language', 'premiereDate', 'showId', 'summary', 'title', 'tvdbId' and 'year'.
- (NSArray *)findShowByName:(NSString *)showName inLanguage:(NSString *)language;

// Find shows by unique id in a language. Returns an array of NSDictionary objects containing the following possible
// keys: 'airDay', 'airTime', 'contentRating', 'coverURL', 'episodes', 'genre', 'imdbId', 'language', 'network',
// 'premiereDate', 'rating', 'runtime', 'title', 'tvdbId', 'showId', 'status', 'summary' and 'year'.
// The value of 'episodes' key is also an array of NSDictionary objects containing the following possible keys:
// 'bannerURL', 'episodeNumber', 'episodeId', 'imdbId', 'language', 'premiereDate', 'rating', 'seasonNumber', 'summary',
// 'title' and 'tvdbId'.
- (NSDictionary *)findShowById:(NSString *)showId inLanguage:(NSString *)language;

@optional

// The TVDB API key.
@property (nonatomic, retain) NSString *apiKey;

// Gets a list of banners. Returns an array of NSDictionary objects containing the following possible keys:
// 'bannerURL', 'identificator, 'language' and 'type'.
- (NSArray *)getBannersById:(NSString *)showId inLanguage:(NSString *)language;

- (NSDictionary *)findEpisodeById:(NSString *)episodeId;

- (NSDictionary *)findEpisodeByShowId:(NSString *)showId
                         seasonNumber:(NSString *)seasonNumber
                        episodeNumber:(NSString *)episodeNumber;

@end
