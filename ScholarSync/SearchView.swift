//
//  SearchView.swift
//  ScholarSync
//
//  Created by Adam on 8/25/24.
//

import UIKit

class SearchView: UIView {
    

    @IBOutlet weak var gradeSelectorButton: UIButton!
    
    @IBOutlet weak var datePicker: UIDatePicker!
        
    @IBOutlet weak var stateSelectorButton: UIButton!
    
//    var selectedDate = 
//    var selectedGrade = "All Grades"
//    var selectedState = "All States"
    var selectedMonth = ""
    var selectedYear = ""
   
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        view.layer.cornerRadius = 5.0
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: "SearchView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    @IBAction func dateChangeHandler(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        
        let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "MMM" // "MMM" gives the short month name (e.g., "Aug")
            
        selectedMonth = dateFormatter1.string(from: selectedDate)
        
        let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "yyyy"
        
        selectedYear = dateFormatter2.string(from: selectedDate)
        
    }
    
    func setupUI() {
        let action1 = UIAction(title: "All Grades", image: nil) { _ in
                   print ("All Grades Selected")
            self.selectedGrade = "All Grades"
            self.gradeSelectorButton.setTitle("All Grades", for: .normal)
               }
        
        let action2 = UIAction(title: "High School", image: nil) { _ in
            print ("High School Selected")
            self.selectedGrade = "High School"
            self.gradeSelectorButton.setTitle("High School", for: .normal)
               }
        
        let action3 = UIAction(title: "College & Grad", image: nil) { _ in
            print ("College & Grad Selected")
            self.selectedGrade = "College & Grad"
            self.gradeSelectorButton.setTitle("College & Grad", for: .normal)
               }
               
          
        
        let menu = UIMenu(title: "", children: [action1, action2, action3])
        
        gradeSelectorButton.menu = menu
        gradeSelectorButton.setTitle(selectedGrade, for: .normal)
        gradeSelectorButton.showsMenuAsPrimaryAction = true
        
        
        let states = [
                   "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado",
                   "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho",
                   "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana",
                   "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota",
                   "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada",
                   "New Hampshire", "New Jersey", "New Mexico", "New York",
                   "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon",
                   "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota",
                   "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington",
                   "West Virginia", "Wisconsin", "Wyoming"
               ]
               
               // Create actions for each state
               let stateActions = states.map { state in
                   UIAction(title: state) { _ in
                       print("Selected state: \(state)")
                       self.selectedState = state
                       self.stateSelectorButton.setTitle(state, for: .normal)
                   }
               }
               
               // Create the menu with all state actions
               let menu2 = UIMenu(title: "All States", children: stateActions)
               
               // Assign the menu to the button
               stateSelectorButton.menu = menu2
        stateSelectorButton.setTitle(selectedState, for: .normal)
        stateSelectorButton.showsMenuAsPrimaryAction = true
    }
    
    
    @IBAction func findMatch_tapHandler(_ sender: Any) {
//       
//        let data = [
//            "selectedMonth": selectedMonth,
//            "selectedYear": selectedYear,
//            "selectedGrade": selectedGrade,
//            "selectedState": selectedState
//        ]
        NotificationCenter.default.post(name: Notification.Name("FindMatchingScholarships"), object: nil, userInfo:nil)
    }
    
    var selectedGrade: String {
        get {
          
            if UserDefaults.standard.value(forKey: "selectedGrade") == nil {
                return "All Grades"
            }
            return UserDefaults.standard.string(forKey: "selectedGrade") ?? "All Grades"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "selectedGrade")
        }
    }
    
    
    var selectedState: String {
        get {
          
            if UserDefaults.standard.value(forKey: "selectedState") == nil {
                return "All States"
            }
            return UserDefaults.standard.string(forKey: "selectedState") ?? "All States"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "selectedState")
        }
    }
    
    
}
