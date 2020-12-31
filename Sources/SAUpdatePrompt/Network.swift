import Foundation

fileprivate struct BundleLookupResponse: Codable {
  
  struct StoreResult: Codable {
    let version: String
    let bundleId: String
  }
  
  let resultCount: Int
  let results: [StoreResult]
}

internal enum Network {
 
  static func check(for bundleIdentifier: String,
                    currentVersion: String,
                    completion: @escaping (Result<(Bool, String?), Error>) -> Void) {
    
    guard let lookupUrl = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleIdentifier)") else { return }
    
    let request = URLRequest(url: lookupUrl)
    
    // Build up the completion handler.
    let completionHandler: (Data?, URLResponse?, Error?) -> Void = { (data, response, error) in
      
      if let error = error {
        // We want to return a failure to completion handler.
        completion(.failure(error))
        return
      }
      
      if let data = data {
        do {
          let response = try JSONDecoder().decode(BundleLookupResponse.self, from: data)
          
          func compareNumeric(_ version1: String, _ version2: String) -> ComparisonResult {
            return version1.compare(version2, options: .numeric)
          }
          
          switch compareNumeric(currentVersion, response.results[0].version) {
          case .orderedAscending: completion(.success((true, response.results[0].version)))
          case .orderedDescending, .orderedSame: completion(.success((false, nil)))
          }
          
        } catch let error {
          completion(.failure(error))
        }
      }
      
    }
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
    
  }
  
}