import XCTest
@testable import SAUpdatePrompt

final class NetworkTests: XCTestCase {
  
  private let defaultExpectationHandler: XCWaitCompletionHandler = { (error) in
    if error != nil {
      XCTFail("Expectations Timeout")
    }
  }
  
  func testVersionCheck() {
    
    let checkExpectation = expectation(description: "Waiting for check result")
    
    Network.check(for: "co.laudeon.Sage",
                  currentVersion: "1.0.0") { result in
      switch result {
      case .success:
        checkExpectation.fulfill()
      default: return
      }
      
    }
    
    waitForExpectations(timeout: 5, handler: defaultExpectationHandler)
    
  }
  
}
