//
//  ContentView.swift
//  swiftui-calculator
//
//  Created by Jacob Singer on 10/24/21.
//

import SwiftUI

enum CalcButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case multiply = "x"
    case divide = "/"
    case equal = "="
    case clear = "AC"
    case decimal = "."
    case percent = "%"
    case negative = "+/-"
    
    var buttonColor: Color {
        switch self {
        case .negative, .clear, .percent:
            return Color(.lightGray)
        case .divide, .multiply, .subtract, .add, .equal:
            return Color(UIColor(red: 32/255.0, green: 86/255.0, blue: 115/255.0, alpha: 1))
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
}

enum Operation {
    case add, subtract, multiply, divide, none
}

struct ContentView: View {
    
    @State var value = "0"
    @State var inputNum = 0
    @State var accumulator = 0.0
    @State var currentVal = 0.0
    @State var currentOperation: Operation = .none
    @State var onNextVal = false;
    @State var isNegative = false;
    @State var numbersArr: [Double] = []
    @State var numbersArrIndex = 0
    @State var viewingAns = false
    @State var hasDecimal = false
    
    
    let buttons: [[CalcButton]] = [
        
        [.clear, .negative, .percent, .divide],
        
        [.seven, .eight, .nine, .add],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .multiply],
        
        [.zero, .decimal, .equal]
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                //TEXT DISPLAY
                HStack {
                    Spacer()
                    Text(self.value)
                        .font(.system(size: 88))
                        .foregroundColor(.white)
                        .bold()
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    
                }
                .padding()
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id:\.self) { item in
                            Button(action: {
                                self.didTap(button: item)
                                if (self.onNextVal) {
                                    
                                }
                            }, label: {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(width: self.buttonWidth(item: item), height: self.buttonHeight())
                                    .background(item.buttonColor)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(self.buttonWidth(item: item)/2)
                            })
                        }
                    }.padding(.bottom, 3)
                }
            }
            .padding()
            
            
            
        }
    }
    
    
    func didTap(button: CalcButton) {
        
        //Update decimal info
        if (self.value).contains(".") {
            self.hasDecimal = true;
        } else {
            self.hasDecimal = false
        }
        
        //CHECK BUTTON
        switch button {
        case .add, .subtract, .multiply, .divide, .equal:
            
            onNextVal = true
            self.inputNum = 0
            
            if button != .equal {
                self.accumulator = Double(self.value) ?? 0.0
                numbersArr.append(self.accumulator)
                numbersArrIndex += 1
            }
            
            
            if button == .add {
                self.currentOperation = .add
            } else if button == .subtract {
                self.currentOperation = .subtract
            } else if button == .multiply {
                self.currentOperation = .multiply
            } else if button == .divide {
                self.currentOperation = .divide
            } else if button == .equal {
                
                //DO OPERATION
                onNextVal = false
                currentVal = Double(self.value) ?? 0.0
                numbersArr.append(currentVal)
                numbersArrIndex += 1
                
                
                //SAVE FIRST VAL
                
                var opVal = 0.0
                
                
                //CHECK FOR OPERATION
                switch self.currentOperation {
                case .add:
                    opVal = self.accumulator + self.currentVal
                    break
                case .subtract:
                    opVal = self.accumulator - self.currentVal
                    break
                case .multiply:
                    opVal = self.accumulator * self.currentVal
                    break
                case .divide:
                    if self.currentVal != 0 {
                        opVal = self.accumulator / self.currentVal
                    } else {
                        self.value = "Cannot divide by 0 😡"
                        inputNum = 0
                        onNextVal = false
                        return
                    }
                    break
                case .none:
                    break
                }
                
                self.value = (floor(opVal) == opVal) ? "\(Int(opVal))" : forTrailingZero(temp: opVal)
                
                
                
                
                
            }
            break
        case .clear:
            allClear()
            break
        case .decimal:
            let number = button.rawValue
            if !hasDecimal {
                if inputNum == 0 {
                    self.value = number
                    inputNum += 1
                } else {
                    self.value = self.value + number
                    inputNum += 1
                }
            } else if inputNum == 0 {
                self.value = number
            }
            break
        case .negative:
            //pos to neg
            if !isNegative {
                self.value = "-" + self.value
            }
            //neg to pos
            else {
                let range = (self.value).index((self.value).startIndex, offsetBy: 1)..<(self.value).endIndex
                self.value = String((self.value)[range])
            }
            self.isNegative = !self.isNegative
        case .percent:
            if !onNextVal {
                break
            } else {
                //do calculations
                
                var newVal = 0.0
                
                switch currentOperation {
                case .add:
                    newVal = numbersArr.last! + (numbersArr.last! * ((Double(self.value) ?? 0.0) / 100))
                case .subtract:
                    newVal = numbersArr.last! - (numbersArr.last! * ((Double(self.value) ?? 0.0) / 100))
                case .multiply:
                    newVal = numbersArr.last! * (numbersArr.last! * ((Double(self.value) ?? 0.0) / 100))
                case .divide:
                    if numbersArr.last == 0.0 {
                        self.value = "Cannot divide by 0 😡"
                        inputNum = 0
                        onNextVal = false
                        return
                    } else {
                        newVal = numbersArr.last! / (numbersArr.last! * ((Double(self.value) ?? 0.0) / 100))
                    }
                case .none:
                    break
                }
                
                numbersArr.append(newVal)
                self.value = (floor(newVal) == newVal) ? "\(Int(newVal))" : forTrailingZero(temp: newVal)
                
                //reset things
                inputNum = 0
                onNextVal = false
            }
            break
        default:
            
            //reg number
            let number = button.rawValue
            if inputNum == 0 {
                
                self.value = number
                inputNum += 1
            } else {
                self.value = self.value + number
                inputNum += 1
            }
            
        }
        
//        print("Val \(self.value)")
//        print("ACC: \(self.accumulator)")
//        print("CUR \(self.currentVal)")
//        print("OP \(self.currentOperation)")
//        print("ARR \(self.numbersArr)")
    }
    
    func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (5*12)) / 2)
        }
        return ((UIScreen.main.bounds.width - (5*12)) / 4)
    }
    
    func buttonHeight() -> CGFloat {
        return ((UIScreen.main.bounds.width - (5*12)) / 4)
    }
    
    func forTrailingZero(temp: Double) -> String {
        let tempVar = String(format: "%g", temp)
        return tempVar
    }
    
    func allClear() {
        value = "0"
        inputNum = 0
        accumulator = 0.0
        currentVal = 0.0
        currentOperation = Operation.none
        onNextVal = false;
        isNegative = false;
        numbersArr = []
        numbersArrIndex = 0
        viewingAns = false
        hasDecimal = false
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

