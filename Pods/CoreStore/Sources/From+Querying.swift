//
//  From+Querying.swift
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


// MARK: - From

extension From {
    
    /**
     Creates a `FetchChainBuilder` that starts with the specified `Where` clause
     
     - parameter clause: the `Where` clause to create a `FetchChainBuilder` with
     - returns: a `FetchChainBuilder` that starts with the specified `Where` clause
     */
    public func `where`(_ clause: Where<D>) -> FetchChainBuilder<D> {
        
        return self.fetchChain(appending: clause)
    }
    
    /**
     Creates a `FetchChainBuilder` with a predicate using the specified string format and arguments
     
     - parameter format: the format string for the predicate
     - parameter args: the arguments for `format`
     - returns: a `FetchChainBuilder` with a predicate using the specified string format and arguments
     */
    public func `where`(format: String, _ args: Any...) -> FetchChainBuilder<D> {
        
        return self.fetchChain(appending: Where<D>(format, argumentArray: args))
    }
    
    /**
     Creates a `FetchChainBuilder` with a predicate using the specified string format and arguments
     
     - parameter format: the format string for the predicate
     - parameter argumentArray: the arguments for `format`
     - returns: a `FetchChainBuilder` with a predicate using the specified string format and arguments
     */
    public func `where`(format: String, argumentArray: [Any]?) -> FetchChainBuilder<D> {
        
        return self.fetchChain(appending: Where<D>(format, argumentArray: argumentArray))
    }

    /**
     Creates a `FetchChainBuilder` that starts with the specified `OrderBy` clause.

     - parameter clause: the `OrderBy` clause to create a `FetchChainBuilder` with
     - returns: a `FetchChainBuilder` that starts with the specified `OrderBy` clause
     */
    public func orderBy(_ clause: OrderBy<D>) -> FetchChainBuilder<D> {

        return self.fetchChain(appending: clause)
    }
    
    /**
     Creates a `FetchChainBuilder` with a series of `SortKey`s
     
     - parameter sortKey: a single `SortKey`
     - parameter sortKeys: a series of other `SortKey`s
     - returns: a `FetchChainBuilder` with a series of `SortKey`s
     */
    public func orderBy(_ sortKey: OrderBy<D>.SortKey, _ sortKeys: OrderBy<D>.SortKey...) -> FetchChainBuilder<D> {
        
        return self.fetchChain(appending: OrderBy<D>([sortKey] + sortKeys))
    }

    /**
     Creates a `FetchChainBuilder` with a series of `SortKey`s

     - parameter sortKeys: a series of `SortKey`s
     - returns: a `FetchChainBuilder` with a series of `SortKey`s
     */
    public func orderBy(_ sortKeys: [OrderBy<D>.SortKey]) -> FetchChainBuilder<D> {

        return self.fetchChain(appending: OrderBy<D>(sortKeys))
    }
    
    /**
     Creates a `FetchChainBuilder` with a closure where the `NSFetchRequest` may be configured
     
     - parameter fetchRequest: the block to customize the `NSFetchRequest`
     - returns: a `FetchChainBuilder` with closure where the `NSFetchRequest` may be configured
     */
    public func tweak(_ fetchRequest: @escaping (NSFetchRequest<NSFetchRequestResult>) -> Void) -> FetchChainBuilder<D> {
        
        return self.fetchChain(appending: Tweak(fetchRequest))
    }
    
    /**
     Creates a `FetchChainBuilder` and immediately appending a `FetchClause`
     
     - parameter clause: the `FetchClause` to add to the `FetchChainBuilder`
     - returns: a `FetchChainBuilder` containing the specified `FetchClause`
     */
    public func appending(_ clause: FetchClause) -> FetchChainBuilder<D> {
        
        return self.fetchChain(appending: clause)
    }
    
    /**
     Creates a `FetchChainBuilder` and immediately appending a series of `FetchClause`s
     
     - parameter clauses: the `FetchClause`s to add to the `FetchChainBuilder`
     - returns: a `FetchChainBuilder` containing the specified `FetchClause`s
     */
    public func appending<S: Sequence>(contentsOf clauses: S) -> FetchChainBuilder<D> where S.Element == FetchClause {
        
        return self.fetchChain(appending: clauses)
    }
    
    /**
     Creates a `QueryChainBuilder` that starts with the specified `Select` clause
     
     - parameter clause: the `Select` clause to create a `QueryChainBuilder` with
     - returns: a `QueryChainBuilder` that starts with the specified `Select` clause
     */
    public func select<R>(_ clause: Select<D, R>) -> QueryChainBuilder<D, R> {
        
        return .init(
            from: self,
            select: clause,
            queryClauses: []
        )
    }
    
    /**
     Creates a `QueryChainBuilder` that starts with a `Select` clause created from the specified `SelectTerm`s
     
     - parameter resultType: the generic `SelectResultType` for the `Select` clause
     - parameter selectTerm: a `SelectTerm`
     - parameter selectTerms: a series of `SelectTerm`s
     - returns: a `QueryChainBuilder` that starts with a `Select` clause created from the specified `SelectTerm`s
     */
    public func select<R>(_ resultType: R.Type, _ selectTerm: SelectTerm<D>, _ selectTerms: SelectTerm<D>...) -> QueryChainBuilder<D, R> {
        
        return self.select(resultType, [selectTerm] + selectTerms)
    }
    
    /**
     Creates a `QueryChainBuilder` that starts with a `Select` clause created from the specified `SelectTerm`s
     
     - parameter resultType: the generic `SelectResultType` for the `Select` clause
     - parameter selectTerms: a series of `SelectTerm`s
     - returns: a `QueryChainBuilder` that starts with a `Select` clause created from the specified `SelectTerm`s
     */
    public func select<R>(_ resultType: R.Type, _ selectTerms: [SelectTerm<D>]) -> QueryChainBuilder<D, R> {
        
        return .init(
            from: self,
            select: .init(selectTerms),
            queryClauses: []
        )
    }
    
    /**
     Creates a `SectionMonitorChainBuilder` that starts with the `SectionBy` to use to group `ListMonitor` objects into sections
     
     - parameter clause: the `SectionBy` to be used by the `ListMonitor`
     - returns: a `SectionMonitorChainBuilder` that is sectioned by the specified key path
     */
    @available(macOS 10.12, *)
    public func sectionBy(_ clause: SectionBy<D>) -> SectionMonitorChainBuilder<D> {
        
        return .init(
            from: self,
            sectionBy: clause,
            fetchClauses: []
        )
    }
    
    /**
     Creates a `SectionMonitorChainBuilder` with the key path to use to group `ListMonitor` objects into sections
     
     - parameter sectionKeyPath: the key path to use to group the objects into sections
     - returns: a `SectionMonitorChainBuilder` that is sectioned by the specified key path
     */
    @available(macOS 10.12, *)
    public func sectionBy(_ sectionKeyPath: KeyPathString) -> SectionMonitorChainBuilder<D> {
        
        return self.sectionBy(sectionKeyPath, { $0 })
    }
    
    /**
     Creates a `SectionMonitorChainBuilder` with the key path to use to group `ListMonitor` objects into sections, and a closure to transform the value for the key path to an appropriate section name
     
     - Important: Some utilities (such as `ListMonitor`s) may keep `SectionBy`s in memory and may thus introduce retain cycles if reference captures are not handled properly.
     - parameter sectionKeyPath: the key path to use to group the objects into sections
     - parameter sectionIndexTransformer: a closure to transform the value for the key path to an appropriate section name
     - returns: a `SectionMonitorChainBuilder` that is sectioned by the specified key path
     */
    @available(macOS 10.12, *)
    public func sectionBy(_ sectionKeyPath: KeyPathString, _ sectionIndexTransformer: @escaping (_ sectionName: String?) -> String?) -> SectionMonitorChainBuilder<D> {
        
        return .init(
            from: self,
            sectionBy: .init(sectionKeyPath, sectionIndexTransformer),
            fetchClauses: []
        )
    }
    
    
    // MARK: Private
    
    private func fetchChain(appending clause: FetchClause) -> FetchChainBuilder<D> {
        
        return .init(from: self, fetchClauses: [clause])
    }
    
    private func fetchChain<S: Sequence>(appending clauses: S) -> FetchChainBuilder<D> where S.Element == FetchClause {
        
        return .init(from: self, fetchClauses: Array(clauses))
    }
}


// MARK: - From where D: NSManagedObject

extension From where D: NSManagedObject {
    
    /**
     Creates a `QueryChainBuilder` that starts with a `Select` clause created from the specified key path
     
     - parameter keyPath: the keyPath to query the value for
     - returns: a `QueryChainBuilder` that starts with a `Select` clause created from the specified key path
     */
    public func select<R>(_ keyPath: KeyPath<D, R>) -> QueryChainBuilder<D, R> {
        
        return self.select(R.self, [SelectTerm<D>.attribute(keyPath)])
    }
    
    /**
     Creates a `SectionMonitorChainBuilder` with the key path to use to group `ListMonitor` objects into sections
     
     - parameter sectionKeyPath: the `KeyPath` to use to group the objects into sections
     - returns: a `SectionMonitorChainBuilder` that is sectioned by the specified key path
     */
    @available(macOS 10.12, *)
    public func sectionBy<T>(_ sectionKeyPath: KeyPath<D, T>) -> SectionMonitorChainBuilder<D> {
        
        return self.sectionBy(sectionKeyPath._kvcKeyPathString!, { $0 })
    }
    
    /**
     Creates a `SectionMonitorChainBuilder` with the key path to use to group `ListMonitor` objects into sections, and a closure to transform the value for the key path to an appropriate section name
     
     - Important: Some utilities (such as `ListMonitor`s) may keep `SectionBy`s in memory and may thus introduce retain cycles if reference captures are not handled properly.
     - parameter sectionKeyPath: the `KeyPath` to use to group the objects into sections
     - parameter sectionIndexTransformer: a closure to transform the value for the key path to an appropriate section name
     - returns: a `SectionMonitorChainBuilder` that is sectioned by the specified key path
     */
    @available(macOS 10.12, *)
    public func sectionBy<T>(_ sectionKeyPath: KeyPath<D, T>, _ sectionIndexTransformer: @escaping (_ sectionName: String?) -> String?) -> SectionMonitorChainBuilder<D> {
        
        return self.sectionBy(sectionKeyPath._kvcKeyPathString!, sectionIndexTransformer)
    }
}


// MARK: - From where D: CoreStoreObject

extension From where D: CoreStoreObject {
    
    /**
     Creates a `FetchChainBuilder` that starts with the specified `Where` clause
     
     - parameter clause: a closure that returns a `Where` clause
     - returns: a `FetchChainBuilder` that starts with the specified `Where` clause
     */
    public func `where`<T: AnyWhereClause>(_ clause: (D) -> T) -> FetchChainBuilder<D> {
        
        return self.fetchChain(appending: clause(D.meta))
    }

    public func `where`(combinedByAnd clause: Where<D>, _ others: Where<D>...) -> FetchChainBuilder<D> {

        return self.fetchChain(appending: ([clause] + others).combinedByAnd())
    }
    
    /**
     Creates a `QueryChainBuilder` that starts with a `Select` clause created from the specified key path
     
     - parameter keyPath: the keyPath to query the value for
     - returns: a `QueryChainBuilder` that starts with a `Select` clause created from the specified key path
     */
    public func select<R>(_ keyPath: KeyPath<D, ValueContainer<D>.Required<R>>) -> QueryChainBuilder<D, R> {
        
        return self.select(R.self, [SelectTerm<D>.attribute(keyPath)])
    }
    
    /**
     Creates a `QueryChainBuilder` that starts with a `Select` clause created from the specified key path
     
     - parameter keyPath: the keyPath to query the value for
     - returns: a `QueryChainBuilder` that starts with a `Select` clause created from the specified key path
     */
    public func select<R>(_ keyPath: KeyPath<D, ValueContainer<D>.Optional<R>>) -> QueryChainBuilder<D, R> {
        
        return self.select(R.self, [SelectTerm<D>.attribute(keyPath)])
    }
    
    /**
     Creates a `QueryChainBuilder` that starts with a `Select` clause created from the specified key path
     
     - parameter keyPath: the keyPath to query the value for
     - returns: a `QueryChainBuilder` that starts with a `Select` clause created from the specified key path
     */
    public func select<R>(_ keyPath: KeyPath<D, TransformableContainer<D>.Required<R>>) -> QueryChainBuilder<D, R> {
        
        return self.select(R.self, [SelectTerm<D>.attribute(keyPath)])
    }
    
    /**
     Creates a `QueryChainBuilder` that starts with a `Select` clause created from the specified key path
     
     - parameter keyPath: the keyPath to query the value for
     - returns: a `QueryChainBuilder` that starts with a `Select` clause created from the specified key path
     */
    public func select<R>(_ keyPath: KeyPath<D, TransformableContainer<D>.Optional<R>>) -> QueryChainBuilder<D, R> {
        
        return self.select(R.self, [SelectTerm<D>.attribute(keyPath)])
    }
    
    /**
     Creates a `SectionMonitorChainBuilder` with the key path to use to group `ListMonitor` objects into sections
     
     - parameter sectionKeyPath: the `KeyPath` to use to group the objects into sections
     - returns: a `SectionMonitorChainBuilder` that is sectioned by the specified key path
     */
    @available(macOS 10.12, *)
    public func sectionBy<T>(_ sectionKeyPath: KeyPath<D, ValueContainer<D>.Required<T>>) -> SectionMonitorChainBuilder<D> {
        
        return self.sectionBy(D.meta[keyPath: sectionKeyPath].keyPath, { $0 })
    }
    
    /**
     Creates a `SectionMonitorChainBuilder` with the key path to use to group `ListMonitor` objects into sections
     
     - parameter sectionKeyPath: the `KeyPath` to use to group the objects into sections
     - returns: a `SectionMonitorChainBuilder` that is sectioned by the specified key path
     */
    @available(macOS 10.12, *)
    public func sectionBy<T>(_ sectionKeyPath: KeyPath<D, ValueContainer<D>.Optional<T>>) -> SectionMonitorChainBuilder<D> {
        
        return self.sectionBy(D.meta[keyPath: sectionKeyPath].keyPath, { $0 })
    }
    
    /**
     Creates a `SectionMonitorChainBuilder` with the key path to use to group `ListMonitor` objects into sections
     
     - parameter sectionKeyPath: the `KeyPath` to use to group the objects into sections
     - returns: a `SectionMonitorChainBuilder` that is sectioned by the specified key path
     */
    @available(macOS 10.12, *)
    public func sectionBy<T>(_ sectionKeyPath: KeyPath<D, TransformableContainer<D>.Required<T>>) -> SectionMonitorChainBuilder<D> {
        
        return self.sectionBy(D.meta[keyPath: sectionKeyPath].keyPath, { $0 })
    }
    
    /**
     Creates a `SectionMonitorChainBuilder` with the key path to use to group `ListMonitor` objects into sections
     
     - parameter sectionKeyPath: the `KeyPath` to use to group the objects into sections
     - returns: a `SectionMonitorChainBuilder` that is sectioned by the specified key path
     */
    @available(macOS 10.12, *)
    public func sectionBy<T>(_ sectionKeyPath: KeyPath<D, TransformableContainer<D>.Optional<T>>) -> SectionMonitorChainBuilder<D> {
        
        return self.sectionBy(D.meta[keyPath: sectionKeyPath].keyPath, { $0 })
    }
    
    /**
     Creates a `SectionMonitorChainBuilder` with the key path to use to group `ListMonitor` objects into sections, and a closure to transform the value for the key path to an appropriate section name
     
     - Important: Some utilities (such as `ListMonitor`s) may keep `SectionBy`s in memory and may thus introduce retain cycles if reference captures are not handled properly.
     - parameter sectionKeyPath: the `KeyPath` to use to group the objects into sections
     - parameter sectionIndexTransformer: a closure to transform the value for the key path to an appropriate section name
     - returns: a `SectionMonitorChainBuilder` that is sectioned by the specified key path
     */
    @available(macOS 10.12, *)
    public func sectionBy<T>(_ sectionKeyPath: KeyPath<D, ValueContainer<D>.Required<T>>, _ sectionIndexTransformer: @escaping (_ sectionName: String?) -> String?) -> SectionMonitorChainBuilder<D> {
        
        return self.sectionBy(D.meta[keyPath: sectionKeyPath].keyPath, sectionIndexTransformer)
    }
    
    /**
     Creates a `SectionMonitorChainBuilder` with the key path to use to group `ListMonitor` objects into sections, and a closure to transform the value for the key path to an appropriate section name
     
     - Important: Some utilities (such as `ListMonitor`s) may keep `SectionBy`s in memory and may thus introduce retain cycles if reference captures are not handled properly.
     - parameter sectionKeyPath: the `KeyPath` to use to group the objects into sections
     - parameter sectionIndexTransformer: a closure to transform the value for the key path to an appropriate section name
     - returns: a `SectionMonitorChainBuilder` that is sectioned by the specified key path
     */
    @available(macOS 10.12, *)
    public func sectionBy<T>(_ sectionKeyPath: KeyPath<D, ValueContainer<D>.Optional<T>>, _ sectionIndexTransformer: @escaping (_ sectionName: String?) -> String?) -> SectionMonitorChainBuilder<D> {
        
        return self.sectionBy(D.meta[keyPath: sectionKeyPath].keyPath, sectionIndexTransformer)
    }
    
    /**
     Creates a `SectionMonitorChainBuilder` with the key path to use to group `ListMonitor` objects into sections, and a closure to transform the value for the key path to an appropriate section name
     
     - Important: Some utilities (such as `ListMonitor`s) may keep `SectionBy`s in memory and may thus introduce retain cycles if reference captures are not handled properly.
     - parameter sectionKeyPath: the `KeyPath` to use to group the objects into sections
     - parameter sectionIndexTransformer: a closure to transform the value for the key path to an appropriate section name
     - returns: a `SectionMonitorChainBuilder` that is sectioned by the specified key path
     */
    @available(macOS 10.12, *)
    public func sectionBy<T>(_ sectionKeyPath: KeyPath<D, TransformableContainer<D>.Required<T>>, _ sectionIndexTransformer: @escaping (_ sectionName: String?) -> String?) -> SectionMonitorChainBuilder<D> {
        
        return self.sectionBy(D.meta[keyPath: sectionKeyPath].keyPath, sectionIndexTransformer)
    }
    
    /**
     Creates a `SectionMonitorChainBuilder` with the key path to use to group `ListMonitor` objects into sections, and a closure to transform the value for the key path to an appropriate section name
     
     - Important: Some utilities (such as `ListMonitor`s) may keep `SectionBy`s in memory and may thus introduce retain cycles if reference captures are not handled properly.
     - parameter sectionKeyPath: the `KeyPath` to use to group the objects into sections
     - parameter sectionIndexTransformer: a closure to transform the value for the key path to an appropriate section name
     - returns: a `SectionMonitorChainBuilder` that is sectioned by the specified key path
     */
    @available(macOS 10.12, *)
    public func sectionBy<T>(_ sectionKeyPath: KeyPath<D, TransformableContainer<D>.Optional<T>>, _ sectionIndexTransformer: @escaping (_ sectionName: String?) -> String?) -> SectionMonitorChainBuilder<D> {
        
        return self.sectionBy(D.meta[keyPath: sectionKeyPath].keyPath, sectionIndexTransformer)
    }
}


// MARK: - FetchChainBuilder

extension FetchChainBuilder {
    
    /**
     Adds a `Where` clause to the `FetchChainBuilder`
     
     - parameter clause: a `Where` clause to add to the fetch builder
     - returns: a new `FetchChainBuilder` containing the `Where` clause
     */
    public func `where`(_ clause: Where<D>) -> FetchChainBuilder<D> {
        
        return self.fetchChain(appending: clause)
    }
    
    /**
     Adds a `Where` clause to the `FetchChainBuilder`
     
     - parameter format: the format string for the predicate
     - parameter args: the arguments for `format`
     - returns: a new `FetchChainBuilder` containing the `Where` clause
     */
    public func `where`(format: String, _ args: Any...) -> FetchChainBuilder<D> {
        
        return self.fetchChain(appending: Where<D>(format, argumentArray: args))
    }
    
    /**
     Adds a `Where` clause to the `FetchChainBuilder`
     
     - parameter format: the format string for the predicate
     - parameter argumentArray: the arguments for `format`
     - returns: a new `FetchChainBuilder` containing the `Where` clause
     */
    public func `where`(format: String, argumentArray: [Any]?) -> FetchChainBuilder<D> {
        
        return self.fetchChain(appending: Where<D>(format, argumentArray: argumentArray))
    }

    /**
     Adds an `OrderBy` clause to the `FetchChainBuilder`

     - parameter clause: the `OrderBy` clause to add
     - returns: a new `FetchChainBuilder` containing the `OrderBy` clause
     */
    public func orderBy(_ clause: OrderBy<D>) -> FetchChainBuilder<D> {

        return self.fetchChain(appending: clause)
    }
    
    /**
     Adds an `OrderBy` clause to the `FetchChainBuilder`
     
     - parameter sortKey: a single `SortKey`
     - parameter sortKeys: a series of other `SortKey`s
     - returns: a new `FetchChainBuilder` containing the `OrderBy` clause
     */
    public func orderBy(_ sortKey: OrderBy<D>.SortKey, _ sortKeys: OrderBy<D>.SortKey...) -> FetchChainBuilder<D> {
        
        return self.fetchChain(appending: OrderBy<D>([sortKey] + sortKeys))
    }

    /**
     Adds an `OrderBy` clause to the `FetchChainBuilder`

     - parameter sortKeys: a series of `SortKey`s
     - returns: a new `FetchChainBuilder` containing the `OrderBy` clause
     */
    public func orderBy(_ sortKeys: [OrderBy<D>.SortKey]) -> FetchChainBuilder<D> {

        return self.fetchChain(appending: OrderBy<D>(sortKeys))
    }
    
    /**
     Adds a `Tweak` clause to the `FetchChainBuilder` with a closure where the `NSFetchRequest` may be configured
     
     - parameter fetchRequest: the block to customize the `NSFetchRequest`
     - returns: a new `FetchChainBuilder` containing the `Tweak` clause
     */
    public func tweak(_ fetchRequest: @escaping (NSFetchRequest<NSFetchRequestResult>) -> Void) -> FetchChainBuilder<D> {
        
        return self.fetchChain(appending: Tweak(fetchRequest))
    }
    
    /**
     Appends a `FetchClause` to the `FetchChainBuilder`
     
     - parameter clause: the `FetchClause` to add to the `FetchChainBuilder`
     - returns: a new `FetchChainBuilder` containing the `FetchClause`
     */
    public func appending(_ clause: FetchClause) -> FetchChainBuilder<D> {
        
        return self.fetchChain(appending: clause)
    }
    
    /**
     Appends a series of `FetchClause`s to the `FetchChainBuilder`
     
     - parameter clauses: the `FetchClause`s to add to the `FetchChainBuilder`
     - returns: a new `FetchChainBuilder` containing the `FetchClause`s
     */
    public func appending<S: Sequence>(contentsOf clauses: S) -> FetchChainBuilder<D> where S.Element == FetchClause {
        
        return self.fetchChain(appending: clauses)
    }
    
    
    // MARK: Private
    
    private func fetchChain(appending clause: FetchClause) -> FetchChainBuilder<D> {
        
        return .init(
            from: self.from,
            fetchClauses: self.fetchClauses + [clause]
        )
    }
    
    private func fetchChain<S: Sequence>(appending clauses: S) -> FetchChainBuilder<D> where S.Element == FetchClause {
        
        return .init(
            from: self.from,
            fetchClauses: self.fetchClauses + Array(clauses)
        )
    }
}


// MARK: - FetchChainBuilder where D: CoreStoreObject

extension FetchChainBuilder where D: CoreStoreObject {
    
    public func `where`<T: AnyWhereClause>(_ clause: (D) -> T) -> FetchChainBuilder<D> {
        
        return self.fetchChain(appending: clause(D.meta))
    }
}


// MARK: - QueryChainBuilder

extension QueryChainBuilder {
    
    /**
     Adds a `Where` clause to the `QueryChainBuilder`
     
     - parameter clause: a `Where` clause to add to the query builder
     - returns: a new `QueryChainBuilder` containing the `Where` clause
     */
    public func `where`(_ clause: Where<D>) -> QueryChainBuilder<D, R> {
        
        return self.queryChain(appending: clause)
    }
    
    /**
     Adds a `Where` clause to the `QueryChainBuilder`
     
     - parameter format: the format string for the predicate
     - parameter args: the arguments for `format`
     - returns: a new `QueryChainBuilder` containing the `Where` clause
     */
    public func `where`(format: String, _ args: Any...) -> QueryChainBuilder<D, R> {
        
        return self.queryChain(appending: Where<D>(format, argumentArray: args))
    }
    
    /**
     Adds a `Where` clause to the `QueryChainBuilder`
     
     - parameter format: the format string for the predicate
     - parameter argumentArray: the arguments for `format`
     - returns: a new `QueryChainBuilder` containing the `Where` clause
     */
    public func `where`(format: String, argumentArray: [Any]?) -> QueryChainBuilder<D, R> {
        
        return self.queryChain(appending: Where<D>(format, argumentArray: argumentArray))
    }

    /**
     Adds an `OrderBy` clause to the `QueryChainBuilder`

     - parameter clause: the `OrderBy` clause to add
     - returns: a new `QueryChainBuilder` containing the `OrderBy` clause
     */
    public func orderBy(_ clause: OrderBy<D>) -> QueryChainBuilder<D, R> {

        return self.queryChain(appending: clause)
    }
    
    /**
     Adds an `OrderBy` clause to the `QueryChainBuilder`
     
     - parameter sortKey: a single `SortKey`
     - parameter sortKeys: a series of other `SortKey`s
     - returns: a new `QueryChainBuilder` containing the `OrderBy` clause
     */
    public func orderBy(_ sortKey: OrderBy<D>.SortKey, _ sortKeys: OrderBy<D>.SortKey...) -> QueryChainBuilder<D, R> {
        
        return self.queryChain(appending: OrderBy<D>([sortKey] + sortKeys))
    }

    /**
     Adds an `OrderBy` clause to the `QueryChainBuild`

     - parameter sortKeys: a series of `SortKey`s
     - returns: a new `QueryChainBuilder` containing the `OrderBy` clause
     */
    public func orderBy(_ sortKeys: [OrderBy<D>.SortKey]) -> QueryChainBuilder<D, R> {

        return self.queryChain(appending: OrderBy<D>(sortKeys))
    }
    
    /**
     Adds a `Tweak` clause to the `QueryChainBuilder` with a closure where the `NSFetchRequest` may be configured
     
     - parameter fetchRequest: the block to customize the `NSFetchRequest`
     - returns: a new `QueryChainBuilder` containing the `Tweak` clause
     */
    public func tweak(_ fetchRequest: @escaping (NSFetchRequest<NSFetchRequestResult>) -> Void) -> QueryChainBuilder<D, R> {
        
        return self.queryChain(appending: Tweak(fetchRequest))
    }
    
    /**
     Adds a `GroupBy` clause to the `QueryChainBuilder`
     
     - parameter clause: a `GroupBy` clause to add to the query builder
     - returns: a new `QueryChainBuilder` containing the `GroupBy` clause
     */
    public func groupBy(_ clause: GroupBy<D>) -> QueryChainBuilder<D, R> {
        
        return self.queryChain(appending: clause)
    }
    
    /**
     Adds a `GroupBy` clause to the `QueryChainBuilder`
     
     - parameter keyPath: a key path to group the query results with
     - parameter keyPaths: other key paths to group the query results with
     - returns: a new `QueryChainBuilder` containing the `GroupBy` clause
     */
    public func groupBy(_ keyPath: KeyPathString, _ keyPaths: KeyPathString...) -> QueryChainBuilder<D, R> {
        
        return self.groupBy(GroupBy<D>([keyPath] + keyPaths))
    }
    
    /**
     Adds a `GroupBy` clause to the `QueryChainBuilder`
     
     - parameter keyPaths: a series of key paths to group the query results with
     - returns: a new `QueryChainBuilder` containing the `GroupBy` clause
     */
    public func groupBy(_ keyPaths: [KeyPathString]) -> QueryChainBuilder<D, R> {
        
        return self.queryChain(appending: GroupBy<D>(keyPaths))
    }
    
    /**
     Appends a `QueryClause` to the `QueryChainBuilder`
     
     - parameter clause: the `QueryClause` to add to the `QueryChainBuilder`
     - returns: a new `QueryChainBuilder` containing the `QueryClause`
     */
    public func appending(_ clause: QueryClause) -> QueryChainBuilder<D, R> {
        
        return self.queryChain(appending: clause)
    }
    
    /**
     Appends a series of `QueryClause`s to the `QueryChainBuilder`
     
     - parameter clauses: the `QueryClause`s to add to the `QueryChainBuilder`
     - returns: a new `QueryChainBuilder` containing the `QueryClause`s
     */
    public func appending<S: Sequence>(contentsOf clauses: S) -> QueryChainBuilder<D, R> where S.Element == QueryClause {
        
        return self.queryChain(appending: clauses)
    }
    
    
    // MARK: Private
    
    private func queryChain(appending clause: QueryClause) -> QueryChainBuilder<D, R> {
        
        return .init(
            from: self.from,
            select: self.select,
            queryClauses: self.queryClauses + [clause]
        )
    }
    
    private func queryChain<S: Sequence>(appending clauses: S) -> QueryChainBuilder<D, R> where S.Element == QueryClause {
        
        return .init(
            from: self.from,
            select: self.select,
            queryClauses: self.queryClauses + Array(clauses)
        )
    }
}


// MARK: - QueryChainBuilder where D: NSManagedObject

extension QueryChainBuilder where D: NSManagedObject {
    
    /**
     Adds a `GroupBy` clause to the `QueryChainBuilder`
     
     - parameter keyPath: a key path to group the query results with
     - returns: a new `QueryChainBuilder` containing the `GroupBy` clause
     */
    public func groupBy<T>(_ keyPath: KeyPath<D, T>) -> QueryChainBuilder<D, R> {
        
        return self.groupBy(GroupBy<D>(keyPath))
    }
}


// MARK: - QueryChainBuilder where D: CoreStoreObject

extension QueryChainBuilder where D: CoreStoreObject {
    
    /**
     Adds a `Where` clause to the `QueryChainBuilder`
     
     - parameter clause: a `Where` clause to add to the query builder
     - returns: a new `QueryChainBuilder` containing the `Where` clause
     */
    public func `where`<T: AnyWhereClause>(_ clause: (D) -> T) -> QueryChainBuilder<D, R> {
        
        return self.queryChain(appending: clause(D.meta))
    }
    
    /**
     Adds a `GroupBy` clause to the `QueryChainBuilder`
     
     - parameter keyPath: a key path to group the query results with
     - returns: a new `QueryChainBuilder` containing the `GroupBy` clause
     */
    public func groupBy<T>(_ keyPath: KeyPath<D, ValueContainer<D>.Required<T>>) -> QueryChainBuilder<D, R> {
        
        return self.groupBy(GroupBy<D>(keyPath))
    }
    
    /**
     Adds a `GroupBy` clause to the `QueryChainBuilder`
     
     - parameter keyPath: a key path to group the query results with
     - returns: a new `QueryChainBuilder` containing the `GroupBy` clause
     */
    public func groupBy<T>(_ keyPath: KeyPath<D, ValueContainer<D>.Optional<T>>) -> QueryChainBuilder<D, R> {
        
        return self.groupBy(GroupBy<D>(keyPath))
    }
    
    /**
     Adds a `GroupBy` clause to the `QueryChainBuilder`
     
     - parameter keyPath: a key path to group the query results with
     - returns: a new `QueryChainBuilder` containing the `GroupBy` clause
     */
    public func groupBy<T>(_ keyPath: KeyPath<D, TransformableContainer<D>.Required<T>>) -> QueryChainBuilder<D, R> {
        
        return self.groupBy(GroupBy<D>(keyPath))
    }
    
    /**
     Adds a `GroupBy` clause to the `QueryChainBuilder`
     
     - parameter keyPath: a key path to group the query results with
     - returns: a new `QueryChainBuilder` containing the `GroupBy` clause
     */
    public func groupBy<T>(_ keyPath: KeyPath<D, TransformableContainer<D>.Optional<T>>) -> QueryChainBuilder<D, R> {
        
        return self.groupBy(GroupBy<D>(keyPath))
    }
}


// MARK: - SectionMonitorChainBuilder

@available(macOS 10.12, *)
extension SectionMonitorChainBuilder {
    
    /**
     Adds a `Where` clause to the `SectionMonitorChainBuilder`
     
     - parameter clause: a `Where` clause to add to the fetch builder
     - returns: a new `SectionMonitorChainBuilder` containing the `Where` clause
     */
    public func `where`(_ clause: Where<D>) -> SectionMonitorChainBuilder<D> {
        
        return self.sectionMonitorChain(appending: clause)
    }
    
    /**
     Adds a `Where` clause to the `SectionMonitorChainBuilder`
     
     - parameter format: the format string for the predicate
     - parameter args: the arguments for `format`
     - returns: a new `SectionMonitorChainBuilder` containing the `Where` clause
     */
    public func `where`(format: String, _ args: Any...) -> SectionMonitorChainBuilder<D> {
        
        return self.sectionMonitorChain(appending: Where<D>(format, argumentArray: args))
    }
    
    /**
     Adds a `Where` clause to the `SectionMonitorChainBuilder`
     
     - parameter format: the format string for the predicate
     - parameter argumentArray: the arguments for `format`
     - returns: a new `SectionMonitorChainBuilder` containing the `Where` clause
     */
    public func `where`(format: String, argumentArray: [Any]?) -> SectionMonitorChainBuilder<D> {
        
        return self.sectionMonitorChain(appending: Where<D>(format, argumentArray: argumentArray))
    }

    /**
     Adds an `OrderBy` clause to the `SectionMonitorChainBuilder`

     - parameter clause: the `OrderBy` clause to add
     - returns: a new `SectionMonitorChainBuilder` containing the `OrderBy` clause
     */
    public func orderBy(_ clause: OrderBy<D>) -> SectionMonitorChainBuilder<D> {

        return self.sectionMonitorChain(appending: clause)
    }
    
    /**
     Adds an `OrderBy` clause to the `SectionMonitorChainBuilder`
     
     - parameter sortKey: a single `SortKey`
     - parameter sortKeys: a series of other `SortKey`s
     - returns: a new `SectionMonitorChainBuilder` containing the `OrderBy` clause
     */
    public func orderBy(_ sortKey: OrderBy<D>.SortKey, _ sortKeys: OrderBy<D>.SortKey...) -> SectionMonitorChainBuilder<D> {
        
        return self.sectionMonitorChain(appending: OrderBy<D>([sortKey] + sortKeys))
    }

    /**
     Adds an `OrderBy` clause to the `SectionMonitorChainBuilder`

     - parameter sortKeys: a series of `SortKey`s
     - returns: a new `SectionMonitorChainBuilder` containing the `OrderBy` clause
     */
    public func orderBy(_ sortKeys: [OrderBy<D>.SortKey]) -> SectionMonitorChainBuilder<D> {

        return self.sectionMonitorChain(appending: OrderBy<D>(sortKeys))
    }
    
    /**
     Adds a `Tweak` clause to the `SectionMonitorChainBuilder` with a closure where the `NSFetchRequest` may be configured
     
     - parameter fetchRequest: the block to customize the `NSFetchRequest`
     - returns: a new `SectionMonitorChainBuilder` containing the `Tweak` clause
     */
    public func tweak(_ fetchRequest: @escaping (NSFetchRequest<NSFetchRequestResult>) -> Void) -> SectionMonitorChainBuilder<D> {
        
        return self.sectionMonitorChain(appending: Tweak(fetchRequest))
    }
    
    /**
     Appends a `QueryClause` to the `SectionMonitorChainBuilder`
     
     - parameter clause: the `QueryClause` to add to the `SectionMonitorChainBuilder`
     - returns: a new `SectionMonitorChainBuilder` containing the `QueryClause`
     */
    public func appending(_ clause: FetchClause) -> SectionMonitorChainBuilder<D> {
        
        return self.sectionMonitorChain(appending: clause)
    }
    
    /**
     Appends a series of `QueryClause`s to the `SectionMonitorChainBuilder`
     
     - parameter clauses: the `QueryClause`s to add to the `SectionMonitorChainBuilder`
     - returns: a new `SectionMonitorChainBuilder` containing the `QueryClause`s
     */
    public func appending<S: Sequence>(contentsOf clauses: S) -> SectionMonitorChainBuilder<D> where S.Element == FetchClause {
        
        return self.sectionMonitorChain(appending: clauses)
    }
    
    
    // MARK: Private
    
    private func sectionMonitorChain(appending clause: FetchClause) -> SectionMonitorChainBuilder<D> {
        
        return .init(
            from: self.from,
            sectionBy: self.sectionBy,
            fetchClauses: self.fetchClauses + [clause]
        )
    }
    
    private func sectionMonitorChain<S: Sequence>(appending clauses: S) -> SectionMonitorChainBuilder<D> where S.Element == FetchClause {
        
        return .init(
            from: self.from,
            sectionBy: self.sectionBy,
            fetchClauses: self.fetchClauses + Array(clauses)
        )
    }
}


// MARK: - SectionMonitorChainBuilder where D: CoreStoreObject

@available(macOS 10.12, *)
extension SectionMonitorChainBuilder where D: CoreStoreObject {
    
    /**
     Adds a `Where` clause to the `SectionMonitorChainBuilder`
     
     - parameter clause: a `Where` clause to add to the fetch builder
     - returns: a new `SectionMonitorChainBuilder` containing the `Where` clause
     */
    public func `where`<T: AnyWhereClause>(_ clause: (D) -> T) -> SectionMonitorChainBuilder<D> {
        
        return self.sectionMonitorChain(appending: clause(D.meta))
    }
}
