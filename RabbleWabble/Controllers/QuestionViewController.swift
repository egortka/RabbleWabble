//
//  ViewController.swift
//  RabbleWabble
//
//  Created by Egor Tkachenko on 15/11/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import UIKit

public protocol QuestionViewControllerDelegate: class {
    
    func questionViewController(
        _ viewController: QuestionViewController,
        didCancel questionStrategy: QuestionStrategy)
    
    func questionViewController(
        _ viewController: QuestionViewController,
        didComplete questionStrategy: QuestionStrategy)
}

public class QuestionViewController: UIViewController {
    
    public weak var delegate: QuestionViewControllerDelegate?
    
    public var questionStrategy: QuestionStrategy! {
        didSet {
            navigationItem.title = questionStrategy.title
        }
    }
    
    public var questionIndex = 0
    
    public var correctCount = 0
    public var incorrectCount = 0
    
    public var questionView: QuestionView! {
        guard isViewLoaded else { return nil }
        return (view as! QuestionView)
    }
    
    private lazy var questionIndexItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "",
        style: .plain,
        target: nil,
        action: nil)
        item.tintColor = .black
        navigationItem.rightBarButtonItem = item
        return item
        }()
    
    // MARK: - View Lifecycle
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        self.showQuestion()
        self.setupCancelButton()
    }
    
    private func setupCancelButton() {
        let action = #selector(handleCancelPressed(sender:))
        let image = UIImage(named: "ic_menu")
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(image: image,
                            landscapeImagePhone: nil,
                            style: .plain,
                            target: self,
                            action: action)
    }
    
    @objc private func handleCancelPressed(sender: UIBarButtonItem) {
        
        delegate?.questionViewController(self, didCancel: self.questionStrategy)
    }
    
    public func showQuestion() {
    
        let question = self.questionStrategy.currentQuestion()
        
        self.questionView.answerLabel.text = question.answer
        self.questionView.hintLabel.text = question.hint
        self.questionView.promptLabel.text = question.prompt
        
        self.questionView.correctCountLabel.isHidden = true
        self.questionView.incorrectCountLabel.isHidden = true
        
        questionIndexItem.title = questionStrategy.questionIndexTitle()
    }
    
    
    // MARK: - Actions
    @IBAction func toggleAnswerLabels(_ sender: Any) {
        
        self.questionView.answerLabel.isHidden =
            !self.questionView.answerLabel.isHidden
        self.questionView.hintLabel.isHidden =
            !self.questionView.hintLabel.isHidden
    }
    
    @IBAction func handleCorrect(_ sender: Any) {
        let question = questionStrategy.currentQuestion()
        questionStrategy.markQuestionCorrect(question)
        
        questionView.correctCountLabel.text =
            String(questionStrategy.correctCount)
        showNextQuestion()
    }
    
    @IBAction func handleIncorrect(_ sender: Any) {
        let question = questionStrategy.currentQuestion()
        questionStrategy.markQuestionIncorrect(question)
        
        questionView.incorrectCountLabel.text =
            String(questionStrategy.incorrectCount)
        showNextQuestion()
    }
    
    private func showNextQuestion() {
        
        guard self.questionStrategy.advanceToNextQuestion() else {
            delegate?.questionViewController(self, didComplete: self.questionStrategy)
            return
        }
        
        self.showQuestion()
    }
}

