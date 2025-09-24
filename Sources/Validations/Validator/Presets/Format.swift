import RegexBuilder

public struct Format: Validator, PresenceValidatable {
    public var value: String?

    @usableFromInline
    var regex: Regex<AnyRegexOutput>

    public var presenceOption: PresenceOption = .required

    @inlinable
    public init<O>(of value: (some StringProtocol)?, with regex: Regex<O>) {
        self.value = value.map(String.init(_:))
        self.regex = Regex(regex)
    }

    @inlinable
    public init<O>(of value: (some StringProtocol)?, @RegexComponentBuilder _ builder: () -> some RegexComponent<O>) {
        self.init(of: value, with: Regex(builder))
    }

    @inlinable
    public func validate() throws {
        guard let presenceValue = try validatePresence(resolvingErrorWithReasons: .format) else {
            return
        }

        if !presenceValue.contains(regex) {
            throw ValidationError(reasons: .count)
        }
    }
}
