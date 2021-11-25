import XCTest

class UITests: XCTestCase {
  
  var app: XCUIApplication!
  
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
    enterTotalPoints("10")
    enterReachedPoints("5")

    let markText = app.staticTexts["markText"]
    XCTAssertTrue(markText.waitForExistence(timeout: 5))
    print("locale: \(Locale.current.identifier) expected: \(decimal(3, 5)) actual: \(markText.label)")
    XCTAssertEqual(decimal(3, 5), markText.label)
  }

  func testClear() throws {
    enterTotalPoints("10")
    enterReachedPoints("10")
    
    let clearButton = app.buttons["clearButton"]
    clearButton.tap()

    XCTAssertEqual("", app.textFields["totalPointsField"].label)
    XCTAssertEqual("", app.textFields["reachedPointsField"].label)
  }
  
  func enterTotalPoints(_ value: String) {
    let textField = app.textFields["totalPointsField"]
    XCTAssertTrue(textField.waitForExistence(timeout: 5))
    textField.tap()
    textField.typeText(value)
  }
  
  func enterReachedPoints(_ value: String) {
    let textField = app.textFields["reachedPointsField"]
    XCTAssertTrue(textField.waitForExistence(timeout: 5))
    textField.tap()
    textField.typeText(value)
  }
  
  func decimal(_ preDecimal: Int, _ postDecimal: Int) -> String {
    "\(preDecimal)\(Locale.current.decimalSeparator ?? "decimal-separator")\(postDecimal)"
  }
  
}
