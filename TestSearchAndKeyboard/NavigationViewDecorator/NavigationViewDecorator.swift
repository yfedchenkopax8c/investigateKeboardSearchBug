import SwiftUI

/// Replacement for the `NavigationView` which hides navigation bar and places custom
/// navigation bar instead.
///
/// Can be styled to support different layouts if needed via `NavigationContainerViewStyle` protocol.
public struct NavigationViewDecorator<Content: View>: View {
    let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        NavigationView {
            NavigationContainerView {
                content
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
}

#if DEBUG
struct NavigationViewDecorator_Previews: PreviewProvider {
    static var previews: some View {
        NavigationViewDecorator {
            Text("Hello, world!")
        }
    }
}
#endif
