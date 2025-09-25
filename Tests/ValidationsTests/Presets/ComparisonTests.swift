import Foundation
import Testing
@testable import Validations

@Suite
struct ComparisonTests {
    @Test func greaterThan() {
        let now = Date.now
        #expect(throws: Never.self) { try Comparison(of: now, .greaterThan(now - 1)).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: now, .greaterThan(now)).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: now, .greaterThan(now + 1)).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, .greaterThan(now - 1)).validate() }
        #expect(throws: Never.self) { try Comparison(of: nil, .greaterThan(now + 1)).allowsNil().validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, .greaterThan(now - 1)).allowsNil(false).validate() }
    }

    @Test func greaterThanOrEqual() {
        let now = Date.now
        #expect(throws: Never.self) { try Comparison(of: now, .greaterThanOrEqualTo(now - 1)).validate() }
        #expect(throws: Never.self) { try Comparison(of: now, .greaterThanOrEqualTo(now)).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: now, .greaterThanOrEqualTo(now + 1)).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, .greaterThanOrEqualTo(now - 1)).validate() }
        #expect(throws: Never.self) { try Comparison(of: nil, .greaterThanOrEqualTo(now + 1)).allowsNil().validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, .greaterThanOrEqualTo(now - 1)).allowsNil(false).validate() }
    }

    @Test func lessThan() {
        let now = Date.now
        #expect(throws: ValidationError.self) { try Comparison(of: now, .lessThan(now - 1)).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: now, .lessThan(now)).validate() }
        #expect(throws: Never.self) { try Comparison(of: now, .lessThan(now + 1)).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, .lessThan(now + 1)).validate() }
        #expect(throws: Never.self) { try Comparison(of: nil, .lessThan(now - 1)).allowsNil().validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, .lessThan(now + 1)).allowsNil(false).validate() }
    }

    @Test func lessThanOrEqual() {
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

    @Test func equalTo() {
        let now = Date.now
        #expect(throws: ValidationError.self) { try Comparison(of: now, .equalTo(now - 1)).validate() }
        #expect(throws: Never.self) { try Comparison(of: now, .equalTo(now)).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: now, .equalTo(now + 1)).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, .equalTo(now)).validate() }
        #expect(throws: Never.self) { try Comparison(of: nil, .equalTo(now - 1)).allowsNil().validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, .equalTo(now)).allowsNil(false).validate() }
    }

    @Test
    func equatableValues() throws {
        #expect(throws: Never.self) { try Comparison(of: false, equalTo: false).validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: true, equalTo: false).validate() }

        #expect(throws: ValidationError.self) { try Comparison(of: nil, equalTo: true).validate() }
        #expect(throws: Never.self) { try Comparison(of: nil, equalTo: true).allowsNil().validate() }
        #expect(throws: ValidationError.self) { try Comparison(of: nil, equalTo: true).allowsNil(false).validate() }

        #expect(throws: Never.self) { try Comparison(of: Optional(true), equalTo: true).validate() }
    }

    @Suite struct GreaterThanWithCollectionValues {
        @Test func basic() {
            #expect(throws: Never.self) { try Comparison(of: [5, 10, 0], .greaterThan([5, 9, 2])).validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [5, 10, 0], .greaterThan([5, 10, 0])).validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [5, 10, 0], .greaterThan([6, 0, 0])).validate() }
        }

        @Test func nilAndEmptyAllowed() {
            #expect(throws: Never.self) { try Comparison(of: nil, .greaterThan([5, 9, 2])).allowsNil().allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .greaterThan([5, 10, 0])).allowsNil().allowsEmpty().validate() }
        }

        @Test func nilAndEmptyDisAllowed() {
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .greaterThan([5, 9, 2])).validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .greaterThan([5, 10, 0])).validate() }
        }

        @Test func nilAllowedButEmptyDisallowed() {
            #expect(throws: Never.self) { try Comparison(of: nil, .greaterThan([5, 9, 2])).allowsNil().validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .greaterThan([5, 10, 0])).allowsNil().validate() }
        }

        @Test func emptyAllowedButNilDisallowed() {
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .greaterThan([5, 9, 2])).allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .greaterThan([5, 10, 0])).allowsEmpty().validate() }
        }
    }

    @Suite struct GreaterThanOrEqualWithCollectionValues {
        @Test func basic() {
            #expect(throws: Never.self) { try Comparison(of: [5, 10, 0], .greaterThanOrEqualTo([5, 9, 2])).validate() }
            #expect(throws: Never.self) { try Comparison(of: [5, 10, 0], .greaterThanOrEqualTo([5, 10, 0])).validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [5, 10, 0], .greaterThanOrEqualTo([6, 0, 0])).validate() }
        }

        @Test func nilAndEmptyAllowed() {
            #expect(throws: Never.self) { try Comparison(of: nil, .greaterThanOrEqualTo([5, 9, 2])).allowsNil().allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .greaterThanOrEqualTo([5, 10, 0])).allowsNil().allowsEmpty().validate() }
        }

        @Test func nilAndEmptyDisallowed() {
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .greaterThanOrEqualTo([5, 9, 2])).validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .greaterThanOrEqualTo([5, 10, 0])).validate() }
        }

        @Test func nilAllowedButEmptyDisallowed() {
            #expect(throws: Never.self) { try Comparison(of: nil, .greaterThanOrEqualTo([5, 9, 2])).allowsNil().validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .greaterThanOrEqualTo([5, 10, 0])).allowsNil().validate() }
        }

        @Test func emptyAllowedButNilDisallowed() {
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .greaterThanOrEqualTo([5, 9, 2])).allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .greaterThanOrEqualTo([5, 10, 0])).allowsEmpty().validate() }
        }
    }

    @Suite struct LessThanWithCollectionValues {
        @Test func basic() {
            #expect(throws: ValidationError.self) { try Comparison(of: [5, 10, 0], .lessThan([5, 9, 2])).validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [5, 10, 0], .lessThan([5, 10, 0])).validate() }
            #expect(throws: Never.self) { try Comparison(of: [5, 10, 0], .lessThan([6, 0, 0])).validate() }
        }

        @Test func nilAndEmptyAllowed() {
            #expect(throws: Never.self) { try Comparison(of: nil, .lessThan([5, 9, 2])).allowsNil().allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .lessThan([5, 10, 0])).allowsNil().allowsEmpty().validate() }
        }

        @Test func nilAndEmptyDisallowed() {
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .lessThan([5, 9, 2])).validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .lessThan([5, 10, 0])).validate() }
        }

        @Test func nilAllowedButEmptyDisallowed() {
            #expect(throws: Never.self) { try Comparison(of: nil, .lessThan([5, 9, 2])).allowsNil().validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .lessThan([5, 10, 0])).allowsNil().validate() }
        }

        @Test func emptyAllowedButNilDisallowed() {
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .lessThan([5, 9, 2])).allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .lessThan([5, 10, 0])).allowsEmpty().validate() }
        }
    }

    @Suite struct LessThanOrEqualWithCollectionValues {
        @Test func basic() {
            #expect(throws: ValidationError.self) { try Comparison(of: [5, 10, 0], .lessThanOrEqualTo([5, 9, 2])).validate() }
            #expect(throws: Never.self) { try Comparison(of: [5, 10, 0], .lessThanOrEqualTo([5, 10, 0])).validate() }
            #expect(throws: Never.self) { try Comparison(of: [5, 10, 0], .lessThanOrEqualTo([6, 0, 0])).validate() }
        }

        @Test func nilAndEmptyAllowed() {
            #expect(throws: Never.self) { try Comparison(of: nil, .lessThanOrEqualTo([5, 9, 2])).allowsNil().allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .lessThanOrEqualTo([5, 10, 0])).allowsNil().allowsEmpty().validate() }
        }

        @Test func nilAndEmptyDisallowed() {
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .lessThanOrEqualTo([5, 9, 2])).validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .lessThanOrEqualTo([5, 10, 0])).validate() }
        }

        @Test func nilAllowedButEmptyDisallowed() {
            #expect(throws: Never.self) { try Comparison(of: nil, .lessThanOrEqualTo([5, 9, 2])).allowsNil().validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .lessThanOrEqualTo([5, 10, 0])).allowsNil().validate() }
        }

        @Test func emptyAllowedButNilDisallowed() {
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .lessThanOrEqualTo([5, 9, 2])).allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .lessThanOrEqualTo([5, 10, 0])).allowsEmpty().validate() }
        }
    }

    @Suite struct OtherThanWithCollectionValues {
        @Test func basic() {
            #expect(throws: Never.self) { try Comparison(of: [5, 10, 0], .otherThan([5, 9, 2])).validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [5, 10, 0], .otherThan([5, 10, 0])).validate() }
            #expect(throws: Never.self) { try Comparison(of: [5, 10, 0], .otherThan([6, 0, 0])).validate() }
        }

        @Test func nilAndEmptyAllowed() {
            #expect(throws: Never.self) { try Comparison(of: nil, .otherThan([5, 9, 2])).allowsNil().allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .otherThan([5, 10, 0])).allowsNil().allowsEmpty().validate() }
        }

        @Test func nilAndEmptyDisallowed() {
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .otherThan([5, 9, 2])).validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .otherThan([5, 10, 0])).validate() }
        }

        @Test func nilAllowedButEmptyDisallowed() {
            #expect(throws: Never.self) { try Comparison(of: nil, .otherThan([5, 9, 2])).allowsNil().validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .otherThan([5, 10, 0])).allowsNil().validate() }
        }

        @Test func emptyAllowedButNilDisallowed() {
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .otherThan([5, 9, 2])).allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .otherThan([5, 10, 0])).allowsEmpty().validate() }
        }
    }

    @Suite struct EqualToWithCollectionValues {
        @Test func basic() {
            #expect(throws: ValidationError.self) { try Comparison(of: [5, 10, 0], .equalTo([5, 9, 2])).validate() }
            #expect(throws: Never.self) { try Comparison(of: [5, 10, 0], .equalTo([5, 10, 0])).validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [5, 10, 0], .equalTo([6, 0, 0])).validate() }
        }

        @Test func nilAndEmptyAllowed() {
            #expect(throws: Never.self) { try Comparison(of: nil, .equalTo([5, 9, 2])).allowsNil().allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .equalTo([5, 10, 0])).allowsNil().allowsEmpty().validate() }
        }

        @Test func nilAndEmptyDisallowed() {
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .equalTo([5, 9, 2])).validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .equalTo([5, 10, 0])).validate() }
        }

        @Test func nilAllowedButEmptyDisallowed() {
            #expect(throws: Never.self) { try Comparison(of: nil, .equalTo([5, 9, 2])).allowsNil().validate() }
            #expect(throws: ValidationError.self) { try Comparison(of: [], .equalTo([5, 10, 0])).allowsNil().validate() }
        }

        @Test func emptyAllowedButNilDisallowed() {
            #expect(throws: ValidationError.self) { try Comparison(of: nil, .equalTo([5, 9, 2])).allowsEmpty().validate() }
            #expect(throws: Never.self) { try Comparison(of: [], .equalTo([5, 10, 0])).allowsEmpty().validate() }
        }
    }
}
