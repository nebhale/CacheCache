// Copyright 2015 the original author or authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


import LoggerLogger

/// An implementation of `Cache` that persists data in memory.  This persistence is not durable across restarts of an application and therefore should not be used as a production caching mechanism.
public final class InMemoryCache<T>: Cache {

    typealias Deserializer = Any -> T?

    typealias Serializer = T -> Any

    private var cache: Any?

    private let logger = Logger()

    private let type: String

    /// Creates a new instance of `InMemoryCache`
    ///
    /// - parameter type: A user-readable representation of the type being cached
    public init(type: String) {
        self.type = type
    }

    /// Persists a payload for later retrieval
    ///
    /// - parameter payload:    The payload to persist
    /// - parameter serializer: The serializer to use to map the payload into cached data.  Will only be called if the payload is non-`nil`.  The default is an *identity* implementation that makes no changes to the payload.
    public func persist(payload: T?, serializer serialize: Serializer = InMemoryCache.identitySerializer) {
        if let payload = payload {
            self.logger.info("Persisting \(self.type) payload")

            self.cache = serialize(payload)

            self.logger.debug("Persisted \(self.type) payload")
        } else {
            self.logger.debug("Did not persist \(self.type) payload")
        }
    }

    /// Retrieves a payload from an earlier persistence.  If `persist()` has never been called, then it will always return `nil`.
    ///
    /// - parameter deserializer: The deserializer to use to mapt the cached data into the payload.  Will only be called if the cached data is non-`nil`.  The default is an *identity* implementation that makes no changes to the payload.
    ///
    /// - returns: The payload if one has been persisted and it can be properly deserialized
    public func retrieve(deserializer deserialize: Deserializer = InMemoryCache.identityDeserializer) -> T? {
        if let cache = self.cache {
            self.logger.info("Retrieving \(self.type) payload")

            let payload = deserialize(cache)

            self.logger.debug("Retrieved \(self.type) payload")
            return payload
        } else {
            self.logger.debug("Did not retrieve \(self.type) payload")
            return nil
        }
    }

    private static func identityDeserializer(cache: Any) -> T? {
        return cache as? T
    }

    private static func identitySerializer(payload: T) -> Any {
        return payload
    }
}
