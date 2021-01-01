import Foundation

typealias LogicClosure = (Bool, Bool?) -> Void

protocol LogicProtocol {
  func check(for bundleIdentifier: String, currentVersion: String, completion: @escaping LogicClosure)
}

struct Logic: LogicProtocol {
  let service: AppVersionServiceProtocol
  
  var forceMajorUpgrades: Bool = true
  
  func check(for bundleIdentifier: String,
             currentVersion: String,
             completion: @escaping LogicClosure) {
    
    service.check(for: bundleIdentifier) { result in
      switch result {
      case .failure: completion(false, nil)
      case let .success(storeResult):
      
        let result = compareNumeric(currentVersion, storeResult.version)
        
        switch result {
        case .orderedAscending:
          
          let currentSplit = currentVersion.split(separator: ".")
          let storeSplit = storeResult.version.split(separator: ".")
          
          if currentSplit[0] < storeSplit[0] &&
              forceMajorUpgrades {
            completion(true, forceMajorUpgrades)
            return
          }
          completion(true, nil)
          
        default: completion(false, nil)
        }
        
      }
    }
    
  }
  
}

extension Logic {
 
  func compareNumeric(_ version1: String, _ version2: String) -> ComparisonResult {
    return version1.compare(version2, options: .numeric)
  }
  
}
