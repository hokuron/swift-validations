import Testing
import MacroTesting
import ValidationsMacros

@Suite(.macros([ValidatableMacro.self]))
struct ValidatableTests {
    @Test func availability() {
        assertMacro {
            #"""
            @available(iOS, deprecated: 9999, message: "Use the newer 'validation' API (v2.0+) instead") @available(macOS, deprecated: 9999, message: "Use the newer 'validation' API (v2.0+) instead") @available(tvOS, deprecated: 9999, message: "Use the newer 'validation' API (v2.0+) instead") @available(watchOS, deprecated: 9999, message: "Use the newer 'validation' API (v2.0+) instead")
            @Validatable
            struct User {
                var name: String

                #Validation(\Self.name, presence: .required)
            }
            """#
        } expansion: {
            #"""
            @available(iOS, deprecated: 9999, message: "Use the newer 'validation' API (v2.0+) instead") @available(macOS, deprecated: 9999, message: "Use the newer 'validation' API (v2.0+) instead") @available(tvOS, deprecated: 9999, message: "Use the newer 'validation' API (v2.0+) instead") @available(watchOS, deprecated: 9999, message: "Use the newer 'validation' API (v2.0+) instead")
            struct User {
                var name: String

                #Validation(\Self.name, presence: .required)
            }

            @available(iOS, deprecated: 9999, message: "Use the newer 'validation' API (v2.0+) instead") @available(macOS, deprecated: 9999, message: "Use the newer 'validation' API (v2.0+) instead") @available(tvOS, deprecated: 9999, message: "Use the newer 'validation' API (v2.0+) instead") @available(watchOS, deprecated: 9999, message: "Use the newer 'validation' API (v2.0+) instead") extension User: Validations.Validatable {
                var validation: some Validator {
                    Presence(of: self[keyPath: \Self.name]).presence(.required).errorKey(Self.self, \Self.name)
                }
            }
            """#
        }
    }

    @Test func noAvailability() {
        assertMacro {
            #"""
            @Validatable
            struct User {
                var name: String

                #Validation(\Self.name, presence: .required)
            }
            """#
        } expansion: {
            #"""
            struct User {
                var name: String

                #Validation(\Self.name, presence: .required)
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    Presence(of: self[keyPath: \Self.name]).presence(.required).errorKey(Self.self, \Self.name)
                }
            }
            """#
        }
    }

    @Test func accessModifierPublic() {
        assertMacro {
            #"""
            @Validatable
            public struct User {
                var name: String

                #Validation(\Self.name, presence: .required)
            }
            """#
        } expansion: {
            #"""
            public struct User {
                var name: String

                #Validation(\Self.name, presence: .required)
            }

            extension User: Validations.Validatable {
                public var validation: some Validator {
                    Presence(of: self[keyPath: \Self.name]).presence(.required).errorKey(Self.self, \Self.name)
                }
            }
            """#
        }
    }

    @Test func accessModifierPackage() {
        assertMacro {
            #"""
            @Validatable
            package struct User {
                var name: String

                #Validation(\Self.name, presence: .required)
            }
            """#
        } expansion: {
            #"""
            package struct User {
                var name: String

                #Validation(\Self.name, presence: .required)
            }

            extension User: Validations.Validatable {
                package var validation: some Validator {
                    Presence(of: self[keyPath: \Self.name]).presence(.required).errorKey(Self.self, \Self.name)
                }
            }
            """#
        }
    }

    @Test func accessModifierInternal() {
        assertMacro {
            #"""
            @Validatable
            internal struct User {
                var name: String

                #Validation(\Self.name, presence: .required)
            }
            """#
        } expansion: {
            #"""
            internal struct User {
                var name: String

                #Validation(\Self.name, presence: .required)
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    Presence(of: self[keyPath: \Self.name]).presence(.required).errorKey(Self.self, \Self.name)
                }
            }
            """#
        }
    }

    @Test func accessModifierPrivate() {
        assertMacro {
            #"""
            @Validatable
            private struct User {
                var name: String

                #Validation(\Self.name, presence: .required)
            }
            """#
        } expansion: {
            #"""
            private struct User {
                var name: String

                #Validation(\Self.name, presence: .required)
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    Presence(of: self[keyPath: \Self.name]).presence(.required).errorKey(Self.self, \Self.name)
                }
            }
            """#
        }
    }

    @Test func accessModifierFileprivate() {
        assertMacro {
            #"""
            @Validatable
            fileprivate struct User {
                var name: String

                #Validation(\Self.name, presence: .required)
            }
            """#
        } expansion: {
            #"""
            fileprivate struct User {
                var name: String

                #Validation(\Self.name, presence: .required)
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    Presence(of: self[keyPath: \Self.name]).presence(.required).errorKey(Self.self, \Self.name)
                }
            }
            """#
        }
    }
}
