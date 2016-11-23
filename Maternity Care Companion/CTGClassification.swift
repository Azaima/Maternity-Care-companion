//
//  CTGClassification.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 14/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit

class CTGClassification: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var classifScrollView: UIScrollView!
    @IBOutlet weak var classificationImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classifScrollView.delegate = self
        classifScrollView.minimumZoomScale = 0.75
        classifScrollView.maximumZoomScale = 2.0

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

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return classificationImage
    }
    
    
   
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
