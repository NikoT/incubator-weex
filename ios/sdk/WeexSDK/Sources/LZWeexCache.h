//
//  LZWeexCache.h
//  leizong
//
//  Created by Lot on 02/04/2018.
//  Copyright © 2018 leizong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXUtility.h"

@interface LZWeexCache : NSObject


+ (instancetype)instance;

- (NSURL*)weexUrl:(NSURL*)url;

@end
