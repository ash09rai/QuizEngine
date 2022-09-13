//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by Ashish Rai on 13/09/22.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {
    
    func test_start_WithNoQuestion_DoesNotRouteToQuestion() {
        let router = RouterSpy()
        let sut = Flow(router: router, question: [])
        
        sut.start()
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_WithOneQuestion_RouteToCorrectQuestion() {
        let router = RouterSpy()
        let sut = Flow(router: router, question: ["Q1"])
        
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_WithOneQuestion_RouteToCorrectQuestion2() {
        let router = RouterSpy()
        let sut = Flow(router: router, question: ["Q2"])
        
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }
    
    func test_start_WithTwoQuestion_RouteToFirstQuestion() {
        let router = RouterSpy()
        let sut = Flow(router: router, question: ["Q1","Q2"])
        
        sut.start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_WithTwoQuestion_RouteToFirstQuestion() {
        let router = RouterSpy()
        let sut = Flow(router: router, question: ["Q1","Q2"])

        sut.start()
        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstQuiestion_WithTwoQuestion_RouteToSecondQuestion() {
        let router = RouterSpy()
        let sut = Flow(router: router, question: ["Q1","Q2"])

        sut.start()
        router.answerCallback("A1")
        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2"])
    }
    
    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var answerCallback: ((String) -> Void) = {_ in}

        func route(to question: String, answerCallback: @escaping((String) -> Void)) {
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
    }
    
}
