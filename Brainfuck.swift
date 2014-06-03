//
//  Brainfuck.swift
//
//  Created by ISHII 2bit on 2014/06/03.
//  Copyright (c) 2014 buffer Renaiss. All rights reserved.
//

import Foundation

protocol InterpretBrainfuck {
    func stringAtPosition(pos:Int) -> NSString;
    func interpretAsBrainfuck();
    func toBrainfuckSource() -> NSString;
}

operator infix ** {}
@infix func ** (str:String, n:Int) -> String {
    var s = "";
    for i in 1...n {
        s += str;
    }
    return s;
}

extension NSString: InterpretBrainfuck {
    func stringAtPosition(pos:Int) -> NSString {
        return substringWithRange(NSMakeRange(pos, 1));
    }
    
    func interpretAsBrainfuck() {
        var memorySpace:Int[] = [0];
        var pointer:Int = 0;
        var cursor:Int = 0;
        var loopPosition:Int[] = [];
        
        while cursor < length {
            var x = stringAtPosition(cursor);
            switch x {
            case ">":
                pointer++;
                if memorySpace.count <= pointer {
                    memorySpace.append(0);
                }
            case "<":
                pointer--;
                if pointer < 0 {
                    println("Error: Negative Memory Index");
                    return;
                }
            case "+":
                memorySpace[pointer]++;
            case "-":
                memorySpace[pointer]--;
            case ".":
                putchar(CInt(memorySpace[pointer]));
            case ",":
                memorySpace[pointer] = Int(getchar());
            case "[":
                if(0 == memorySpace[pointer]) {
                    while stringAtPosition(cursor) != "]" {
                        cursor++;
                    }
                } else {
                    loopPosition.append(cursor);
                }
            case "]":
                if loopPosition.count == 0 {
                    println("Error: Loop Bracket is Unbalance");
                    return;
                }
                cursor = loopPosition[loopPosition.count - 1] - 1;
                loopPosition.removeLast();
            default:
                0;
            }
            cursor++;
        }
    }
    
    func toBrainfuckSource() -> NSString {
        var source: String = ("+" ** 8) + "[>" + ("+" ** 8) + "<-]>+[>"
                           + (">+>" ** length)
                           + ("<<" ** length)
                           + "<-]";
        for(var i:Int = 0; i < self.length; i++) {
            var char:Int = Int(characterAtIndex(i)) - 65;
            var sign = char < 0 ? -1 : 1;
            char *= sign;
            var (m, n, r) = calculateThreePair(char);
            var sourcePiece = createSourcePieces(m, n: n, r: r, op: sign < 0 ? "-" : "+");
            source += ">" + sourcePiece;
        }
        
        return source;
    }
    
    func createSourcePieces(m:Int, n:Int, r:Int, op:String) -> String {
        return ("+" ** m) + "[>" + (op ** n) + "<-]>" + (op ** r) + ".";
    }
    
    func calculateThreePair(num:Int) -> (Int, Int, Int) {
        func sumPairs(p:(Int, Int, Int)) -> Int {
            var (x, y, z) = p;
            return x + y + z;
        }
        var sqrtNum = Int(sqrtf(CFloat(num)));
        var pairs:(Int, Int, Int) = (num, num, num);
        for i in 1...sqrtNum {
            for j in 1...sqrtNum {
                if sumPairs((i, j, num - i * j)) < sumPairs(pairs) {
                    pairs = (i, j, num - i * j);
                }
            }
        }
        return pairs;
    }
}
