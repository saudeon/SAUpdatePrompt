import Foundation

internal struct AppVersionResponse: Codable {
  let resultCount: Int
  let results: [StoreResult]
}

internal struct StoreResult: Codable {
  let version: String
  let bundleId: String
  let minimumOsVersion: String
}
