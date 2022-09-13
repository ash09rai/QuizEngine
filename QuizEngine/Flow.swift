//
//  Flow.swift
//  QuizEngine
//
//  Created by Ashish Rai on 13/09/22.
//

import Foundation

protocol Router{
    func route(to question: String, answerCallback: @escaping((String) -> Void))
}

class Flow {
    let router: Router
    var question: [String]
    
    init(router: Router, question: [String]) {
        self.router = router
        self.question = question
    }
    
    func start() {
        if let firstQuestion = question.first {
            router.route(to: firstQuestion) { [weak self] _ in
                if let strongSelf = self,
                   let firstQuestionIndex = strongSelf.question.firstIndex(of: firstQuestion),
                   case let secondQuestion = strongSelf.question[firstQuestionIndex + 1] {
                    strongSelf.router.route(to: secondQuestion) {_ in}
                }
            }
        }
    }
}
