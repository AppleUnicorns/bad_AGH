//
//  tool1.m
//  CTF-dev2
//
//  Created by Pati on 23/04/2025.
//
#import <Foundation/Foundation.h>


NSString *handleTool1(NSString *input) {
    if ([input isEqualToString:@"test123"]) return @"test123";
    return [NSString stringWithFormat:@"Tool1 says: %@", input];
}
