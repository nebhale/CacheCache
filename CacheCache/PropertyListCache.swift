/*
Copyright 2015 the original author or authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import Foundation
import LoggerLogger


/**
An implementation of `Cache` that persists data into a property list written out to the `.CachesDirectory` of a bundle.

**NOTE:** This implementation uses `NSPropertyListSerialization` which requires that the serialized cached data be `AnyObject` rather than `Any`.  In addition, the serialized cached data must be made up of "property list types and objects".
*/
public final class PropertyListCache<T>: Cache {

    typealias Deserializer = AnyObject -> T?

    typealias Serializer = T -> AnyObject

    private let location: NSURL?

    private let logger = Logger()

    private let type: String

    /**
    Creates a new instance of `PropertyListCache`

    - parameter type:   A user-readable representation of the type being cached
    - parameter bundle: The bundle to write the property list into.  The default is the `NSBundle.mainBundle()`.
    */
    public init(type: String, bundle: NSBundle = NSBundle.mainBundle()) {
        self.location = PropertyListCache.location(type, bundle: bundle)
        self.type = type
    }

    /**
    Persists a payload for later retrieval

    - parameter payload:    The payload to persist
    - parameter serializer: The serializer to use to map the payload into cached data.  Will only be called if the payload is non-`nil`.
    */
    public func persist(payload: T?, serializer serialize: Serializer) {
        if let location = self.location, let payload = payload, let cache = cache(serialize(payload)) {
            self.logger.info("Persisting \(self.type) payload to \(location)")

            cache.writeToURL(location, atomically: true)

            self.logger.debug("Persisted \(self.type) payload")
        } else {
            self.logger.debug("Did not persist \(self.type) payload")
        }
    }

    /**
    Retrieves a payload from an earlier persistence.  If `persist()` has never been called, then it will always return `nil`.

    - parameter deserializer: The deserializer to use to mapt the cached data into the payload.  Will only be called if the cached data is non-`nil`.

    - returns: The payload if one has been persisted and it can be properly deserialized
    */
    public func retrieve(deserializer deserialize: Deserializer) -> T? {
        if let location = self.location, let data = NSData(contentsOfURL: location), let cache: AnyObject = cache(data) {
            self.logger.info("Retrieving \(self.type) payload from \(location)")

            let payload = deserialize(cache)

            self.logger.debug("Retrieved \(self.type) payload")
            return payload
        } else {
            self.logger.debug("Did not retrieve \(self.type) payload")
            return nil
        }
    }

    private func cache(data: NSData) -> AnyObject? {
        do {
            return try NSPropertyListSerialization.propertyListWithData(data, options: NSPropertyListReadOptions.Immutable, format: nil)
        } catch {
            self.logger.error("Unable to convert data to property list")
            return nil
        }
    }

    private func cache(payload: AnyObject) -> NSData? {
        do {
            return try NSPropertyListSerialization.dataWithPropertyList(payload, format: .BinaryFormat_v1_0, options: 0)
        } catch {
            self.logger.error("Unable to convert property list to data")
            return nil
        }
    }

    private static func location(name: String, bundle: NSBundle) -> NSURL? {
        let fileManager = NSFileManager.defaultManager()

        if let cachesDirectory = fileManager.URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).first, let bundleIdentifier = bundle.bundleIdentifier {
            do {
                let bundleCacheDirectory = cachesDirectory.URLByAppendingPathComponent(bundleIdentifier, isDirectory: true)
                try fileManager.createDirectoryAtURL(bundleCacheDirectory, withIntermediateDirectories: true, attributes: nil)
                return bundleCacheDirectory.URLByAppendingPathComponent(name).URLByAppendingPathExtension("plist")
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}