//
//  MovieQuizTestsUI.swift
//  MovieQuizTestsUI
//
//  Created by Aleksey Kosichenko on 09.05.2026.
//

import XCTest

final class MovieQuizTestsUI: XCTestCase {
    
    var app: XCUIApplication!
    
    
    
    

    override func setUpWithError() throws {
        
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false

        
    }

    override func tearDownWithError() throws {
        
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
  
    func testYesButton() {
        
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        
       
        
    }
    
    func testNoButton() {
        
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(secondPosterData, firstPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    
    func testEndGameAlert() {
        
        sleep(2)
        
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["GameResults"]
    
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть ещё раз" )
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

   
}
