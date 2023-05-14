import SwiftUI

struct NavigationContainerView<Content: View>: View {
    @Environment(\.navigationContainerViewStyle)
    private var style

    let content: () -> Content
    @State
    private var isBackButtonHidden: Bool = true
    @State
    private var title: String = ""
    @State
    private var subtitle: String?
    @State
    private var backgroundColor: Color = .clear
    @State
    private var tintColor: Color? = .accentColor
    @State
    private var isNavigationBarHidden: Bool = false

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        style.makeBody(configuration: .init(bar: {
            if !isNavigationBarHidden {
                NavigationBarView(
                    showBackButton: !isBackButtonHidden,
                    title: title,
                    subtitle: subtitle,
                    backgroundColor: backgroundColor,
                    tintColor: tintColor
                )
            }
        }, content: {
            content()
        }))
        .onPreferenceChange(NavigationTitlePreferenceKey.self, perform: { value in
            title = value
        })
        .onPreferenceChange(NavigationSubtitlePreferenceKey.self, perform: { value in
            subtitle = value
        })
        .onPreferenceChange(NavigationBackButtonHiddenPreferenceKey.self, perform: { value in
            isBackButtonHidden = value
        })
        .onPreferenceChange(NavigationBackgroundColorPreferenceKey.self, perform: { value in
            backgroundColor = value
        })
        .onPreferenceChange(NavigationBarAccentColorKey.self, perform: { value in
            tintColor = value
        })
        .onPreferenceChange(NavigationBarHiddenPreferenceKey.self, perform: { value in
            isNavigationBarHidden = value
        })
    }
}

#if DEBUG
struct NavigationBarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationContainerView {
            ZStack {
                Color.yellow
                    .edgesIgnoringSafeArea(.all)

                Text("Hello, world!")
                    .foregroundColor(.black)
                    .customNavigationTitle("New Title")
                    .customNavigationSubtitle("Subtitle")
                    .customNavigationBackButtonHidden(true)
                    .customNavigationBackgroundColor(.blue)
            }
        }
    }
}
#endif
