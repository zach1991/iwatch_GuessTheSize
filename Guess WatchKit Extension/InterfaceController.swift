//
//  InterfaceController.swift
//  Guess WatchKit Extension
//
//  Created by Zach on 15/4/29.
//  Copyright (c) 2015年 Zach. All rights reserved.
//

import WatchKit
import Foundation

enum Times: Int {
    case Lose = 0, Win = 2, Match = 10
}

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var sliderGuess: WKInterfaceSlider!
    @IBOutlet weak var labelGuessNumber: WKInterfaceLabel!
    @IBOutlet weak var labelBonus: WKInterfaceLabel!
    
    @IBOutlet weak var buttonCharge: WKInterfaceButton!
    @IBOutlet weak var buttonStart: WKInterfaceButton!
    @IBOutlet weak var labelResult: WKInterfaceLabel!
    
    //当前选中的点数
     var guessNumber = 3
    //赔率倍数
    var times = 1
    //赌资
    var bonus = 100 {
        didSet {
            if bonus == 0 {
                buttonCharge.setHidden(false)
                buttonStart.setHidden(true)
            } else {
                buttonCharge.setHidden(true)
                buttonStart.setHidden(false)
            }
            labelBonus.setText("金钱:\(bonus)")
        }
    }

    //更新选的点数
    @IBAction func updateGuessNumber(value: Float) {
        guessNumber = Int(value)
        
        labelGuessNumber.setText("选\(guessNumber),\(isBig(guessNumber).1)")
    }
    
    //充值
    @IBAction func chargeBonus() {
        bonus = 1000
    }
    //开始猜
    @IBAction func startGuess() {
        buttonStart.setTitle("再来一把")
        
        //本次大小的 随机数， 1~10之间
        var randomNumber =  Int(arc4random_uniform(9)) + 1
        
        //是不是猜对了大小
        if isBig(guessNumber).0 == isBig(randomNumber).0 {
        
            //并非完全猜准
            if guessNumber != randomNumber {
                labelResult.setText("\(randomNumber),恭喜奖金X2")
                times = Times.Win.rawValue
            } else {
                labelResult.setText("\(randomNumber),你太厉害了,奖金X10")
                times = Times.Match.rawValue
            }
            
            
        }else{
            labelResult.setText("\(randomNumber),很遗憾!")
            times = Times.Lose.rawValue
        }
        
        //本次赌博后，赌资的变化 是 原赌资 乘以 本次应有的倍数
        bonus = bonus * times
    }
    
    //判断大小
    func isBig(number: Int) -> (Bool,String){
        return number > 5 ? (true, "大") : (false, "小")
     }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        buttonCharge.setHidden(true)
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
