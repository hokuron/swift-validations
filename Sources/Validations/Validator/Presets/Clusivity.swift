public enum _Clusivity {
    public protocol Member<Element> {
        associatedtype Element: Equatable
        func contains(_ other: some Collection<Element>) -> Bool
    }

    public struct CollectionMember<Base: Collection>: Member where Base.Element: Equatable {
        public typealias Element = Base.Element

        @usableFromInline
        var base: Base

        @usableFromInline
        init(base: Base) {
            self.base = base
        }

        @inlinable
        @inline(__always)
        public func contains(_ other: some Collection<Element>) -> Bool {
            base.contains(other)
        }
    }

    public struct RangeMember<Base: RangeExpression>: Member where Base.Bound: Comparable {
        public typealias Element = Base.Bound

        @usableFromInline
        var base: Base

        @usableFromInline
        init(base: Base) {
            self.base = base
        }

        @inlinable
        @inline(__always)
        public func contains(_ other: some Collection<Element>) -> Bool {
            other.allSatisfy(base.contains(_:))
        }
    }
}

extension _Clusivity.Member {
    @usableFromInline
    func contains(_ element: Element) -> Bool {
        contains(CollectionOfOne(element))
    }
}

extension _Clusivity.CollectionMember: Sendable where Base: Sendable {}
extension _Clusivity.CollectionMember: Equatable where Base: Equatable {}
extension _Clusivity.CollectionMember: Hashable where Base: Hashable {}

extension _Clusivity.RangeMember: Sendable where Base: Sendable {}
extension _Clusivity.RangeMember: Equatable where Base: Equatable {}
extension _Clusivity.RangeMember: Hashable where Base: Hashable {}
