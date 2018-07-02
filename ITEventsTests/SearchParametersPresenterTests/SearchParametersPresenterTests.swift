import XCTest
@testable import ITEvents

class SearchParametersPresenterTests: XCTestCase {
    var searchParametersPresenter: ISearchParametersPresenter!
    var view: (ISearchParametersView & ISearchParametersViewMock)!
    var searchParametersService: ISearchParametersService!
    
    override func setUp() {
        super.setUp()
        
        searchParametersService = SearchParametersService()
        view = SearchParametersMockViewController()
        searchParametersPresenter = SearchParametersPresenter(view: view, searchParametersService: searchParametersService)
    }
    
    override func tearDown() {
        searchParametersPresenter = nil
        super.tearDown()
    }
    
    func testPresenterSetup() {
        //Given
        let selectedTags = [Tag(id: 1, name: "JavaScript"),
                            Tag(id: 2, name: "iOS")]
        let otherTags = [Tag(id: 3, name: "Android"),
                         Tag(id: 4, name: "Python")]
        searchParametersService.updateTags(selectedTags: selectedTags, otherTags: otherTags)
        
        //When
        searchParametersPresenter.setup()
        
        //Then
        XCTAssertEqual(view.selectedTags, searchParametersService.selectedTags)
        XCTAssertEqual(view.otherTags, searchParametersService.otherTags)
    }
    
    func testPresenterSelectSearchTagAndSave() {
        //Given
        let selectedTags = [Tag(id: 1, name: "JavaScript"),
                            Tag(id: 2, name: "iOS")]
        let otherTags = [Tag(id: 3, name: "Android"),
                         Tag(id: 4, name: "Python")]
        let finalSelectedTags = [Tag(id: 3, name: "Android"),
                                 Tag(id: 1, name: "JavaScript"),
                                 Tag(id: 2, name: "iOS")]
        let finalOtherTags = [Tag(id: 4, name: "Python")]
        searchParametersService.updateTags(selectedTags: selectedTags, otherTags: otherTags)
        
        //When
        searchParametersPresenter.setup()
        searchParametersPresenter.selectTag(Tag(id: 3, name: "Android"))
        searchParametersPresenter.saveSettings()
        
        //Then
        XCTAssertEqual(searchParametersService.selectedTags, finalSelectedTags)
        XCTAssertEqual(searchParametersService.otherTags, finalOtherTags)
    }
    
    func testPresenterDeselectSearchTagAndSave() {
        //Given
        let selectedTags = [Tag(id: 1, name: "JavaScript"),
                            Tag(id: 2, name: "iOS")]
        let otherTags = [Tag(id: 3, name: "Android"),
                         Tag(id: 4, name: "Python")]
        let finalSelectedTags = [Tag(id: 2, name: "iOS")]
        let finalOtherTags = [Tag(id: 3, name: "Android"),
                              Tag(id: 1, name: "JavaScript"),
                              Tag(id: 4, name: "Python")]
        searchParametersService.updateTags(selectedTags: selectedTags, otherTags: otherTags)
        
        //When
        searchParametersPresenter.setup()
        searchParametersPresenter.deselectTag(Tag(id: 1, name: "JavaScript"))
        searchParametersPresenter.saveSettings()
        
        //Then
        XCTAssertEqual(searchParametersService.selectedTags, finalSelectedTags)
        XCTAssertEqual(searchParametersService.otherTags, finalOtherTags)
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
    }
    
}
