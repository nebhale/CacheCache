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


/**
The definition of a Cache.  A Cache is an instance that can persist a payload and retrieve it later.  Implementations are free to choose how the payload is persisted.
*/
public protocol Cache {

    /**
    A `typealias` defining the type of the payload managed by the Cache
    */
    typealias PayloadType

    /**
    A `typealias` for a function that can deserialize the cached data into the `PayloadType`
    */
    typealias Deserializer = Any -> PayloadType?

    /**
    A `typealias` for a function that can serialize the `PayloadType` into cached data
    */
    typealias Serializer = PayloadType -> Any

    /**
    Persists a payload for later retrieval

    - parameter payload:    The payload to persist
    - parameter serializer: The serializer to use to map the payload into cached data.  Will only be called if the payload is non-`nil`.
    */
    func persist(payload: PayloadType?, serializer serialize: Serializer)

    /**
    Retrieves a payload from an earlier persistence.  If `persist()` has never been called, then it will always return `nil`.

    - parameter deserializer: The deserializer to use to mapt the cached data into the payload.  Will only be called if the cached data is non-`nil`.

    - returns: The payload if one has been persisted and it can be properly deserialized
    */
    func retrieve(deserializer deserialize: Deserializer) -> PayloadType?
}
