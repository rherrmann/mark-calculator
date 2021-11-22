import XCTest
@testable import Mark_Calculator
import SwiftUI

class ViewModelTests: XCTestCase {
  
  func testTotalPoints_valid() throws {
    let viewModel = CalculatorViewModel(totalPoints: "10", reachedPoints: "5")
    
    XCTAssertEqual(10, viewModel.totalPoints)
  }
  
  func testTotalPoints_invalid() throws {
    let viewModel = CalculatorViewModel(totalPoints: "bad", reachedPoints: "5")
    
    XCTAssertEqual(nil, viewModel.totalPoints)
  }
  
  func testTotalPoints_clearsMarkWhenInvalid() throws {
    var viewModel = CalculatorViewModel(totalPoints: "10", reachedPoints: "5")
    
    viewModel.totalPointsString = "bad"
    
    XCTAssertEqual(nil, viewModel.totalPoints)
    XCTAssertEqual(0, viewModel.mark)
    XCTAssertEqual(LocalizedStringKey(".invalid.total.points"), viewModel.notification)
  }
  
  func testReachedPoints_valid() throws {
    let viewModel = CalculatorViewModel(totalPoints: "10", reachedPoints: "5")
    
    XCTAssertEqual(5, viewModel.reachedPoints)
  }
  
  func testReachedPoints_clearsMarkWhenInvalid() throws {
    var viewModel = CalculatorViewModel(totalPoints: "10", reachedPoints: "5")
    
    viewModel.reachedPointsString = "bad"
    
    XCTAssertEqual(nil, viewModel.reachedPoints)
    XCTAssertEqual(0, viewModel.mark)
    XCTAssertEqual(LocalizedStringKey(".invalid.reached.points"), viewModel.notification)
  }
  
  func testReachedPoints_invalid() throws {
    let viewModel = CalculatorViewModel(totalPoints: "10", reachedPoints: "bad")
    
    XCTAssertEqual(nil, viewModel.reachedPoints)
  }
  
  func testMark_validPoints() throws {
    let viewModel = CalculatorViewModel(totalPoints: "10", reachedPoints: "5")
    
    XCTAssertEqual(3.5, viewModel.mark)
    XCTAssertEqual(nil, viewModel.notification)
  }
  
  func testMark_increasingReachedPoints() throws {
    var viewModel = CalculatorViewModel(totalPoints: "10", reachedPoints: "0")
    
    for reached in 1...10 {
      viewModel.reachedPointsString = String(reached)
      XCTAssert(viewModel.mark >= 1)
      XCTAssert(viewModel.mark <= 6)
      XCTAssertEqual(nil, viewModel.notification)
    }
  }
  
  func testMark_emptyPoints() throws {
    let viewModel = CalculatorViewModel(totalPoints: "", reachedPoints: "")
    
    XCTAssertEqual(0, viewModel.mark)
    XCTAssertEqual(nil, viewModel.notification)
  }
  
  func testMark_invalidTotalPoints() throws {
    let viewModel = CalculatorViewModel(totalPoints: "bad", reachedPoints: "5")
    
    XCTAssertEqual(0, viewModel.mark)
    XCTAssertEqual(LocalizedStringKey(".invalid.total.points"), viewModel.notification)
  }
  
  func testMark_zeroTotalPoints() throws {
    let viewModel = CalculatorViewModel(totalPoints: "0", reachedPoints: "5")
    
    XCTAssertEqual(0, viewModel.mark)
    XCTAssertEqual(LocalizedStringKey(".invalid.total.points"), viewModel.notification)
  }
  
  func testMark_invalidReachedPoints() throws {
    let viewModel = CalculatorViewModel(totalPoints: "10", reachedPoints: "bad")
    
    XCTAssertEqual(0, viewModel.mark)
    XCTAssertEqual(LocalizedStringKey(".invalid.reached.points"), viewModel.notification)
  }
  
  func testMark_reachedGreaterThanTotal() throws {
    let viewModel = CalculatorViewModel(totalPoints: "5", reachedPoints: "6")
    
    XCTAssertEqual(0, viewModel.mark)
    XCTAssertEqual(LocalizedStringKey(".invalid.reached.greater.than.total"), viewModel.notification)
  }
  
  func testMark_zeroReachedPoints() throws {
    let viewModel = CalculatorViewModel(totalPoints: "1", reachedPoints: "0")
    
    XCTAssertEqual(6, viewModel.mark)
    XCTAssertEqual(nil, viewModel.notification)
  }
  
  func testStepTotalPoints_emptyPlusOne() {
    var viewModel = CalculatorViewModel(totalPoints: "", reachedPoints: "")
    
    viewModel.stepTotalPoints(1)
    
    XCTAssertEqual(1, viewModel.totalPoints)
    XCTAssertEqual("1.0", viewModel.totalPointsString)
  }
  
  func testStepTotalPoints_emptyMinusOne() {
    var viewModel = CalculatorViewModel(totalPoints: "", reachedPoints: "")
    
    viewModel.stepTotalPoints(-1)
    
    XCTAssertEqual(nil, viewModel.totalPoints)
    XCTAssertEqual("", viewModel.totalPointsString)
  }
  
  func testStepTotalPoints_oneMinusOne() {
    var viewModel = CalculatorViewModel(totalPoints: "1", reachedPoints: "")
    
    viewModel.stepTotalPoints(-1)
    
    XCTAssertEqual(nil, viewModel.totalPoints)
    XCTAssertEqual("", viewModel.totalPointsString)
  }
  
  func testStepReachedPoints_emptyPlusOne() {
    var viewModel = CalculatorViewModel(totalPoints: "", reachedPoints: "")
    
    viewModel.stepReachedPoints(1)
    
    XCTAssertEqual(0, viewModel.reachedPoints)
    XCTAssertEqual("0.0", viewModel.reachedPointsString)
  }
  
  func testStepReachedPoints_emptyMinusOne() {
    var viewModel = CalculatorViewModel(totalPoints: "", reachedPoints: "")
    
    viewModel.stepReachedPoints(-1)
    
    XCTAssertEqual(nil, viewModel.reachedPoints)
    XCTAssertEqual("", viewModel.reachedPointsString)
  }
  
  func testStepReachedPoints_oneMinusOne() {
    var viewModel = CalculatorViewModel(totalPoints: "", reachedPoints: "1")
    
    viewModel.stepReachedPoints(-1)
    
    XCTAssertEqual(0, viewModel.reachedPoints)
    XCTAssertEqual("0.0", viewModel.reachedPointsString)
  }
  
  func testStepReachedPoints_zeroMinusOne() {
    var viewModel = CalculatorViewModel(totalPoints: "", reachedPoints: "0.0")
    
    viewModel.stepReachedPoints(-1)
    
    XCTAssertEqual(0, viewModel.reachedPoints)
    XCTAssertEqual("0.0", viewModel.reachedPointsString)
  }
  
}
