//
//  SubjectObservableWrapper.swift
//  GhibliSimpleAPIInfoDemo
//
//  Created by TianXi Wu on 2026/1/13.
//

import RxSwift

@propertyWrapper
struct SubjectObservableWrapper<Value: ObservableType & ObserverType> {
    
    private let subject: Value
    
    init(subject: Value) {
        self.subject = subject
    }
    
    var wrappedValue: Observable<Value.Element> {
        subject.asObservable()
    }
    
    var projectedValue: Value {
        subject
    }
}
