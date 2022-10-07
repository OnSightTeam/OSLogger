//
//  SampleViewController.swift
//  Sample
//
//  Created by admin on 31.05.2022.
//

import UIKit


class SampleViewController: UIViewController {

    // MARK: - Private methods -
    @IBOutlet var viewModel: SampleViewModel!

    // MARK: - Lifecycle methods -

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Logger [Debug]"
        
        // Method handle for add custom log actions
        handleCallbacks()
    }
    
    // MARK: - Action methods -

    @IBAction func didClickConfiguration(_ sender: UIBarButtonItem) {
        
        let configurations = UIAlertController(title: "Configuration", message: "Change logger tool configuration", preferredStyle: .actionSheet)
        
        let defaultConfig = UIAlertAction(title: "Default", style: .default) { [weak self] _ in
            guard let self = `self` else { return }
            
            self.viewModel.setupLoggerTool(with: .default)
            self.title = "Logger [Default]"
        }
        
        let debugConfig = UIAlertAction(title: "Debug", style: .default) { [weak self] _ in
            guard let self = `self` else { return }
            
            self.viewModel.setupLoggerTool(with: .debug)
            self.title = "Logger [Debug]"
        }
        
        configurations.addAction(defaultConfig)
        configurations.addAction(debugConfig)
        configurations.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(configurations, animated: true)
    }
    
    // MARK: - Internal methods -
    
    func handleCallbacks() {
        viewModel.addLogDetail = { [weak self] type in
            guard let self = self else { return }
            
            self.createLogDetails(type)
        }
    }
    
    func createLogDetails(_ type: TestLogType) {
        let alert = UIAlertController(title: "Add custom log", message: "Fill custom log details", preferredStyle: .alert)
        
        alert.addTextField { textfield in
            textfield.placeholder = "Enter message:"
            textfield.tag = LogDetailType.message.rawValue
        }
        
        if type == .customCategoryLog {
            alert.addTextField { textfield in
                textfield.placeholder = "Enter category:"
                textfield.tag = LogDetailType.category.rawValue
            }
        }
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) {[weak self] _ in
            guard let self = `self` else { return }
            
            if let message = alert.textFields?.first?.text {
                
                if type == .customCategoryLog,
                   let category = alert.textFields?.last?.text {
                    self.viewModel.addCustomLog(message: message, category: category)
                } else {
                    self.viewModel.addCustomLog(message: message)
                }
            }
        }
        
        alert.addAction(confirmAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}
