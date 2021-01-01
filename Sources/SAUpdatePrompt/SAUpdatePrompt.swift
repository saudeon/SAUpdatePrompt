import UIKit

public typealias cancelAction = (() -> Void)?
public typealias updateAction = (() -> Void)?

public struct SAUpdatePrompt {
  
  static let instance = SAUpdatePrompt()
  
  let logic: Logic
  
  init(_ logic: Logic = .init(service: AppVersionService())) {
    self.logic = logic
  }
  
  public func showPrompt(title: String,
                         message: String,
                         fullscreen: Bool? = false,
                         forceMajor: Bool? = true,
                         cancelAction: cancelAction,
                         updateAction: updateAction) {
    
    guard let bundleInfo = Bundle.main.infoDictionary,
          let bundleIdentifier = bundleInfo["CFBundleIdentifier"] as? String,
          let currentVersion = bundleInfo["CFBundleShortVersionString"] as? String else { return }
    
    logic.check(for: bundleIdentifier,
                currentVersion: currentVersion) { (updateAvailable, forceUpgrade) in
      
    }
    
  }
  
}
