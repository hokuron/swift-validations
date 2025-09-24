import Testing
import MacroTesting
import Validations
import ValidationsMacros

@Suite(.macros([ValidatableMacro.self]))
struct ValidationFormatTests {
    @Validatable
    struct User {
        var firstName: String
        var lastName: String
        var phoneNumber: String?

        var isActive: Bool

        #Validation(\Self.firstName, \.lastName, format: /\A[a-zA-Z]+\z/, presence: .required(allowsNil: true), where: \.isActive)
        #Validation(\Self.phoneNumber, format: /\A\d+\z/, presence: .none, where: \.isActive)
    }

    @Test func basic() {
        assertMacro {
            #"""
            @Validatable
            struct User {
                var firstName: String
                var lastName: String

                #Validation(\Self.firstName, \.lastName, format: /\A[a-zA-Z]+\z/)
            }
            """#
        } expansion: {
            #"""
            struct User {
                var firstName: String
                var lastName: String

                #Validation(\Self.firstName, \.lastName, format: /\A[a-zA-Z]+\z/)
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    Format(of: self[keyPath: \Self.firstName], with: /\A[a-zA-Z]+\z/).errorKey(Self.self, \Self.firstName)
                    Format(of: self[keyPath: \.lastName], with: /\A[a-zA-Z]+\z/).errorKey(Self.self, \.lastName)
                }
            }
            """#
        }
    }

    @Test func withPresenceOption() {
        assertMacro {
            #"""
            @Validatable
            struct User {
                var firstName: String
                var lastName: String
                var phoneNumber: String?

                #Validation(\Self.firstName, \.lastName, format: /\A[a-zA-Z]+\z/, presence: .required(allowsNil: true))
                #Validation(\Self.phoneNumber, format: /\A\d+\z/, presence: .none)
            }
            """#
        } expansion: {
            #"""
            struct User {
                var firstName: String
                var lastName: String
                var phoneNumber: String?

                #Validation(\Self.firstName, \.lastName, format: /\A[a-zA-Z]+\z/, presence: .required(allowsNil: true))
                #Validation(\Self.phoneNumber, format: /\A\d+\z/, presence: .none)
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    Format(of: self[keyPath: \Self.firstName], with: /\A[a-zA-Z]+\z/).presence(.required(allowsNil: true)).errorKey(Self.self, \Self.firstName)
                    Format(of: self[keyPath: \.lastName], with: /\A[a-zA-Z]+\z/).presence(.required(allowsNil: true)).errorKey(Self.self, \.lastName)
                    Format(of: self[keyPath: \Self.phoneNumber], with: /\A\d+\z/).presence(.none).errorKey(Self.self, \Self.phoneNumber)
                }
            }
            """#
        }
    }

    @Test func withCondition() {
        assertMacro {
            #"""
            @Validatable
            struct User {
                var firstName: String
                var lastName: String
                var phoneNumber: String?

                var isActive: Bool

                #Validation(\Self.firstName, \.lastName, format: /\A[a-zA-Z]+\z/, presence: .required(allowsEmpty: true), where: \.isActive)
                #Validation(\Self.phoneNumber, format: /\A\d+\z/, presence: .none, where: \.isActive)
            }
            """#
        } expansion: {
            #"""
            struct User {
                var firstName: String
                var lastName: String
                var phoneNumber: String?

                var isActive: Bool

                #Validation(\Self.firstName, \.lastName, format: /\A[a-zA-Z]+\z/, presence: .required(allowsEmpty: true), where: \.isActive)
                #Validation(\Self.phoneNumber, format: /\A\d+\z/, presence: .none, where: \.isActive)
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    if self[keyPath: \.isActive] {
                        Format(of: self[keyPath: \Self.firstName], with: /\A[a-zA-Z]+\z/).presence(.required(allowsEmpty: true)).errorKey(Self.self, \Self.firstName)
                        Format(of: self[keyPath: \.lastName], with: /\A[a-zA-Z]+\z/).presence(.required(allowsEmpty: true)).errorKey(Self.self, \.lastName)
                    }
                    if self[keyPath: \.isActive] {
                        Format(of: self[keyPath: \Self.phoneNumber], with: /\A\d+\z/).presence(.none).errorKey(Self.self, \Self.phoneNumber)
                    }
                }
            }
            """#
        }
    }
}
