import XCTest
@testable import Validations

final class ValidatorErrorKeyTests: XCTestCase {
    func testString() {
        let sut = Validate {
            throw ValidationError(reasons: .format)
        }
        .errorKey("Error Key")

        XCTAssertEqual(sut.validationErrors?.first?.key, "Error Key")
    }

    func testKeyPath() {
        struct SUT: Validator {
            var name: String?

            var validation: some Validator {
                Presence(name)
                    .errorKey(\SUT.name)
            }
        }

        #if swift(>=6.0)
        XCTAssertEqual(SUT().validationError?.key, \SUT.name)
        #else
        XCTAssertEqual(SUT().validationErrors?.first?.key, (\SUT.name).hashValue)
        #endif
    }

    func testWithValidatorBuilder() {
        struct SUT: Validator {
            var name: String?
            var age = 10

            var validation: some Validator {
                Presence(name)
                    .errorKey("presence")

                if name == nil {
                    Count(name, exact: 0)
                        .errorKey("count")
                }

                Comparison(age, .greaterThan(18))
                    .errorKey("comparison")
            }
        }

        XCTAssertEqual(SUT().validationErrors?.map(\.key), ["presence", "count", "comparison"])
    }

    func testOverwriteKeys() {
        struct SUT: Validator {
            var child = Child()

            struct Child: Validator {
                var validation: some Validator {
                    Presence("")
                        .errorKey("child presence")
                    Count("", within: 10...)
                    Absence("abc")
                }
            }

            var validation: some Validator {
                Presence("")
                    .errorKey("parent presence")
                child
                    .errorKey("overwritten key")
                Presence("")
                Absence("abc")
                    .errorKey("parent absence")
            }
        }

        XCTAssertEqual(
            SUT().validationErrors?.map(\.key),
            ["parent presence", "child presence", "overwritten key", "overwritten key", nil, "parent absence"]
        )
        XCTAssertEqual(SUT().validationErrors?.reasons(for: "overwritten key"), [.count, .present])
    }
}
