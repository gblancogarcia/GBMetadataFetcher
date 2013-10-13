GBMetadataFetcher
=================

GBMetadataFetcher library provides 

## Requirements

GBMetadataFetcher works on iOS 7 SDK or later and is compatible with ARC projects.

## Adding GBMetadataFetcher to your project

## Source files

1. Drag the *.h and *.m files from this repository into your project.
2. `#import "GBMetadataFetcher.h"`

### Static library

You can add `GBInfiniteLoopScrollView` as a static library to your project or workspace. 

1. Download the [latest code version](https://github.com/gblancogarcia/GBMetadataFetcher/archive/master.zip) or add the repository as a git submodule to your git-tracked project. 
2. Open your project in Xcode, then drag and drop `GBMetadataFetcher.xcodeproj` onto your project or workspace (use the "Product Navigator view"). 
3. Select your target and go to the Build phases tab. In the Link Binary With Libraries section select the add button. On the sheet find and add `libGBMetadataFetcher.a`. You might also need to add `GBMetadataFetcher` to the Target Dependencies list. 
4. Include `GBInfiniteLoopScrollView` wherever you need it with `#import <GBMetadataFetcher/GBMetadataFetcher.h>`.

## Usage

To use it, you simply need to get an instance of `GBMetadataFetcher`. For this purpose, there are avaliable this two factory methods:

```objective-c
// Returns a new object instance of the default GBMetadataFetcherType that conforms to the protocol GBMetadataFetching.
+ (id <GBMetadataFetching>)metadataFetcher;

// Returns a new object instance of the indicated GBMetadataFetcherType that conforms to the protocol GBMetadataFetching.
+ (id <GBMetadataFetching>)metadataFetcherWithType:(GBMetadataFetcherType) type;
```

You can get a new brand instance this way:

```objective-c
id <GBMetadataFetching> metadataFetcher = [GBMetadataFetcher metadataFetcherWithType:TVDB];
```

To start using GBMetadataFetcher with TVDB type you'll first need an API key from the TVDB website. An API key can be retrieved by registering for one on the TVDB website. Once you have an API key, you'll need to initialize the TVDbClient by setting it as the following:

```objective-c
if ([metadataFetcher respondsToSelector:@selector(setApiKey:)]) {
    [metadataFetcher setApiKey:@"TVDBApiKey"];
}
```

Now you can find the id and other information of a series based on its name whit this method:

```objective-c
- (NSArray *)findShowByName:(NSString *)showName inLanguage:(NSString *)language;
```

It will return an array of NSDictionary objects containing the following possible keys: 
- `imdbId`
- `language`
- `premiereDate`
- `showId`
- `summary`
- `title`
- `tvdbId`
- `year`

[...]

##License (MIT)

Copyright (c) 2013 Gerardo Blanco

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
