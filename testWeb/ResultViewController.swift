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
        
        print(digestHTML())
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
    
    //表示
    func showResult(group :Dictionary<String,Int>, nonfinishedGroup :Dictionary<String, Int>, credit :Dictionary<String, Int>, GPA:Int) -> String{
        var printText :String = ""
        var creditSum = 0
        var nonfinishedCreditSum = 0
        var classNum = 0
        
        printText = printText + "---群別の単位数(カッコ内は履修はしているもののまだ成績が決定されていないもの)---" + "\n"
        for (key, value) in group{
            let temp = Int(nonfinishedGroup[key]!)
            printText = printText + key + " : "  + String(value)
            printText = printText  + " (" + String(temp) + ")\n"
            creditSum = creditSum + value
            nonfinishedCreditSum = nonfinishedCreditSum + nonfinishedGroup[key]!
        }
        printText = printText + "合計:" + String(creditSum) + " (" + String(nonfinishedCreditSum) + ")単位\n"
        
        //return printText
        
        for (key, value) in credit{
            if key != "<br>"{
                printText = printText + key + " " + String(value) + "\n"
                classNum = classNum + value
            }
        }
        
        printText = printText + "\n---成績計算---\n"
        printText = printText +  "scoreSum " + String(GPA) + "\n"
        printText = printText + "class " + String(classNum - credit["＊"]!) + "\n"
        printText = printText  + "GPA " + String(GPA/(classNum - credit["＊"]!))
        
        
        return printText
    }
    
    //HTMLを解釈し計算する
    func digestHTML() -> String{
        var lines:[String] = disassemble(text: recievedText)
        
        var credits:Dictionary<String, Int>= [:]
        var group:Dictionary<String, Int> = [:]
        var nonfinishedGroup:Dictionary<String, Int>=[:]
        var currentGroup = "NONEGROUP"
        var GPA:Int = 0
        
        for(index, element) in lines.enumerated(){
            if element.contains("operationboxf"){
                var subIndex = index
                subIndex = subIndex + 1
                let currentHeadLine = lines[subIndex]
                
                if currentHeadLine.contains("群"){
                    currentGroup = currentHeadLine.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: "<td>", with: "").replacingOccurrences(of: "</td>", with: "").replacingOccurrences(of: "<br>", with: "").replacingOccurrences(of: "＊", with: "").replacingOccurrences(of: "◎", with: "")
                    
                    group[currentGroup] = 0
                    nonfinishedGroup[currentGroup] = 0
                    continue
                }else if currentGroup != "NONEGROUP" && currentHeadLine.contains("nbsp"){
                    subIndex = subIndex + 3
                    var currentLine = lines[subIndex]
                    //単位数
                    let creditNum = Int(currentLine.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: "<td>", with: "").replacingOccurrences(of: "</td>", with: "").replacingOccurrences(of: "<br>", with: "").replacingOccurrences(of: "＊", with: "") )
                    print(currentLine)
                    print(currentLine.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: "<td>", with: "").replacingOccurrences(of: "</td>", with: "").replacingOccurrences(of: "<br>", with: "").replacingOccurrences(of: "＊", with: ""))
                    print("CREDITNUM:")
                    print(creditNum as Any)
                    subIndex = subIndex + 1
                    currentLine = lines[subIndex]
                    //成績評価
                    let grade = currentLine.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: "<td>", with: "").replacingOccurrences(of: "</td>", with: "")
                    print("GRADE")
                    print(grade)
                    //単位数のカウント
                    if grade != "＊" && grade != "<br>"{
                        group[currentGroup] =  group[currentGroup]! + creditNum!
                    }else if grade == "＊" {
                        nonfinishedGroup[currentGroup] = nonfinishedGroup[currentGroup]! + creditNum!
                    }
                    subIndex = subIndex + 1
                    currentLine = lines[subIndex]
                    //授業のスコア
                    let score = Int(currentLine.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).replacingOccurrences(of: "<td>", with: "").replacingOccurrences(of: "</td>", with: "").replacingOccurrences(of: "<br>", with: "").replacingOccurrences(of: "＊", with: "") )
                    print("SCORE")
                    print(currentLine)
                    print(score as Any)
                    if score != nil{
                        GPA = GPA + score!
                    }
                    
                    if let _ = credits[grade]{
                        credits[grade] = credits[grade]! + 1
                    }else{
                        credits[grade] = 1
                    }
                }
            }
        }
        
        return showResult(group: group, nonfinishedGroup: nonfinishedGroup, credit: credits, GPA: GPA)
    }
}

