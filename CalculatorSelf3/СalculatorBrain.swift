//
//  СalculatorBrain.swift
//  CalculatorSelf3
//
//  Created by Mac User on 7/7/17.
//  Copyright © 2017 Mac User. All rights reserved.
//

import Foundation

struct CalculatorBrain {

    var result : Double? {
        get {
            return accumulator}
    }

    private enum operation {
        case Constant(Double)
        case Unary((Double) -> Double)
        case Binary((Double,Double) -> Double)
        case Equal
    }
    mutating func addUnaryOperation(with symbol: String, _ newOperation: @escaping (Double) -> Double) {
        Operations[symbol] = operation.Unary(newOperation)
    }

    private var Operations : Dictionary <String, operation> =
        [
            "π" : .Constant(Double.pi),
            "√" : .Unary(sqrt),
            "+" : .Binary({$0 + $1}),
            "-" : .Binary({$0 - $1}),
            "×" : .Binary({$0 * $1}),
            "÷" : .Binary({$0 / $1}),
            "=" : .Equal
    ]

    private var accumulator : Double?
    
    private struct PendingBinaryOperation {
        let operation : (Double, Double) -> Double
        let operand : Double
        
        func perform(with secondOperand: Double) -> Double {
            return operation(operand, secondOperand)
        }
    }
    private var pendingOperation : PendingBinaryOperation?
    
    mutating func performOperation(oper symbol: String) {
    
        if let curOperation = Operations[symbol] {
            switch curOperation {
            case .Constant(let ass_value) : accumulator = ass_value
            case .Unary(let foo) : accumulator = foo(accumulator ?? 0)
            case .Binary(let foo) : pendingOperation = PendingBinaryOperation(operation: foo, operand: accumulator!)
                accumulator = nil
            case .Equal :
                if pendingOperation != nil {
                    accumulator = pendingOperation?.perform(with: accumulator ?? 0)
                    pendingOperation = nil
                
                }
            }
        }
    }

    mutating func pushDigit(_ digit: Double) {
        accumulator = digit
    }
}
