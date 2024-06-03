import XCTest
import SwiftUI
@testable import Validations

final class ValidatorBuilderTests: XCTestCase {
    func testMergeValidations() {
        struct SUT: Validator {
            var name: String?
            var email: String?
            var confirmedEmail: String?
            var age: String?
            var agreed: Bool

            var validation: some Validator {
                Presence(of: name)
                Presence(of: email)
                if let email {
                    Confirmation(of: confirmedEmail, matching: email)
                } else {
                    Inclusion(of: agreed, in: [false])
                }

                Inclusion(of: agreed, in: [true])
            }
        }

        XCTAssertNoThrow(try SUT(name: "A B", email: "mail@example.com", agreed: true).validate())
        XCTAssertEqual(SUT(name: "", email: "mail@example.com", agreed: false).validationErrors?.reasons, [.empty, .inclusion])
    }

    // MARK: - Compile time tests.

    enum Test {
        struct Empty: Validator {
            var validation: some Validator {
                Validate {}
            }
        }

        @available(iOS, introduced: 9999)
        @available(macOS, introduced: 9999)
        @available(tvOS, introduced: 9999)
        @available(visionOS, introduced: 9999)
        @available(watchOS, introduced: 9999)
        struct Unavailable: Validator {
            var validation: some Validator {
                Empty()
            }
        }
    }

    func testSingleBlock() {
        struct SUT: Validator {
            var validation: some Validator {
                Test.Empty()
            }
        }

        XCTAssertNoThrow(try SUT().validate())
    }

    func testLimitedAvailability() {
        struct SUT: Validator {
            var validation: some Validator {
                Test.Empty()
                if #available(iOS 9999, macOS 9999, tvOS 9999, visionOS 9999, watchOS 9999, *) {
                    Test.Unavailable()
                } else if #available(iOS 8888, macOS 8888, tvOS 8888, visionOS 8888, watchOS 8888, *) {
                    Test.Empty()
                }
                Test.Empty()
            }
        }

        XCTAssertNoThrow(try SUT().validate())
    }

    func testEither() {
        struct SUT: Validator {
            var validation: some Validator {
                if Bool.random() {
                    Test.Empty()
                } else {
                    Test.Empty()
                }
            }
        }

        XCTAssertNoThrow(try SUT().validate())
    }

    func testOptional() {
        struct SUT: Validator {
            var validation: some Validator {
                if Bool.random() {
                    Test.Empty()
                }
            }
        }

        XCTAssertNoThrow(try SUT().validate())
    }
}
