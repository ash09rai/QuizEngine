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
    let router = RouterSpy()
    
    func test_start_WithNoQuestion_DoesNotRouteToQuestion() {
        makeSUT([]).start()
        XCTAssertTrue(router.routedQuestions.isEmpty)
    }
    
    func test_start_WithOneQuestion_RouteToCorrectQuestion() {
        makeSUT(["Q1"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_start_WithOneQuestion_RouteToCorrectQuestion2() {
        makeSUT(["Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q2"])
    }
    
    func test_start_WithTwoQuestion_RouteToFirstQuestion() {
        makeSUT(["Q1","Q2"]).start()
        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    func test_startTwice_WithTwoQuestion_RouteToFirstQuestion() {
        let sut = makeSUT(["Q1","Q2"])
        sut.start()
        sut.start()

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q1"])
    }
   
    func test_startAndAnswerFirstAndSecondQuestion_WithThreeQuestion_RouteToFirstAndSecondQuestion() {
        let sut = makeSUT(["Q1","Q2","Q3"])
        sut.start()
        router.answerCallback("A1")
        router.answerCallback("A2")

        XCTAssertEqual(router.routedQuestions, ["Q1", "Q2","Q3"])
    }
    
    func test_startAndAnswerFirst_WithOneQuestion_DoesNotRouteToAnotherQuestion() {
        let sut = makeSUT(["Q1"])
        sut.start()
        router.answerCallback("A1")

        XCTAssertEqual(router.routedQuestions, ["Q1"])
    }
    
    // MARK: Helper methods
    private func makeSUT(_ question: [String]) -> Flow {
        Flow(router: router, question: question)
    }

    class RouterSpy: Router {
        var routedQuestions: [String] = []
        var answerCallback: AnswerCallback = {_ in}

        func route(to question: String, answerCallback: @escaping AnswerCallback) {
            routedQuestions.append(question)
            self.answerCallback = answerCallback
        }
    }
    
}
