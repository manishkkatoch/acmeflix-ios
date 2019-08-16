//
//  FailureViewController.swift
//  Acmeflix
//
//  Created by Manish Katoch on 06/08/19.
//  Copyright © 2019 Manish Katoch. All rights reserved.
//

import Foundation
import UIKit

class FailureViewController: UIViewController {
    
    @IBOutlet weak var tryAgainButton: AcmeButton!
    
    @IBAction func tryAgainButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
