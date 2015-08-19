//
//  Real.swift
//  symbolic
//
//  Created by jazzon on 15/8/18.
//  Copyright © 2015年 jazzon. All rights reserved.
//

import Foundation

enum ValueError: ErrorType {
    case error(msg: String)
}

class Real {
    var int_part   = [Int]()
    var float_part = [Int]()
    var abs_value  = ""
    var sign       : String
    var literal    = ""
    
    init (value: String) throws {
        var find_floating_point = false
        var value_copy          = value
        
        // 储存实数的字面值和符号，即使字面值不合法
        if ["+", "-"].contains(value.characters.first!) {
            self.sign = String(Array(value.characters)[0])
            value_copy = value.substringFromIndex(advance(value.startIndex, 1))
        }
        else {
            self.sign = "+"
        }
        
        if value.characters.count == 0 {
            //空字符串不合法，报错
            throw ValueError.error(msg: "empty string is invalid")
        }

        for i in value_copy.characters {
            if ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."].contains(i) {
                if !find_floating_point && i == "." {
                    // 第一次找到小数点
                    find_floating_point = true
                }
                else if i == "." && find_floating_point {
                    // 找到了多于一个小数点，报错
                    throw ValueError.error(msg: "find more than 1 floating point")
                }
            }
            else {
                // 字面值中有非（数字或小数点）的字符，报错
                throw ValueError.error(msg: "contains invalid character")
            }
        }

        var temp = value_copy.componentsSeparatedByString(".")
        
        if self.sign == "-" {
            self.literal   += "-"
        }
        
        //整数部分不是空的
        if temp[0].characters.first != nil {
            var 酱油变量 = Array(temp[0].characters)
            if temp[0].characters.first! == "0" {
                酱油变量 = Array(temp[0].characters.dropFirst(temp[0].characters.split(isSeparator: { $0 != "0" })[0].count))
            }
            for i in 酱油变量 {
                self.literal   += String(i)
                self.abs_value += String(i)
                
                switch i {
                case "0": self.int_part.append(0); break
                case "1": self.int_part.append(1); break
                case "2": self.int_part.append(2); break
                case "3": self.int_part.append(3); break
                case "4": self.int_part.append(4); break
                case "5": self.int_part.append(5); break
                case "6": self.int_part.append(6); break
                case "7": self.int_part.append(7); break
                case "8": self.int_part.append(8); break
                case "9": self.int_part.append(9); break
                default: break
                }
            }
        }

        //有小数部分
        if find_floating_point {
            self.literal   += "."
            self.abs_value += "."
            //小数部分不为空
            if temp[1].characters.last != nil {
                var 酱油变量 = Array(temp[1].characters)
                if temp[1].characters.last! == "0" {
                    酱油变量 = Array(temp[1].characters.dropLast(temp[1].characters.split(isSeparator: { $0 != "0" }).last!.count))
                    }
                for i in 酱油变量 {
                    self.literal   += String(i)
                    self.abs_value += String(i)
                    switch i {
                    case "0": self.float_part.append(0); break
                    case "1": self.float_part.append(1); break
                    case "2": self.float_part.append(2); break
                    case "3": self.float_part.append(3); break
                    case "4": self.float_part.append(4); break
                    case "5": self.float_part.append(5); break
                    case "6": self.float_part.append(6); break
                    case "7": self.float_part.append(7); break
                    case "8": self.float_part.append(8); break
                    case "9": self.float_part.append(9); break
                    default: break
                    }
                }
            }
        }
    }
    
    class func array2real (array: ([Int], [Int])) throws -> Real {
        do {
            if array.0.isEmpty {
                return try Real(value: "0." + "".join(array.1.map({ "\($0)" })))
            }
            else if array.1.isEmpty {
                return try Real(value: "".join(array.0.map({ "\($0)" })))
            }
            else {
                return try Real(value: "".join(array.0.map({ "\($0)" })) + "." + "".join(array.1.map({ "\($0)" })))
            }
        }
        catch {
            throw ValueError.error(msg: "Convert failed")
        }
    }
    
    func negative() -> Real? {
        do {
            if self.sign == "+" {
                return try Real(value: "-" + self.abs_value)
            }
            else if self.sign == "-" {
                return try Real(value: self.abs_value)
            }
            else {
                return try Real(value: "-" + self.abs_value)
            }
        }
        catch {
            return nil
        }
    }
    
}