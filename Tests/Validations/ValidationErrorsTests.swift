import Testing
@testable import Validations

@Suite
struct ValidationErrorsTests {
    @Test
    func reasonsForKey() {
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
        #expect(sut.reasons(for: "error group 1") == [.count, .empty, .format])
        #expect(sut.reasons(for: "error group 2") == .empty)
        #expect(sut.reasons(for: "error group 3") == [.greaterThan, .nil])
    }

    @Test
    func reasonsForKeyPath() {
        struct Test: Validator {
            var name = ""

            var validation: some Validator {
                Count(of: name, within: 4...)
                    .errorKey(\Test.name)
                Inclusion(of: name, in: "Swift")
                    .errorKey(\Test.name)
            }
        }

        #expect(Test().validationErrors?.reasons(for: \Test.name) == [.count, .inclusion])
    }
}
