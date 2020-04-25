//
//  OrderBy.swift
//  CoreStore
//
//  Copyright © 2018 John Rommel Estropia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import CoreData


// MARK: - OrderBy

/**
 The `OrderBy` clause specifies the sort order for results for a fetch or a query.
 */
public struct OrderBy<D: DynamicObject>: OrderByClause, FetchClause, QueryClause, DeleteClause, Hashable {
    
    /**
     Combines two `OrderBy` sort descriptors together
     */
    public static func + (left: OrderBy, right: OrderBy) -> OrderBy {
        
        return OrderBy(left.sortDescriptors + right.sortDescriptors)
    }
    
    /**
     Combines two `OrderBy` sort descriptors together and stores the result to the left operand
     */
    public static func += (left: inout OrderBy, right: OrderBy) {
        
        left = left + right
    }
    
    /**
     Initializes a `OrderBy` clause with an empty list of sort descriptors
     */
    public init() {
        
        self.init([NSSortDescriptor]())
    }
    
    /**
     Initializes a `OrderBy` clause with a single sort descriptor
     
     - parameter sortDescriptor: a `NSSortDescriptor`
     */
    public init(_ sortDescriptor: NSSortDescriptor) {
        
        self.init([sortDescriptor])
    }
    
    /**
     Initializes a `OrderBy` clause with a list of sort descriptors
     
     - parameter sortDescriptors: a series of `NSSortDescriptor`s
     */
    public init(_ sortDescriptors: [NSSortDescriptor]) {
        
        self.sortDescriptors = sortDescriptors
    }
    
    /**
     Initializes a `OrderBy` clause with a series of `SortKey`s
     
     - parameter sortKey: a series of `SortKey`s
     */
    public init(_ sortKeys: [SortKey]) {
        
        self.init(sortKeys.map({ $0.descriptor }))
    }
    
    /**
     Initializes a `OrderBy` clause with a series of `SortKey`s
     
     - parameter sortKey: a single `SortKey`
     - parameter sortKeys: a series of `SortKey`s
     */
    public init(_ sortKey: SortKey, _ sortKeys: SortKey...) {
        
        self.init([sortKey] + sortKeys)
    }
    
    
    // MARK: OrderByClause
    
    public typealias ObjectType = D
    
    public let sortDescriptors: [NSSortDescriptor]
    
    
    // MARK: FetchClause, QueryClause, DeleteClause
    
    public func applyToFetchRequest<ResultType>(_ fetchRequest: NSFetchRequest<ResultType>) {
        
        if let sortDescriptors = fetchRequest.sortDescriptors, sortDescriptors != self.sortDescriptors {
            
            CoreStore.log(
                .warning,
                message: "Existing sortDescriptors for the \(cs_typeName(fetchRequest)) was overwritten by \(cs_typeName(self)) query clause."
            )
        }
        
        fetchRequest.sortDescriptors = self.sortDescriptors
    }
    
    
    // MARK: Equatable
    
    public static func == (lhs: OrderBy, rhs: OrderBy) -> Bool {
        
        return lhs.sortDescriptors == rhs.sortDescriptors
    }
    
    
    // MARK: Hashable

    public func hash(into hasher: inout Hasher) {

        hasher.combine(self.sortDescriptors)
    }
    
    
    // MARK: - SortKey
    
    /**
     The `SortKey` is passed to the `OrderBy` clause to indicate the sort keys and their sort direction.
     */
    public struct SortKey {
        
        // MARK: Raw Key Paths
        
        /**
         Indicates that the `KeyPathString` should be sorted in ascending order
         */
        public static func ascending(_ keyPath: KeyPathString) -> SortKey {
            
            return SortKey(descriptor: .init(key: keyPath, ascending: true))
        }
        
        /**
         Indicates that the `KeyPathString` should be sorted in descending order
         */
        public static func descending(_ keyPath: KeyPathString) -> SortKey {
            
            return SortKey(descriptor: .init(key: keyPath, ascending: false))
        }
        
        
        // MARK: NSManagedObject Key Paths
        
        /**
         Indicates that the `KeyPathString` should be sorted in ascending order
         */
        public static func ascending<T>(_ keyPath: KeyPath<D, T>) -> SortKey where D: NSManagedObject {
            
            return .ascending(keyPath._kvcKeyPathString!)
        }
        
        /**
         Indicates that the `KeyPathString` should be sorted in descending order
         */
        public static func descending<T>(_ keyPath: KeyPath<D, T>) -> SortKey where D: NSManagedObject {
            
            return .descending(keyPath._kvcKeyPathString!)
        }
        
        
        // MARK: CoreStoreObject Key Paths
        
        /**
         Indicates that the `KeyPathString` should be sorted in ascending order
         */
        public static func ascending<T>(_ attribute: KeyPath<D, ValueContainer<D>.Required<T>>) -> SortKey {
            
            return .ascending(D.meta[keyPath: attribute].keyPath)
        }
        
        /**
         Indicates that the `KeyPathString` should be sorted in ascending order
         */
        public static func ascending<T>(_ attribute: KeyPath<D, ValueContainer<D>.Optional<T>>) -> SortKey {
            
            return .ascending(D.meta[keyPath: attribute].keyPath)
        }
        
        /**
         Indicates that the `KeyPathString` should be sorted in ascending order
         */
        public static func ascending<T>(_ attribute: KeyPath<D, TransformableContainer<D>.Required<T>>) -> SortKey {
            
            return .ascending(D.meta[keyPath: attribute].keyPath)
        }
        
        /**
         Indicates that the `KeyPathString` should be sorted in ascending order
         */
        public static func ascending<T>(_ attribute: KeyPath<D, TransformableContainer<D>.Optional<T>>) -> SortKey {
            
            return .ascending(D.meta[keyPath: attribute].keyPath)
        }
        
        /**
         Indicates that the `KeyPathString` should be sorted in descending order
         */
        public static func descending<T>(_ attribute: KeyPath<D, ValueContainer<D>.Required<T>>) -> SortKey {
            
            return .descending(D.meta[keyPath: attribute].keyPath)
        }
        
        /**
         Indicates that the `KeyPathString` should be sorted in descending order
         */
        public static func descending<T>(_ attribute: KeyPath<D, ValueContainer<D>.Optional<T>>) -> SortKey {
            
            return .descending(D.meta[keyPath: attribute].keyPath)
        }
        
        /**
         Indicates that the `KeyPathString` should be sorted in descending order
         */
        public static func descending<T>(_ attribute: KeyPath<D, TransformableContainer<D>.Required<T>>) -> SortKey {
            
            return .descending(D.meta[keyPath: attribute].keyPath)
        }
        
        /**
         Indicates that the `KeyPathString` should be sorted in descending order
         */
        public static func descending<T>(_ attribute: KeyPath<D, TransformableContainer<D>.Optional<T>>) -> SortKey {
            
            return .descending(D.meta[keyPath: attribute].keyPath)
        }
        
        
        // MARK: Private
        
        fileprivate let descriptor: NSSortDescriptor
    }
}


// MARK: - OrderBy.SortKey where D: CoreStoreObject

extension OrderBy.SortKey where D: CoreStoreObject {
    
    /**
     Indicates that the `KeyPathString` should be sorted in ascending order
     */
    public static func ascending<K: KeyPathStringConvertible>(_ attribute: (D) -> K) -> OrderBy<D>.SortKey {
        
        return .ascending(attribute(D.meta).cs_keyPathString)
    }
    
    /**
     Indicates that the `KeyPathString` should be sorted in descending order
     */
    public static func descending<K: KeyPathStringConvertible>(_ attribute: (D) -> K) -> OrderBy<D>.SortKey {
        
        return .descending(attribute(D.meta).cs_keyPathString)
    }
}


// MARK: - OrderByClause

/**
 Abstracts the `OrderBy` clause for protocol utilities.
 */
public protocol OrderByClause {
    
    /**
     The `DynamicObject` type associated with the clause
     */
    associatedtype ObjectType: DynamicObject
    
    /**
     The `NSSortDescriptor` array for the fetch or query
     */
    var sortDescriptors: [NSSortDescriptor] { get }
}


// MARK: - Sequence where Iterator.Element: OrderByClause

extension Sequence where Iterator.Element: OrderByClause {
    
    /**
     Combines multiple `OrderBy` predicates together
     */
    public func combined() -> OrderBy<Iterator.Element.ObjectType> {
        
        return OrderBy(self.flatMap({ $0.sortDescriptors }))
    }
}
