extension Swift.Optional: Validator where Wrapped: Validator {
    @inlinable
    public func validate() throws {
        if case .some(let wrapped) = self {
            try wrapped.validate()
        }
    }
}
