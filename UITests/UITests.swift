import XCTest

class UITests: XCTestCase {
  
  var app: XCUIApplication!
  
  override class var runsForEachTargetApplicationUIConfiguration: Bool {
    true
  }
  
  override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launch()
  }
  
  override func tearDown() {
    if let failureCount = testRun?.failureCount, failureCount > 0 {
      let screenshot = XCUIScreen.main.screenshot()
      let attachment = XCTAttachment(screenshot: screenshot)
      add(attachment)
    }
  }
  
  func testCalculateMarkFromTextEntry() throws {
    let totalPointsField = app.textFields["totalPointsField"]
    totalPointsField.tap()
    totalPointsField.typeText("10")
    
    let reachedPointsField = app.textFields["reachedPointsField"]
    reachedPointsField.tap()
    reachedPointsField.typeText("5")
    
    let markText = app.staticTexts["markText"]
    XCTAssertTrue(markText.waitForExistence(timeout: 5))
    XCTAssertEqual("3.50", markText.label)
  }

  func testClear() throws {
    let totalPointsField = app.textFields["totalPointsField"]
    totalPointsField.tap()
    totalPointsField.typeText("10")
    
    let reachedPointsField = app.textFields["reachedPointsField"]
    reachedPointsField.tap()
    reachedPointsField.typeText("10")

    let markText = app.staticTexts["markText"]
    XCTAssertTrue(markText.waitForExistence(timeout: 5))
    XCTAssertEqual("1.00", markText.label)
    
    let clearButton = app.buttons["clearButton"]
    clearButton.tap()

    XCTAssertTrue(totalPointsField.waitForExistence(timeout: 5))
    XCTAssertEqual("", totalPointsField.label)
  }
  
}
