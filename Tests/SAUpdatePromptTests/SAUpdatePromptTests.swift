import XCTest
@testable import SAUpdatePrompt

final class UpdatePromptTests: XCTestCase {
  
  func testPromptCreation() {
    let sut = UpdatePrompt()
    
    sut.showPrompt(title: "Test Prompt", message: "Hello there.") {
      print("derp")
    } updateAction: {
      print("derp")
    }
    
  }
  
}
