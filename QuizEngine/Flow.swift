//
//  Flow.swift
//  QuizEngine
//
//  Created by Ashish Rai on 13/09/22.
//

import Foundation

protocol Router{
    typealias AnswerCallback = (String) -> Void
    func route(to question: String, answerCallback: @escaping AnswerCallback)
}

class Flow {
    private let router: Router
    private let question: [String]
    
    init(router: Router, question: [String]) {
        self.router = router
        self.question = question
    }
    
    func start() {
        if let firstQuestion = question.first {
            router.route(to: firstQuestion, answerCallback: routeNext(from: firstQuestion))
        }
    }
    
    private func routeNext(from question: String) -> Router.AnswerCallback {
        return { [weak self] _ in
            guard let strongSelf = self,
                  let indexOfQuestion = strongSelf.question.firstIndex(of: question),
                  indexOfQuestion + 1 < strongSelf.question.count
            else {return}
            let nextQuestion = strongSelf.question[indexOfQuestion + 1]
            strongSelf.router.route(to: nextQuestion,
                                    answerCallback: strongSelf.routeNext(from: nextQuestion))
        }
    }
}
    
