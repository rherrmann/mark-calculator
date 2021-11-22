import Foundation

struct SnapshotModel: Codable {

  var totalPoints: String
  var reachedPoints: String
  
  static func load() throws -> SnapshotModel {
    let dataUrl = try dataUrl()
    if !FileManager.default.fileExists(atPath: dataUrl.path) {
      return SnapshotModel(totalPoints: "", reachedPoints: "")
    }
    let data: Data = try Data(contentsOf: dataUrl)
    return try JSONDecoder().decode(SnapshotModel.self, from: data)
  }
  
  func save() throws {
    let json = try JSONEncoder().encode(self)
    try json.write(to: Self.dataUrl())
  }
  
  private static func dataUrl() throws -> URL {
    let folderUrl = try FileManager.default.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: true
    )
    return folderUrl.appendingPathComponent("snapshot.json")
  }

}
