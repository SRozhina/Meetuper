//
//  FullEventViewController.swift
//  ITEvents
//
//  Created by Sofia on 28/01/2018.
//  Copyright © 2018 Sofia. All rights reserved.
//

import UIKit

class FullEventViewController: UIViewController {
    @IBOutlet var eventView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var showAllDescriptions: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let xibView = Bundle.main.loadNibNamed("EventView", owner: self, options: nil)!.first as! EventView
        
        xibView.frame = eventView.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        eventView.addSubview(xibView)
    }

}
