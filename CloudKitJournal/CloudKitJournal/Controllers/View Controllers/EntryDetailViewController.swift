//
//  EntryDetailViewController.swift
//  CloudKitJournal
//
//  Created by River McCaine on 2/1/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextView!
    
    // MARK: - Properties
    var entry: Entry? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Actions
    @IBAction func mainViewTapped(_ sender: Any) {
        titleTextField.resignFirstResponder()
        bodyTextField.resignFirstResponder()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
              let body = bodyTextField.text, !body.isEmpty else { return presentErrorToUser()}
        if let entry = entry {
            EntryController.shared.updateEntry(entry: entry, title: title, body: body) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let success):
                        entry.title = title
                        entry.body = body
                        self.navigationController?.popViewController(animated: true)
                        print(success)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        } else {
            
            EntryController.shared.createEntry(with: title, with: body, with: Date()) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let entry):
                        self.entry = entry
                        self.navigationController?.popViewController(animated: true)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        titleTextField.text = ""
        bodyTextField.text = "" 
    }
    
    
    // MARK: - Helper Methods
    func updateViews() {
        if let entry = entry {
            titleTextField.text = entry.title
            bodyTextField.text = entry.body
        }
    }
    
} // END OF CLASS

extension EntryDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
    }
    
} // END OF EXTENSION
