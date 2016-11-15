//
//  ShowProcedureVC.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 15/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit

class ShowProcedureVC: UIViewController {

    @IBOutlet weak var pageHeaderLabel: UILabel!
    @IBOutlet weak var procedureImage: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    var header = "Procedure"
    var stepsArray = [(String, UIImage?)]()
    var step = 0 {
        didSet{
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageHeaderLabel.text = header
        updateView()
    }

    func updateView(){
            commentLabel.text = stepsArray[step].0
        
        
            procedureImage.image = stepsArray[step].1
        
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        
        if step != 0 {
            step -= 1
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if step != stepsArray.count - 1 {
            step += 1
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
   

}
