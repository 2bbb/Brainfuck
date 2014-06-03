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
}
