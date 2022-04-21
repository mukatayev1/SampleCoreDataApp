//
//  UIViewController + Extension.swift
//  CoreDataPractice
//
//  Created by Aidos Mukatayev on 2022/04/21.
//

import UIKit

extension UIViewController {
    func presentBasicAlert(title: String, message: String, preferredStyle: UIAlertController.Style = .alert, actionTitleText: String = "OK", completion: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let okAction = UIAlertAction(title: actionTitleText, style: .cancel, handler: completion)
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
