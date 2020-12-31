import XCTest
@testable import SAUpdatePrompt

final class SAUpdatePromptTests: XCTestCase {
  
  func testPromptCreation() {
    let sut = SAUpdatePrompt()
    
    sut.showPrompt(title: "", message: "") {
      print("Cancel")
    } updateAction: {
      print("Update")
    }

  }
  
}
