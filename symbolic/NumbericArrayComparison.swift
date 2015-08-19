//
//  NumbericArrayComparison.swift
//  symbolic
//
//  Created by jazzon on 15/8/18.
//  Copyright © 2015年 jazzon. All rights reserved.
//

import Foundation

func <(lhs: [Int], rhs: [Int]) -> Bool {
    if lhs.count < rhs.count {
        return true
    }
    else if lhs.count > rhs.count {
        return false
    }
    else {
        return Array(zip(lhs, rhs)).map({ (t: (Int, Int)) in t.0 < t.1}).reduce(false, combine: { $0 || $1 })
    }
}

func <=(lhs: [Int], rhs: [Int]) -> Bool {
    return (lhs < rhs) || (lhs == rhs)
}

func >(lhs: [Int], rhs: [Int]) -> Bool {
    return !(lhs <= rhs)
}

func >=(lhs: [Int], rhs: [Int]) -> Bool {
    return !(lhs < rhs)
}

// =========================Real 数组========================= //

func <(lhs: [Real], rhs: [Real]) -> Bool {
    if lhs.count < rhs.count {
        return true
    }
    else if lhs.count > rhs.count {
        return false
    }
    else {
        return Array(zip(lhs, rhs)).map({ (t: (Real, Real)) in t.0 < t.1}).reduce(false, combine: { $0 || $1 })
    }
}

func <=(lhs: [Real], rhs: [Real]) -> Bool {
    return (lhs < rhs) || (lhs == rhs)
}

func >(lhs: [Real], rhs: [Real]) -> Bool {
    return !(lhs <= rhs)
}

func >=(lhs: [Real], rhs: [Real]) -> Bool {
    return !(lhs < rhs)
}