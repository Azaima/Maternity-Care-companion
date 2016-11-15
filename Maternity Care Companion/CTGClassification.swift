//
//  CTGClassification.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 14/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit

class CTGClassification: UIViewController {

    @IBOutlet weak var classificationImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func classificationSelected(_ sender: Any) {
        switch (sender as! UISegmentedControl).selectedSegmentIndex {
        case 0:
            classificationImage.image = #imageLiteral(resourceName: "CTG_FIGO_2015")
        case 1:
            classificationImage.image = #imageLiteral(resourceName: "CTG_NICE_2014")
        case 2:
            classificationImage.image = #imageLiteral(resourceName: "CTG_Classification_NICE_2007")
        default:
            classificationImage.image = #imageLiteral(resourceName: "CTG_STAN")
        }
    }
    @IBAction func pinchClassificationImage(_ sender: Any) {
        let scale = (sender as! UIPinchGestureRecognizer).scale
        classificationImage.frame.size = CGSize(width: Int(classificationImage.frame.size.width * scale), height: Int(classificationImage.frame.size.height * scale))
    }
   
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
