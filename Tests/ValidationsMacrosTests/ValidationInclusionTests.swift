import Testing
import MacroTesting
import Validations
import ValidationsMacros

@Suite(.macros([ValidatableMacro.self]))
struct ValidationInclusionTests {
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

        #Validation(\Self.status, inclusion: [.published, .secret], presence: .required(allowsNil: true), where: \.isActive)
        #Validation(\Self.title, \.body, inclusion: ["news", "article", "blog"], presence: .none, where: \.isActive)
        #Validation(\Self.tags, inclusion: ["swift", "programming", "ios"], presence: .required, where: \.isActive)
        #Validation(\Self.reactions, inclusion: ["good", "bad", "ugly"], presence: .required(allowsEmpty: true), where: \.isActive)

        // For `RangeExpression & Collection`
        #Validation(\Self.readingTime, inclusion: 1...60, presence: .required, where: \.isActive)
        #Validation(\Self.ratings, inclusion: 1...5, presence: .none, where: \.isActive)
        #Validation(\Self.topRatings, inclusion: 3...5, presence: .required(allowsEmpty: true), where: \.isActive)
        #Validation(\Self.totalRating, inclusion: 0...99, presence: .none, where: \.isActive)

        // For `RangeExpression`
        #Validation(\Self.readingTime, inclusion: 1..., presence: .required, where: \.isActive)
        #Validation(\Self.ratings, inclusion: ..<6, presence: .none, where: \.isActive)
        #Validation(\Self.topRatings, inclusion: ...5, presence: .required(allowsEmpty: true), where: \.isActive)
        #Validation(\Self.totalRating, inclusion: ..<100, presence: .none, where: \.isActive)
    }

    @Test func basic() {
        assertMacro {
            #"""
            @Validatable
            struct Article {
                var status: Status?
                var title: String
                var body: String

                var topRating: Int?
                var ratings: [Int]

                #Validation(\Self.status, inclusion: [.published, .secret])
                #Validation(\Self.title, \.body, inclusion: ["news", "article", "blog"])

                #Validation(\Self.ratings, inclusion: ..<6)
                #Validation(\Self.topRatings, inclusion: 1...5)
            }
            """#
        } expansion: {
            #"""
            struct Article {
                var status: Status?
                var title: String
                var body: String

                var topRating: Int?
                var ratings: [Int]

                #Validation(\Self.status, inclusion: [.published, .secret])
                #Validation(\Self.title, \.body, inclusion: ["news", "article", "blog"])

                #Validation(\Self.ratings, inclusion: ..<6)
                #Validation(\Self.topRatings, inclusion: 1...5)
            }

            extension Article: Validations.Validatable {
                var validation: some Validator {
                    Inclusion(of: self[keyPath: \Self.status], in: [.published, .secret]).errorKey(Self.self, \Self.status)
                    Inclusion(of: self[keyPath: \Self.title], in: ["news", "article", "blog"]).errorKey(Self.self, \Self.title)
                    Inclusion(of: self[keyPath: \.body], in: ["news", "article", "blog"]).errorKey(Self.self, \.body)
                    Inclusion(of: self[keyPath: \Self.ratings], in: ..<6).errorKey(Self.self, \Self.ratings)
                    Inclusion(of: self[keyPath: \Self.topRatings], in: 1 ... 5).errorKey(Self.self, \Self.topRatings)
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
            
                var topRating: Int?
                var ratings: [Int]
            
                #Validation(\Self.status, inclusion: [.published, .secret], presence: .required(allowsNil: true))
                #Validation(\Self.title, \.body, inclusion: ["news", "article", "blog"], presence: .none)
            
                #Validation(\Self.ratings, inclusion: ..<6, presence: .required(allowsNil: true))
                #Validation(\Self.topRatings, inclusion: 1...5, presence: .required(allowsEmpty: true))
            }
            """#
        } expansion: {
            #"""
            struct Article {
                var status: Status?
                var title: String
                var body: String

                var topRating: Int?
                var ratings: [Int]

                #Validation(\Self.status, inclusion: [.published, .secret], presence: .required(allowsNil: true))
                #Validation(\Self.title, \.body, inclusion: ["news", "article", "blog"], presence: .none)

                #Validation(\Self.ratings, inclusion: ..<6, presence: .required(allowsNil: true))
                #Validation(\Self.topRatings, inclusion: 1...5, presence: .required(allowsEmpty: true))
            }

            extension Article: Validations.Validatable {
                var validation: some Validator {
                    Inclusion(of: self[keyPath: \Self.status], in: [.published, .secret]).presence(.required(allowsNil: true)).errorKey(Self.self, \Self.status)
                    Inclusion(of: self[keyPath: \Self.title], in: ["news", "article", "blog"]).presence(.none).errorKey(Self.self, \Self.title)
                    Inclusion(of: self[keyPath: \.body], in: ["news", "article", "blog"]).presence(.none).errorKey(Self.self, \.body)
                    Inclusion(of: self[keyPath: \Self.ratings], in: ..<6).presence(.required(allowsNil: true)).errorKey(Self.self, \Self.ratings)
                    Inclusion(of: self[keyPath: \Self.topRatings], in: 1 ... 5).presence(.required(allowsEmpty: true)).errorKey(Self.self, \Self.topRatings)
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
            
                var topRating: Int?
                var ratings: [Int]

                var isActive: Bool

                #Validation(\Self.status, inclusion: [.published, .secret], presence: .required(allowsNil: true), where: \.isActive)
                #Validation(\Self.title, \.body, inclusion: ["news", "article", "blog"], presence: .none, where: \.isActive)
            
                #Validation(\Self.ratings, inclusion: ..<6, presence: .required(allowsNil: true), where: \.isActive)
                #Validation(\Self.topRatings, inclusion: 1...5, presence: .required(allowsEmpty: true), where: \.isActive)
            }
            """#
        } expansion: {
            #"""
            struct Article {
                var status: Status?
                var title: String
                var body: String

                var topRating: Int?
                var ratings: [Int]

                var isActive: Bool

                #Validation(\Self.status, inclusion: [.published, .secret], presence: .required(allowsNil: true), where: \.isActive)
                #Validation(\Self.title, \.body, inclusion: ["news", "article", "blog"], presence: .none, where: \.isActive)

                #Validation(\Self.ratings, inclusion: ..<6, presence: .required(allowsNil: true), where: \.isActive)
                #Validation(\Self.topRatings, inclusion: 1...5, presence: .required(allowsEmpty: true), where: \.isActive)
            }

            extension Article: Validations.Validatable {
                var validation: some Validator {
                    if self[keyPath: \.isActive] {
                        Inclusion(of: self[keyPath: \Self.status], in: [.published, .secret]).presence(.required(allowsNil: true)).errorKey(Self.self, \Self.status)
                    }
                    if self[keyPath: \.isActive] {
                        Inclusion(of: self[keyPath: \Self.title], in: ["news", "article", "blog"]).presence(.none).errorKey(Self.self, \Self.title)
                        Inclusion(of: self[keyPath: \.body], in: ["news", "article", "blog"]).presence(.none).errorKey(Self.self, \.body)
                    }
                    if self[keyPath: \.isActive] {
                        Inclusion(of: self[keyPath: \Self.ratings], in: ..<6).presence(.required(allowsNil: true)).errorKey(Self.self, \Self.ratings)
                    }
                    if self[keyPath: \.isActive] {
                        Inclusion(of: self[keyPath: \Self.topRatings], in: 1 ... 5).presence(.required(allowsEmpty: true)).errorKey(Self.self, \Self.topRatings)
                    }
                }
            }
            """#
        }
    }
}
