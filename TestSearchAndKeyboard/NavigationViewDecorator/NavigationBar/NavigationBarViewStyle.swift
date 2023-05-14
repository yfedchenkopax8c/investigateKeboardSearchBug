import SwiftUI

public protocol NavigationBarViewStyle {
    associatedtype Body: View
    typealias Configuration = NavigationBarViewStyleConfiguration

    func makeBody(configuration: Configuration) -> Body
}

public struct NavigationBarViewStyleConfiguration {
    public let isBackItemVisible: Bool
    public let title: String
    public let subtitle: String?
    public let tintColor: Color?
    public let backItemAction: () -> Void

    public init(
        isBackItemVisible: Bool,
        title: String,
        subtitle: String?,
        accentColor: Color?,
        backItemAction: @escaping () -> Void
    ) {
        self.isBackItemVisible = isBackItemVisible
        self.title = title
        self.subtitle = subtitle
        self.tintColor = accentColor
        self.backItemAction = backItemAction
    }
}

struct NavigationBarEnvironmentKey: EnvironmentKey {
    static var defaultValue = AnyNavigationBarViewStyle(style: .default)
}

struct AnyNavigationBarViewStyle: NavigationBarViewStyle {
    private var _makeBody: (Configuration) -> AnyView

    init<Style: NavigationBarViewStyle>(style: Style) {
        _makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        _makeBody(configuration)
    }
}

extension EnvironmentValues {
    var navigationBarViewStyle: AnyNavigationBarViewStyle {
        get { self[NavigationBarEnvironmentKey.self] }
        set { self[NavigationBarEnvironmentKey.self] = newValue }
    }
}

public extension View {
    func navigationBarViewStyle<Style: NavigationBarViewStyle>(
        _ style: Style
    ) -> some View {
        environment(
            \.navigationBarViewStyle,
             AnyNavigationBarViewStyle(style: style)
        )
    }
}

/// Default navigation bar view style. Nothing fancy. Back button is `<`. Title, subtitle and items
/// are coloured by `tintColor`
struct DefaultNavigationBarViewStyle: NavigationBarViewStyle {
    private let backItemWidth: CGFloat = 44

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if configuration.isBackItemVisible {
                Button(action: {
                    configuration.backItemAction()
                }, label: {
                    Image(systemName: "chevron.left")
                })
                    .frame(width: backItemWidth)
            }
            Spacer()
            VStack(alignment: .center) {
                Text(configuration.title)
                    .font(.title)
                configuration.subtitle.flatMap(Text.init)
            }
            Spacer()
            if configuration.isBackItemVisible {
                Spacer()
                    .frame(width: backItemWidth)
            }
        }
        .foregroundColor(configuration.tintColor)
        .accentColor(configuration.tintColor)
    }
}

extension NavigationBarViewStyle where Self == DefaultNavigationBarViewStyle {
    static var `default`: DefaultNavigationBarViewStyle {
        DefaultNavigationBarViewStyle()
    }
}
