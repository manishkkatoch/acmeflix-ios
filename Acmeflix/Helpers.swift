//
//  Helpers.swift
//  Acmeflix
//
//  Created by Manish Katoch on 10/08/19.
//  Copyright © 2019 Manish Katoch. All rights reserved.
//

import Foundation
import UIKit

public func createOkAlert(title: String, message: String, on vc: UIViewController) {
    let alertView = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
    alertView.view.backgroundColor = .darkGray
    DispatchQueue.main.async {
        alertView.show(vc, sender: nil)
        alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        vc.present(alertView, animated: true, completion: nil)
    }
}
