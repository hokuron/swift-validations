extension Validator {
    @inlinable
    public func errorKey<K: Hashable & Sendable>(_ key: K) -> some Validator {
        _ErrorKeyModifier(parent: self, errorKey: key)
    }

    @inlinable
    public func errorKey<Root, Value>(_ keyPath: KeyPath<Root, Value>) -> some Validator {
        _ErrorKeyModifier(parent: self, errorKey: keyPath)
    }
}

@usableFromInline
struct _ErrorKeyModifier<Parent: Validator, Key: Hashable & Sendable>: Validator {
    @usableFromInline
    var parent: Parent
    
    @usableFromInline
    var errorKey: Key

    @inlinable
    init(parent: Parent, errorKey: Key) {
        self.parent = parent
        self.errorKey = errorKey
    }

    #if DEBUG && swift(>=6.0) // https://github.com/apple/swift/issues/57560
    @inlinable
    init<R, V>(parent: Parent, errorKey keyPath: KeyPath<R, V>) where Key == KeyPath<R, V> {
        self.parent = parent
        self.errorKey = keyPath
    }
    #else
    @inlinable
    init<R, V>(parent: Parent, errorKey keyPath: KeyPath<R, V>) where Key == Int {
        self.parent = parent
        self.errorKey = keyPath.hashValue
    }
    #endif

    @inlinable
    func validate() throws {
        do {
            try parent.validate()
        } catch var error as ValidationError {
            error.setKey(errorKey)
            throw error
        } catch var errors as ValidationErrors {
            for index in errors.indices where errors[index].key == nil {
                errors[index].setKey(errorKey)
            }
            throw errors
        } catch {
            preconditionFailure("Unknown error: \(error)")
        }
    }
}
import RegexBuilder

func f() {
    Format(of: "productCode", with: #/\A[a-zA-Z\d]+\z/#)
    Format(of: "") {
        Anchor.startOfSubject
        OneOrMore {
            CharacterClass(
                ("a"..."z"),
                ("A"..."Z"),
                .digit
            )
        }
        Anchor.endOfSubject
    }

    let predefinedRegex = Regex {
        Anchor.startOfSubject
        OneOrMore {
            CharacterClass(
                ("a"..."z"),
                ("A"..."Z"),
                .digit
            )
        }
        Anchor.endOfSubject
    }
    Format(of: "", with: predefinedRegex)

    Confirmation(of: "", matching: "")
        .presence(.required)
        .presence(.required(allowsNil: true))
        .presence(.required(allowsEmpty: true))
    Comparison(3, .greaterThanOrEqualTo(2))

    let currentVersion = [5, 10, 0]
    let requiredVersion = [6, 0, 0]
    Comparison(currentVersion, .greaterThanOrEqualTo(requiredVersion)).isValid // => false

    enum Status {
        case published, draft, secret, reader, editor, admin, root
    }
    let articleStatus = Status.draft
    Inclusion(articleStatus, in: [.published, .secret])

    let permission = Status.admin
    Exclusion(permission, in: [.reader, .editor])

    let age: UInt = 18
    Inclusion(age, in: 16...)
    Exclusion(age, in: ..<16)

    Validate {
        Presence("")
        Count("", within: 0...1000)
    }
    .errorKey("Profile")
}
