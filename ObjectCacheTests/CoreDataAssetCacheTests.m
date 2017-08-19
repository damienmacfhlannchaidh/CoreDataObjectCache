//
//  CoreDataAssetCacheTests.m
//  CoreDataAssetCacheTests
//
//  Created by occurred Mac Fhlannchaidh on 06/10/2012.
//  Copyright (c) 2012 occurred Mac Fhlannchaidh. All rights reserved.
//

#import "CoreDataAssetCacheTests.h"
#import "CoreDataObjectCacheCache.h"

@implementation CoreDataAssetCacheTests

- (void)setUp
{
    [super setUp];
    // Set-up code here.
    [[CoreDataObjectCacheCache cache] resetObjectCache];
    [CoreDataObjectCacheCache resetDispatchOnceToken];
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

- (void)testObjectCacheFactory
{
    CoreDataObjectCacheCache *cache = [CoreDataObjectCacheCache cache];
    STAssertNotNil(cache, @"Cache should not be nil");
}

- (void)testObjectCacheIsSingleton
{
    CoreDataObjectCacheCache *cacheA = [CoreDataObjectCacheCache cache];
    STAssertNotNil(cacheA, @"CacheA should not be nil");

    CoreDataObjectCacheCache *cacheB = [CoreDataObjectCacheCache cache];
    STAssertNotNil(cacheB, @"CacheB should not be nil");

    STAssertEqualObjects(cacheA, cacheB, @"CacheA and CacheB should be equal objects as they are singletons");
}

- (void)testDispatchOnceReset
{
    CoreDataObjectCacheCache *cacheA = [CoreDataObjectCacheCache cache];
    STAssertNotNil(cacheA, @"CacheA should not be nil");

    [CoreDataObjectCacheCache resetDispatchOnceToken];

    CoreDataObjectCacheCache *cacheB = [CoreDataObjectCacheCache cache];
    STAssertNotNil(cacheB, @"CacheB should not be nil");

    if (cacheA == cacheB) {
        STFail(@"Cache singleton did not reset");
    }
}

- (void)testDefaultObjectCacheCapacity
{
    CoreDataObjectCacheCache *cache = [CoreDataObjectCacheCache cache];
    if (cache.capacity != NSUIntegerMax) {
        STFail(@"Capacity should be INTEGER_MAX");
    }
}

- (void)testDefaultObjectCacheCapacity500
{
    CoreDataObjectCacheCache *cache = [CoreDataObjectCacheCache cacheWithCapacity:500];
    if (cache.capacity != 500) {
        STFail(@"Capacity should be 500");
    }
}

- (void)testDefaultObjectCacheCapacity10000
{
    CoreDataObjectCacheCache *cache = [CoreDataObjectCacheCache cacheWithCapacity:10000];
    if (cache.capacity != 10000) {
        STFail(@"Capacity should be 10000");
    }
}

- (void)testObjectCacheLoadsAnValidRemoteObject
{
    CoreDataObjectCacheCache *cache = [CoreDataObjectCacheCache cache];

    [cache objectWithURL:[NSURL URLWithString:@"https://www.damienmacfhlannchaidh.com/blogimages/weather1.png"] success:^(NSData *object, NSURLResponse *response, ObjectLoadSource source) {
        STAssertNotNil(object, @"An object should have been returned.");
        if (!object) {
            [self notify:SenAsyncTestCaseStatusFailed];
        } else {
            if (source != ObjectLoadSourceNetwork) {
                STFail(@"Object should have been loaded from network and not cache");
                [self notify:SenAsyncTestCaseStatusFailed];
            }
            [self notify:SenAsyncTestCaseStatusSucceeded];
        }
    } failure:^(NSError *error) {
        STFail(@"An error should not have occurred while attempting to load remote object https://www.damienmacfhlannchaidh.com/blogimages/weather1.png");
        [self notify:SenAsyncTestCaseStatusFailed];
    }];

    [self waitForStatus:SenAsyncTestCaseStatusSucceeded timeout:STANDARD_TIMEOUT_IN_SECS];
}

- (void)testObjectCacheLoadsAnInvalidRemoteObject
{
    CoreDataObjectCacheCache *cache = [CoreDataObjectCacheCache cache];

    [cache objectWithURL:[NSURL URLWithString:@"https://www.damienmacfhlannchaidh.com/blogimages/invalid.png"] success:^(NSData *object, NSURLResponse *response, ObjectLoadSource source) {
        STFail(@"An error should have occurred while attempting to load remote object https://www.damienmacfhlannchaidh.com/blogimages/invalid.png");
        [self notify:SenAsyncTestCaseStatusFailed];
    } failure:^(NSError *error) {
        STAssertNotNil(error, @"An error object should have been returned");
        if (!error) {
            [self notify:SenAsyncTestCaseStatusFailed];
        }
        [self notify:SenAsyncTestCaseStatusSucceeded];
    }];

    [self waitForStatus:SenAsyncTestCaseStatusSucceeded timeout:STANDARD_TIMEOUT_IN_SECS];
}

- (void)testObjectCacheResetWorks
{
    CoreDataObjectCacheCache *cache = [CoreDataObjectCacheCache cache];

    if (cache.count !=0) {
        STFail(@"Cache count should be 0");
        [self notify:SenAsyncTestCaseStatusFailed];
    }

    [cache objectWithURL:[NSURL URLWithString:@"https://www.damienmacfhlannchaidh.com/blogimages/weather1.png"] success:^(NSData *object, NSURLResponse *response, ObjectLoadSource source) {
        STAssertNotNil(object, @"An object should have been returned.");
        if (!object) {
            [self notify:SenAsyncTestCaseStatusFailed];
        } else {
            if (source != ObjectLoadSourceNetwork) {
                STFail(@"Object should have been loaded from network and not cache");
                [self notify:SenAsyncTestCaseStatusFailed];
            }
            NSUInteger count = cache.count;
            if (count != 1) {
                STFail(@"Cache count should be 1");
                [self notify:SenAsyncTestCaseStatusFailed];
            }

            [cache resetObjectCache];

            if (cache.count !=0) {
                STFail(@"Cache count should be 0");
                [self notify:SenAsyncTestCaseStatusFailed];
            }

            [self notify:SenAsyncTestCaseStatusSucceeded];
        }
    } failure:^(NSError *error) {
        STFail(@"An error should not have occurred while attempting to load remote object https://www.damienmacfhlannchaidh.com/blogimages/weather1.png");
        [self notify:SenAsyncTestCaseStatusFailed];
    }];

    [self waitForStatus:SenAsyncTestCaseStatusSucceeded timeout:STANDARD_TIMEOUT_IN_SECS];
}

- (void)testObjectCacheLoadsAnValidRemoteObjectAndPlacesItInCache
{
    CoreDataObjectCacheCache *cache = [CoreDataObjectCacheCache cache];

    [cache objectWithURL:[NSURL URLWithString:@"https://www.damienmacfhlannchaidh.com/blogimages/weather1.png"] success:^(NSData *object, NSURLResponse *response, ObjectLoadSource source) {
        STAssertNotNil(object, @"An object should have been returned.");
        if (!object) {
            [self notify:SenAsyncTestCaseStatusFailed];
        } else {
            if (source != ObjectLoadSourceNetwork) {
                STFail(@"Object should have been loaded from network and not cache");
                [self notify:SenAsyncTestCaseStatusFailed];
            }
            NSUInteger count = cache.count;
            if (count != 1) {
                STFail(@"Cache count should be 1");
                [self notify:SenAsyncTestCaseStatusFailed];
            }

            [self notify:SenAsyncTestCaseStatusSucceeded];
        }
    } failure:^(NSError *error) {
        STFail(@"An error should not have occurred while attempting to load remote object https://www.damienmacfhlannchaidh.com/blogimages/weather1.png");
        [self notify:SenAsyncTestCaseStatusFailed];
    }];

    [self waitForStatus:SenAsyncTestCaseStatusSucceeded timeout:STANDARD_TIMEOUT_IN_SECS];
}

- (void)testObjectCacheLoadsAnValidRemoteObjectAndPlacesItInCacheAndThenReturnsItFromCacheOnSubsequentRequests
{
    __block CoreDataObjectCacheCache *cache = [CoreDataObjectCacheCache cache];

    [cache objectWithURL:[NSURL URLWithString:@"https://www.damienmacfhlannchaidh.com/blogimages/weather1.png"] success:^(NSData *object, NSURLResponse *response, ObjectLoadSource source) {
        STAssertNotNil(object, @"An object should have been returned.");
        if (!object) {
            [self notify:SenAsyncTestCaseStatusFailed];
        } else {
            if (source != ObjectLoadSourceNetwork) {
                STFail(@"Object should have been loaded from network and not cache");
                [self notify:SenAsyncTestCaseStatusFailed];
            }
            NSUInteger count = cache.count;
            if (count != 1) {
                STFail(@"Cache count should be 1");
                [self notify:SenAsyncTestCaseStatusFailed];
            }

            [cache objectWithURL:[NSURL URLWithString:@"https://www.damienmacfhlannchaidh.com/blogimages/weather1.png"] success:^(NSData *object, NSURLResponse *response, ObjectLoadSource source) {
                if (source != ObjectLoadSourceCache) {
                    STFail(@"Object should have been loaded from cache and not network");
                    [self notify:SenAsyncTestCaseStatusFailed];
                }

                [self notify:SenAsyncTestCaseStatusSucceeded];
            } failure:^(NSError *error) {
                STFail(@"An error should not have occurred while attempting to load remote object https://www.damienmacfhlannchaidh.com/blogimages/weather1.png");
                [self notify:SenAsyncTestCaseStatusFailed];
            }];
        }
    } failure:^(NSError *error) {
        STFail(@"An error should not have occurred while attempting to load remote object https://www.damienmacfhlannchaidh.com/blogimages/weather1.png");
        [self notify:SenAsyncTestCaseStatusFailed];
    }];

    [self waitForStatus:SenAsyncTestCaseStatusSucceeded timeout:STANDARD_TIMEOUT_IN_SECS];
}

- (void)testObjectCacheLoadsMultipleValidRemoteObjectsAndPlacesThemInCache
{
    CoreDataObjectCacheCache *cache = [CoreDataObjectCacheCache cache];

    NSUInteger TARGET_INSERTS = 10;

    for (NSUInteger i=0; i < TARGET_INSERTS; i++) {
        NSString *url = [NSString stringWithFormat:@"%@?%@", @"https://www.damienmacfhlannchaidh.com/blogimages/weather1.png",[NSProcessInfo processInfo].globallyUniqueString];

        [cache objectWithURL:[NSURL URLWithString:url] success:^(NSData *object, NSURLResponse *response, ObjectLoadSource source) {
            STAssertNotNil(object, @"An object should have been returned.");
            if (!object) {
                [self notify:SenAsyncTestCaseStatusFailed];
            } else {
                if (source != ObjectLoadSourceNetwork) {
                    STFail(@"Object should have been loaded from network and not cache");
                    [self notify:SenAsyncTestCaseStatusFailed];
                }

                if (i == TARGET_INSERTS-1) {
                    [self notify:SenAsyncTestCaseStatusSucceeded];
                }
            }
        } failure:^(NSError *error) {
            STFail(@"An error should not have occurred while attempting to load remote object https://www.damienmacfhlannchaidh.com/blogimages/weather1.png");
            [self notify:SenAsyncTestCaseStatusFailed];
        }];
    }

    [self waitForStatus:SenAsyncTestCaseStatusSucceeded timeout:STANDARD_TIMEOUT_IN_SECS*6];
}

- (void)testObjectCacheDeleteExistingResource
{
    CoreDataObjectCacheCache *cache = [CoreDataObjectCacheCache cache];

    [cache objectWithURL:[NSURL URLWithString:@"https://www.damienmacfhlannchaidh.com/blogimages/weather1.png"] success:^(NSData *object, NSURLResponse *response, ObjectLoadSource source) {
        STAssertNotNil(object, @"An object should have been returned.");
        if (!object) {
            [self notify:SenAsyncTestCaseStatusFailed];
        } else {
            if (source != ObjectLoadSourceNetwork) {
                STFail(@"Object should have been loaded from network and not cache");
                [self notify:SenAsyncTestCaseStatusFailed];
            }
            NSUInteger count = cache.count;
            if (count != 1) {
                STFail(@"Cache count should be 1");
                [self notify:SenAsyncTestCaseStatusFailed];
            }

            [cache removeObjectWithURL:[NSURL URLWithString:@"https://www.damienmacfhlannchaidh.com/blogimages/weather1.png"] success:^(NSData *object, NSURLResponse *response, ObjectLoadSource source) {
                NSUInteger count = cache.count;
                if (count != 0) {
                    STFail(@"Cache count should be 0");
                    [self notify:SenAsyncTestCaseStatusFailed];
                }
                [self notify:SenAsyncTestCaseStatusSucceeded];
            } failure:^(NSError *error) {
                [self notify:SenAsyncTestCaseStatusFailed];
            }];
        }
    } failure:^(NSError *error) {
        STFail(@"An error should not have occurred while attempting to load remote object https://www.damienmacfhlannchaidh.com/blogimages/weather1.png");
        [self notify:SenAsyncTestCaseStatusFailed];
    }];

    [self waitForStatus:SenAsyncTestCaseStatusSucceeded timeout:STANDARD_TIMEOUT_IN_SECS];
}

- (void)testObjectCacheHandlesCapacityLimitsCorrectly
{
    CoreDataObjectCacheCache *cache = [CoreDataObjectCacheCache cacheWithCapacity:2];

    NSUInteger TARGET_INSERTS = 10;

    for (NSUInteger i=0; i < TARGET_INSERTS; i++) {
        NSString *url = [NSString stringWithFormat:@"%@?%@", @"https://www.damienmacfhlannchaidh.com/blogimages/weather1.png",[NSProcessInfo processInfo].globallyUniqueString];

        [cache objectWithURL:[NSURL URLWithString:url] success:^(NSData *object, NSURLResponse *response, ObjectLoadSource source) {
            STAssertNotNil(object, @"An object should have been returned.");
            if (!object) {
                [self notify:SenAsyncTestCaseStatusFailed];
            } else {
                if (source != ObjectLoadSourceNetwork) {
                    STFail(@"Object should have been loaded from network and not cache");
                    [self notify:SenAsyncTestCaseStatusFailed];
                }

                if (i == TARGET_INSERTS-1) {
                    [self notify:SenAsyncTestCaseStatusSucceeded];
                }
            }
        } failure:^(NSError *error) {
            STFail(@"An error should not have occurred while attempting to load remote object https://www.damienmacfhlannchaidh.com/blogimages/weather1.png");
            [self notify:SenAsyncTestCaseStatusFailed];
        }];
    }

    [self waitForStatus:SenAsyncTestCaseStatusSucceeded timeout:STANDARD_TIMEOUT_IN_SECS*6];
}

- (void)testPrintStats
{
    CoreDataObjectCacheCache *cache = [CoreDataObjectCacheCache cache];

    NSUInteger TARGET_INSERTS = 10;

    for (NSUInteger i=0; i < TARGET_INSERTS; i++) {
        NSString *url = [NSString stringWithFormat:@"%@?%@", @"https://www.damienmacfhlannchaidh.com/blogimages/weather1.png",[NSProcessInfo processInfo].globallyUniqueString];

        [cache objectWithURL:[NSURL URLWithString:url] success:^(NSData *object, NSURLResponse *response, ObjectLoadSource source) {
            STAssertNotNil(object, @"An object should have been returned.");
            if (!object) {
                [self notify:SenAsyncTestCaseStatusFailed];
            } else {
                if (source != ObjectLoadSourceNetwork) {
                    STFail(@"Object should have been loaded from network and not cache");
                    [self notify:SenAsyncTestCaseStatusFailed];
                }

                if (i == TARGET_INSERTS-1) {
                    [cache printStatistics];
                    [self notify:SenAsyncTestCaseStatusSucceeded];
                }
            }
        } failure:^(NSError *error) {
            STFail(@"An error should not have occurred while attempting to load remote object https://www.damienmacfhlannchaidh.com/blogimages/weather1.png");
            [self notify:SenAsyncTestCaseStatusFailed];
        }];
    }

    [self waitForStatus:SenAsyncTestCaseStatusSucceeded timeout:STANDARD_TIMEOUT_IN_SECS*6];
}

- (void)testGetImageViaCache
{
    CoreDataObjectCacheCache *cache = [CoreDataObjectCacheCache cache];

    [cache objectWithURL:[NSURL URLWithString:@"https://www.damienmacfhlannchaidh.com/blogimages/weather1.png"] success:^(NSData *object, NSURLResponse *response, ObjectLoadSource source) {
        STAssertNotNil(object, @"An object should have been returned.");
        if (!object) {
            [self notify:SenAsyncTestCaseStatusFailed];
        } else {
            if (source != ObjectLoadSourceNetwork) {
                STFail(@"Object should have been loaded from network and not cache");
                [self notify:SenAsyncTestCaseStatusFailed];
            }
            NSUInteger count = cache.count;
            if (count != 1) {
                STFail(@"Cache count should be 1");
                [self notify:SenAsyncTestCaseStatusFailed];
            }

            UIImage *image = [UIImage imageWithData:object];
            if (!image) {
                STFail(@"Image should have been created");
                [self notify:SenAsyncTestCaseStatusFailed];
            }

            [self notify:SenAsyncTestCaseStatusSucceeded];
        }
    } failure:^(NSError *error) {
        STFail(@"An error should not have occurred while attempting to load remote object https://www.damienmacfhlannchaidh.com/blogimages/weather1.png");
        [self notify:SenAsyncTestCaseStatusFailed];
    }];
    
    [self waitForStatus:SenAsyncTestCaseStatusSucceeded timeout:STANDARD_TIMEOUT_IN_SECS];
}

@end
