//
//  YesNoSegmentedControl.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 11/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit

class YesNoSegmentedControl: UISegmentedControl {
    
    required init(colour: UIColor, tintColour: UIColor) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        self.insertSegment(withTitle: "No", at: 0, animated: true)
        self.insertSegment(withTitle: "Yes", at: 1, animated: true)
        
        self.backgroundColor = colour
        self.tintColor = tintColour
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
     
     let answerSegmentedControl = UISegmentedControl(frame: CGRect(x: centreX - 100, y: totalHeight, width: 200, height: 30))
     answerSegmentedControl.insertSegment(withTitle: "No", at: 0, animated: false)
     answerSegmentedControl.insertSegment(withTitle: "Yes", at: 1, animated: false)
     
     answerSegmentedControl.backgroundColor = UIColor.white
     answerSegmentedControl.tintColor = UIColor.darkGray

    */

}
