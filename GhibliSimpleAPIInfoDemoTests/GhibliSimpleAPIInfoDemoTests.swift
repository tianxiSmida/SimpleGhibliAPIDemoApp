//
//  GhibliSimpleAPIInfoDemoTests.swift
//  GhibliSimpleAPIInfoDemoTests
//
//  Created by TianXi Wu on 2026/1/12.
//

import XCTest
import RxSwift

@testable import GhibliSimpleAPIInfoDemo

final class GhibliSimpleAPIInfoDemoTests: XCTestCase {

    var disposed: DisposeBag = .init()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchFilms() throws {
        let baseInfo = BaseInfo(uuid: UUID().uuidString, token: "")
        let service = GBLServer(baseInfo: baseInfo)
        let expectation = XCTestExpectation(description: "Fetch Film Success")
        
        service.fetchFilms()
            .subscribe(onSuccess: { films in
                expectation.fulfill()
            }, onFailure: { error in
                XCTFail("Fetch Film faill: \(error)")
            })
            .disposed(by: disposed)
        
        wait(for: [expectation], timeout: 5.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
