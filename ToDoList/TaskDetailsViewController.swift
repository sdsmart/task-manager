//
//  ToDoItemDetailsViewController.swift
//  ToDoList
//
//  Created by Steve Smart on 5/27/15.
//  Copyright (c) 2015 Steve Smart. All rights reserved.
//

import UIKit
import CoreData

class TaskDetailsViewController: UIViewController {

    // MARK: - Properties
    var managedObjectContext: NSManagedObjectContext!
    var taskManaged: TaskManaged? = nil
    var dateFormatter: NSDateFormatter?
    
    @IBOutlet weak var nameHeaderLabel: UILabel!
    @IBOutlet weak var importanceHeaderLabel: UILabel!
    @IBOutlet weak var createdDateHeaderLabel: UILabel!
    @IBOutlet weak var dueDateHeaderLabel: UILabel!
    @IBOutlet weak var detailsHeaderLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var importanceLabel: UILabel!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    // MARK: - View Controller Lifecycle Methods
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        initialViewSetup()
        updateUI()
    }
    
    private func initialViewSetup() {
        implementColorCheme()
        
        detailsTextView.layer.borderWidth = CGFloat(0.5)
        detailsTextView.layer.borderColor = UIColor.blackColor().CGColor
        detailsTextView.layer.cornerRadius = UIConstants.Appearance.textViewBorderRadius
        detailsTextView.clipsToBounds = true
        
        dateFormatter = NSDateFormatter()
        dateFormatter!.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter!.timeStyle = NSDateFormatterStyle.ShortStyle
    }
    
    private func implementColorCheme() {
        self.view.backgroundColor = UIConstants.Colors.DefaultColorScheme.mainBackgroundColor
        detailsTextView.backgroundColor = UIConstants.Colors.DefaultColorScheme.secondaryBackgroundColor
        
        nameHeaderLabel.textColor = UIConstants.Colors.DefaultColorScheme.nameLabelColor
        importanceHeaderLabel.textColor = UIConstants.Colors.DefaultColorScheme.importanceLabelColor
        createdDateHeaderLabel.textColor = UIConstants.Colors.DefaultColorScheme.createdDateLabelColor
        dueDateHeaderLabel.textColor = UIConstants.Colors.DefaultColorScheme.dueDateLabelColor
        dueDateLabel.textColor = UIConstants.Colors.DefaultColorScheme.dueDateTextColor
        detailsHeaderLabel.textColor = UIConstants.Colors.DefaultColorScheme.detailsLabelColor
        
        editButton.tintColor = UIConstants.Colors.DefaultColorScheme.editButtonColor
    }
    
    private func updateUI() {
        if taskManaged != nil {
            updateImportanceTextColor()
            
            let createdDate = dateFormatter?.stringFromDate(taskManaged!.createdDate)
            let dueDate = dateFormatter?.stringFromDate(taskManaged!.dueDate)
            
            createdDateLabel.text = createdDate
            dueDateLabel.text = dueDate
            nameLabel.text = taskManaged!.name
            importanceLabel.text = "\(taskManaged!.importance)"
            detailsTextView.text = taskManaged!.details
        }
    }
    
    private func updateImportanceTextColor() {
        if let importance = taskManaged?.importance {
            switch importance {
            case 8...10:
                importanceLabel.textColor = UIConstants.Colors.highImportanceColor
            case 4...7:
                importanceLabel.textColor = UIConstants.Colors.mediumImportanceColor
            case 1...3:
                importanceLabel.textColor = UIConstants.Colors.lowImportanceColor
            default:
                println("printing from the default case of the updateImportanceTextColor method in the TaskDetailsViewController class")
            }
        }
    }
    
    // MARK: - Navigation Methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case StoryboardConstants.SegueIdentifiers.editTaskSegue:
                if let destinationVC = segue.destinationViewController as? UINavigationController {
                    if let taskEditorController = destinationVC.viewControllers[0] as? TaskEditorViewController {
                        taskEditorController.managedObjectContext = self.managedObjectContext
                        if taskManaged != nil {
                            taskEditorController.taskManaged = taskManaged
                            taskEditorController.title = UIConstants.Appearance.taskEditorTitleForEdit
                        }
                    }
                }
            default:
                println("printing from default case of the prepareForSegue method in the TaskDetailsViewController class")
            }
        }
    }
}
