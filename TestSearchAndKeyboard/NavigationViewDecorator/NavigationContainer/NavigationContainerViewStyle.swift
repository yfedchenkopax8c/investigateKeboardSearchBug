import SwiftUI

/// Styling navigation container which contains some navigation bar and content.
///
/// Can be used to provide different layouts for navigation bar/content.
public protocol NavigationContainerViewStyle {
    associatedtype Body: View
    typealias Configuration = NavigationContainerStyleConfiguration

    func makeBody(configuration: Configuration) -> Body
}

public struct NavigationContainerStyleConfiguration {
    public let bar: Self.Label
    public let content: Self.Label

    public init<Bar: View, Content: View>(
        @ViewBuilder bar: () -> Bar,
        @ViewBuilder content: () -> Content
    ) {
        self.bar = .init(content: bar())
        self.content = .init(content: content())
    }

    public init<Bar: View, Content: View>(bar: Bar, content: Content) {
        self.bar = .init(content: bar)
        self.content = .init(content: content)
    }
}

struct NavigationContainerEnvironmentKey: EnvironmentKey {
    static var defaultValue = AnyNavigationContainerViewStyle(style: .default)
}

struct AnyNavigationContainerViewStyle: NavigationContainerViewStyle {
    private var _makeBody: (Configuration) -> AnyView

    init<Style: NavigationContainerViewStyle>(style: Style) {
        _makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        _makeBody(configuration)
    }
}

extension EnvironmentValues {
    var navigationContainerViewStyle: AnyNavigationContainerViewStyle {
        get { self[NavigationContainerEnvironmentKey.self] }
        set { self[NavigationContainerEnvironmentKey.self] = newValue }
    }
}

public extension View {
    func navigationContainerViewStyle<Style: NavigationContainerViewStyle>(
        _ style: Style
    ) -> some View {
        environment(
            \.navigationContainerViewStyle,
             AnyNavigationContainerViewStyle(style: style)
        )
    }
}

public extension NavigationContainerStyleConfiguration {
    struct Label: View {
        public var body: AnyView

        init<Content: View>(content: Content) {
            body = AnyView(content)
        }
    }
}

/// Default navigation container style. Navigation bar is placed on top of the content.
struct DefaultNavigationContainerViewStyle: NavigationContainerViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .center, spacing: 0) {
            configuration.bar
            ZStack {
                Spacer()
                configuration.content
            }
            .frame(maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension NavigationContainerViewStyle where Self == DefaultNavigationContainerViewStyle {
    static var `default`: DefaultNavigationContainerViewStyle {
        DefaultNavigationContainerViewStyle()
    }
}
