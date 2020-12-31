import UIKit

public typealias cancelAction = (() -> Void)?
public typealias updateAction = (() -> Void)?

public struct SAUpdatePrompt {
  
  public init() {}
  
  public func showPrompt(title: String,
                         message: String,
                         fullscreen: Bool? = false,
                         forceMajor: Bool? = true,
                         cancelAction: cancelAction,
                         updateAction: updateAction) {
    
    guard let bundleInfo = Bundle.main.infoDictionary,
          let bundleIdentifier = bundleInfo["CFBundleIdentifier"] as? String,
          let currentVersion = bundleInfo["CFBundleShortVersionString"] as? String else { return }

    
    
  }
  
}
