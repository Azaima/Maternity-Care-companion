//
//  ShowProcedureVC.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 15/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit

class ShowProcedureVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var pageHeaderLabel: UILabel!
    @IBOutlet weak var procedureImage: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var scroller: UIScrollView!
    
    
    var procedure: Procedure!
    var step = 0 {
        didSet{
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageHeaderLabel.text = procedure.procedureName
        updateView()
        scroller.delegate = self
        scroller.minimumZoomScale = 0.75
        scroller.maximumZoomScale = 2.0
        
    }

    func updateView(){
        commentLabel.text = procedure.commentsArray[step]
        if procedure.linksToImages.contains(step){
            let number = procedure.linksToImages.index(of: step)
            procedureImage.image = procedure.imagesArray[number!]
        } else {
            procedureImage.image = nil
        }
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return procedureImage
    }
    
    @IBAction func previousButtonPressed(_ sender: Any) {
        
        if step != 0 {
            step -= 1
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if step != procedure.commentsArray.count - 1 {
            step += 1
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
   

}
