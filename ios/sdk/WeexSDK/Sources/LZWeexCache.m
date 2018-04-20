//
//  LZWeexCache.m
//  leizong
//
//  Created by Lot on 02/04/2018.
//  Copyright © 2018 leizong. All rights reserved.
//

#import "LZWeexCache.h"
//#import "LZHttpManager.h"

@interface LZWeexCache ()

@property(nonatomic,strong)NSString* weexPath;

@end

@implementation LZWeexCache

+ (instancetype)instance{
    static LZWeexCache* _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _weexPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"weex"];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        
        if (![fm fileExistsAtPath:_weexPath]) {
            NSError* err ;
            BOOL isCtreat;
            isCtreat = [fm createDirectoryAtPath:_weexPath withIntermediateDirectories:YES attributes:nil error:&err];
            if (!isCtreat) {
                NSLog(@"_weexPath create wrong!!!  %@", err);
            }
        }
        
    }
    return self;
}



- (NSURL*)weexUrl:(NSURL*)url{
    NSString* _urlStr = url.absoluteString;
    NSString* _md5 = [WXUtility md5:_urlStr];
    NSString* _path = [_weexPath stringByAppendingPathComponent:_md5];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:_path]) {
        _urlStr = [NSString stringWithFormat:@"file://%@",_path];
    }else{
#ifdef DEBUG
        if ([_urlStr hasPrefix:@"http://192.168."]||[_urlStr hasPrefix:@"https://mpre.xinhuifun.cn/"]) { //测试环境
            return [NSURL URLWithString:_urlStr];
        }
#endif
        [self download:url to:_path];
    }
    
    return [NSURL URLWithString:_urlStr];
}

- (void)download:(NSURL*)url to:(NSString*)path{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if(!error){
            NSLog(@"lzweex down load succccccesssssssssss~~~");
            NSFileManager *mgr = [NSFileManager defaultManager];
            [mgr moveItemAtURL:location toURL:[NSURL fileURLWithPath:path] error:nil];
        }
    }];
    [task resume];
    
}




@end
