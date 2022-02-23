//
//  RouteController.swift
//  How Do I Get There?
//
//  Created by Maciej Sałuda on 10/02/2022.
//

import UIKit

class RouteViewController: UIViewController {
    
    var routeManager: RouteManager?
    var routeModel: RouteModel?
    

    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var busNumber: UILabel!
   
    @IBOutlet weak var when: UILabel!
    
    @IBOutlet weak var whereFrom: UILabel!
    @IBOutlet weak var whereTo: UILabel!
    
    @IBOutlet weak var whichBusNumber: UILabel!
    func setup(manager: RouteManager, route: RouteModel?) {
        self.routeManager = manager
        self.routeModel = route
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.timeLabel.text = self.getTime(string: self.routeModel?.originTime)
            self.placeLabel.text = self.routeModel?.originPlace
            self.destinationLabel.text = self.routeModel?.destinationPlace
            self.busNumber.text = self.routeModel?.busNumb
        }
    }
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    func getTime(string: String?) -> String?  {
        guard let string = string else {
            return nil
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        dateFormatter.locale = .current
        let date = dateFormatter.date(from: string)
        
        guard let date = date else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let time = formatter.string(from: date)
        return time
        }
    
}
