//
//  QuestionComplex.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 12/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit

class QuestionComplex {
    
    var questionLabel: ColouredLabel!
    var answerSegmentedControl: UISegmentedControl!
    var numberOfOptions = -1
    
    required init(width: Int, questionText: String, colour: UIColor, textColour: UIColor, numberOfOptions: Int?) {
        
        let numberOfLines = width / (questionText.characters.count * 15)
        self.questionLabel = ColouredLabel(width: width, height: 40 + 20 * numberOfLines, colour: colour, textColour: textColour, numberOfLines: numberOfLines, text: questionText)
        if numberOfOptions != nil {
            self.numberOfOptions = numberOfOptions!
        } else {
            answerSegmentedControl = YesNoSegmentedControl(colour: colour, tintColour: textColour)
        }
        
        
    }
    
    
    
}
