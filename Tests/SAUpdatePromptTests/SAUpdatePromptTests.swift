import XCTest
@testable import SAUpdatePrompt

final class SAUpdatePromptTests: XCTestCase {
  
  func testPromptCreation() {
    let sut = SAUpdatePrompt()
    
    sut.showPrompt(title: "Test Prompt", message: "Hello there.") {
      print("derp")
    } updateAction: {
      print("derp")
    }
    
  }
  
}
