import Testing
import MacroTesting
import Validations
import ValidationsMacros

@Suite(.macros([ValidatableMacro.self]))
struct ValidationAbsenceTests {
    @Validatable
    struct Article {
        enum Status {
            case draft, published, secret, archived
        }

        var status: Status?
        var title: String
        var body: String

        var tags: [String]
        var reactions: [String]?

        var readingTime: Int

        var ratings: [Int]
        var topRatings: [Int]?
        var totalRating: Int?

        var isActive: Bool

        #Validation(\Self.status, absence: .required, where: \.isActive)
        #Validation(\Self.title, \.body, absence: .required, where: \.isActive)
        #Validation(\Self.tags, absence: .required, where: \.isActive)
        #Validation(\Self.reactions, absence: .required, where: \.isActive)
        #Validation(\Self.readingTime, absence: .required, where: \.isActive)
        #Validation(\Self.ratings, absence: .required, where: \.isActive)
        #Validation(\Self.topRatings, absence: .required, where: \.isActive)
        #Validation(\Self.totalRating, absence: .required, where: \.isActive)
    }

    @Test func basic() {
        assertMacro {
            #"""
            @Validatable
            struct Article {
                var status: Status?
                var title: String
                var body: String
                var tags: [String]
                var reactions: [String]?

                #Validation(\Self.status, absence: .required)
                #Validation(\Self.title, \.body, absence: .required)
                #Validation(\Self.tags, absence: .required)
                #Validation(\Self.reactions, absence: .required)
            }
            """#
        } expansion: {
            #"""
            struct Article {
                var status: Status?
                var title: String
                var body: String
                var tags: [String]
                var reactions: [String]?

                #Validation(\Self.status, absence: .required)
                #Validation(\Self.title, \.body, absence: .required)
                #Validation(\Self.tags, absence: .required)
                #Validation(\Self.reactions, absence: .required)
            }

            extension Article: Validations.Validatable {
                var validation: some Validator {
                    Absence(of: self[keyPath: \Self.status]).errorKey(Self.self, \Self.status)
                    Absence(of: self[keyPath: \Self.title]).errorKey(Self.self, \Self.title)
                    Absence(of: self[keyPath: \.body]).errorKey(Self.self, \.body)
                    Absence(of: self[keyPath: \Self.tags]).errorKey(Self.self, \Self.tags)
                    Absence(of: self[keyPath: \Self.reactions]).errorKey(Self.self, \Self.reactions)
                }
            }
            """#
        }
    }

    @Test func withCondition() {
        assertMacro {
            #"""
            @Validatable
            struct Article {
                var status: Status?
                var title: String
                var body: String
                var tags: [String]
                var reactions: [String]?
                var isActive: Bool

                #Validation(\Self.status, absence: .required, where: \.isActive)
                #Validation(\Self.title, \.body, absence: .required, where: \.isActive)
                #Validation(\Self.tags, absence: .required, where: \.isActive)
                #Validation(\Self.reactions, absence: .required, where: \.isActive)
            }
            """#
        } expansion: {
            #"""
            struct Article {
                var status: Status?
                var title: String
                var body: String
                var tags: [String]
                var reactions: [String]?
                var isActive: Bool

                #Validation(\Self.status, absence: .required, where: \.isActive)
                #Validation(\Self.title, \.body, absence: .required, where: \.isActive)
                #Validation(\Self.tags, absence: .required, where: \.isActive)
                #Validation(\Self.reactions, absence: .required, where: \.isActive)
            }

            extension Article: Validations.Validatable {
                var validation: some Validator {
                    if self[keyPath: \.isActive] {
                        Absence(of: self[keyPath: \Self.status]).errorKey(Self.self, \Self.status)
                    }
                    if self[keyPath: \.isActive] {
                        Absence(of: self[keyPath: \Self.title]).errorKey(Self.self, \Self.title)
                        Absence(of: self[keyPath: \.body]).errorKey(Self.self, \.body)
                    }
                    if self[keyPath: \.isActive] {
                        Absence(of: self[keyPath: \Self.tags]).errorKey(Self.self, \Self.tags)
                    }
                    if self[keyPath: \.isActive] {
                        Absence(of: self[keyPath: \Self.reactions]).errorKey(Self.self, \Self.reactions)
                    }
                }
            }
            """#
        }
    }

    @Test func mixedTypes() {
        assertMacro {
            #"""
            @Validatable
            struct User {
                var username: String
                var email: String?
                var scores: [Int]
                var preferences: [String: Bool]?
                var age: Int

                #Validation(\Self.username, absence: .required)
                #Validation(\Self.email, absence: .required)
                #Validation(\Self.scores, absence: .required)
                #Validation(\Self.preferences, absence: .required)
                #Validation(\Self.age, absence: .required)
            }
            """#
        } expansion: {
            #"""
            struct User {
                var username: String
                var email: String?
                var scores: [Int]
                var preferences: [String: Bool]?
                var age: Int

                #Validation(\Self.username, absence: .required)
                #Validation(\Self.email, absence: .required)
                #Validation(\Self.scores, absence: .required)
                #Validation(\Self.preferences, absence: .required)
                #Validation(\Self.age, absence: .required)
            }

            extension User: Validations.Validatable {
                var validation: some Validator {
                    Absence(of: self[keyPath: \Self.username]).errorKey(Self.self, \Self.username)
                    Absence(of: self[keyPath: \Self.email]).errorKey(Self.self, \Self.email)
                    Absence(of: self[keyPath: \Self.scores]).errorKey(Self.self, \Self.scores)
                    Absence(of: self[keyPath: \Self.preferences]).errorKey(Self.self, \Self.preferences)
                    Absence(of: self[keyPath: \Self.age]).errorKey(Self.self, \Self.age)
                }
            }
            """#
        }
    }
}