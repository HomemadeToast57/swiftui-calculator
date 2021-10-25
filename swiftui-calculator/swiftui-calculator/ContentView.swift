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
            return .orange
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
                    Text(value)
                        .font(.system(size: 88))
                        .foregroundColor(.white)
                        .bold()
                    
                    
                }
                .padding()
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id:\.self) { item in
                            Button(action: {
                                self.didTap(button: item)
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
        
        
        switch button {
        case .add, .subtract, .multiply, .divide, .equal:
            if button == .add {
                self.currentOperation = .add
                self.accumulator = Double(self.value) ?? 0.0
                self.value = "0"
                self.inputNum = 0
            } else if button == .subtract {
                self.currentOperation = .subtract
                self.accumulator = Double(self.value) ?? 0.0
                self.value = "0"
                self.inputNum = 0
            } else if button == .multiply {
                self.currentOperation = .multiply
                self.accumulator = Double(self.value) ?? 0.0
                self.value = "0"
                self.inputNum = 0
            } else if button == .divide {
                self.currentOperation = .divide
                self.accumulator = Double(self.value) ?? 0.0
                self.value = "0"
                self.inputNum = 0
            } else if button == .equal {
                
                currentVal = Double(self.value) ?? 0.0
                
                switch self.currentOperation {
                case .add:
                    let opVal = self.accumulator + self.currentVal
                    self.value = (floor(opVal) == opVal) ? "\(Int(opVal))" : String(format: "%.4f", opVal)
                    break
                case .subtract:
                    let opVal = self.accumulator - self.currentVal
                    self.value = (floor(opVal) == opVal) ? "\(Int(opVal))" : String(format: "%.4f", opVal)
                    break
                case .multiply:
                    let opVal = self.accumulator * self.currentVal
                    self.value = (floor(opVal) == opVal) ? "\(Int(opVal))" : String(format: "%.4f", opVal)
                    break
                case .divide:
                    let opVal = self.accumulator / self.currentVal
                    self.value = (floor(opVal) == opVal) ? "\(Int(opVal))" : String(format: "%.4f", opVal)
                    break
                case .none:
                    break
                }
                
                print("Acc = \(self.accumulator)")
                print("CurrentVal = \(self.currentVal)")
            }
            break
        case .clear:
            
            self.currentVal = 0.0
            self.accumulator = 0.0
            self.value = "0"
            self.currentOperation = .none
            self.inputNum = 0
            
            break
        case .decimal, .negative, .percent:
            break
        default:
            let number = button.rawValue
            if (self.value == "0" && inputNum == 0) {
                value = number
                self.inputNum+=1
            }
            else {
                self.value = "\(self.value)\(number)"
                self.inputNum+=1
            }
        }
        
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
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

