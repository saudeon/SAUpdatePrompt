import Foundation

internal struct LogicStruct {
  let upgradeAvailable: Bool
  let forceUpgrade: Bool
  let nextVersion: String
}

typealias LogicClosure = (LogicStruct) -> Void

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
      case .failure: completion(.init(upgradeAvailable: false, forceUpgrade: false, nextVersion: currentVersion))
      case let .success(storeResult):
      
        let result = compareNumeric(currentVersion, storeResult.version)
        
        switch result {
        case .orderedAscending:
          
          let currentSplit = currentVersion.split(separator: ".")
          let storeSplit = storeResult.version.split(separator: ".")
          
          if currentSplit[0] < storeSplit[0] {
            completion(.init(upgradeAvailable: true, forceUpgrade: forceMajorUpgrades, nextVersion: storeResult.version))
            return
          }
          completion(.init(upgradeAvailable: true, forceUpgrade: false, nextVersion: storeResult.version))
        default: completion(.init(upgradeAvailable: false, forceUpgrade: false, nextVersion: storeResult.version))
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
