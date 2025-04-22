//
//  fetcher.m
//  CTF-dev
//
//  Created by Pati on 22/04/2025.
//

#import "fetcher.h"

@implementation JSONFetcher

+ (NSArray *)fetchArrayFromURL:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *dataError = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&dataError];
    if (dataError) {
        NSLog(@"[FETCH ERROR] %@ – %@", urlString, dataError.localizedDescription);
        return nil;
    }

    NSError *jsonError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    if (jsonError || ![jsonObject isKindOfClass:[NSArray class]]) {
        NSLog(@"[JSON ERROR] %@ – %@", urlString, jsonError.localizedDescription);
        return nil;
    }

    return (NSArray *)jsonObject;
}

@end
