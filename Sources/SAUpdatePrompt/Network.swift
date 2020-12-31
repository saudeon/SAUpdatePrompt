import Foundation

fileprivate struct BundleLookupResponse: Codable {
  
  struct StoreResult: Codable {
    let version: String
    let bundleId: String
  }
  
  let resultCount: Int
  let results: [StoreResult]
}

internal enum NetworkError: LocalizedError {
  case generic(Error)
  case noResults
}

internal enum Network {
 
  static func check(for bundleIdentifier: String,
                    currentVersion: String,
                    completion: @escaping (Result<(Bool, String?), NetworkError>) -> Void) {
    
    guard let lookupUrl = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleIdentifier)") else { return }
    
    let request = URLRequest(url: lookupUrl)
    
    // Build up the completion handler.
    let completionHandler: (Data?, URLResponse?, Error?) -> Void = { (data, response, error) in
      
      if let error = error {
        // We want to return a failure to completion handler.
        completion(.failure(.generic(error)))
        return
      }
      
      if let data = data {
        do {
          let response = try JSONDecoder().decode(BundleLookupResponse.self, from: data)
          
          // TODO: Provide better contextual error handling.
          guard response.resultCount >= 1, response.results.count > 0 else {
            completion(.failure(.noResults))
            return
          }
          
          // If we have more than one match for the bundle identifier, we want to get the correct application.
          guard let storeResult = response.results.first(where: { result in
            return result.bundleId == bundleIdentifier
          }) else {
            completion(.failure(.noResults))
            return
          }
          
          func compareNumeric(_ version1: String, _ version2: String) -> ComparisonResult {
            return version1.compare(version2, options: .numeric)
          }
          
          switch compareNumeric(currentVersion, storeResult.version) {
          case .orderedAscending: completion(.success((true, storeResult.version)))
          case .orderedDescending, .orderedSame: completion(.success((false, nil)))
          }
          
        } catch let error {
          completion(.failure(.generic(error)))
        }
      }
      
    }
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
    
  }
  
}
