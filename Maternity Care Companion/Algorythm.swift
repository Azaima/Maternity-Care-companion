//
//  Algorythm.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 11/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit

class Algorythm {
    
    
    let titleLabel: ColouredLabel!
    
    var arrayOfLabels = [BorderedLabel]()
    var questionsForLabels = [Int]()
    
    var arrayOfQuestionLabels = [ColouredLabel]()
    var arrayOfQuestionSegmentControls = [YesNoSegmentedControl]()
    var arrayOfOptionsForQuestions = [(Int,Int)]()
    
    var arrayOfArrows = [DownArrowImage]()
    
    required init(title: String, arrayOfLabelEntries: [(String,Int)], arrayOfQuestionEntries: [(String,Int,Int)]){
        
        self.titleLabel = ColouredLabel(width: 200, height: 40, colour: .black, textColour: .white, numberOfLines: 3, text: title)
        createLabels(textForLabels: arrayOfLabelEntries)
        createQuestionLabels(textForQuestions: arrayOfQuestionEntries)
        
        let numberOfArrows = arrayOfQuestionLabels.count + arrayOfLabels.count
        arrayOfArrows = Array(repeating: DownArrowImage(), count: numberOfArrows)
        
        
        
        
    }
    
    func createLabels(textForLabels: [(String, Int)]){
        
        for text in textForLabels {
            let numberOfLines = text.0.characters.count * 15 / 200
            let label = BorderedLabel(width: 200, height: 30 + (20 * numberOfLines), numberOfLines: numberOfLines + 1, borderColor: UIColor.black.cgColor, textColor: .black, text: text.0)
            arrayOfLabels.append(label)
            questionsForLabels.append(text.1)
            
        }
    }
    
    func createQuestionLabels(textForQuestions: [(String,Int,Int)]){
        
        for text in textForQuestions {
            let numberOfLines = text.0.characters.count * 15 / 200
            let questionLabel = ColouredLabel(width: 200, height: 30 + (20 * numberOfLines), colour: .black, textColour: .white, numberOfLines: numberOfLines + 1, text: text.0)
            let questionSegmentedControl = YesNoSegmentedControl(colour: .white, tintColour: .black)
            
            arrayOfQuestionLabels.append(questionLabel)
            arrayOfQuestionSegmentControls.append(questionSegmentedControl)
            arrayOfOptionsForQuestions.append((text.1,text.2))

        }
    }
}
