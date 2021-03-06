CoreDataObjectCacheCache
=============

An objective-c based URL object cache, backed by Core Data. This is a network aware pass-thru cache, meaning that you make a request for a URL-based resource to the component. If the cache has the resource it will deliver it from within its store, otherwise if the cache does not have the resource, then it will fetch it for you, insert into its store and return the resource over to you. Subsequent requests for that resource will be delivered from the cache. 

It is designed to cache resources for a relatively long time (between application restarts) and is optimized for that use case. It is not as fast as a pure in-memory implementation.

Features
--------

* High-performance core-data backed cache, utilizing the memory efficiencies of `NSManagedObjects`.
* Configurable cache-size.
* Implemented as singleton, so very simple to use throughout your codebase.
* Asynchronous, block-based API.
* Small and simple code-base: One class file, one matching header and a Core Data model file.
* Monitor the cache performance, cache size, hits, misses, etc.
* Honors `Expiry` HTTP headers.


Installation
------------

1. Copy the files from `ObjectCache` into your project.
2. Make sure that you are linking against the `CoreData.framework`.

Using the cache
---------------

Use the cache like this:

```objective-c

    //init the cache (singleton)
	CoreDataObjectCacheCache *cache = [CoreDataObjectCacheCache cache];
	
	//load a resource
	[cache objectWithURL:[NSURL URLWithString:@"https://www.damienmacfhlannchaidh.com/blogimages/weather1.png"] success:^(NSData *object, NSURLResponse *response, ObjectLoadSource source) {
		//Notes:
		//data = is the contents of your URL resource.
		//response =  contains the http response from your network request, if the cache had to retrieve the resource from the network.
		//resource is nil if it was delivered from the cache
		//source indicates if the resource was delivered from the network or the cache
	} failure:^(NSError *error) {
		//an error occurred
	}];
	
```

You can reset the cache at any time:

```objective-c

	CoreDataObjectCacheCache *cache = [CoreDataObjectCacheCache cache];
	[cache resetObjectCache];
```

You can remove a specific resource from the cache:

```objective-c

	CoreDataObjectCacheCache *cache = [CoreDataObjectCacheCache cache];
	
	//remove a resource from the cache
	[cache removeObjectWithURL:[NSURL URLWithString:@"https://www.damienmacfhlannchaidh.com/blogimages/weather1.png"] success:^(NSData *object, NSURLResponse *response, ObjectLoadSource source) {
		//resource removed
	} failure:^(NSError *error) {
		//an error occurred
	}];
```

Display the cache performance stats by:

```objective-c

	CoreDataObjectCacheCache *cache = [CoreDataObjectCacheCache cache];
	[cache printStatistics];
```

Or you can grab specific stats by reading the `cacheHits`, `cacheMisses` and `totalHits` properties. A cache-miss indicates that the cache had to grab the resource from the network.

Load a `UIImage` from the cache:

```objective-c

	CoreDataObjectCacheCache *cache = [CoreDataObjectCacheCache cache];
	
	//load a resource
	[cache objectWithURL:[NSURL URLWithString:@"https://www.damienmacfhlannchaidh.com/blogimages/weather1.png"] success:^(NSData *object, NSURLResponse *response, ObjectLoadSource source) {
		 UIImage *image = [UIImage imageWithData:object];
	} failure:^(NSError *error) {
		//an error occurred
	}];
	
```

Unit Tests
----------

Copy the files from `ObjectCacheTests` to you OCUnit test target.

Feedback
--------

Please open an Issue to provide feedback, bugs, enhancements, suggestions, etc.

LICENSE
-------

CoreDataObjectCacheCache is available under the MIT license.

Copyright (c) 2012 Damien Mac Fhlannchaidh (https://www.damienmacfhlannchaidh.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


