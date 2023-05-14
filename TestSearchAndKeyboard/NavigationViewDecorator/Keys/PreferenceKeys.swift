import SwiftUI

struct NavigationTitlePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""

    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

struct NavigationSubtitlePreferenceKey: PreferenceKey {
    static var defaultValue: String?

    static func reduce(value: inout String?, nextValue: () -> String?) {
        value = nextValue()
    }
}

struct NavigationBackButtonHiddenPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = true

    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

struct NavigationBackgroundColorPreferenceKey: PreferenceKey {
    static var defaultValue: Color = .clear

    static func reduce(value: inout Color, nextValue: () -> Color) {
        value = nextValue()
    }
}

struct NavigationBarAccentColorKey: PreferenceKey {
    static var defaultValue: Color?

    static func reduce(value: inout Color?, nextValue: () -> Color?) {
        value = nextValue()
    }
}

struct NavigationBarHiddenPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false

    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}
