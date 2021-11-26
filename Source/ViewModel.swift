import Foundation
import Combine
import SwiftUI

struct CalculatorViewModel {
  var totalPointsString: String = "" {
    didSet {
      updateMark()
    }
  }
  
  var reachedPointsString: String = "" {
    didSet {
      updateMark()
    }
  }
  
  var totalPoints: Float? {
    Self.toFloat(totalPointsString)
  }
  
  var reachedPoints: Float? {
    Self.toFloat(reachedPointsString)
  }
  
  var notification: LocalizedStringKey? = nil
  var mark: Float = 0
  
  var markString: String {
    mark == 0 ? " " : Self.toString(mark)
  }
  
  init() {
    self.init(totalPoints: "", reachedPoints: "")
  }
  
  init(totalPoints: String, reachedPoints: String) {
    self.totalPointsString = totalPoints
    self.reachedPointsString = reachedPoints
    updateMark()
  }
  
  mutating func stepTotalPoints(_ stepWidth: Float) {
    if let totalPoints = totalPoints, totalPoints + stepWidth >= 0 {
      totalPointsString = totalPoints + stepWidth == 0 ? "" : Self.toString(totalPoints + stepWidth)
    } else if totalPointsString.trimmingCharacters(in: .whitespaces).isEmpty && stepWidth > 0 {
      totalPointsString = Self.toString(1.0)
    }
  }
  
  mutating func stepReachedPoints(_ stepWidth: Float) {
    if reachedPointsString.trimmingCharacters(in: .whitespaces).isEmpty && stepWidth > 0 {
      reachedPointsString = Self.toString(0.0)
    } else if let reachedPoints = reachedPoints, reachedPoints + stepWidth >= 0 {
      reachedPointsString = Self.toString(reachedPoints + stepWidth)
    }
  }
  
  private mutating func updateMark() {
    if totalPointsString.isEmpty && reachedPointsString.isEmpty {
      mark = 0
      notification = nil
      return
    }
    guard let totalPoints = Self.toFloat(totalPointsString) else {
      notify(".invalid.total.points")
      return
    }
    guard let reachedPoints = Self.toFloat(reachedPointsString) else {
      notify(".invalid.reached.points")
      return
    }
    if totalPoints <= 0 {
      notify(".invalid.total.points")
      return
    }
    if reachedPoints < 0 {
      notify(".invalid.reached.points")
      return
    }
    if reachedPoints > totalPoints {
      notify(".invalid.reached.greater.than.total")
      return
    }
    let m = 6.0 - (5.0 * reachedPoints / totalPoints)
    mark = round(m * 10.0) / 10.0
    notification = nil
  }
  
  private mutating func notify(_ message: String) {
    mark = 0
    notification = LocalizedStringKey(message)
  }
  
  private static func toFloat(_ string: String) -> Float? {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    let number = numberFormatter.number(from: string.trimmingCharacters(in: .whitespaces))
    return number?.floatValue
  }

  private static func toString(_ float: Float) -> String {
    String(format: "%0.1f", locale: Locale.current, arguments: [float])
  }
  
}

