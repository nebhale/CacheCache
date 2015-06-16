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
import Quick


final class InMemoryCacheSpec: QuickSpec {

    override func spec() {
        describe("InMemoryCache") {
            var cache: InMemoryCache<String>!

            beforeEach {
                cache = InMemoryCache(type: NSUUID().UUIDString)
            }

            describe("persist") {
                it("persists nil") {
                    cache.persist(nil)
                    expect(cache.retrieve()).to(beNil())
                }

                it("persists non-nil") {
                    cache.persist("test-payload")
                    expect(cache.retrieve()).to(equal("test-payload"))
                }

                it("calls serializer") {
                    var called = false

                    cache.persist("test-payload") { payload in
                        called = true
                        return payload
                    }

                    expect(called).to(beTrue())
                }
            }

            describe("retrieve") {
                it("retrieves nil") {
                    cache.persist(nil)
                    expect(cache.retrieve()).to(beNil())
                }

                it("retrieves non-nil") {
                    cache.persist("test-payload")
                    expect(cache.retrieve()).to(equal("test-payload"))
                }

                it("calls deserializer") {
                    cache.persist("test-payload")

                    var called = false
                    cache.retrieve { payload in
                        called = true
                        return payload as? String
                    }
                    
                    expect(called).to(beTrue())
                }
            }
        }
    }
}