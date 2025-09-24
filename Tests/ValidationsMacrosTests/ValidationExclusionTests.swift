import Testing
import MacroTesting
import Validations
import ValidationsMacros

@Suite(.macros([ValidatableMacro.self]))
struct ValidationExclusionTests {
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

        #Validation(\Self.status, exclusion: [.draft, .archived], presence: .required(allowsNil: true), where: \.isActive)
        #Validation(\Self.title, \.body, exclusion: ["spam", "advertisement", "clickbait"], presence: .none, where: \.isActive)
        #Validation(\Self.tags, exclusion: ["nsfw", "adult", "18+"], presence: .required, where: \.isActive)
        #Validation(\Self.reactions, exclusion: ["hate", "toxic", "spam"], presence: .required(allowsEmpty: true), where: \.isActive)

        // For `RangeExpression & Collection`
        #Validation(\Self.readingTime, exclusion: 301...999, presence: .required, where: \.isActive)
        #Validation(\Self.ratings, exclusion: 6...10, presence: .none, where: \.isActive)
        #Validation(\Self.topRatings, exclusion: 0...2, presence: .required(allowsEmpty: true), where: \.isActive)
        #Validation(\Self.totalRating, exclusion: 100...999, presence: .none, where: \.isActive)

        // For `RangeExpression`
        #Validation(\Self.readingTime, exclusion: 1000..., presence: .required, where: \.isActive)
        #Validation(\Self.ratings, exclusion: ..<0, presence: .none, where: \.isActive)
        #Validation(\Self.topRatings, exclusion: ...(-1), presence: .required(allowsEmpty: true), where: \.isActive)
        #Validation(\Self.totalRating, exclusion: ..<(-100), presence: .none, where: \.isActive)
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

                #Validation(\Self.status, exclusion: [.draft, .archived])
                #Validation(\Self.title, \.body, exclusion: ["spam", "advertisement", "clickbait"])

                #Validation(\Self.ratings, exclusion: ..<0)
                #Validation(\Self.topRatings, exclusion: 0...2)
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

                #Validation(\Self.status, exclusion: [.draft, .archived])
                #Validation(\Self.title, \.body, exclusion: ["spam", "advertisement", "clickbait"])

                #Validation(\Self.ratings, exclusion: ..<0)
                #Validation(\Self.topRatings, exclusion: 0...2)
            }

            extension Article: Validations.Validatable {
                var validation: some Validator {
                    Exclusion(of: self[keyPath: \Self.status], from: [.draft, .archived]).errorKey(Self.self, \Self.status)
                    Exclusion(of: self[keyPath: \Self.title], from: ["spam", "advertisement", "clickbait"]).errorKey(Self.self, \Self.title)
                    Exclusion(of: self[keyPath: \.body], from: ["spam", "advertisement", "clickbait"]).errorKey(Self.self, \.body)
                    Exclusion(of: self[keyPath: \Self.ratings], from: ..<0).errorKey(Self.self, \Self.ratings)
                    Exclusion(of: self[keyPath: \Self.topRatings], from: 0 ... 2).errorKey(Self.self, \Self.topRatings)
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
            
                #Validation(\Self.status, exclusion: [.draft, .archived], presence: .required(allowsNil: true))
                #Validation(\Self.title, \.body, exclusion: ["spam", "advertisement", "clickbait"], presence: .none)
            
                #Validation(\Self.ratings, exclusion: ..<0, presence: .required(allowsNil: true))
                #Validation(\Self.topRatings, exclusion: 0...2, presence: .required(allowsEmpty: true))
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

                #Validation(\Self.status, exclusion: [.draft, .archived], presence: .required(allowsNil: true))
                #Validation(\Self.title, \.body, exclusion: ["spam", "advertisement", "clickbait"], presence: .none)

                #Validation(\Self.ratings, exclusion: ..<0, presence: .required(allowsNil: true))
                #Validation(\Self.topRatings, exclusion: 0...2, presence: .required(allowsEmpty: true))
            }

            extension Article: Validations.Validatable {
                var validation: some Validator {
                    Exclusion(of: self[keyPath: \Self.status], from: [.draft, .archived]).presence(.required(allowsNil: true)).errorKey(Self.self, \Self.status)
                    Exclusion(of: self[keyPath: \Self.title], from: ["spam", "advertisement", "clickbait"]).presence(.none).errorKey(Self.self, \Self.title)
                    Exclusion(of: self[keyPath: \.body], from: ["spam", "advertisement", "clickbait"]).presence(.none).errorKey(Self.self, \.body)
                    Exclusion(of: self[keyPath: \Self.ratings], from: ..<0).presence(.required(allowsNil: true)).errorKey(Self.self, \Self.ratings)
                    Exclusion(of: self[keyPath: \Self.topRatings], from: 0 ... 2).presence(.required(allowsEmpty: true)).errorKey(Self.self, \Self.topRatings)
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

                #Validation(\Self.status, exclusion: [.draft, .archived], presence: .required(allowsNil: true), where: \.isActive)
                #Validation(\Self.title, \.body, exclusion: ["spam", "advertisement", "clickbait"], presence: .none, where: \.isActive)
            
                #Validation(\Self.ratings, exclusion: ..<0, presence: .required(allowsNil: true), where: \.isActive)
                #Validation(\Self.topRatings, exclusion: 0...2, presence: .required(allowsEmpty: true), where: \.isActive)
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

                #Validation(\Self.status, exclusion: [.draft, .archived], presence: .required(allowsNil: true), where: \.isActive)
                #Validation(\Self.title, \.body, exclusion: ["spam", "advertisement", "clickbait"], presence: .none, where: \.isActive)

                #Validation(\Self.ratings, exclusion: ..<0, presence: .required(allowsNil: true), where: \.isActive)
                #Validation(\Self.topRatings, exclusion: 0...2, presence: .required(allowsEmpty: true), where: \.isActive)
            }

            extension Article: Validations.Validatable {
                var validation: some Validator {
                    if self[keyPath: \.isActive] {
                        Exclusion(of: self[keyPath: \Self.status], from: [.draft, .archived]).presence(.required(allowsNil: true)).errorKey(Self.self, \Self.status)
                    }
                    if self[keyPath: \.isActive] {
                        Exclusion(of: self[keyPath: \Self.title], from: ["spam", "advertisement", "clickbait"]).presence(.none).errorKey(Self.self, \Self.title)
                        Exclusion(of: self[keyPath: \.body], from: ["spam", "advertisement", "clickbait"]).presence(.none).errorKey(Self.self, \.body)
                    }
                    if self[keyPath: \.isActive] {
                        Exclusion(of: self[keyPath: \Self.ratings], from: ..<0).presence(.required(allowsNil: true)).errorKey(Self.self, \Self.ratings)
                    }
                    if self[keyPath: \.isActive] {
                        Exclusion(of: self[keyPath: \Self.topRatings], from: 0 ... 2).presence(.required(allowsEmpty: true)).errorKey(Self.self, \Self.topRatings)
                    }
                }
            }
            """#
        }
    }
}
