//
//  GBMetadataFetcher.h
//  GBMetadataFetcher
//
//  Created by Gerardo Blanco García on 01/10/2013.
//  Copyright (c) 2013 Gerardo Blanco García. All rights reserved.
//

// This code is distributed under the terms and conditions of the MIT license.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "GBMetadataFetching.h"
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GBMetadataFetcherType) {
    TVDB    // TVDB fetcher. This is the default.
};

@interface GBMetadataFetcher : NSObject

// Factory method. Returns a new object instance of the default GBMetadataFetcherType that conforms to the protocol
// GBMetadataFetching.
+ (id <GBMetadataFetching>)metadataFetcher;

// Factory method. Returns a new object instance of the indicated GBMetadataFetcherType that conforms to the protocol
// GBMetadataFetching.
+ (id <GBMetadataFetching>)metadataFetcherWithType:(GBMetadataFetcherType) type;

@end
