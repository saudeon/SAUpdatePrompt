import UIKit

public typealias cancelAction = (() -> Void)?
public typealias updateAction = (() -> Void)?

public struct SAUpdatePrompt {
  
  public init() {}
  
  public func showPrompt(title: String,
                         message: String,
                         cancelAction: cancelAction,
                         updateAction: updateAction) {
    
    guard let bundleInfo = Bundle.main.infoDictionary,
          let bundleIdentifier = bundleInfo["CFBundleIdentifier"] as? String,
          let currentVersion = bundleInfo["CFBundleShortVersionString"] as? String else { return }
    
    Network.check(for: bundleIdentifier,
                  currentVersion: currentVersion) { result in
      
      // TODO: Define visually how we want this to look.
      
    }
    
  }
  
}
