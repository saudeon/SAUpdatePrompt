import UIKit

public typealias cancelAction = (() -> Void)?
public typealias updateAction = (() -> Void)?

public struct SAUpdatePrompt {
  
  static var instance = SAUpdatePrompt()
  
  var logic: Logic
  
  init(_ logic: Logic = .init(service: AppVersionService())) {
    self.logic = logic
  }
  
  public func showPrompt(title: String,
                         message: String,
                         fullscreen: Bool = false,
                         forceMajor: Bool = true,
                         cancelAction: cancelAction,
                         updateAction: updateAction) {
    
    guard let bundleInfo = Bundle.main.infoDictionary,
          let bundleIdentifier = bundleInfo["CFBundleIdentifier"] as? String,
          let currentVersion = bundleInfo["CFBundleShortVersionString"] as? String else { return }
    
    SAUpdatePrompt.instance.logic.forceMajorUpgrades = forceMajor
    
    logic.check(for: bundleIdentifier, currentVersion: currentVersion) { response in
      
      if !response.upgradeAvailable {
        print("No Upgrade Available")
        return
      }
      
      if response.upgradeAvailable && response.forceUpgrade {
        print("Force Upgrade Prompt")
        return
      }
      
      print("Soft Upgrade Prompt")
      
    }
    
  }
  
}
