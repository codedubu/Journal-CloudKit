//
//  UIViewControllerExtension.swift
//  CloudKitJournal
//
//  Created by River McCaine on 2/1/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentErrorToUser() {
        
        let alertController = UIAlertController(title: "Uh Oh!", message: "Enter a title and a body!", preferredStyle: .actionSheet)
        
        let dismissAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true)
    }
}

