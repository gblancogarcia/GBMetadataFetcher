//
//  GBTVDBFetcher.h
//  TVShows
//
//  Created by Gerardo Blanco García on 02/03/13.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GBMetadataFetching.h"

#define TVDB_BASE_URI                   @"http://thetvdb.com/api/"
#define TVDB_BANNERS_URI                @"http://thetvdb.com/banners/"
#define TVDB_DEFAULT_LANGUAGE           @"en"
#define TVDB_ACTORS                     @"actors"
#define TVDB_AIRS_DAY_OF_WEEK           @"airs_dayofweek"
#define TVDB_AIRS_TIME                  @"airs_time"
#define TVDB_BANNERS                    @"banners"
#define TVDB_BANNER                     @"banner"
#define TVDB_BANNER_PATH                @"bannerpath"
#define TVDB_BANNER_TYPE                @"bannertype"
#define TVDB_CONTENT_RATING             @"contentrating"
#define TVDB_DATA                       @"data"
#define TVDB_DIRECTOR                   @"director"
#define TVDB_EPISODE                    @"episode"
#define TVDB_EPISODE_NAME               @"episodename"
#define TVDB_EPISODE_NUMBER             @"episodenumber"
#define TVDB_FILENAME                   @"filename"
#define TVDB_FIRST_AIRED                @"firstaired"
#define TVDB_FIRST_AIRED                @"firstaired"
#define TVDB_GENRE                      @"genre"
#define TVDB_GUEST_STARS                @"gueststars"
#define TVDB_IDENTIFICATOR              @"id"
#define TVDB_IMDB_ID                    @"imdb_id"
#define TVDB_LANGUAGE                   @"language"
#define TVDB_NETWORK                    @"network"
#define TVDB_OVERVIEW                   @"overview"
#define TVDB_POSTER                     @"poster"
#define TVDB_RATING                     @"rating"
#define TVDB_RUNTIME                    @"runtime"
#define TVDB_SEASON_NUMBER              @"seasonnumber"
#define TVDB_SERIES                     @"series"
#define TVDB_SERIES_ID                  @"seriesid"
#define TVDB_SERIES_NAME                @"seriesname"
#define TVDB_STATUS                     @"status"

@interface GBTVDBFetcher : NSObject <GBMetadataFetching>

@property (nonatomic, retain) NSString *apiKey;

- (NSDictionary *)findShowByName:(NSString *)showName inLanguage:(NSString *)language;

- (NSDictionary *)findShowById:(NSString *)showId inLanguage:(NSString *)language;

- (NSArray *)getBannersById:(NSString *)showId inLanguage:(NSString *)language;

@end
