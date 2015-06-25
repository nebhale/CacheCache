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

@testable
import CacheCache
import Foundation
import Nimble
import XCTest


final class InMemoryCacheSpec: XCTestCase {

    private var cache: InMemoryCache<String>!

    override func setUp() {
        self.cache = InMemoryCache(type: NSUUID().UUIDString)
    }

    // MARK: - Persist

    func test_PersistsNil() {
        self.cache.persist(nil)
        expect(self.cache.retrieve()).to(beNil())
    }

    func test_PersistsNonNil() {
        self.cache.persist("test-payload")
        expect(self.cache.retrieve()).to(equal("test-payload"))
    }

    func test_CallsSerializer() {
        var called = false

        self.cache.persist("test-payload") { payload in
            called = true
            return payload
        }

        expect(called).to(beTrue())
    }

    // MARK: - Retrieve

    func test_RetrievesNil() {
        self.cache.persist(nil)
        expect(self.cache.retrieve()).to(beNil())
    }

    func test_RetrievesNonNil() {
        self.cache.persist("test-payload")
        expect(self.cache.retrieve()).to(equal("test-payload"))
    }

    func test_CallsDeserializer() {
        self.cache.persist("test-payload")

        var called = false
        self.cache.retrieve { payload in
            called = true
            return payload as? String
        }

        expect(called).to(beTrue())
    }
}