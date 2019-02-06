//
//  MessageEditorViewController.swift
//  LuckyNotification
//
//  Created by Luke Davis on 2/2/19.
//  Copyright © 2019 Lucky 13 Technologies, LLC. All rights reserved.
//

import UIKit
import LuckyNotification

class MessageEditorViewController: UITableViewController {
    
    let notification = LuckyNotification()
    var configuration = NotificationConfiguration.default
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var verticalMarginLabel: UILabel!
    @IBOutlet weak var verticalMarginStepper: UIStepper!
    
    @IBOutlet weak var horizontalMarginLabel: UILabel!
    @IBOutlet weak var horizontalMarginStepper: UIStepper!
    
    @IBOutlet weak var spacingLabel: UILabel!
    @IBOutlet weak var spacingStepper: UIStepper!
    
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var widthStepper: UIStepper!
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var heightStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notification.displayDuration = 10
        let margin = configuration.layoutMargin
        
        verticalMarginStepper.value = Double(margin.top)
        verticalMarginLabel.text = "\(margin.top)"
        
        horizontalMarginStepper.value = Double(margin.leading)
        horizontalMarginLabel.text = "\(margin.leading)"
        
        let spacing = configuration.contentSpacing
        
        spacingStepper.value = Double(spacing)
        spacingLabel.text = "\(spacing)"
        
        let iconSize = configuration.iconSize
        widthStepper.value = Double(iconSize.width)
        widthLabel.text = "\(iconSize.width)"
        heightStepper.value = Double(iconSize.height)
        heightLabel.text = "\(iconSize.height)"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func handleShowMessagePress(_ sender: Any) {
        let title = self.titleTextField.text ?? ""
        let description = self.descriptionTextField.text ?? ""
        notification.showNotification(icon: #imageLiteral(resourceName: "errorIcon"), title: title, description: description, autoHide: true)
    }
    
    @IBAction func handleStepperChange(_ sender: UIStepper) {
        if sender == self.widthStepper {
            widthLabel.text = "\(sender.value)"
            configuration.iconSize.width = CGFloat(sender.value)
        } else if sender == self.heightStepper {
            heightLabel.text = "\(sender.value)"
            configuration.iconSize.height = CGFloat(sender.value)
        } else if sender == self.verticalMarginStepper {
            verticalMarginLabel.text = "\(sender.value)"
            self.configuration.layoutMargin.top = CGFloat(sender.value)
            self.configuration.layoutMargin.bottom = CGFloat(sender.value)
        } else if sender == self.horizontalMarginStepper {
            horizontalMarginLabel.text = "\(sender.value)"
            self.configuration.layoutMargin.leading = CGFloat(sender.value)
            self.configuration.layoutMargin.trailing = CGFloat(sender.value)
        } else if sender == self.spacingStepper {
            spacingLabel.text = "\(sender.value)"
            self.configuration.contentSpacing = CGFloat(sender.value)
        }
        self.notification.configuration = self.configuration
    }
    
}
