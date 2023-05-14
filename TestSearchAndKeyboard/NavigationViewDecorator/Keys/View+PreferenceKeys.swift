import SwiftUI

public extension View {
    /// Adds navigation title to the `NavigationViewDecorator`
    func customNavigationTitle(_ title: String) -> some View {
        preference(key: NavigationTitlePreferenceKey.self, value: title)
    }

    /// Adds navigation subtitle to the `NavigationViewDecorator`
    func customNavigationSubtitle(_ subtitle: String?) -> some View {
        preference(key: NavigationSubtitlePreferenceKey.self, value: subtitle)
    }

    /// Hides back button of the `NavigationViewDecorator`
    func customNavigationBackButtonHidden(_ hidden: Bool) -> some View {
        preference(key: NavigationBackButtonHiddenPreferenceKey.self, value: hidden)
    }

    /// Changes background color of custom NavigationBar and top safe area in `NavigationViewDecorator`
    func customNavigationBackgroundColor(_ color: Color) -> some View {
        preference(key: NavigationBackgroundColorPreferenceKey.self, value: color)
    }

    /// Updates `accentColor` and `foregroundColor` of items in navigation bar of `NavigationViewDecorator`
    func customNavigationBarTintColor(_ color: Color?) -> some View {
        preference(key: NavigationBarAccentColorKey.self, value: color)
    }

    /// Hides navigation bar of the `NavigationViewDecorator`
    func customNavigationBarHidden(_ hidden: Bool) -> some View {
        preference(key: NavigationBarHiddenPreferenceKey.self, value: hidden)
    }
}
