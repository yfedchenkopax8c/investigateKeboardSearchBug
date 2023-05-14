//
//  TestSearchAndKeyboardApp.swift
//  TestSearchAndKeyboard
//
//  Created by YuriyFpc on 14.05.2023.
//

import SwiftUI

@main
struct TestSearchAndKeyboardApp: App {
    let contentStore = Store(
        initialState: ContentState(),
        reducer: contentReducer,
        environment: ContentEnvironment()
    )

    var body: some Scene {
        WindowGroup {
            ContentView(store: contentStore)
        }
    }
}

import ComposableArchitecture

struct ContentState: Equatable {
    var firstModal: FirstModalState?
}

enum ContentAction {
    case firstModal(FirstModalAction)
    case showFirstModal
    case hideFirstModal
}

struct ContentEnvironment {
    let firstModal = FirstModalEnvironment()
}

let contentReducer = Reducer<
    ContentState, ContentAction, ContentEnvironment
> .combine(
    firstModalReducer
        .optional()
        .pullback(state: \.firstModal, action: /ContentAction.firstModal, environment: \.firstModal),

    Reducer { state, action, _ in
        switch action {
        case .showFirstModal:
            state.firstModal = FirstModalState()
            return .none

        case .hideFirstModal:
            state.firstModal = nil
            return .none

        default:
            return .none
        }
    }
)


import ComposableArchitecture

struct FirstModalState: Equatable {
    var secondModal: SecondModalState?
    var text = ""
}

enum FirstModalAction {
    case secondModal(SecondModalAction)
    case showSecondModal
    case hideSecondModal
    case textChanged(String)
}

struct FirstModalEnvironment {
    let secondModal = SecondModalEnvironment()
}

let firstModalReducer = Reducer<
    FirstModalState, FirstModalAction, FirstModalEnvironment
>.combine(
    secondModalReducer
        .optional()
        .pullback(state: \.secondModal, action: /FirstModalAction.secondModal, environment: \.secondModal),

    Reducer { state, action, _ in
        switch action {
        case .showSecondModal:
            state.secondModal = SecondModalState()
            return .none

        case .hideSecondModal:
            state.secondModal = nil
            return .none

        case .textChanged(let text):
            state.text = text
            return .none

        default:
            return .none
        }
    }
)

import ComposableArchitecture

struct SecondModalState: Equatable {
    //var secondModal: FirstModalState?
    var text = ""
}

enum SecondModalAction {
    case textChanged(String)
//    case secondModal(FirstModalAction)
//    case showSecondModal
//    case hideSecondModal
}

struct SecondModalEnvironment {
    //let secondModal: FirstModalEnvironment
}

let secondModalReducer = Reducer<
    SecondModalState, SecondModalAction, SecondModalEnvironment
> { state, action, _ in
    switch action {
    case .textChanged(let text):
        state.text = text
        return .none
//    case .showSecondModal:
//        state.secondModal = SecondModalState()
//        return .none
//
//    case .hideSecondModal:
//        state.firstModal = nil
//        return .none

    default:
        return .none
    }
}
