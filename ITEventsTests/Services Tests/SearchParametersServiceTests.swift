import XCTest
@testable import ITEvents

class SearchParametersServiceTests: XCTestCase {
    private var searchParametersService: ISearchParametersService!
    
    override func setUp() {
        super.setUp()
        searchParametersService = SearchParametersService()
    }

    override func tearDown() {
        super.tearDown()
        searchParametersService = nil
    }

    func testSearchParametersService() {
        //Given
        let selectedTags = [Tag(id: 1, name: "JavaScript"),
                            Tag(id: 2, name: "iOS")]
        let otherTags = [Tag(id: 3, name: "Android"),
                         Tag(id: 4, name: "Python")]
        
        //When
        searchParametersService.updateTags(selectedTags: selectedTags, otherTags: otherTags)
        
        //Then
        XCTAssertEqual(searchParametersService.selectedTags, selectedTags)
        XCTAssertEqual(searchParametersService.otherTags, otherTags)
    }
}
