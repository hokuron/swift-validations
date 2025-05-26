import Foundation
import Testing
import XCTest
@testable import Validations

@Suite
struct ComparisonTests {
    @Test
    func greaterThan() {
        let now = Date.now
        #expect(throws: Never.self) { try Comparison(of: now, .greaterThan(now - 1)).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: now, .greaterThan(now)).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: now, .greaterThan(now + 1)).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, .greaterThan(now - 1)).validate() }
        #expect(throws: Never.self) { try Comparison(of: nil, .greaterThan(now + 1)).allowsNil().validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, .greaterThan(now - 1)).allowsNil(false).validate() }
    }

    @Test
    func greaterThanOrEqual() {
        let now = Date.now
        #expect(throws: Never.self) { try Comparison(of: now, .greaterThanOrEqualTo(now - 1)).validate() }
        #expect(throws: Never.self) { try Comparison(of: now, .greaterThanOrEqualTo(now)).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: now, .greaterThanOrEqualTo(now + 1)).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, .greaterThanOrEqualTo(now - 1)).validate() }
        #expect(throws: Never.self) { try Comparison(of: nil, .greaterThanOrEqualTo(now + 1)).allowsNil().validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, .greaterThanOrEqualTo(now - 1)).allowsNil(false).validate() }
    }

    @Test
    func lessThan() {
        let now = Date.now
        #expect(throws: ValidationError.self) { try Comparison(of: now, .lessThan(now - 1)).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: now, .lessThan(now)).validate() }
        #expect(throws: Never.self) { try Comparison(of: now, .lessThan(now + 1)).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, .lessThan(now + 1)).validate() }
        #expect(throws: Never.self) { try Comparison(of: nil, .lessThan(now - 1)).allowsNil().validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, .lessThan(now + 1)).allowsNil(false).validate() }
    }

    @Test
    func lessThanOrEqual() {
        let now = Date.now
        #expect(throws: ValidationError.self) { try Comparison(of: now, .lessThanOrEqualTo(now - 1)).validate() }
        #expect(throws: Never.self) { try Comparison(of: now, .lessThanOrEqualTo(now)).validate() }
        #expect(throws: Never.self) { try Comparison(of: now, .lessThanOrEqualTo(now + 1)).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, .lessThanOrEqualTo(now + 1)).validate() }
        #expect(throws: Never.self) { try Comparison(of: nil, .lessThanOrEqualTo(now - 1)).allowsNil().validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, .lessThanOrEqualTo(now + 1)).allowsNil(false).validate() }
    }

    @Test func otherThan() {
        let now = Date.now
        #expect(throws: Never.self) { try Comparison(of: now, .otherThan(now - 1)).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: now, .otherThan(now)).validate() }
        #expect(throws: Never.self) { try Comparison(of: now, .otherThan(now + 1)).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, .otherThan(now - 1)).validate() }
        #expect(throws: Never.self) { try Comparison(of: nil, .otherThan(now)).allowsNil().validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, .otherThan(now + 1)).allowsNil(false).validate() }
    }

    @Test func equality() {
        let now = Date.now
        #expect(throws: ValidationError.self) { try Comparison(of: now, .equalTo(now - 1)).validate() }
        #expect(throws: Never.self) { try Comparison(of: now, .equalTo(now)).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: now, .equalTo(now + 1)).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, .equalTo(now)).validate() }
        #expect(throws: Never.self) { try Comparison(of: nil, .equalTo(now - 1)).allowsNil().validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, .equalTo(now)).allowsNil(false).validate() }
    }

    @Test
    @MainActor
    func greaterThanWithCollection() {
        #expect(throws: Never.self) { try Comparison(of: [5, 10, 0], .greaterThan([5, 9, 2])).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: [5, 10, 0], .greaterThan([5, 10, 0])).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: [5, 10, 0], .greaterThan([6, 0, 0])).validate() }

        XCTContext.runActivity(named: "nil and empty allowed") { _ in
            #expect(throws: Never.self) { try Comparison(of: nil, .greaterThan([5, 9, 2])).allowsNil().allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .greaterThan([5, 10, 0])).allowsNil().allowsEmpty().validate() }
        }
        XCTContext.runActivity(named: "nil and empty disallowed") { _ in
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .greaterThan([5, 9, 2])).validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .greaterThan([5, 10, 0])).validate() }
        }
        XCTContext.runActivity(named: "nil allowed but empty disallowed") { _ in
            #expect(throws: Never.self) { try Comparison(of: nil, .greaterThan([5, 9, 2])).allowsNil().validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .greaterThan([5, 10, 0])).allowsNil().validate() }
        }
        XCTContext.runActivity(named: "empty allowed but nil disallowed") { _ in
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .greaterThan([5, 9, 2])).allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .greaterThan([5, 10, 0])).allowsEmpty().validate() }
        }
    }

    @Test
    @MainActor
    func greaterThanOrEqualWithCollection() throws {
        #expect(throws: Never.self) { try Comparison(of: [5, 10, 0], .greaterThanOrEqualTo([5, 9, 2])).validate() }
        #expect(throws: Never.self) { try Comparison(of: [5, 10, 0], .greaterThanOrEqualTo([5, 10, 0])).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: [5, 10, 0], .greaterThanOrEqualTo([6, 0, 0])).validate() }

        XCTContext.runActivity(named: "nil and empty allowed") { _ in
            #expect(throws: Never.self) { try Comparison(of: nil, .greaterThanOrEqualTo([5, 9, 2])).allowsNil().allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .greaterThanOrEqualTo([5, 10, 0])).allowsNil().allowsEmpty().validate() }
        }
        XCTContext.runActivity(named: "nil and empty disallowed") { _ in
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .greaterThanOrEqualTo([5, 9, 2])).validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .greaterThanOrEqualTo([5, 10, 0])).validate() }
        }
        XCTContext.runActivity(named: "nil allowed but empty disallowed") { _ in
            #expect(throws: Never.self) { try Comparison(of: nil, .greaterThanOrEqualTo([5, 9, 2])).allowsNil().validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .greaterThanOrEqualTo([5, 10, 0])).allowsNil().validate() }
        }
        XCTContext.runActivity(named: "empty allowed but nil disallowed") { _ in
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .greaterThanOrEqualTo([5, 9, 2])).allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .greaterThanOrEqualTo([5, 10, 0])).allowsEmpty().validate() }
        }
    }

    @Test
    @MainActor
    func lessThanWithCollection() throws {
        #expect(throws: ValidationError.self) { try Comparison(of: [5, 10, 0], .lessThan([5, 9, 2])).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: [5, 10, 0], .lessThan([5, 10, 0])).validate() }
        #expect(throws: Never.self) { try Comparison(of: [5, 10, 0], .lessThan([6, 0, 0])).validate() }

        XCTContext.runActivity(named: "nil and empty allowed") { _ in
            #expect(throws: Never.self) { try Comparison(of: nil, .lessThan([5, 9, 2])).allowsNil().allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .lessThan([5, 10, 0])).allowsNil().allowsEmpty().validate() }
        }
        XCTContext.runActivity(named: "nil and empty disallowed") { _ in
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .lessThan([5, 9, 2])).validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .lessThan([5, 10, 0])).validate() }
        }
        XCTContext.runActivity(named: "nil allowed but empty disallowed") { _ in
            #expect(throws: Never.self) { try Comparison(of: nil, .lessThan([5, 9, 2])).allowsNil().validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .lessThan([5, 10, 0])).allowsNil().validate() }
        }
        XCTContext.runActivity(named: "empty allowed but nil disallowed") { _ in
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .lessThan([5, 9, 2])).allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .lessThan([5, 10, 0])).allowsEmpty().validate() }
        }
    }

    @Test
    @MainActor
    func lessThanOrEqualWithCollection() throws {
        #expect(throws: ValidationError.self) { try Comparison(of: [5, 10, 0], .lessThanOrEqualTo([5, 9, 2])).validate() }
        #expect(throws: Never.self) { try Comparison(of: [5, 10, 0], .lessThanOrEqualTo([5, 10, 0])).validate() }
        #expect(throws: Never.self) { try Comparison(of: [5, 10, 0], .lessThanOrEqualTo([6, 0, 0])).validate() }

        XCTContext.runActivity(named: "nil and empty allowed") { _ in
            #expect(throws: Never.self) { try Comparison(of: nil, .lessThanOrEqualTo([5, 9, 2])).allowsNil().allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .lessThanOrEqualTo([5, 10, 0])).allowsNil().allowsEmpty().validate() }
        }
        XCTContext.runActivity(named: "nil and empty disallowed") { _ in
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .lessThanOrEqualTo([5, 9, 2])).validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .lessThanOrEqualTo([5, 10, 0])).validate() }
        }
        XCTContext.runActivity(named: "nil allowed but empty disallowed") { _ in
            #expect(throws: Never.self) { try Comparison(of: nil, .lessThanOrEqualTo([5, 9, 2])).allowsNil().validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .lessThanOrEqualTo([5, 10, 0])).allowsNil().validate() }
        }
        XCTContext.runActivity(named: "empty allowed but nil disallowed") { _ in
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .lessThanOrEqualTo([5, 9, 2])).allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .lessThanOrEqualTo([5, 10, 0])).allowsEmpty().validate() }
        }
    }

    @Test
    @MainActor
    func otherThanWithCollection() throws {
        #expect(throws: Never.self) { try Comparison(of: [5, 10, 0], .otherThan([5, 9, 2])).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: [5, 10, 0], .otherThan([5, 10, 0])).validate() }
        #expect(throws: Never.self) { try Comparison(of: [5, 10, 0], .otherThan([6, 0, 0])).validate() }

        XCTContext.runActivity(named: "nil and empty allowed") { _ in
            #expect(throws: Never.self) { try Comparison(of: nil, .otherThan([5, 9, 2])).allowsNil().allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .otherThan([5, 10, 0])).allowsNil().allowsEmpty().validate() }
        }
        XCTContext.runActivity(named: "nil and empty disallowed") { _ in
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .otherThan([5, 9, 2])).validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .otherThan([5, 10, 0])).validate() }
        }
        XCTContext.runActivity(named: "nil allowed but empty disallowed") { _ in
            #expect(throws: Never.self) { try Comparison(of: nil, .otherThan([5, 9, 2])).allowsNil().validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .otherThan([5, 10, 0])).allowsNil().validate() }
        }
        XCTContext.runActivity(named: "empty allowed but nil disallowed") { _ in
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .otherThan([5, 9, 2])).allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .otherThan([5, 10, 0])).allowsEmpty().validate() }
        }
    }

    @Test

    @MainActor
    func equalityWithCollection() throws {
        #expect(throws: ValidationError.self) { try Comparison(of: [5, 10, 0], .equalTo([5, 9, 2])).validate() }
        #expect(throws: Never.self) { try Comparison(of: [5, 10, 0], .equalTo([5, 10, 0])).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: [5, 10, 0], .equalTo([6, 0, 0])).validate() }

        XCTContext.runActivity(named: "nil and empty allowed") { _ in
            #expect(throws: Never.self) { try Comparison(of: nil, .equalTo([5, 9, 2])).allowsNil().allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .equalTo([5, 10, 0])).allowsNil().allowsEmpty().validate() }
        }
        XCTContext.runActivity(named: "nil and empty disallowed") { _ in
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .equalTo([5, 9, 2])).validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .equalTo([5, 10, 0])).validate() }
        }
        XCTContext.runActivity(named: "nil allowed but empty disallowed") { _ in
            #expect(throws: Never.self) { try Comparison(of: nil, .equalTo([5, 9, 2])).allowsNil().validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .equalTo([5, 10, 0])).allowsNil().validate() }
        }
        XCTContext.runActivity(named: "empty allowed but nil disallowed") { _ in
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .equalTo([5, 9, 2])).allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .equalTo([5, 10, 0])).allowsEmpty().validate() }
        }
    }

    @Test
    func equatable() throws {
        #expect(throws: Never.self) { try Comparison(of: false, equalTo: false).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: true, equalTo: false).validate() }

        #expect(throws: ValidationError.self) { try Comparison(of: nil, equalTo: true).validate() }
        #expect(throws: Never.self) { try Comparison(of: nil, equalTo: true).allowsNil().validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, equalTo: true).allowsNil(false).validate() }

        #expect(throws: Never.self) { try Comparison(of: Optional(true), equalTo: true).validate() }
    }
}
