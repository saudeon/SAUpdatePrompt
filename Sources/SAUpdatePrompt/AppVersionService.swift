import Foundation

internal enum AppVersionServiceError: LocalizedError {
  case generic(Error)
  case noResults
  case noUpgradeAvailable
}

typealias AppVersionCompletionClosure = (Result<StoreResult, AppVersionServiceError>) -> Void

protocol AppVersionServiceProtocol {
  func check(for bundleIdentifier: String, completion: @escaping AppVersionCompletionClosure)
}

class AppVersionService: AppVersionServiceProtocol {
  
  func check(for bundleIdentifier: String,
                    completion: @escaping AppVersionCompletionClosure) {
    
    guard let lookupUrl = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleIdentifier)") else { return }
    let request = URLRequest(url: lookupUrl)
    
    let completionHandler: (Data?, URLResponse?, Error?) -> Void = { (data, response, error) in
      
      if let error = error {
        completion(.failure(.generic(error)))
        return
      }
      
      if let data = data {
        do {
          let response = try JSONDecoder().decode(AppVersionResponse.self, from: data)
          
          guard response.resultCount >= 1, response.results.count > 0 else {
            completion(.failure(.noResults))
            return
          }
          
          guard let storeResult = response.results.first(where: { result in
            return result.bundleId == bundleIdentifier
          }) else {
            completion(.failure(.noResults))
            return
          }
          
          completion(.success(storeResult))
          
        } catch let error {
          completion(.failure(.generic(error)))
        }
      }
      
    }
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
    
  }
  
}
