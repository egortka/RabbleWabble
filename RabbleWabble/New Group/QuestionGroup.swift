//
//  QuestionGroup.swift
//  RabbleWabble
//
//  Created by Egor Tkachenko on 15/11/2019.
//  Copyright © 2019 ET. All rights reserved.
//

import Foundation

public class QuestionGroup: Codable {
    
    public class Score: Codable {
        public var correctCount: Int = 0
        public var incorrectCount: Int = 0
        
    }
    
    public let questions: [Question]
    public let score: Score
    public let title: String
    
    init(questions: [Question],
         score: Score = Score(),
         title: String) {
        
        self.questions = questions
        self.score = score
        self.title = title
    }
}
