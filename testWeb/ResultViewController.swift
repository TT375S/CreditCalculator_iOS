//
//  ResultViewController.swift
//  testWeb
//
//  Created by T.T on 2017/02/06.
//  Copyright © 2017年 T.T. All rights reserved.
//

//
//  ViewController.swift
//  testWeb
//
//  Created by T.T on 2017/02/04.
//  Copyright © 2017年 T.T. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController{
    
    var recievedText = ""
    
    @IBOutlet weak var uiLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiLabel.numberOfLines = 0
        uiLabel.adjustsFontSizeToFitWidth = true
        uiLabel.text = "honyahonya"
        uiLabel.text = recievedText
        print(recievedText)
        print("transp!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //テキストを行ごとの配列に分解
    func disassemble(text: String) -> Array<String>{
        var lines:[String] = []
        text.enumerateLines { (line, stop) -> () in
            lines.append(line)
        }
        
        return lines
    }
    
    //HTMLを解釈し計算する
    func digestHTML(){
        var lines:[String] = disassemble(text: recievedText)
        
        var credits:Dictionary<String, Int>= [:]
        var group:Dictionary<String, Int> = [:]
        var nonfinishedGroup:Dictionary<String, Int>=[:]
        var currentGroup = "NONEGROUP"
        var GPA:Int = 0
        var classNum:Int = 0
        
        for(index, element) in lines.enumerated(){
            if element.contains("operationbox"){
                var subIndex = index
                subIndex = subIndex + 1
                let currentHeadLine = lines[subIndex]
                if currentHeadLine.contains("群"){
                    currentGroup = currentHeadLine.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    group[currentGroup] = 0
                    nonfinishedGroup[currentGroup] = 0
                    continue
                }else if currentGroup != "NONEGROUP"{
                    subIndex = subIndex + 4
                    var currentLine = lines[subIndex]
                    //単位数
                    let creditNum = Int(currentLine.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: "<TD>", with: "").replacingOccurrences(of: "</TD>", with: "").replacingOccurrences(of: "<BR>", with: "").replacingOccurrences(of: "＊", with: "") )
                    subIndex = subIndex + 1
                    currentLine = lines[subIndex]
                    //成績評価
                    let grade = element.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: "<TD>", with: "").replacingOccurrences(of: "</TD>", with: "")
                    //単位数のカウント
                    if grade != "＊" && grade != "<BR>"{
                        group[currentGroup] =  group[currentGroup]! + creditNum!
                    }else if grade == "＊" {
                        nonfinishedGroup[currentGroup] = nonfinishedGroup[currentGroup]! + creditNum!
                    }
                    subIndex = subIndex + 1
                    currentLine = lines[subIndex]
                    //授業のスコア
                    let score = Int(currentLine.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: "<TD>", with: "").replacingOccurrences(of: "</TD>", with: "").replacingOccurrences(of: "<BR>", with: "").replacingOccurrences(of: "＊", with: "") )
                    
                    GPA = GPA + score!
                    
                    if let _ = credits[grade]{
                        credits[grade] = credits[grade]! + 1
                    }else{
                        credits[grade] = 1
                    }
                }
            }
        }
        
        
    }
}

