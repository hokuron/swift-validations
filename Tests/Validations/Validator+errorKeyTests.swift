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
                Presence(of: name)
                    .errorKey(\SUT.name)
            }
        }

        XCTAssertEqual(SUT().validationErrors?.first?.key, \SUT.name)
    }

    func testWithValidatorBuilder() {
        struct SUT: Validator {
            var name: String?
            var age = 10

            var validation: some Validator {
                Presence(of: name)
                    .errorKey("presence")

                if name == nil {
                    Count(of: name, exact: 0)
                        .errorKey("count")
                }

                Comparison(of: age, .greaterThan(18))
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
                    Presence(of: "")
                        .errorKey("child presence")
                    Count(of: "", within: 10...)
                    Absence(of: "abc")
                }
            }

            var validation: some Validator {
                Presence(of: "")
                    .errorKey("parent presence")
                child
                    .errorKey("overwritten key")
                Presence(of: "")
                Absence(of: "abc")
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
