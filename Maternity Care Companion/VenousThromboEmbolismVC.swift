//
//  VenousThromboEmbolismVC.swift
//  Maternity Care Companion
//
//  Created by Ahmed Zaima on 09/11/2016.
//  Copyright © 2016 Ahmed Zaima. All rights reserved.
//

import UIKit

class VenousThromboEmbolismVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIScrollViewDelegate {

    @IBOutlet weak var pageSegmentControl: UISegmentedControl!
    @IBOutlet weak var secondarySegmentControl: UISegmentedControl!
    @IBOutlet weak var vteScrollView: UIScrollView!
    @IBOutlet weak var scrollViewImage: UIImageView!
    
    @IBOutlet weak var antenatalPostnatalSegment: UISegmentedControl!
    
    
    let ageLabel = BorderedLabel(width: 60, height: 40, numberOfLines: 2, borderColor: UIColor.black.cgColor, textColor: .black, text: "Age\r(years)")
    let ageTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
    let gaLabel = BorderedLabel(width: 60, height: 40, numberOfLines: 2, borderColor: UIColor.black.cgColor, textColor: .black, text: "Gestational Age\r(Weeks)")
    let gaTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
    let bmiLabel = BorderedLabel(width: 60, height: 40, numberOfLines: 2, borderColor: UIColor.black.cgColor, textColor: .black, text: "BMI\r(Whole Number)")
    let bmiTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
    let vteDecisionLabel = BorderedLabel(width: 100, height: 100, numberOfLines: 5, borderColor: UIColor.black.cgColor, textColor: .black, text: "Decision")
    
    var vteScoringViews = [UIView]()
    var gestationalAge = 0
    var age = 0
    var bmi = 0
    var vteScoreLabels = [UILabel]()
    var vteSegmentControls = [YesNoSegmentedControl]()
    var vteScore = 0 {
        didSet{
            updateVTEDecisionLabel()
        }
    }
    
    
    var arrayOfViewsInScrollView = [UIView]()
    var pathway = [0]
    
    var peAlgorythm: Algorythm!
    
    var arrayOfTextForLabels = [String]()
    var arrayOfLabels = [BorderedLabel]()
    
    var arrayOfQuestions = [String]()
    var arrayOfQuestionLabels = [ColouredLabel]()
    var arrayOfSegmentedControlsForQuestions = [YesNoSegmentedControl]()
    
   
    var inr = 0.0
    
    let inrTextField = UITextField()
    var doseLabel = UILabel()
    let dayPicker = UIPickerView()
    
    
    let listOfRowsForVTERisk = [
        [("Previous VTE(except a single event related to major surgery)", 4),
         ("Single VTE Event provoked by major surgery", 3),
         ("Known high-risk thrombophilia", 3),
         ("Medical comorbidities", 3),
         ("Family history of unprovoked or estrogen-related VTE in first-degree relative", 1),
         ("Known low-risk thrombophilia (no VTE)", 1),
         ("Smoker", 1),
         ("Gross varicose veins", 1)],
        [("Pre-eclampsia in current pregnancy",1),
         ("ART/IVF", 1),
         ("Multiple pregnancy", 1),
         ("Caesarean section in labour", 2),
         ("Elective caesarean section", 1),
         ("Mid-cavity or rotational operative delivery", 1),
         ("Prolonged labour (> 24 hours)", 1),
         ("PPH (> 1 litre or transfusion)", 1),
         ("Preterm birth < 37+0 weeks in current pregnancy", 1),
         ("Stillbirth in current pregnancy", 1)],
        [("Any surgical procedure in pregnancy or puerperium except immediate repair of the perineum", 3),
         ("Hyperemesis", 3),
         ("OHSS", 4),
         ("Current systemic infection", 1),
         ("Immobility, dehydration", 1)]
    ]
    
    let headersForRisk = ["Pre-existing risk factors", "Obstetric risk factors", "Transient risk factors"]
    
    var listOfRowsForVTERisksChosen = [[(String, Int)]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        vteScoringViews = [ageLabel, ageTextField, gaLabel, gaTextField, bmiLabel, bmiTextField, vteDecisionLabel]
        
        for subview in vteScoringViews {
            vteScrollView.addSubview(subview)
            if subview is UITextField {
                subview.isHidden = true
                (subview as! UITextField).delegate = self
                subview.backgroundColor = .white
                (subview as! UITextField).textAlignment = .center
                
            }
        }
        
        
        vteScrollView.layer.borderWidth = 1
        vteScrollView.layer.borderColor = UIColor.darkGray.cgColor
        vteScrollView.layer.cornerRadius = 5
        vteScrollView.clipsToBounds = true
        vteScrollView.contentSize.width = self.view.frame.size.width
        
        vteScrollView.delegate = self
        vteScrollView.minimumZoomScale = 0.75
        vteScrollView.maximumZoomScale = 2.0
        
        setupPEAlgorythm()
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollViewImage
    }

   
    func setupVTEScoreViews(){
        textFieldFormat(textField: ageTextField)
        textFieldFormat(textField: gaTextField)
        textFieldFormat(textField: bmiTextField)
        
        vteScrollView.addSubview(ageTextField)
        vteScrollView.addSubview(gaTextField)
        vteScrollView.addSubview(ageLabel)
        vteScrollView.addSubview(gaLabel)
        vteScrollView.addSubview(bmiTextField)
        vteScrollView.addSubview(bmiLabel)
        
        
        ageLabel.frame.origin = CGPoint(x: 20, y: 20)
        ageTextField.frame.origin = CGPoint(x: 80, y: 20)
        
        gaLabel.frame.origin = CGPoint(x: 20, y: 70)
        gaTextField.frame.origin = CGPoint(x: 80, y: 70)
        
        bmiLabel.frame.origin = CGPoint(x: 20, y: 120)
        bmiTextField.frame.origin = CGPoint(x: 80, y: 120)
    }
    
    func textFieldFormat(textField: UITextField){
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
    }
   

    
    
    
  
//MARK: Manage PRimary segment Control
    
    @IBAction func primarySegmentSelected(_ sender: Any) {
        
        clearScrollView()
        
        switch pageSegmentControl.selectedSegmentIndex {
        case 1:
            
            for viewInScroll in arrayOfViewsInScrollView {
                viewInScroll.isHidden = true
            }
            arrayOfViewsInScrollView = []
            
            if secondarySegmentControl.numberOfSegments == 2 {
                
                secondarySegmentControl.insertSegment(withTitle: "Tinzaparin", at: 2, animated: true)
                secondarySegmentControl.setTitle("Enoxaparin", forSegmentAt: 0)
                secondarySegmentControl.setTitle("Dalteparin", forSegmentAt: 1)
                secondarySegmentControl.selectedSegmentIndex = 0

            } else if secondarySegmentControl.numberOfSegments == 4 {
                
                secondarySegmentControl.removeSegment(at: 3, animated: true)
                secondarySegmentControl.selectedSegmentIndex = 0
            }
        case 2:
            
            
            for viewInScroll in arrayOfViewsInScrollView {
                viewInScroll.isHidden = true
            }
            arrayOfViewsInScrollView = []
            
            if secondarySegmentControl.numberOfSegments == 2 {
                secondarySegmentControl.insertSegment(withTitle: "Tinzaparin", at: 2, animated: true)
                secondarySegmentControl.insertSegment(withTitle: "Warfarin", at: 3, animated: true)
                secondarySegmentControl.setTitle("Enoxaparin", forSegmentAt: 0)
                secondarySegmentControl.setTitle("Dalteparin", forSegmentAt: 1)
                secondarySegmentControl.selectedSegmentIndex = 0
            }   else if secondarySegmentControl.numberOfSegments == 3 {
                
                secondarySegmentControl.insertSegment(withTitle: "Warfarin", at: 3, animated: true)

            }
            
            secondarySegmentSelected(sender)
        default:
            if secondarySegmentControl.numberOfSegments == 4 {
                secondarySegmentControl.removeSegment(at: 3, animated: true)
            }
            secondarySegmentControl.removeSegment(at: 2, animated: true)
            secondarySegmentControl.setTitle("VTE Risk Score", forSegmentAt: 0)
            secondarySegmentControl.setTitle("PE Diagnostic Algorythm", forSegmentAt: 1)
            secondarySegmentControl.selectedSegmentIndex = 1
            startPEALgorythm()
        }
        
        secondarySegmentSelected(sender)
    }
    
    func clearScrollView(){
        let scrollSubviews = vteScrollView.subviews
        for subview in scrollSubviews {
            subview.isHidden = true
        }
        
        arrayOfViewsInScrollView = []
    }
    
// MARK: Manage Secondary segment control
    
    @IBAction func secondarySegmentSelected(_ sender: Any) {
       
        antenatalPostnatalSegment.isHidden = !(pageSegmentControl.selectedSegmentIndex == 0 && secondarySegmentControl.selectedSegmentIndex == 0)
        
        
        switch pageSegmentControl.selectedSegmentIndex {
        case 1:
            scrollViewImage.isHidden = false
            switch secondarySegmentControl.selectedSegmentIndex {
            case 0:
                scrollViewImage.image = #imageLiteral(resourceName: "thromboprophylaxisClexane")
                
            case 1:
                scrollViewImage.image = #imageLiteral(resourceName: "thromboprophylaxisFragmin")
                
            default:
                scrollViewImage.image = #imageLiteral(resourceName: "thromboprophylaxisTinzaparin")
            }

        case 2:
            scrollViewImage.isHidden = false
            switch secondarySegmentControl.selectedSegmentIndex {
            case 0:
                scrollViewImage.image = #imageLiteral(resourceName: "TherapeuticClexane")
                
            case 1:
                scrollViewImage.image = #imageLiteral(resourceName: "TherapeuticFragmin")
                
            case 2:
                scrollViewImage.image = #imageLiteral(resourceName: "TherapeuticTinzaparin")
                
            default:
                clearScrollView()
                showWarfarinCalculationWindow()
            }
            
        default:
            switch secondarySegmentControl.selectedSegmentIndex {
            case 1:
                clearScrollView()
                startPEALgorythm()
            default:
                clearScrollView()
                showVTEScoreCalculator()
            }
        }

    }
  
    
// MARK: Warfarin Calculation
    
    func showWarfarinCalculationWindow(){
        
        
        
            displayTitleLabels(titlesText: ["Day", "INR Level"])
            
            dayPicker.frame = CGRect(x: 0, y: 50, width: 150, height: 80)
            dayPicker.delegate = self
            

            dayPicker.clipsToBounds = true
            dayPicker.selectRow(0, inComponent: 0, animated: true)
            vteScrollView.addSubview(dayPicker)
            
            inrTextField.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
            inrTextField.center = CGPoint(x: 225, y: dayPicker.center.y)
            inrTextField.backgroundColor = .white
            inrTextField.layer.borderWidth = 1
            inrTextField.layer.borderColor = UIColor.lightGray.cgColor
            inrTextField.layer.cornerRadius = 5
            inrTextField.clipsToBounds = true
            inrTextField.textAlignment = .center
            inrTextField.isHidden = true
            
            inrTextField.delegate = self
            vteScrollView.addSubview(inrTextField)
        
            let label = ColouredLabel(width: 300, height: 50, colour: .black, textColour: .white, numberOfLines: 2, text: "Warfarin Dose (mg)")
            label.center.x = vteScrollView.center.x
            label.frame.origin.y = 150
            label.isHidden = false
        
            doseLabel = BorderedLabel(width: 300, height: 50, numberOfLines: 1, borderColor: UIColor.black.cgColor, textColor: .black, text: "7.0")
            doseLabel.isHidden = false
            doseLabel.center.x = vteScrollView.center.x
            doseLabel.frame.origin.y = 210
            doseLabel.textAlignment = .center
            doseLabel.textColor = .black
        
            vteScrollView.addSubview(doseLabel)
            vteScrollView.addSubview(label)
            
       
        
    }
    
    func displayTitleLabels(titlesText: [String]){
        
        for (index,title) in titlesText.enumerated() {
            let label = UILabel(frame: CGRect(x: 150 * index, y: 0, width: 150, height: 40))
            label.text = title
            label.textAlignment = .center
            label.textColor = .black
            label.numberOfLines = 2
            
            vteScrollView.addSubview(label)
        }
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let list = ["First", "Second", "Third", "Fourth"]
        return list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0, 1:
            inrTextField.isHidden = true
            doseLabel.text = "7.0"
            
        default:
            inrTextField.isHidden = false
            inrTextField.text = nil
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkTextFieldAndChangeDoseLabel(textField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        checkTextFieldAndChangeDoseLabel(textField: textField)
        
        return true
    }
    
    func checkTextFieldAndChangeDoseLabel(textField: UITextField){
        if textField == inrTextField{
            
            
            if let inrLevel = Double(textField.text!){
                let inrInt = Int(inrLevel * 10)
                inr = Double(inrInt ) / 10
                textField.text = "\(inr)"
            } else {
                inrTextField.text = nil
            }
            
            if inrTextField.text != nil {
                switch dayPicker.selectedRow(inComponent: 0) {
                case 2:
                    if inr < 2.0 {
                        doseLabel.text = "7.0"
                    } else if inr < 2.2 {
                        doseLabel.text = "5.0"
                    } else if inr < 2.4 {
                        doseLabel.text = "4.5"
                    } else if inr < 2.6 {
                        doseLabel.text = "4.0"
                    } else if inr < 2.8 {
                        doseLabel.text = "3.5"
                    }   else if inr < 3.0 {
                        doseLabel.text = "3.0"
                    }   else if inr < 3.2 {
                        doseLabel.text = "2.5"
                    }   else if inr < 3.4 {
                        doseLabel.text = "2.0"
                    }   else if inr == 3.4 {
                        doseLabel.text = "1.5"
                    }   else if inr == 3.5 {
                        doseLabel.text = "1.0"
                    }   else if inr <= 4.0 {
                        doseLabel.text = "0.5"
                    }   else if inr > 4.0 {
                        doseLabel.text = "0.0"
                    }
                default:
                    if inr < 1.4 {
                        doseLabel.text = "> 8.0"
                    }  else if inr == 1.4 {
                        doseLabel.text = "8.0"
                    }   else if inr == 1.5 {
                        doseLabel.text = "7.5"
                    }   else if inr < 1.8 {
                        doseLabel.text = "7.0"
                    }   else if inr == 1.8 {
                        doseLabel.text = "6.5"
                    }   else if inr == 1.9 {
                        doseLabel.text = "6.0"
                    }   else if inr < 2.2 {
                        doseLabel.text = "5.5"
                    }   else if inr < 2.4 {
                        doseLabel.text = "5.0"
                    }   else if inr < 2.7 {
                        doseLabel.text = "4.5"
                    }   else if inr < 3.1 {
                        doseLabel.text = "4.0"
                    }   else if inr < 3.6 {
                        doseLabel.text = "3.5"
                    }   else if inr < 4.1 {
                        doseLabel.text = "3.0"
                    }   else if inr <= 4.5 {
                        doseLabel.text = "Omit next day's dose then give 2 mg"
                    }   else if inr > 4.5 {
                        doseLabel.text = " Omit two days' doses then give 1 mg"
                    }
                }
            }
        }   else if textField == ageTextField || textField == gaTextField || textField == bmiTextField{
            checkVTEStartProtocol(textField: textField)
        }

    }
    
    func checkVTEStartProtocol(textField: UITextField){
        var outOfRange = false
        if let number = Int(textField.text!){
            switch textField {
            case ageTextField:
                if number > 12 && number < 60 {
                    age = number
                    calculateVTEScore()
                } else {
                    outOfRange = true
                    textField.text = nil
                }
                
            case gaTextField:
                if number > 4 && number < 44{
                    gestationalAge = number
                } else {
                    outOfRange = true
                    textField.text = nil
                }
            default:
                if number > 15 && number < 80 {
                    bmi = number
                    calculateVTEScore()
                } else {
                    outOfRange = true
                    textField.text = nil
                }
                
            }
        }   else {
            textField.text = nil
        }
        if !outOfRange {
            if antenatalPostnatalSegment.selectedSegmentIndex == 0 {
                if bmiTextField.text != nil && bmiTextField.text != "" && gaTextField.text != "" && ageTextField.text != "" && gaTextField.text != nil && ageTextField.text != nil {
                    showVTEScoreScrollView()
                    
                }
            }   else if antenatalPostnatalSegment.selectedSegmentIndex == 1 {
                if bmiTextField.text != nil && bmiTextField.text != ""  && ageTextField.text != ""  && ageTextField.text != nil {
                    showVTEScoreScrollView()
                }
            }   else {
                print(antenatalPostnatalSegment.selectedSegmentIndex)
            }
        } else {
            textField.text = nil
        }
    }
// MARK: Show VTE Score Calculator
    
    func showVTEScoreCalculator(){
        
        antenatalPostnatalSegment.isHidden = false
        antenatalPostnatalSegment.selectedSegmentIndex = -1
        vteScrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    @IBAction func categorySelected(_ sender: Any) {
        
        clearRiskList()
        ageLabel.isHidden = false
        ageTextField.isHidden = false
        bmiLabel.isHidden = false
        bmiTextField.isHidden = false
        let ageLabelx = 10
        let ageLabely = 10
        
        ageLabel.frame.origin = CGPoint(x: ageLabelx, y: ageLabely)
        ageTextField.frame.origin = CGPoint(x: ageLabelx + 60, y: ageLabely)
        bmiLabel.frame.origin = CGPoint(x: ageLabelx, y: ageLabely + 50)
        bmiTextField.frame.origin = CGPoint(x: ageLabelx + 60, y: ageLabely + 50)
        
        if antenatalPostnatalSegment.selectedSegmentIndex == 0 {
            gaLabel.isHidden = false
            gaTextField.isHidden = false
            
            gaLabel.frame.origin = CGPoint(x: ageLabelx, y: ageLabely + 100)
            gaTextField.frame.origin = CGPoint(x: ageLabelx + 60, y: ageLabely + 100)
            
            
        }   else {
            gaTextField.isHidden = true
            gaLabel.isHidden = true
        }
    }
    
    func adjustRiskList(){
        
        listOfRowsForVTERisksChosen = listOfRowsForVTERisk

        if antenatalPostnatalSegment.selectedSegmentIndex == 0 {
            for _ in 1 ... 7 {
                listOfRowsForVTERisksChosen[1].removeLast()
            }
            
            if gestationalAge > 14 {
                listOfRowsForVTERisksChosen[2].remove(at: 2)
            }
        } else if antenatalPostnatalSegment.selectedSegmentIndex == 1 {
            
            listOfRowsForVTERisksChosen[1].remove(at: 1)
            listOfRowsForVTERisksChosen[2].remove(at: 1)
            listOfRowsForVTERisksChosen[2].remove(at: 1)
        }
    }
    
    func clearRiskList(){
        vteScore = 0
        
        for _ in 0 ..< arrayOfViewsInScrollView.count {
            
            arrayOfViewsInScrollView.last?.isHidden = true
            arrayOfViewsInScrollView.removeLast()
        }
        vteSegmentControls = []
        vteScoreLabels = []
        
        calculateVTEScore()
    }
    
    func calculateVTEScore(){
        vteScore = 0
        
        if age > 35 {
            ageTextField.backgroundColor = .yellow
            vteScore += 1
        }   else {
            ageTextField.backgroundColor = .white
        }
        if bmi >= 30 && bmi < 40 {
            bmiTextField.backgroundColor = .yellow
            vteScore += 1
        }   else if bmi >= 40 {
            bmiTextField.backgroundColor = .orange
            vteScore += 2
        }   else {
            bmiTextField.backgroundColor = .white
        }
    }
    
    func showVTEScoreScrollView(){
        
        adjustRiskList()
        clearRiskList()
        
            
        vteScrollView.contentSize.height = CGFloat(listOfRowsForVTERisksChosen[0].count + listOfRowsForVTERisksChosen[1].count + listOfRowsForVTERisksChosen[2].count + 3) * 30 + 250
        var finalY = 150
        for (index, list) in listOfRowsForVTERisksChosen.enumerated() {
            let sectionLabel = ColouredLabel(width: Int(vteScrollView.frame.size.width), height: 30, colour: .blue, textColour: .white, numberOfLines: 2, text: headersForRisk[index])
            sectionLabel.isHidden = false
            sectionLabel.frame.origin = CGPoint(x: 0, y: finalY)
            vteScrollView.addSubview(sectionLabel)
            arrayOfViewsInScrollView.append(sectionLabel)
            finalY += 30
            for risk in list {
                let riskLabel = UILabel(frame: CGRect(x: 0, y: finalY, width: Int(vteScrollView.frame.size.width - 100), height: 30))
                riskLabel.text = risk.0
                riskLabel.backgroundColor = .white
                riskLabel.numberOfLines = 2
                riskLabel.adjustsFontSizeToFitWidth = true
                vteScoreLabels.append(riskLabel)
                
                let riskSegmentControl = YesNoSegmentedControl(colour: .white, tintColour: .blue)
                riskSegmentControl.frame.size.width = 100
                riskSegmentControl.isHidden = false
                riskSegmentControl.frame.origin = CGPoint(x: Int(vteScrollView.frame.size.width - 100), y: finalY)
                vteSegmentControls.append(riskSegmentControl)
                
                vteScrollView.addSubview(riskLabel)
                vteScrollView.addSubview(riskSegmentControl)
                arrayOfViewsInScrollView.append(riskLabel)
                arrayOfViewsInScrollView.append(riskSegmentControl)
                
                riskSegmentControl.addTarget(YesNoSegmentedControl?.self, action: #selector(vteRiskSelected(sender:)), for: UIControlEvents.valueChanged)
                finalY += 30
            }
        }
        
        vteDecisionLabel.isHidden = false
        vteDecisionLabel.frame.origin = CGPoint(x: 0, y: finalY)
        vteDecisionLabel.frame.size.width = vteScrollView.frame.size.width
    }
    
    @IBAction func vteRiskSelected(sender: YesNoSegmentedControl?){
       
        if sender == vteSegmentControls[0] {
            if sender?.selectedSegmentIndex == 1 {
                vteSegmentControls[1].selectedSegmentIndex = 0
            }
        }   else if sender == vteSegmentControls[1] {
            if sender?.selectedSegmentIndex == 1 {
                vteSegmentControls[0].selectedSegmentIndex = 0
            }
        }
        
        calculateVTEScore()
        

        
        let group1 = listOfRowsForVTERisksChosen[0].count
        let group2 = listOfRowsForVTERisksChosen[1].count
        
        
        for (index, selectedSegment) in vteSegmentControls.enumerated(){
            var riskOfVTE = 0
            if selectedSegment.selectedSegmentIndex == 1 {
                
                if index < group1 {
                    riskOfVTE = listOfRowsForVTERisksChosen[0][index].1
                    
                }   else if index < group1 + group2 {
                    riskOfVTE = listOfRowsForVTERisksChosen[1][index - group1].1
                    
                }   else {
                    riskOfVTE = listOfRowsForVTERisksChosen[2][index - (group1 + group2)].1
                    
                }
            }
            
            switch riskOfVTE {
            case 4:
                vteScoreLabels[index].backgroundColor = .red
                
            case 2, 3:
                
                vteScoreLabels[index].backgroundColor = .orange
                
            case 1:
                vteScoreLabels[index].backgroundColor = .yellow
                
            default:
                vteScoreLabels[index].backgroundColor = .white
            }
            
            vteScore += riskOfVTE
        }
    }
    
    func updateVTEDecisionLabel(){
        
        var decisionSentence = "Toatal VTE Risk Score: \(vteScore)\r"
        var risk = 0
        
        if antenatalPostnatalSegment.selectedSegmentIndex == 0 {
            if vteScore >= 4 || ( vteScore == 3 && gestationalAge > 28 ){
                decisionSentence += "Consider thromboprophylaxis\r"
                risk = 2
            }   else if vteScore == 3 && gestationalAge < 28 {
                decisionSentence += "Consider from 28 weeks\r"
                risk = 1
            }   else {
                decisionSentence += "Ensure Mobilisation and avoid dehydration\r"
            }
            
            decisionSentence += "• If admitted to hospital antenatally consider thromboprophylaxis"
        }   else {
            if vteScore > 3 {
                decisionSentence += "For Thromboprophylaxis for at least 6 weeks Postnatal\r"
                risk = 2
            }   else if vteScore >= 2 {
                decisionSentence += "For thromboprphylaxis for at least 10 days Postnatal\r"
                risk = 1
            }   else {
                decisionSentence += "For Early mobilisation and avoidance of dehydration\r"
            }
            
            decisionSentence += "• If prolonged admission (≥ 3 days) or readmission to hospital within the puerperium consider thromboprophylaxis"
        }
        
        vteDecisionLabel.text = decisionSentence
        switch risk {
        case 2:
            vteDecisionLabel.backgroundColor = .red
        case 1:
            vteDecisionLabel.backgroundColor = .yellow
            
        default:
            vteDecisionLabel.backgroundColor = .green
        }
    }
    
// MARK: Management of Suspected PE Algorythm
    
    func setupPEAlgorythm(){
        
        let arrayOfQuestionEntries = [
            ("Symptoms or Signs of DVT?", 12, 1),
            ("DVT Confirmed", 12, 2),
            ("Chest X-Ray Normal?", 4, 3),
            ("PE Confirmed?", 14,2),
            ("Is the clinical suspicion of PE high?", 5, 6 )]
        
        let arrayOfLabelEntries = [
            ("Clinical assessment\rPerform CXR and ECG\rTest FBC, U&E, LFTs\rCommence LMWH (unless treatment is contraindicated)", 0),
            ("Perform compression duplex ultrasound", 1),
            ("Continue therapeutic Dose of LMWH", -1),
            ("Perform V/Q scan", 3),
            ("Perform CTPA", 3),
            ("Discontinue LMWH\rConsider Alternative Diagnoses", -1),
            ("Continue therapeutic Dose of LMWH\rConsider Alternative/Repeat testing", -1)]
        
        peAlgorythm = Algorythm(title: "Suspected PE?", arrayOfLabelEntries: arrayOfLabelEntries, arrayOfQuestionEntries: arrayOfQuestionEntries)
        
    }
    
    func startPEALgorythm() {
        
        
        addViewToVTEScrollView(views: peAlgorythm.arrayOfLabels)
        addViewToVTEScrollView(views: peAlgorythm.arrayOfQuestionLabels)
        addViewToVTEScrollView(views: peAlgorythm.arrayOfQuestionSegmentControls)
        
        for segmentedControl in peAlgorythm.arrayOfQuestionSegmentControls{
            segmentedControl.addTarget(YesNoSegmentedControl?.self, action: #selector(handleSegmentSelection(sender:)), for: UIControlEvents.valueChanged)
        }
        
        let titleLabel = peAlgorythm.titleLabel
        titleLabel?.frame.size.width = vteScrollView.frame.size.width - 20
        vteScrollView.contentSize.width = vteScrollView.frame.size.width
        titleLabel?.isHidden = false
        titleLabel?.center.x = vteScrollView.center.x
        
        vteScrollView.addSubview(titleLabel!)
        
        vteScrollView.contentSize.height = CGFloat(addLabelToAlgorythm(labelNum: 0, yPoint: 40))
        
    }
    
    func addLabelToAlgorythm(labelNum: Int, yPoint: Int) -> Int{
        
        let arrow = DownArrowImage()
        arrow.isHidden = false
        arrow.center = CGPoint(x: Int(vteScrollView.center.x), y: yPoint + 15)
        vteScrollView.addSubview(arrow)
        arrayOfViewsInScrollView.append(arrow)
        
        
        let label = peAlgorythm.arrayOfLabels[labelNum]
        label.isHidden = false
        arrayOfViewsInScrollView.append(label)
        
        label.center = CGPoint(x: Int(vteScrollView.center.x), y: yPoint + 30 + Int(label.frame.size.height / 2))
        var finalY = Int(label.frame.size.height) + 30 + yPoint
        
        if peAlgorythm.questionsForLabels[labelNum] != -1 {
            finalY = addQuestionLabelToAlgorythm(question: peAlgorythm.questionsForLabels[labelNum], yPoint: finalY)
        }
        if finalY > Int(vteScrollView.frame.size.height){
            vteScrollView.setContentOffset(CGPoint(x: 0, y: finalY - Int(vteScrollView.frame.size.height)), animated: true)
        }
        return finalY
    }
    
    func addQuestionLabelToAlgorythm(question: Int, yPoint: Int) -> Int {
        
        let arrow = DownArrowImage()
        arrow.isHidden = false
        arrow.center = CGPoint(x: Int(vteScrollView.center.x), y: yPoint + 15)
        vteScrollView.addSubview(arrow)
        arrayOfViewsInScrollView.append(arrow)
        
        let questionLabel = peAlgorythm.arrayOfQuestionLabels[question]
        let questionSegmentedControl = peAlgorythm.arrayOfQuestionSegmentControls[question]
        
        arrayOfViewsInScrollView.append(questionLabel)
        arrayOfViewsInScrollView.append(questionSegmentedControl)
        
        questionLabel.isHidden = false
        questionLabel.center = CGPoint(x: Int(vteScrollView.center.x), y: yPoint + 30 + Int(questionLabel.frame.size.height / 2))
        
        questionSegmentedControl.isHidden = false
        questionSegmentedControl.center = CGPoint(x: Int(vteScrollView.center.x), y: yPoint + 30 + Int(questionLabel.frame.size.height) + Int(questionSegmentedControl.frame.size.height / 2))
        
        let finalY = yPoint + 30 + Int(questionLabel.frame.size.height) + Int(questionSegmentedControl.frame.size.height)
        if finalY > Int(vteScrollView.frame.size.height){
            vteScrollView.setContentOffset(CGPoint(x: 0, y: finalY - Int(vteScrollView.frame.size.height)), animated: true)
        }
        return finalY
    }
    
    func addViewToVTEScrollView(views: [UIView]){
        for view in views{
            vteScrollView.addSubview(view)
        }
    }
    
    @IBAction func handleSegmentSelection(sender: YesNoSegmentedControl?){
        
        let selectedSegment = peAlgorythm.arrayOfQuestionSegmentControls.index(of: sender!)
        let selectedAnswer = sender?.selectedSegmentIndex
        
        var questionOutcome = 0
        
        if selectedAnswer == 0 {
            questionOutcome = peAlgorythm.arrayOfOptionsForQuestions[selectedSegment!].0
        } else {
            questionOutcome = peAlgorythm.arrayOfOptionsForQuestions[selectedSegment!].1
        }
        
        let segmentIndexInView = arrayOfViewsInScrollView.index(of: sender!)
        
        if sender != arrayOfViewsInScrollView.last {
            
            for _ in segmentIndexInView! + 1 ..< arrayOfViewsInScrollView.count {
                arrayOfViewsInScrollView[segmentIndexInView! + 1].isHidden = true
                arrayOfViewsInScrollView.remove(at: segmentIndexInView! + 1)
            }
            
        }
        for view in arrayOfViewsInScrollView{
            view.isHidden = false
        }
        
        if questionOutcome < 10 {
            vteScrollView.contentSize.height = CGFloat(addLabelToAlgorythm(labelNum: questionOutcome, yPoint: Int((sender?.frame.origin.y)! + (sender?.frame.size.height)!)))
        }   else {
            vteScrollView.contentSize.height = CGFloat(addQuestionLabelToAlgorythm(question: questionOutcome % 10, yPoint: Int((sender?.frame.origin.y)! + (sender?.frame.size.height)!)))
        }
        
    
    }


    // Navigation
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
