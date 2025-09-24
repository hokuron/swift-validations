import Testing
import MacroTesting
import Validations
import ValidationsMacros

@Suite(.macros([ValidatableMacro.self]))
struct ValidationTest {
    @Validatable
    struct User {
        var name: Name
        var namePronunciation: NamePronunciation
        var phoneNumber: PhoneNumber?

        #Validation(\Self.name, \.namePronunciation, \.phoneNumber)

        @Validatable
        struct Name {
            var first: String
            var last: String

            #Validation(anyOf: \Self.first, \.last, pass: Presence.init(of:))
        }

        struct NamePronunciation: Validator {
            var first: String
            var last: String

            var validation: some Validator {
                AnyOf([first, last], pass: Presence.init(of:))
            }
        }

        @Validatable
        struct PhoneNumber {
            var value: String

            #Validation(\Self.value, format: /\A\d+\z/)
        }
    }

    @Test func basic() {
        assertMacro {
            #"""
            @Validatable
            struct User {
                var name: Name
                var namePronunciation: NamePronunciation
                var phoneNumber: PhoneNumber?

                #Validation(\Self.name, \.namePronunciation, \.phoneNumber)
            }
            """#
        } expansion: {
            #"""
            struct User {
                var name: Name
                var namePronunciation: NamePronunciation
                var phoneNumber: PhoneNumber?

                #Validation(\Self.name, \.namePronunciation, \.phoneNumber)
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    self[keyPath: \Self.name]
                    self[keyPath: \.namePronunciation]
                    self[keyPath: \.phoneNumber]
                }
            }
            """#
        }
    }
}
