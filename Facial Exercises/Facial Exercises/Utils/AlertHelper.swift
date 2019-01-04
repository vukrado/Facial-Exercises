//
//  AlertHelper.swift
//  Facial Exercises
//
//  Created by Simon Elhoej Steinmejer on 03/01/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(with text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
