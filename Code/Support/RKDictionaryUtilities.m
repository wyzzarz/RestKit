//
//  RKDictionaryUtilities.m
//  RestKit
//
//  Created by Blake Watters on 9/11/12.
//  Copyright (c) 2012 RestKit. All rights reserved.
//

#import "RKDictionaryUtilities.h"

NSDictionary *RKDictionaryByMergingDictionaryWithDictionary(NSDictionary *dict1, NSDictionary *dict2)
{
    if (! dict1) return dict2;
    if (! dict2) return dict1;

    NSMutableDictionary *mergedDictionary = [dict1 mutableCopy];

    [dict2 enumerateKeysAndObjectsUsingBlock:^(id key2, id obj2, BOOL *stop) {
        id obj1 = [dict1 valueForKey:key2];
        if ([obj1 isKindOfClass:[NSDictionary class]] && [obj2 isKindOfClass:[NSDictionary class]]) {
            NSDictionary *mergedSubdict = RKDictionaryByMergingDictionaryWithDictionary(obj1, obj2);
            [mergedDictionary setValue:mergedSubdict forKey:key2];
        } else if ([obj1 isKindOfClass:[NSArray class]] && [obj2 isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *mergedArray = [obj1 mutableCopy];
            for (NSInteger i = 0; i < mergedArray.count; i++) {
                id obj1 = mergedArray[i];
                NSDictionary *mergedSubdict = RKDictionaryByMergingDictionaryWithDictionary(obj1, obj2);
                if (mergedSubdict) {
                    [mergedArray replaceObjectAtIndex: i withObject: mergedSubdict];
                }
            }
            [mergedDictionary setValue:mergedArray forKey:key2];
        } else {
            [mergedDictionary setValue:obj2 forKey:key2];
        }
    }];
    
    return [mergedDictionary copy];
}

NSDictionary *RKDictionaryByReplacingPercentEscapesInEntriesFromDictionary(NSDictionary *dictionary)
{
    NSMutableDictionary *results = [NSMutableDictionary dictionaryWithCapacity:[dictionary count]];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop)
     {
         NSString *escapedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         id escapedValue = value;
         if ([value respondsToSelector:@selector(stringByReplacingPercentEscapesUsingEncoding:)])
             escapedValue = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
         [results setObject:escapedValue forKey:escapedKey];
     }];
    return results;
}
