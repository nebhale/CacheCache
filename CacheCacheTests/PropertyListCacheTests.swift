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


final class PropertyListCacheSpec: XCTestCase {

    private var bundle: NSBundle!

    private var cache: PropertyListCache<[String : String]>!

    override func setUp() {
        self.bundle = NSBundle(forClass: self.dynamicType)
        self.cache = PropertyListCache(type: NSUUID().UUIDString, bundle: self.bundle)
    }

    // MARK: - Persist

    func test_PersistsNil() {
        self.cache.persist(nil) { return $0 }
        expect(self.cache.retrieve() { return $0 as? Dictionary }).to(beNil())
    }

    func test_PersistsNonNil() {
        self.cache.persist(["test-key" : "test-value"]) { return $0 }
        expect(self.cache.retrieve() { return $0 as? Dictionary }).to(equal(["test-key" : "test-value"]))
    }

    func test_CallsSerializer() {
        var called = false

        self.cache.persist(["test-key" : "test-value"]) { payload in
            called = true
            return payload
        }

        expect(called).to(beTrue())
    }

    // MARK: - Retrieve

    func test_RetrievesNil() {
        self.cache.persist(nil) { return $0 }
        expect(self.cache.retrieve() { return $0 as? Dictionary }).to(beNil())
    }

    func test_RetrievesNonNil() {
        self.cache.persist(["test-key" : "test-value"]) { return $0 }
        expect(self.cache.retrieve() { return $0 as? Dictionary }).to(equal(["test-key" : "test-value"]))
    }

    func test_CallsDeserializer() {
        self.cache.persist(["test-key" : "test-value"]) { return $0 }

        var called = false
        self.cache.retrieve { payload in
            called = true
            return payload as? Dictionary
        }

        expect(called).to(beTrue())
    }
}