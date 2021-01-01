import XCTest
@testable import SAUpdatePrompt

fileprivate struct MockAppVersionService: AppVersionServiceProtocol {
  
  let nextVersion: String
  let minimumOsVersion: String
  
  func check(for bundleIdentifier: String,
             completion: @escaping AppVersionCompletionClosure) {
    
    completion(.success(.init(version: nextVersion, bundleId: "com.saupdateprompt.test", minimumOsVersion: minimumOsVersion)))
    
  }
  
}

final class LogicTests: XCTestCase {
  
  private let defaultExpectationHandler: XCWaitCompletionHandler = { (error) in
    if error != nil {
      XCTFail("Expectations Timeout")
    }
  }
  
  func testLogicForceUpgrade() {
    
    let testExpectation = expectation(description: "Waiting for force upgrade")
    
    let service = MockAppVersionService(nextVersion: "2.0.0", minimumOsVersion: "13.0")
    let sut = Logic(service: service)
    
    sut.check(for: "com.saupdateprompt.test", currentVersion: "1.0.0") { (available, forceUpgrade) in
      if available && forceUpgrade == true { testExpectation.fulfill() }
    }
    
    waitForExpectations(timeout: 5, handler: defaultExpectationHandler)
    
  }
  
  func testLogicSoftUpgrade() {
    
    let testExpectation = expectation(description: "Waiting for soft upgrade")
    
    let service = MockAppVersionService(nextVersion: "1.2.0", minimumOsVersion: "13.0")
    let sut = Logic(service: service)
    
    sut.check(for: "com.saupdateprompt.test", currentVersion: "1.0.0") { (available, forceUpgrade) in
      if available && forceUpgrade == nil { testExpectation.fulfill() }
    }
    
    waitForExpectations(timeout: 5, handler: defaultExpectationHandler)
    
  }
  
  func testLogicNoUpgradeAvailable() {
    
    let testExpectation = expectation(description: "Waiting for no upgrade")
    
    let service = MockAppVersionService(nextVersion: "1.2.0", minimumOsVersion: "13.0")
    let sut = Logic(service: service)
    
    sut.check(for: "com.saupdateprompt.test", currentVersion: "1.2.0") { (available, forceUpgrade) in
      if !available && forceUpgrade == nil { testExpectation.fulfill() }
    }
    
    waitForExpectations(timeout: 5, handler: defaultExpectationHandler)
    
  }
  
}
