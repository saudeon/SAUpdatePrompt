import XCTest
@testable import SAUpdatePrompt

final class SAUpdatePromptTests: XCTestCase {
  
  func testPromptCreation() {
    var sut = SAUpdatePrompt()
    sut.forceMajorUpgrade(false)
    
    XCTAssertFalse(sut.logic.forceMajorUpgrades)
    
    sut.showPrompt(title: "Test Prompt", message: "Hello there.") {
      print("derp")
    } updateAction: {
      print("derp")
    }
    
  }
  
}
