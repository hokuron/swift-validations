import Testing
import MacroTesting
import Validations
import ValidationsMacros

@Suite(.macros([ValidatableMacro.self]))
struct ValidationPresenceTests {
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

        #Validation(\Self.status, presence: .required(allowsNil: true), where: \.isActive)
        #Validation(\Self.title, \.body, presence: .required, where: \.isActive)
        #Validation(\Self.tags, presence: .required(allowsEmpty: true), where: \.isActive)
        #Validation(\Self.reactions, presence: .none, where: \.isActive)
        #Validation(\Self.readingTime, presence: .required, where: \.isActive)
        #Validation(\Self.ratings, presence: .required(allowsEmpty: true), where: \.isActive)
        #Validation(\Self.topRatings, presence: .required(allowsNil: true), where: \.isActive)
        #Validation(\Self.totalRating, presence: .none, where: \.isActive)
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

                #Validation(\Self.status, presence: .required)
                #Validation(\Self.title, \.body, presence: .required)
                #Validation(\Self.tags, presence: .required)
                #Validation(\Self.reactions, presence: .none)
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

                #Validation(\Self.status, presence: .required)
                #Validation(\Self.title, \.body, presence: .required)
                #Validation(\Self.tags, presence: .required)
                #Validation(\Self.reactions, presence: .none)
            }

            extension Article: Validations.Validatable {
                var validation: some Validator {
                    Presence(of: self[keyPath: \Self.status]).presence(.required).errorKey(Self.self, \Self.status)
                    Presence(of: self[keyPath: \Self.title]).presence(.required).errorKey(Self.self, \Self.title)
                    Presence(of: self[keyPath: \.body]).presence(.required).errorKey(Self.self, \.body)
                    Presence(of: self[keyPath: \Self.tags]).presence(.required).errorKey(Self.self, \Self.tags)
                    Presence(of: self[keyPath: \Self.reactions]).presence(.none).errorKey(Self.self, \Self.reactions)
                }
            }
            """#
        }
    }

    @Test func withPresenceOption() {
        assertMacro {
            #"""
            @Validatable
            struct Article {
                var status: Status?
                var title: String
                var body: String
                var tags: [String]
                var reactions: [String]?
                var totalRating: Int?

                #Validation(\Self.status, presence: .required(allowsNil: true))
                #Validation(\Self.tags, presence: .required(allowsEmpty: true))
                #Validation(\Self.totalRating, presence: .required(allowsNil: false))
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
                var totalRating: Int?

                #Validation(\Self.status, presence: .required(allowsNil: true))
                #Validation(\Self.tags, presence: .required(allowsEmpty: true))
                #Validation(\Self.totalRating, presence: .required(allowsNil: false))
            }

            extension Article: Validations.Validatable {
                var validation: some Validator {
                    Presence(of: self[keyPath: \Self.status]).presence(.required(allowsNil: true)).errorKey(Self.self, \Self.status)
                    Presence(of: self[keyPath: \Self.tags]).presence(.required(allowsEmpty: true)).errorKey(Self.self, \Self.tags)
                    Presence(of: self[keyPath: \Self.totalRating]).presence(.required(allowsNil: false)).errorKey(Self.self, \Self.totalRating)
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

                #Validation(\Self.status, presence: .required(allowsNil: true), where: \.isActive)
                #Validation(\Self.title, \.body, presence: .required, where: \.isActive)
                #Validation(\Self.tags, presence: .required(allowsEmpty: true), where: \.isActive)
                #Validation(\Self.reactions, presence: .none, where: \.isActive)
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

                #Validation(\Self.status, presence: .required(allowsNil: true), where: \.isActive)
                #Validation(\Self.title, \.body, presence: .required, where: \.isActive)
                #Validation(\Self.tags, presence: .required(allowsEmpty: true), where: \.isActive)
                #Validation(\Self.reactions, presence: .none, where: \.isActive)
            }

            extension Article: Validations.Validatable {
                var validation: some Validator {
                    if self[keyPath: \.isActive] {
                        Presence(of: self[keyPath: \Self.status]).presence(.required(allowsNil: true)).errorKey(Self.self, \Self.status)
                    }
                    if self[keyPath: \.isActive] {
                        Presence(of: self[keyPath: \Self.title]).presence(.required).errorKey(Self.self, \Self.title)
                        Presence(of: self[keyPath: \.body]).presence(.required).errorKey(Self.self, \.body)
                    }
                    if self[keyPath: \.isActive] {
                        Presence(of: self[keyPath: \Self.tags]).presence(.required(allowsEmpty: true)).errorKey(Self.self, \Self.tags)
                    }
                    if self[keyPath: \.isActive] {
                        Presence(of: self[keyPath: \Self.reactions]).presence(.none).errorKey(Self.self, \Self.reactions)
                    }
                }
            }
            """#
        }
    }
}
