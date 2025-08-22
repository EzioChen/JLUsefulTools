//
//  JLEcTaskPromise.swift
//  JLUsefulTools
//
//  Created by EzioChan on 2025/8/22.
//


import UIKit

@objcMembers
public class JLEcTaskPromise<T> {
    public typealias Completion = (T) -> Void
    private var result: T?
    private var callbacks: [Completion] = []
    private var errorHandler: ((Error) -> Void)?

    public init(_ work: (@escaping Completion) -> Void) {
        work { value in
            self.result = value
            DispatchQueue.main.async {
                self.callbacks.forEach { $0(value) }
            }
        }
    }

    @discardableResult
    public func then(_ callback: @escaping Completion) -> JLEcTaskPromise<T> {
        if let result = result {
            DispatchQueue.main.async {
                callback(result)
            }
        } else {
            callbacks.append(callback)
        }
        return self
    }

    @discardableResult
    public func then<U>(_ transform: @escaping (T) throws -> JLEcTaskPromise<U>) -> JLEcTaskPromise<U> {
        return JLEcTaskPromise<U> { fulfill in
            self.then { value in
                do {
                    let nextPromise = try transform(value)
                    nextPromise.then { nextValue in
                        fulfill(nextValue)
                    }
                } catch {
                    self.reject(error)
                }
            }
        }
    }

    @discardableResult
    public func `catch`(_ handler: @escaping (Error) -> Void) -> Self {
        errorHandler = handler
        return self
    }

    private func reject(_ error: Error) {
        DispatchQueue.main.async {
            self.errorHandler?(error)
        }
    }
}

