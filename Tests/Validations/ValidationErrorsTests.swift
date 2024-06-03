import XCTest
@testable import Validations

final class ValidationErrorsTests: XCTestCase {
    func testReasonsForKey() {
        var error1 = ValidationError(reasons: [.count, .empty])
        error1.setKey("error group 1")
        var error2 = ValidationError(reasons: .format)
        error2.setKey("error group 1")
        var error3 = ValidationError(reasons: .empty)
        error3.setKey("error group 2")
        var error4 = ValidationError(reasons: .greaterThan)
        error4.setKey("error group 3")
        var error5 = ValidationError(reasons: [.greaterThan, .nil])
        error5.setKey("error group 3")

        let sut = ValidationErrors([error1, error2, error3, error4, error5])
        XCTAssertEqual(sut.reasons(for: "error group 1"), [.count, .empty, .format])
        XCTAssertEqual(sut.reasons(for: "error group 2"), .empty)
        XCTAssertEqual(sut.reasons(for: "error group 3"), [.greaterThan, .nil])
    }

    func testReasonsForKeyPath() {
        struct Test: Validator {
            var name = ""

            var validation: some Validator {
                Count(of: name, within: 4...)
                    .errorKey(\Test.name)
                Inclusion(of: name, in: "Swift")
                    .errorKey(\Test.name)
            }
        }

        XCTAssertEqual(Test().validationErrors?.reasons(for: \Test.name), [.count, .inclusion])
    }
}
