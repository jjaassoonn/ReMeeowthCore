//
//  RealArithmetics.swift
//  symbolic
//
//  Created by jazzon on 15/8/19.
//  Copyright © 2015年 jazzon. All rights reserved.
//

import Foundation

// =========================使Real类变得可以做加减运算========================= //
func +(lhs: Real, rhs: Real) -> Real? {
    // 判断符号
    do {
        if lhs.sign == "-" && rhs.sign == "+" {
            let neg = try Real(value: lhs.abs_value)
            return rhs - neg
        }
        else if lhs.sign == "+" && rhs.sign == "-" {
            let neg = try Real(value: rhs.abs_value)
            return lhs - neg
        }
        else if lhs.sign == "-" && rhs.sign == "-" {
            return try (Real(value: lhs.abs_value) + Real(value: rhs.abs_value))?.negative()
        }
        else {
            var lhs_int    = lhs.int_part
            var lhs_float  = lhs.float_part
            var rhs_int    = rhs.int_part
            var rhs_float  = rhs.float_part
            let diff_int   = lhs_int.count - rhs_int.count
            let diff_float = lhs_float.count - rhs_float.count
            
            // 长度不足，整数部分前面补0，小数部分后面补0
            if diff_int != 0 {
                if diff_int < 0 {
                    for _ in 1...abs(diff_int) {
                        lhs_int.insert(0, atIndex: 0)
                    }
                }
                else {
                    for _ in 1...abs(diff_int) {
                        rhs_int.insert(0, atIndex: 0)
                    }
                }
            }
            
            if diff_float != 0 {
                if diff_int < 0 {
                    for _ in 1...abs(diff_float) {
                        rhs_float.append(0)
                    }
                }
                else {
                    for _ in 1...abs(diff_float) {
                        lhs_float.append(0)
                    }
                }
            }
            
            let lhs_int_rev      = Array(lhs_int.reverse())
            let lhs_float_rev    = Array(lhs_float.reverse())
            let rhs_int_rev      = Array(rhs_int.reverse())
            let rhs_float_rev    = Array(rhs_float.reverse())
            
            var result_int_rev   = zip(lhs_int_rev, rhs_int_rev).map({ (t: (Int, Int)) in t.0 + t.1 })
            var result_float_rev = zip(lhs_float_rev, rhs_float_rev).map({ (t: (Int, Int)) in t.0 + t.1 })
            
            // 进位
            if !result_float_rev.isEmpty {
                for i in 0..<result_float_rev.count-1 {
                    if result_float_rev[i] >= 10 {
                        result_float_rev[i+1] += result_float_rev[i] / 10
                        result_float_rev[i]   = result_float_rev[i] % 10
                    }
                }
                
                if result_float_rev[result_float_rev.count-1] >= 10 {
                    result_int_rev[0] += result_float_rev[result_float_rev.count-1] / 10
                    result_float_rev[result_float_rev.count-1] = result_float_rev[result_float_rev.count-1] % 10
                }
            }
            
            if !result_int_rev.isEmpty {
                for i in 0..<result_int_rev.count-1 {
                    if result_int_rev[i] >= 10 {
                        result_int_rev[i+1] += result_int_rev[i] / 10
                        result_int_rev[i]   = result_int_rev[i] % 10
                    }
                }
                
                if result_int_rev[result_int_rev.count-1] >= 10 {
                    result_int_rev.append(result_int_rev[result_int_rev.count-1] / 10)
                    result_int_rev[result_int_rev.count-2] = result_int_rev[result_int_rev.count-2] % 10
                }
            }
            return try Real.array2real((Array(result_int_rev.reverse()), Array(result_float_rev.reverse())))
        }
    }
    catch {
        return nil
    }
}

func -(lhs: Real, rhs: Real) -> Real? {
    do {
        if lhs.sign == "+" && rhs.sign == "+" {
            if lhs > rhs {
                var lhs_int    = lhs.int_part
                var lhs_float  = lhs.float_part
                var rhs_int    = rhs.int_part
                var rhs_float  = rhs.float_part
                let diff_int   = lhs_int.count - rhs_int.count
                let diff_float = lhs_float.count - rhs_float.count
                
                // 长度不起，补齐0，整数在最前面补，小数部分在最后面补
                if diff_int != 0 {
                    if diff_int < 0 {
                        for _ in 1...abs(diff_int) {
                            lhs_int.insert(0, atIndex: 0)
                        }
                    }
                    else {
                        for _ in 1...abs(diff_int) {
                            rhs_int.insert(0, atIndex: 0)
                        }
                    }
                }
                
                if diff_float != 0 {
                    if diff_int < 0 {
                        for _ in 1...abs(diff_float) {
                            rhs_float.append(0)
                        }
                    }
                    else {
                        for _ in 1...abs(diff_float) {
                            lhs_float.append(0)
                        }
                    }
                }
                
                let lhs_int_rev      = Array(lhs_int.reverse())
                let lhs_float_rev    = Array(lhs_float.reverse())
                let rhs_int_rev      = Array(rhs_int.reverse())
                let rhs_float_rev    = Array(rhs_float.reverse())
                
                var result_int_rev   = zip(lhs_int_rev, rhs_int_rev).map({ (t: (Int, Int)) in t.0 - t.1 })
                var result_float_rev = zip(lhs_float_rev, rhs_float_rev).map({ (t: (Int, Int)) in t.0 - t.1 })
                
                //借位
                if !result_float_rev.isEmpty {
                    for i in 0..<result_float_rev.count-1 {
                        if result_float_rev[i] < 0 {
                            result_float_rev[i+1] -= abs(result_float_rev[i]) / 10 + 1
                            result_float_rev[i]   = result_float_rev[i] + 10
                        }
                    }
                    
                    if result_float_rev[result_float_rev.count-1] < 0 {
                        result_int_rev[0] -= abs(result_float_rev[result_float_rev.count-1]) / 10 + 1
                        result_float_rev[result_float_rev.count-1] = result_float_rev[result_float_rev.count-1] + 10
                    }
                }
                
                if !result_int_rev.isEmpty {
                    for i in 0..<result_int_rev.count-1 {
                        if result_int_rev[i] < 0 {
                            result_int_rev[i+1] -= abs(result_int_rev[i]) / 10 + 1
                            result_int_rev[i]   = result_int_rev[i] + 10
                        }
                    }
                    
                    if result_int_rev[result_int_rev.count-1] < 0 {
                        //TODO: 以后出了bug大概在这
                        result_int_rev.removeLast()
                    }
                }
                return try Real.array2real((Array(result_int_rev.reverse()), Array(result_float_rev.reverse())))
                
            }
            else if lhs == rhs {
                return try Real(value: "0")
            }
            else {
                return (rhs - lhs)!.negative()
            }
        }
        else if lhs.sign == "+" && rhs.sign == "-" {
            print(rhs.negative()!.literal)
            return lhs + rhs.negative()!
        }
        else if lhs.sign == "-" && rhs.sign == "-" {
            return lhs + rhs.negative()!
        }
        else if lhs.sign == "-" && rhs.sign == "+" {
            return (rhs - lhs)!.negative()
        }
        return lhs
    }
    catch {
        return nil
    }
}


func *(lhs: Real, rhs: Real) -> Real? {
    do {
        if lhs.sign == "+" && rhs.sign == "+" {
            let lhs_ = try Real.array2real(((lhs.int_part + lhs.float_part).reverse(), []))
            let rhs_ = try Real.array2real(((rhs.int_part + rhs.float_part).reverse(), []))
            
            var 酱油君 = rhs_.int_part.map({ (r : Int) in lhs_.int_part.map({ (t: Int) in r * t}) })
            let max_len     = 酱油君[0].count + 酱油君.count - 1

            for i in 0..<酱油君.count {
                酱油君[i] += Array(0..<(max_len)-(i+酱油君[i].count)).map({ $0 - $0 })
                酱油君[i] =  Array(0..<i).map({ $0 - $0 }) + 酱油君[i]
            }
            
            var result = Array(0..<max_len).map({ (t: Int) in 酱油君.map({ $0[t] }).reduce(0, combine: { (t1: Int, t2: Int) in t1 + t2 })})
            
            if !result.isEmpty {
                for i in 0..<result.count-1 {
                    if result[i] >= 10 {
                        result[i+1] += result[i] / 10
                        result[i]   = result[i] % 10
                    }
                }
                
                if result[result.count-1] >= 10 {
                    result.append(result[result.count-1] / 10)
                    result[result.count-2] = result[result.count-2] % 10
                }
                
                result = result.reverse()
                let fp     = lhs.float_part.count + rhs.float_part.count
                return try Real.array2real((Array(result.dropLast(fp)), Array(result.dropFirst(result.count - fp))))
            }
            else {
                return nil
            }
        }
        else if lhs.sign == "+" && rhs.sign == "-" {
            return (lhs * rhs.negative()!)!.negative()!
        }
        else if lhs.sign == "-" && rhs.sign == "+" {
            return (lhs.negative()! * rhs)!.negative()!
        }
        else {
            return lhs.negative()! * rhs.negative()!
        }
    }
    catch {
        return nil
    }
}