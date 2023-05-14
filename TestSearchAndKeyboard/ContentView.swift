//
//  ContentView.swift
//  TestSearchAndKeyboard
//
//  Created by YuriyFpc on 14.05.2023.
//

import ComposableArchitecture
import SwiftUI

// MARK: - ContentView
struct ContentView: View {
    let store: Store<ContentState, ContentAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")

                Button {
                    viewStore.send(.showFirstModal)
                } label: {
                    Text("Show FirstModalSearch")
                }
            }
            .padding()
            .fullScreenCover(
                isPresented: viewStore.binding(
                    get: \.firstModal,
                    send: { _ in ContentAction.hideFirstModal }
                ).mappedToBool()
            ) {
                IfLetStore(store.scope(state: \.firstModal, action: ContentAction.firstModal)) { store in
                    FirstModalView(store: store)
                }
            }
        }
    }
}

// MARK: - FirstModalView
struct FirstModalView: View {
    let store: Store<FirstModalState, FirstModalAction>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                LabeledSearchBarView(text: viewStore.binding(
                    get: \.text,
                    send: { FirstModalAction.textChanged($0) }
                ), label: "FirstModalSearch")
                Button {
                    viewStore.send(.showSecondModal)
                } label: {
                    Text("Show SecondModalSearch")
                }
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .background(Color.green)
            .transparentFullScreenCover(
                isPresented: viewStore.binding(
                    get: \.secondModal,
                    send: { _ in FirstModalAction.hideSecondModal }
                ).mappedToBool()
            ) {
                IfLetStore(store.scope(state: \.secondModal, action: FirstModalAction.secondModal)) { store in
                    BottomPopoverContainer {
                        SecondModalView(store: store)
                    }
                }
            }
        }
    }
}

struct SecondModalView: View {
    let store: Store<SecondModalState, SecondModalAction>
//    @State
//    var text = ""

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                LabeledSearchBarView(text: viewStore.binding(
                    get: \.text,
                    send: { SecondModalAction.textChanged($0) }
                ), label: "SecongModalSearch")
                Text("SecongModalSearch")
            }
            .background(Color.orange)
        }
    }
}

struct LabeledSearchBarView: View {
    typealias FilterAction = (String) -> Void

    @Binding
    private var text: String
    let label: String
    let filterAction: FilterAction?
    let iconName: String
    let backgroundColor: Color
    let cancelAction: (() -> Void)?
    let clearAction: (() -> Void)?

    @FocusState
    var isSearchFocused: Bool

    init(
        text: Binding<String>,
        label: String,
        filterAction: FilterAction? = nil,
        iconName: String = "magnifyingglass",
        backgroundColor: Color = .clear,
        cancelAction: (() -> Void)? = nil,
        clearAction: (() -> Void)? = nil
    ) {
        self._text = text
        self.label = label
        self.filterAction = filterAction
        self.iconName = iconName
        self.backgroundColor = backgroundColor
        self.cancelAction = cancelAction
        self.clearAction = clearAction
    }

    var body: some View {
        HStack(spacing: 16) {
            HStack {
                Image(systemName: iconName)
                    .foregroundColor(Color.gray)
                    .removed(!isSearchFocused && text.isEmpty)

                TextField(text: $text) {
                    Text(isSearchFocused ? "" : label)
                        .foregroundColor(Color.gray)
                        .font(Font.system(size: 17, weight: .semibold))
                }
                .submitLabel(.search)
//                .modifier(ClearButtonModifier(text: $text, onClearTap: {
//                    clearAction?()
//                }))
                .focused($isSearchFocused)

                Image(systemName: iconName)
                    .foregroundColor(Color.gray)
                    .onTapGesture {
                        isSearchFocused.toggle()
                    }
                    .removed(isSearchFocused || !text.isEmpty)
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
                    .removed(!isSearchFocused && text.isEmpty)
            )

            Button {
                isSearchFocused = false
                cancelAction?()
            } label: {
                Text("Cancel")
                    .font(Font.system(size: 16, weight: .regular))
                    .foregroundColor(Color.black)
            }
            .animation(.default, value: isSearchFocused)
            .removed((!isSearchFocused && text.isEmpty) || cancelAction == nil)

            Button {
                filterAction?(text)
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color.black)
            }
            .removed(filterAction == nil)
        }
        .frame(height: 36, alignment: .leading)
    }
}

extension View {
    /// Hides view conditionally. Can be chained with other `@ViewBuilder` modifiers
    /// - parameter condition: Condition to hide the view. If `true` the view will
    /// become hidden.
    @ViewBuilder
    func hidden(_ condition: @autoclosure () -> Bool) -> some View {
        if condition() {
            self.hidden()
        } else {
            self
        }
    }

    /// Removes view conditionally. Can be chained with other `@ViewBuilder` modifiers
    /// - parameter condition: Condition to remove the view. If `true` the view will
    /// be removed from hierarchy.
    @ViewBuilder
    func removed(_ condition: @autoclosure () -> Bool? = nil) -> some View {
        if condition() == false {
            self
        }
    }
}

public extension Binding where Value == Bool {
    init<Wrapped>(bindingOptional: Binding<Wrapped?>) {
        self.init(
            get: {
                bindingOptional.wrappedValue != nil
            },
            set: { newValue in
                guard newValue == false else { return }

                // We only handle `false` booleans to set our optional to `nil`
                // as we can't handle `true` for restoring the previous value.
                bindingOptional.wrappedValue = nil
            }
        )
    }
}

extension Binding {
    public func mappedToBool<Wrapped>() -> Binding<Bool> where Value == Wrapped? {
        return Binding<Bool>(bindingOptional: self)
    }
}

extension View {
    /// Presents a modal view that covers as much of the screen as possible when binding to a Boolean value you provide is true.
    ///
    /// - parameter isPresented: A binding to a Boolean value that determines whether to present the sheet.
    /// - parameter onDismiss: The closure to execute when dismissing the modal view.
    /// - parameter content: A closure that returns the content of the modal view.
    func transparentFullScreenCover<Content: View>(
        isPresented: Binding<Bool>,
        onDismiss perform: (() -> Void)? = nil,
        content: @escaping () -> Content
    ) -> some View {
        fullScreenCover(isPresented: isPresented, onDismiss: perform) {
            content()
                .background(TransparentBackgroundCoverView())
        }
    }
}

/// This is a hacky way to clear background in a default full screen cover.
///
/// - Warning: Don't use this outside `fullScreenCover` methods
private struct TransparentBackgroundCoverView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .clear
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        //
    }
}

struct BottomPopoverContainer<Content: View>: View {
    @SwiftUI.Environment(\.presentationMode)
    var presentationMode

    var content: () -> Content

    private let overlayColor: Color = .black.opacity(0.4)
    private let backgroundColor: Color = .white

    var body: some View {
        ZStack(alignment: .bottom) {
            overlayColor
                .ignoresSafeArea()
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
                .transition(.opacity)

            ZStack {
                backgroundColor
                    .ignoresSafeArea(edges: .bottom)
                content()
                    .frame(maxWidth: .infinity)
            }
            .frame(maxHeight: 300)
            .fixedSize(horizontal: false, vertical: true)
            .transition(.move(edge: .bottom))
        }
    }
}
