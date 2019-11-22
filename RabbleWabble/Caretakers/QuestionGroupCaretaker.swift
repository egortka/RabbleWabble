//
//  QuestionGroupCaretaker.swift
//  RabbleWabble
//
//  Created by Egor Tkachenko on 20/11/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import Foundation


public final class QuestionGroupCaretaker {
    
    // MARK: - Properties

    private let fileName = "QuestionGroupData"
    public var questionGroups: [QuestionGroup] = []
    public var selectedQuestionGroup: QuestionGroup!
    
    // MARK: - Object Lifecycle
    public init() {

        loadQuestionGroups()
    }
    
    public func loadQuestionGroups() {
        
        if let questionGroups =
        
            try? DiskCaretacker.retrieve([QuestionGroup].self, from: fileName) {
            
            self.questionGroups = questionGroups
        } else {
            
            let bundle = Bundle.main
            let url = bundle.url(forResource: fileName,
                                 withExtension:".json")!
            self.questionGroups = try! DiskCaretacker.retrieve([QuestionGroup].self,
                                                              from: url)
            
            try! saveQuestionGroups()
        }
    }

    public func saveQuestionGroups() throws {
        
        try DiskCaretacker.save(questionGroups, to: fileName)
    }
}

