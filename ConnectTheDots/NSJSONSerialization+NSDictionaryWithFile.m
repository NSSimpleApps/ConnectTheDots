//
//  NSJSONSerialization+NSDictionaryWithFile.m
//  JSONToCoreData
//
//  Created by NSSimpleApps on 06.02.15.
//  Copyright (c) 2015 NSSimpleApps. All rights reserved.
//

#import "NSJSONSerialization+NSDictionaryWithFile.h"

@implementation NSJSONSerialization (NSDictionaryWithFile)

+ (NSDictionary *)dictionaryWithFile:(NSString *)pathForResource {
    
    NSData *data = [NSData dataWithContentsOfFile:pathForResource];
    
    if (!data) {
        
        return nil;
    }
        
    NSError *error = nil;
    NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&error];
    
    if (error) {
        
        return nil;
    }
    
    return JSONDictionary;
}

@end
