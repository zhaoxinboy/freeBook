//
//  NSDictionary+MMUExtension.h
//  MMUSDK
//
//  Created by GaoBin on 15/9/24.
//  Copyright 2007-2016 Alimama.com. All rights reserved.
//
//  Support Email: afpsupport@list.alibaba-inc.com

#import <Foundation/Foundation.h>

#define object_validate(object, default_value) ((object) == nil ? (default_value) : (object))

@interface NSDictionary (MMUExtension)

- (NSString *)mmuStringValueForKey:(NSString *)key;
- (NSNumber *)mmuNumberValueForKey:(NSString *)key;
- (NSArray *)mmuArrayValueForKey:(NSString *)key;
- (NSDictionary *)mmuDictionaryValueForKey:(NSString *)key;

@end
