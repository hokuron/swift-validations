import Testing
import MacroTesting
import Validations
import ValidationsMacros

@Suite(.macros([ValidatableMacro.self]))
struct ValidationAnyOfTests {
    @Validatable
    struct User {
        @Validatable
        struct NameComponent {
            var value: String

            #Validation(\Self.value, presence: .required)
        }

        var firstName: NameComponent
        var lastName: NameComponent
        var middleName: NameComponent?

        var isChanged: Bool

        #Validation(anyOf: \Self.firstName, \.lastName, errorKey: "name components", where: \.isChanged)
        #Validation(anyOf: \Self.middleName, errorKey: "optional name", where: \.isChanged)
        #Validation(anyOf: \Self.firstName, \.lastName, errorKey: "name components", where: \.isChanged, pass: Presence.init(of:))
        #Validation(anyOf: \Self.firstName, \.lastName, errorKey: "name components", where: \.isChanged) {
            Presence(of: $0)
            Count(of: $0.value, within: ...100)
        }
        #Validation(anyOf: \Self.middleName, errorKey: "optional name", where: \.isChanged) {
            Presence(of: $0)
                .allowsNil()
            Count(of: $0?.value, within: ...100)
                .allowsNil()
        }
    }

    @Test func basic() {
        assertMacro {
            #"""
            @Validatable
            struct User {
                struct NameComponent {
                    var value: String
                }

                var firstName: NameComponent
                var lastName: NameComponent
                var middleName: NameComponent?

                #Validation(anyOf: \Self.firstName, \.lastName)
                #Validation(anyOf: \Self.middleName)
            }
            """#
        } expansion: {
            #"""
            struct User {
                struct NameComponent {
                    var value: String
                }

                var firstName: NameComponent
                var lastName: NameComponent
                var middleName: NameComponent?

                #Validation(anyOf: \Self.firstName, \.lastName)
                #Validation(anyOf: \Self.middleName)
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    AnyOf([self[keyPath: \Self.firstName], self[keyPath: \.lastName]])
                    AnyOf([self[keyPath: \Self.middleName]])
                }
            }
            """#
        }
    }

    @Test func withErrorKey() {
        assertMacro {
            #"""
            @Validatable
            struct User {
                struct NameComponent {
                    var value: String
                }

                var firstName: NameComponent
                var lastName: NameComponent

                #Validation(anyOf: \Self.firstName, \.lastName, errorKey: "name components")
            }
            """#
        } expansion: {
            #"""
            struct User {
                struct NameComponent {
                    var value: String
                }

                var firstName: NameComponent
                var lastName: NameComponent

                #Validation(anyOf: \Self.firstName, \.lastName, errorKey: "name components")
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    AnyOf([self[keyPath: \Self.firstName], self[keyPath: \.lastName]]).errorKey("name components")
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
                struct NameComponent {
                    var value: String
                }

                var firstName: NameComponent
                var lastName: NameComponent
                var isChanged: Bool

                #Validation(anyOf: \Self.firstName, \.lastName, errorKey: "name components", where: \.isChanged)
            }
            """#
        } expansion: {
            #"""
            struct User {
                struct NameComponent {
                    var value: String
                }

                var firstName: NameComponent
                var lastName: NameComponent
                var isChanged: Bool

                #Validation(anyOf: \Self.firstName, \.lastName, errorKey: "name components", where: \.isChanged)
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    if self[keyPath: \.isChanged] {
                        AnyOf([self[keyPath: \Self.firstName], self[keyPath: \.lastName]]).errorKey("name components")
                    }
                }
            }
            """#
        }
    }

    @Test func withPassExpression() {
        assertMacro {
            #"""
            @Validatable
            struct User {
                struct NameComponent {
                    var value: String
                }

                var firstName: NameComponent
                var lastName: NameComponent

                #Validation(anyOf: \Self.firstName, \.lastName, pass: Presence.init(of:))
            }
            """#
        } expansion: {
            #"""
            struct User {
                struct NameComponent {
                    var value: String
                }

                var firstName: NameComponent
                var lastName: NameComponent

                #Validation(anyOf: \Self.firstName, \.lastName, pass: Presence.init(of:))
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    AnyOf([self[keyPath: \Self.firstName], self[keyPath: \.lastName]], pass: Presence.init(of:))
                }
            }
            """#
        }
    }

    @Test func withPassClosure() {
        assertMacro {
            #"""
            @Validatable
            struct User {
                struct NameComponent {
                    var value: String
                }

                var firstName: NameComponent
                var lastName: NameComponent

                #Validation(anyOf: \Self.firstName, \.lastName) {
                    Presence(of: $0)
                    Count(of: $0.value, within: ...100)
                }
            }
            """#
        } expansion: {
            #"""
            struct User {
                struct NameComponent {
                    var value: String
                }

                var firstName: NameComponent
                var lastName: NameComponent

                #Validation(anyOf: \Self.firstName, \.lastName) {
                    Presence(of: $0)
                    Count(of: $0.value, within: ...100)
                }
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    AnyOf([self[keyPath: \Self.firstName], self[keyPath: \.lastName]]) {
                        Presence(of: $0)
                        Count(of: $0.value, within: ...100)
                    }
                }
            }
            """#
        }
    }

    @Test func withPassClosureAndErrorKey() {
        assertMacro {
            #"""
            @Validatable
            struct User {
                struct NameComponent {
                    var value: String
                }

                var firstName: NameComponent
                var lastName: NameComponent

                #Validation(anyOf: \Self.firstName, \.lastName, errorKey: "name components") {
                    Presence(of: $0)
                }
            }
            """#
        } expansion: {
            #"""
            struct User {
                struct NameComponent {
                    var value: String
                }

                var firstName: NameComponent
                var lastName: NameComponent

                #Validation(anyOf: \Self.firstName, \.lastName, errorKey: "name components") {
                    Presence(of: $0)
                }
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    AnyOf([self[keyPath: \Self.firstName], self[keyPath: \.lastName]]) {
                        Presence(of: $0)
                    }
                    .errorKey("name components")
                }
            }
            """#
        }
    }

    @Test func nestedValidatorType() {
        assertMacro {
            #"""
            @Validatable
            struct User {
                @Validatable
                struct Address {
                    var street: String
                    #Validation(\Self.street, presence: .required)
                }

                var primaryAddress: Address
                var secondaryAddress: Address
                var thirdAddress: Address?

                #Validation(anyOf: \Self.primaryAddress, \.secondaryAddress)
                #Validation(anyOf: \Self.thirdAddress)
            }
            """#
        } expansion: {
            #"""
            struct User {
                struct Address {
                    var street: String
                    #Validation(\Self.street, presence: .required)
                }

                var primaryAddress: Address
                var secondaryAddress: Address
                var thirdAddress: Address?

                #Validation(anyOf: \Self.primaryAddress, \.secondaryAddress)
                #Validation(anyOf: \Self.thirdAddress)
            }

            extension User.Address: Validations.Validatable {
                var validation: some Validator {
                    Presence(of: self[keyPath: \Self.street]).presence(.required).errorKey(Self.self, \Self.street)
                }
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    AnyOf([self[keyPath: \Self.primaryAddress], self[keyPath: \.secondaryAddress]])
                    AnyOf([self[keyPath: \Self.thirdAddress]])
                }
            }
            """#
        }
    }

    @Test func complexWithAllFeatures() {
        assertMacro {
            #"""
            @Validatable
            struct User {
                struct NameComponent {
                    var value: String
                }

                var firstName: NameComponent
                var lastName: NameComponent
                var isChanged: Bool

                #Validation(anyOf: \Self.firstName, \.lastName, errorKey: "name components", where: \.isChanged) {
                    Presence(of: $0)
                    Count(of: $0.value, within: ...100)
                }
            }
            """#
        } expansion: {
            #"""
            struct User {
                struct NameComponent {
                    var value: String
                }

                var firstName: NameComponent
                var lastName: NameComponent
                var isChanged: Bool

                #Validation(anyOf: \Self.firstName, \.lastName, errorKey: "name components", where: \.isChanged) {
                    Presence(of: $0)
                    Count(of: $0.value, within: ...100)
                }
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    if self[keyPath: \.isChanged] {
                        AnyOf([self[keyPath: \Self.firstName], self[keyPath: \.lastName]]) {
                            Presence(of: $0)
                            Count(of: $0.value, within: ...100)
                        }
                        .errorKey("name components")
                    }
                }
            }
            """#
        }
    }
}
