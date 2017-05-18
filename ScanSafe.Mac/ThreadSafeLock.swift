//
//  ThreadSafeLock.swift
//  ScanSafe.Mac
//
//  Created by Сергей Житинский on 11.05.17.
//  Copyright © 2017 Git in Sky. All rights reserved.
//

import Cocoa

protocol ReadWriteLock {
    // Get a shared reader lock, run the given block, unlock, and return
    // whatever the block returned
    mutating func withReadLock<T>(block: () -> T) -> T
    
    // Get an exclusive writer lock, run the given block, unlock, and
    // return whatever the block returned
    mutating func withWriteLock<T>(block: () -> T) -> T
}

// Protector holds onto an item of type T, and only allows access to it
// from within a "lock block"

class Lock: ReadWriteLock {
    init () {
    
    }
    mutating func withReadLock<T>(block: () -> T) -> T {
        
    }
    mutating func withWriteLock<T>(block: () -> T) -> T {
        
    }
    
}


class Protector<T> {
    private var lock: ReadWriteLock = Lock()
    private var item: T
    
    // initialize an instance with an item
    init(_ item: T) {
        self.item = item
    }
    
    // give read access to "item" to the given block, returning whatever
    // that block returns
    func withReadLock<U>(block: (T) -> U) -> U {
        return lock.withReadLock { [unowned self] in
            return block(self.item)
        }
    }
    
    // give write access to "item" to the given block, returning whatever
    // that block returns
    func withWriteLock<U>(block: (inout T) -> U) -> U {
        return lock.withWriteLock { [unowned self] in
            return block(&self.item)
        }
    }
}

// Let's define a struct to hold our protected data. This should probably
// be embedded inside ArrayTracker, but that doesn't build in Beta 4.
private struct Protected<T> {
    var lastModified: NSDate?
    var things: [T] = []
    
    init() {
    }
}

class ArrayTracker<T> {
    // Put an instance of our protected data inside a Protector
    private let protector = Protector(Protected<T>())
    // ... other properties, but no longer "lock", "lastModified",
    // or "things"
    
    func lastModifiedDate() -> NSDate? {
        return protector.withReadLock { protected in
            return protected.lastModified
        }
    }
    
    func appendToThings(item: T) -> (NSDate, Int) {
        return protector.withWriteLock { protected in
            protected.things.append(item)
            protected.lastModified = NSDate.date()
            return (protected.lastModified!, protected.things.count)
        }
    }
    // ... rest of class
}
