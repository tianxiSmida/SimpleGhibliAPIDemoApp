//
//  APIManager.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/13.
//

import Foundation
import RxSwift

class APIManager {
    private let server: GBLServer
    
    @SubjectObservableWrapper<PublishSubject<Void>>(subject: .init())
    var requestTimeoutEvent: Observable<Void>
    
    @SubjectObservableWrapper<PublishSubject<Void>>(subject: .init())
    var noInternetEvent: Observable<Void>
    
    init(server: GBLServer) {
        self.server = server
    }
    
    func fetchFilms() -> Single<[Film]> {
        return server.fetchFilms()
            .additionalTask(task: processConnectionErrorTask(resp:))
            .map {
                $0.map {
                    Film(film: $0)
                }
            }
    }
    
    func fetchPerson(id: String) -> Single<Person> {
        return server.fetchPerson(id: id)
            .additionalTask(task: processConnectionErrorTask(resp:))
            .map(Person.init(person:))
    }
}

extension Single {
    fileprivate func additionalTask(task: (Self) -> PrimitiveSequence<Trait, Element>) -> PrimitiveSequence<Trait, Element> {
        return task(self)
    }
}

private extension APIManager {
    /// For API Timeout (s)
    static let kAPITimeoutInterval = 15
    
    private func processConnectionErrorTask<T>(resp: Single<T>) -> Single<T> {
        let timeoutEvent = $requestTimeoutEvent
        let noInternetEvent = $noInternetEvent
        return resp
            .timeout(.seconds(APIManager.kAPITimeoutInterval),
                     scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .catch { error in
                switch error {
                case RxSwift.RxError.timeout:
                    timeoutEvent.onNext(())
                    return Observable<T>.never().asSingle()
                case GBLError.server.noInternetConnection:
                    noInternetEvent.onNext(())
                    return Observable<T>.never().asSingle()
                default: break
                }
                throw error
            }
    }
}

extension APIManager {
    func mockFetchFilms() -> Single<[Film]> {
        return .just([
            .init(film: .sample1),
            .init(film: .sample2)
        ])
            .delay(.seconds(1),
                   scheduler: SerialDispatchQueueScheduler.init(qos: .background))
    }
    
    func mockFetchPerson(id: String) -> Single<Person> {
        return .just(
            .init(person: [GBLPerson.sample1, GBLPerson.sample2].randomElement()!)
        )
            .delay(.seconds(1),
                   scheduler: SerialDispatchQueueScheduler.init(qos: .background))
    }
}
