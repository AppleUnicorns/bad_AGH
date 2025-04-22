//
//  fetcher.h
//  CTF-dev
//
//  Created by Pati on 22/04/2025.
//

#import <Foundation/Foundation.h>

@interface JSONFetcher : NSObject

+ (NSArray *)fetchArrayFromURL:(NSString *)urlString;

@end
