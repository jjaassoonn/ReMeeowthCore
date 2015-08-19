//
//  RealComparison.swift
//  symbolic
//
//  Created by jazzon on 15/8/19.
//  Copyright © 2015年 jazzon. All rights reserved.
//

import Foundation

// =========================使Real类变得可以比较========================= //
extension Real: Comparable {}

func ==(lhs: Real, rhs: Real) -> Bool {
    return lhs.int_part == rhs.int_part && lhs.float_part == rhs.float_part && lhs.sign == rhs.sign
}

func !=(lhs: Real, rhs: Real) -> Bool {
    return !(lhs == rhs)
}

func >(lhs: Real, rhs: Real) -> Bool {
    if lhs.sign == "+" && rhs.sign == "-" {
        return true
    }
    else if lhs.sign == "+" && rhs.sign == "+" {
        if lhs.int_part > rhs.int_part {
            return true
        }
        else if lhs.int_part < rhs.int_part {
            return false
        }
        else {
            let un_eq = zip(lhs.float_part, rhs.float_part).map({ (t: (Int, Int)) in t.0 == t.1 }).indexOf(false)
            if un_eq != nil {
                return lhs.float_part[un_eq!] > rhs.float_part[un_eq!]
            }
            else {
                return lhs.float_part.count > rhs.float_part.count
            }
        }
    }
    else if lhs.sign == "-" && rhs.sign == "+" {
        return false
    }
    else {
        return false
    }
}

func >=(lhs: Real, rhs: Real) -> Bool {
    return lhs > rhs || lhs == rhs
}

func <(lhs: Real, rhs: Real) -> Bool {
    return !(lhs >= rhs)
}

func <=(lhs: Real, rhs: Real) -> Bool {
    return !(lhs > rhs)
}
