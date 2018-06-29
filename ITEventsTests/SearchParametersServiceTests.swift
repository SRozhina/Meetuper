import XCTest
@testable import ITEvents

class SearchParametersServiceTests: XCTestCase {
    let selectedTags = [Tag(id: 1, name: "JavaScript"),
                        Tag(id: 2, name: "iOS")]
    let otherTags = [Tag(id: 3, name: "Android"),
                     Tag(id: 4, name: "Python")]
    
    override func setUp() { }

    override func tearDown() { }

    func testSearchParametersService() {
        let searchParametersService = SearchParametersService()
        searchParametersService.selectedTags = selectedTags
        searchParametersService.otherTags = otherTags
        XCTAssertEqual(searchParametersService.selectedTags, selectedTags)
        XCTAssertEqual(searchParametersService.otherTags, otherTags)
    }
}
