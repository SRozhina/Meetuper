import XCTest
@testable import ITEvents

class SearchParametersPresenterTests: XCTestCase {
    var searchParametersPresenter: ISearchParametersPresenter!
    var view: SearchParametersViewMock!
    var searchParametersServiceMock: SearchParametersServiceMock!
    
    override func setUp() {
        super.setUp()
        
        searchParametersServiceMock = SearchParametersServiceMock()
        view = SearchParametersViewMock()
        searchParametersPresenter = SearchParametersPresenter(view: view, searchParametersService: searchParametersServiceMock)
    }
    
    override func tearDown() {
        searchParametersPresenter = nil
        view = nil
        searchParametersServiceMock = nil
        super.tearDown()
    }
    
    func testPresenterSetup() {
        //Given
        searchParametersServiceMock.selectedTags = [Tag(id: 1, name: "JavaScript"),
                                                Tag(id: 2, name: "iOS")]
        searchParametersServiceMock.otherTags = [Tag(id: 3, name: "Android"),
                                             Tag(id: 4, name: "Python")]
        //When
        searchParametersPresenter.setup()
        
        //Then
        XCTAssertEqual(view.selectedTags, searchParametersServiceMock.selectedTags)
        XCTAssertEqual(view.otherTags, searchParametersServiceMock.otherTags)
        XCTAssertEqual(view.fillCallsCount, 1)
    }
    
    func testPresenterSelectSearchTagAndSave() {
        //Given
        searchParametersServiceMock.selectedTags = [Tag(id: 1, name: "JavaScript"),
                                                Tag(id: 2, name: "iOS")]
        searchParametersServiceMock.otherTags = [Tag(id: 3, name: "Android"),
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
        XCTAssertEqual(searchParametersServiceMock.selectedTags, expectedSelectedTags)
        XCTAssertEqual(searchParametersServiceMock.otherTags, expectedOtherTags)
        XCTAssertEqual(view.fillCallsCount, 1)
    }
    
    func testPresenterDeselectSearchTagAndSave() {
        //Given
        searchParametersServiceMock.selectedTags = [Tag(id: 1, name: "JavaScript"),
                                                Tag(id: 2, name: "iOS")]
        searchParametersServiceMock.otherTags = [Tag(id: 3, name: "Android"),
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
        XCTAssertEqual(searchParametersServiceMock.selectedTags, expectedSelectedTags)
        XCTAssertEqual(searchParametersServiceMock.otherTags, expectedOtherTags)
        XCTAssertEqual(view.fillCallsCount, 1)
    }
    
    func testPresenterSelectNonExistingSearchTagAndSave() {
        //Given
        let selectedTags = [Tag(id: 1, name: "JavaScript"),
                            Tag(id: 2, name: "iOS")]
        let otherTags = [Tag(id: 3, name: "Android"),
                         Tag(id: 4, name: "Python")]
        searchParametersServiceMock.selectedTags = selectedTags
        searchParametersServiceMock.otherTags = otherTags
        
        //When
        searchParametersPresenter.setup()
        searchParametersPresenter.selectTag(Tag(id: 5, name: "Ruby"))
        searchParametersPresenter.saveSettings()
        
        //Then
        XCTAssertEqual(searchParametersServiceMock.selectedTags, selectedTags)
        XCTAssertEqual(searchParametersServiceMock.otherTags, otherTags)
        XCTAssertEqual(view.fillCallsCount, 1)
    }
    
    func testPresenterDeselectNonExistingSearchTagAndSave() {
        //Given
        let selectedTags = [Tag(id: 1, name: "JavaScript"),
                            Tag(id: 2, name: "iOS")]
        let otherTags = [Tag(id: 3, name: "Android"),
                         Tag(id: 4, name: "Python")]
        searchParametersServiceMock.selectedTags = selectedTags
        searchParametersServiceMock.otherTags = otherTags
        
        //When
        searchParametersPresenter.setup()
        searchParametersPresenter.deselectTag(Tag(id: 5, name: "Ruby"))
        searchParametersPresenter.saveSettings()
        
        //Then
        XCTAssertEqual(searchParametersServiceMock.selectedTags, selectedTags)
        XCTAssertEqual(searchParametersServiceMock.otherTags, otherTags)
        XCTAssertEqual(view.fillCallsCount, 1)
    }
    
}
