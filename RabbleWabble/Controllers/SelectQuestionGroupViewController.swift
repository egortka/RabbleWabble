//
//  SelectQuestionGroupViewController.swift
//  RabbleWabble
//
//  Created by Egor Tkachenko on 17/11/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import UIKit

public class SelectQuestionGroupViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet internal var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    
    // MARK: - Properties
    private let questionGroupsCaretaker = QuestionGroupCaretaker()
    private var questionGroups: [QuestionGroup] {
        
        return questionGroupsCaretaker.questionGroups
    }
    private var selectedQuestionGroup: QuestionGroup! {
        
        get {
            
            return questionGroupsCaretaker.selectedQuestionGroup
        }
        set {
            
            questionGroupsCaretaker.selectedQuestionGroup = newValue
        }
    }
    private let appSettings = AppSettings.shared
}

// MARK: - UITableViewDataSource
extension SelectQuestionGroupViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int)
        -> Int {
            return questionGroups.count
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let cell = self.tableView.dequeueReusableCell(
                withIdentifier: "QuestionGroupCell", for: indexPath)
                as! QuestionGroupCell
            let questionGroup = self.questionGroups[indexPath.row]
            cell.titleLabel.text = questionGroup.title
            return cell
    }
}

// MARK: - UITableViewDelegate
extension SelectQuestionGroupViewController: UITableViewDelegate {
    
    // 1
    public func tableView(_ tableView: UITableView,
                          willSelectRowAt indexPath: IndexPath)
        -> IndexPath? {
            selectedQuestionGroup = questionGroups[indexPath.row]
            return indexPath
    }
    
    // 2
    public func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // 3
    public override func prepare(for segue: UIStoryboardSegue,
                                 sender: Any?) {
        guard let viewController = segue.destination
            as? QuestionViewController else { return }
        viewController.delegate = self
        viewController.questionStrategy =
            self.appSettings.questionStrategy(for: self.selectedQuestionGroup)
    }
}

//MARK: - QuestionViewControllerDelegate
extension SelectQuestionGroupViewController: QuestionViewControllerDelegate {
    
    public func questionViewController(
        _ viewController: QuestionViewController,
        didCancel questionGroup: QuestionStrategy) {
        navigationController?.popToViewController(self,
                                                  animated: true)
    }
    
    public func questionViewController(
        _ viewController: QuestionViewController,
        didComplete questionGroup: QuestionStrategy) {
        navigationController?.popToViewController(self,
                                                  animated: true)
    }
}
