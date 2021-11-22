import Foundation
import SwiftUI

extension View {
  func withAlertHandler() -> some View {
    modifier(AlertViewModifier())
  }
}

class AlertHandler: ObservableObject {
  @Published var currentAlert: AlertInfo?
  
  func handle(_ error: Error) {
    currentAlert = AlertInfo(title: "Error", message: error.localizedDescription)
  }
  
  func handle(_ title: String, _ errorMessage: String) {
    currentAlert = AlertInfo(title: title, message: errorMessage)
  }
}

struct AlertViewModifier: ViewModifier {
  @StateObject var alertHandler = AlertHandler()
  
  func body(content: Content) -> some View {
    content
      .environmentObject(alertHandler)
      // Applying the alert using a background element is a workaround, if the alert would be
      // applied directly, other .alert modifiers inside of content would not work anymore
      .background(
        EmptyView()
          .alert(item: $alertHandler.currentAlert) { currentAlert in
            Alert(title: Text(currentAlert.title), message: Text(currentAlert.message), dismissButton: .default(Text("OK")) {
              if let dismissAction = currentAlert.dismissAction {
                dismissAction()
              }
            })
          }
      )
  }
}

struct AlertInfo: Identifiable {
  var id = UUID()
  var title: String
  var message: String
  var dismissAction: (() -> Void)?
}
