import SwiftUI

@main
struct MarkCalculatorApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
      .withAlertHandler()
    }
  }
}
