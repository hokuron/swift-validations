import Testing
@testable import Validations

@Suite
struct ValidatorErrorKeyTests {
    @Test func string() {
        let sut = Validate {
            throw ValidationError(reasons: .format)
        }
            .errorKey("Error Key")

        #expect(sut.validationErrors?.first?.key == AnyHashable("Error Key"))
    }

    @Test
    func keyPath() {
        struct SUT: Validator {
            var name: String?

            var validation: some Validator {
                Presence(of: name)
                    .errorKey(\SUT.name)
            }
        }

        #expect(SUT().validationErrors?.first?.key == AnyHashable(\SUT.name))
    }

    @Test
    func withValidatorBuilder() {
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

        #expect(SUT().validationErrors?.map(\.key) == ["presence", "count", "comparison"])
    }

    @Test
    func overwriteKeys() {
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

        #expect(
            SUT().validationErrors?.map(\.key) == ["parent presence", "child presence", "overwritten key", "overwritten key", nil, "parent absence"]
        )
        #expect(SUT().validationErrors?.reasons(for: "overwritten key") == [.count, .present])
    }
}
