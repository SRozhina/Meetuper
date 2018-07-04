import XCTest
@testable import ITEvents

class SearchParametersPresenterTests: XCTestCase {
    var searchParametersPresenter: ISearchParametersPresenter!
    var view: SearchParametersViewMock!
    var searchParametersService: SearchParametersServiceMock!
    
    override func setUp() {
        super.setUp()
        
        searchParametersService = SearchParametersServiceMock()
        view = SearchParametersViewMock()
        searchParametersPresenter = SearchParametersPresenter(view: view, searchParametersService: searchParametersService)
    }
    
    override func tearDown() {
        searchParametersPresenter = nil
        view = nil
        searchParametersService = nil
        super.tearDown()
    }
    
    func testPresenterSetup() {
        //Given
        searchParametersService.selectedTags = [Tag(id: 1, name: "JavaScript"),
                                                Tag(id: 2, name: "iOS")]
        searchParametersService.otherTags = [Tag(id: 3, name: "Android"),
                                             Tag(id: 4, name: "Python")]
        //When
        searchParametersPresenter.setup()
        
        //Then
        XCTAssertEqual(view.selectedTags, searchParametersService.selectedTags)
        XCTAssertEqual(view.otherTags, searchParametersService.otherTags)
        XCTAssertEqual(view.fillCallsCount, 1)
    }
    
    func testPresenterSelectSearchTagAndSave() {
        //Given
        searchParametersService.selectedTags = [Tag(id: 1, name: "JavaScript"),
                                                Tag(id: 2, name: "iOS")]
        searchParametersService.otherTags = [Tag(id: 3, name: "Android"),
                                             Tag(id: 4, name: "Python")]
        
        //When
        searchParametersPresenter.setup()
        searchParametersPresenter.selectTag(Tag(id: 3, name: "Android"))
        searchParametersPresenter.saveSettings()
        
        //Then
        let expectedSelectedTags = [Tag(id: 3, name: "Android"),
                                 Tag(id: 1, name: "JavaScript"),
                                 Tag(id: 2, name: "iOS")]
        let expectedOtherTags = [Tag(id: 4, name: "Python")]
        XCTAssertEqual(searchParametersService.selectedTags, expectedSelectedTags)
        XCTAssertEqual(searchParametersService.otherTags, expectedOtherTags)
        XCTAssertEqual(view.fillCallsCount, 1)
    }
    
    func testPresenterDeselectSearchTagAndSave() {
        //Given
        searchParametersService.selectedTags = [Tag(id: 1, name: "JavaScript"),
                            Tag(id: 2, name: "iOS")]
        searchParametersService.otherTags = [Tag(id: 3, name: "Android"),
                         Tag(id: 4, name: "Python")]
        
        //When
        searchParametersPresenter.setup()
        searchParametersPresenter.deselectTag(Tag(id: 1, name: "JavaScript"))
        searchParametersPresenter.saveSettings()
        
        //Then
        let expectedSelectedTags = [Tag(id: 2, name: "iOS")]
        let expectedOtherTags = [Tag(id: 3, name: "Android"),
                              Tag(id: 1, name: "JavaScript"),
                              Tag(id: 4, name: "Python")]
        XCTAssertEqual(searchParametersService.selectedTags, expectedSelectedTags)
        XCTAssertEqual(searchParametersService.otherTags, expectedOtherTags)
        XCTAssertEqual(view.fillCallsCount, 1)
    }
    
    func testPresenterSelectNonExistingSearchTagAndSave() {
        //Given
        let selectedTags = [Tag(id: 1, name: "JavaScript"),
                            Tag(id: 2, name: "iOS")]
        let otherTags = [Tag(id: 3, name: "Android"),
                         Tag(id: 4, name: "Python")]
        searchParametersService.updateTags(selectedTags: selectedTags, otherTags: otherTags)
        
        //When
        searchParametersPresenter.setup()
        searchParametersPresenter.selectTag(Tag(id: 5, name: "Ruby"))
        searchParametersPresenter.saveSettings()
        
        //Then
        XCTAssertEqual(searchParametersService.selectedTags, selectedTags)
        XCTAssertEqual(searchParametersService.otherTags, otherTags)
        XCTAssertEqual(view.fillCallsCount, 1)
    }
    
    func testPresenterDeselectNonExistingSearchTagAndSave() {
        //Given
        let selectedTags = [Tag(id: 1, name: "JavaScript"),
                            Tag(id: 2, name: "iOS")]
        let otherTags = [Tag(id: 3, name: "Android"),
                         Tag(id: 4, name: "Python")]
        searchParametersService.updateTags(selectedTags: selectedTags, otherTags: otherTags)
        
        //When
        searchParametersPresenter.setup()
        searchParametersPresenter.deselectTag(Tag(id: 5, name: "Ruby"))
        searchParametersPresenter.saveSettings()
        
        //Then
        XCTAssertEqual(searchParametersService.selectedTags, selectedTags)
        XCTAssertEqual(searchParametersService.otherTags, otherTags)
        XCTAssertEqual(view.fillCallsCount, 1)
    }
    
}
