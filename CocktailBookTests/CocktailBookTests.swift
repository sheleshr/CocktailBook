import XCTest
import Combine
@testable import CocktailBook

class CocktailBookTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
    
    }
    
    func test_loadData(){
        let obj = FakeCocktailsAPI()
        let exp = expectation(description: "load_data_test")
        obj.cocktailsPublisher
            .sink { compl in
                
            } receiveValue: { data in
                
                exp.fulfill()
                XCTAssertGreaterThan(data.count, 0)
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 4)
        
    }

    func test_one_object_Make_it_favorite(){
        let sut = MainScreenViewModel()
        sut.loadData()
        
        let delayExpectation = XCTestExpectation()
        delayExpectation.isInverted = true
        wait(for: [delayExpectation], timeout: 4)
        
        let obj = sut.arrCocktails[0]
        sut.setSelection(cocktailModel: obj)
        XCTAssertTrue(sut.arrCocktails[0].selected)
    }
    
    func test_fav_on_top(){
        let sut = MainScreenViewModel()
        sut.loadData()
        
        let delayExpectation = XCTestExpectation()
        delayExpectation.isInverted = true
        wait(for: [delayExpectation], timeout: 4)
        
        let obj = sut.arrCocktails[2]
        sut.setSelection(cocktailModel: obj)
        
        sut.cocktailType = 1
        sut.cocktailType = 0
        
        XCTAssertTrue(sut.arrCocktails[0].selected)
    }
    func test_un_fav_remove_from_top() {
        let sut = MainScreenViewModel()
        sut.loadData()
        
        let delayExpectation = XCTestExpectation()
        delayExpectation.isInverted = true
        wait(for: [delayExpectation], timeout: 4)
        
        let obj = sut.arrCocktails[2]
        sut.setSelection(cocktailModel: obj)
        
        sut.cocktailType = 1
        sut.cocktailType = 0
        //----------------
        sut.arrCocktails[0].setSelection(isSelect: false)
        sut.cocktailType = 1
        sut.cocktailType = 0
        XCTAssertFalse(sut.arrCocktails[0].selected)
    }
    func test_details_screen_fav_clicked(){
        // Prepare data
        let sut = MainScreenViewModel()
        sut.loadData()
        
        let delayExpectation = XCTestExpectation()
        delayExpectation.isInverted = true
        wait(for: [delayExpectation], timeout: 4)
                
        var obj = sut.arrCocktails[0]
        obj.setSelection(isSelect: false)
        
        // System under test
        let sut1 = MainScreenDetailViewModel(cocktailModel: obj, favPublisher: sut.favReceiver)
        sut1.favClicked()
        XCTAssertTrue(sut1.cocktailModel.selected)
    }
}
