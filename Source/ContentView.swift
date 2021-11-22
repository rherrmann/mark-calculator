import os.log
import Combine
import SwiftUI

struct ContentView: View {
  @State var model = CalculatorViewModel()
  
  private let log = Logger()
  @EnvironmentObject private var alertHandler: AlertHandler
  @State private var usePortraitLayout = isDeviceOrientationPortrait()

  var body: some View {
    NavigationView {
      Group {
        if usePortraitLayout {
          VStack {
            pointsGroupBox()
            Text("=").font(.largeTitle)
            markGroupBox()
            Spacer()
          }
        } else {
          HStack(alignment: .top) {
            pointsGroupBox()
            Text("=").font(.largeTitle)
            markGroupBox()
          }
        }
      }
      .padding()
      .navigationTitle(".app.title")
      .navigationBarTitleDisplayMode(.large)
      .navigationBarBackButtonHidden(true)
      .onAppear(perform: loadSnapshot)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(role: .destructive, action: { model = CalculatorViewModel() }) {
            Image(systemName: "clear")
          }
          .accessibilityIdentifier("clearButton")
        }
      }
    }
    .navigationViewStyle(.stack)
    .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
      self.usePortraitLayout = Self.isDeviceOrientationPortrait()
    }
  }

  @ViewBuilder
  private func pointsGroupBox() -> some View {
    let columns = [
      GridItem(.flexible(), spacing: 5, alignment: .leading),
      GridItem(.flexible(), spacing: 5, alignment: .leading),
      GridItem(.flexible(), spacing: 5, alignment: .leading),
    ]
    GroupBox(label: Text("Number of Points").lineLimit(1)) {
      LazyVGrid(columns: columns) {
        Text("Total")
          .padding(.trailing, 10)
        numericTextField(text: $model.totalPointsString)
          .accessibilityIdentifier("totalPointsField")
          .onReceive(Just(model.totalPointsString)) { newValue in
            model.totalPointsString = newValue
            saveSnapshot()
          }
        Stepper("", onIncrement: { model.stepTotalPoints(+1) }, onDecrement: { model.stepTotalPoints(-1) })
          .accessibilityIdentifier("totalPointsStepper")
        Text("")
        Text("")
        Text("")
        Text("Actual")
          .padding(.trailing, 10)
        numericTextField(text: $model.reachedPointsString)
          .accessibilityIdentifier("reachedPointsField")
          .onReceive(Just(model.reachedPointsString)) { newValue in
            model.reachedPointsString = newValue
            saveSnapshot()
          }
        Stepper("", onIncrement: { model.stepReachedPoints(+1) }, onDecrement: { model.stepReachedPoints(-1) })
          .accessibilityIdentifier("reachedPointsStepper")
      }
      if let notification = model.notification {
        Text(notification).foregroundColor(.orange)
      } else {
        Text(" ")
      }
    }
  }
  
  @ViewBuilder
  private func markGroupBox() -> some View {
    GroupBox(label: markGroupHeader()) {
      Text("\(model.mark == 0 ? " " : String(format: "%0.2f", model.mark))")
        .accessibilityIdentifier("markText")
        .font(.largeTitle).padding()
    }
  }
  
  @ViewBuilder
  private func markGroupHeader() -> some View {
    // TODO try to show gauge and gauge.badge.minus (if no mark can be computed)
    HStack {
      Label("Mark", systemImage: "checkmark.seal").lineLimit(1)
      Spacer()
      Button(action: showMarkFormula) {
        Image(systemName: "info.circle")
      }
    }
  }

  @ViewBuilder
  private func numericTextField(text: Binding<String>) -> some View {
    TextField("", text: text)
      .keyboardType(.numbersAndPunctuation)
      .padding(5)
      .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color.black, style: StrokeStyle(lineWidth: 1)))
      .multilineTextAlignment(.trailing)
      .keyboardType(.numbersAndPunctuation)
  }
  
  private func showMarkFormula() {
    alertHandler.handle("Information", LocalizedStringKey(".formula.info").stringValue())
  }
  
  private func loadSnapshot() {
    do {
      let snapshot = try SnapshotModel.load()
      model = CalculatorViewModel(totalPoints: snapshot.totalPoints, reachedPoints: snapshot.reachedPoints)
    } catch {
      log.error("Failed to load snapshot: \(String(describing: error))")
      alertHandler.handle(error)
    }
  }
  
  private func saveSnapshot() {
    do {
      try SnapshotModel(totalPoints: model.totalPointsString, reachedPoints: model.reachedPointsString).save()
    } catch {
      log.error("Failed to save snapshot: \(String(describing: error))")
      alertHandler.handle(error)
    }
  }
  
  private static func isDeviceOrientationPortrait() -> Bool {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return true }
    return windowScene.interfaceOrientation.isPortrait
  }
}

extension LocalizedStringKey {
  var stringKey: String {
    let description = "\(self)"
    
    let components = description.components(separatedBy: "key: \"")
      .map { $0.components(separatedBy: "\",") }
    
    return components[1][0]
  }
}

extension String {
  static func localizedString(for key: String,
                              locale: Locale = .current) -> String {
    
    let language = locale.languageCode
    let path = Bundle.main.path(forResource: language, ofType: "lproj")!
    let bundle = Bundle(path: path)!
    let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")
    
    return localizedString
  }
}

extension LocalizedStringKey {
  func stringValue(locale: Locale = .current) -> String {
    return .localizedString(for: self.stringKey, locale: locale)
  }
}
