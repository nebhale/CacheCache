# CacheCache
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Build Status](https://travis-ci.org/nebhale/CacheCache.svg)](https://travis-ci.org/nebhale/CacheCache)

CacheCache is intended to be a simple, lightweight, and extensible caching framework for Swift-based applications.

## Installation
[Carthage][c] is the easiest way to use this framework.  [Follow the Carthage instructions][a] to add a framework to your application.  The proper declaration for your `Cartfile` is:

```cartfile
github "nebhale/CacheCache"
```

## Usage
To use CacheCache, first start by importing the module. Next, create a new instance of the one of the `Cache` implementations. In most cases, using the `PropertyListCache` is correct. This creates a `Cache` that will write content to a property list in the `.CachesDirectory` of the filesystem.  Finally, call the `persist()` and `retrieve()` methods to access the cache.

```swift
import CacheCache

final class Example {

    private let cache = PropertyListCache<[String : String]>("example-type")

    func example() {
        let expected = ["test-key" : "test-value"]

        self.cache.persist(payload) { return $0 }
        let actual = self.cache.retrieve { return $0 as? Dictionary }

        println(actual == expected)
    }
}
```

## Contributing
[Pull requests][p] are welcome.

## License
This project is released under version 2.0 of the [Apache License][l].


[a]: https://github.com/Carthage/Carthage#adding-frameworks-to-an-application
[c]: https://github.com/Carthage/Carthage
[l]: http://www.apache.org/licenses/LICENSE-2.0
[p]: http://help.github.com/send-pull-requests
