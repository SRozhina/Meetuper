import XCTest
@testable import ITEvents

class SearchParametersServiceTests: XCTestCase {
    var searchParametersService: SearchParametersService!
    
    override func setUp() {
        super.setUp()
        searchParametersService = SearchParametersService()

    }

    override func tearDown() {
        super.tearDown()
        searchParametersService = nil
    }

    func testSearchParametersService() {
        let selectedTags = [Tag(id: 1, name: "JavaScript"),
                            Tag(id: 2, name: "iOS")]
        let otherTags = [Tag(id: 3, name: "Android"),
                         Tag(id: 4, name: "Python")]
        
        searchParametersService.selectedTags = selectedTags
        searchParametersService.otherTags = otherTags
        
        XCTAssertEqual(searchParametersService.selectedTags, selectedTags)
        XCTAssertEqual(searchParametersService.otherTags, otherTags)
    }
}
