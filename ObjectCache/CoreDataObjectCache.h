//
//  CoreDataObjectCacheCache.h
//  CoreDataAssetCache
//
//  Created by occurred Mac Fhlannchaidh on 06/10/2012.
//  Copyright (c) 2012 occurred Mac Fhlannchaidh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef enum {
    ObjectLoadSourceCache = 0,
    ObjectLoadSourceNetwork
} ObjectLoadSource;

typedef void (^ObjectCacheSuccessBlock)(NSData *object, NSURLResponse *response, ObjectLoadSource source);
typedef void (^ObjectCacheFailureBlock)(NSError *error);
typedef NSData *(^ObjectCacheModifyObjectBlock)(NSData *object);

@interface CoreDataObjectCacheCache : NSObject

@property(readonly, assign, nonatomic) NSUInteger capacity;

@property(readonly, assign) NSUInteger cacheHits;
@property(readonly, assign) NSUInteger cacheMisses;
@property(readonly, assign) NSUInteger totalHits;

+ (id)cache;
+ (id)cacheWithCapacity:(NSUInteger)capacity;

- (void)resetObjectCache;
- (NSUInteger)count;
- (void)printStatistics;

- (void)objectWithURL:(NSURL *)url success:(ObjectCacheSuccessBlock)success failure:(ObjectCacheFailureBlock)failure;
- (void)objectWithRequest:(NSURLRequest *)urlRequest success:(ObjectCacheSuccessBlock)success failure:(ObjectCacheFailureBlock)failure;
- (void)objectWithRequest:(NSURLRequest *)urlRequest modifyObject:(ObjectCacheModifyObjectBlock)modify success:(ObjectCacheSuccessBlock)success failure:(ObjectCacheFailureBlock)failure;
- (void)removeObjectWithURL:(NSURL *)url success:(ObjectCacheSuccessBlock)success failure:(ObjectCacheFailureBlock)failure;

#ifdef DEBUG
+ (void)resetDispatchOnceToken;
#endif

@end
