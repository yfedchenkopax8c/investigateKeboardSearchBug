import SwiftUI

struct NavigationBarView: View {
    typealias Configuration = NavigationBarViewStyleConfiguration
    @Environment(\.presentationMode)
    var presentationMode

    @Environment(\.navigationBarViewStyle)
    var style

    let showBackButton: Bool
    let title: String
    let subtitle: String?
    let backgroundColor: Color
    let tintColor: Color?

    var body: some View {
        style.makeBody(configuration: Configuration(
            isBackItemVisible: showBackButton,
            title: title,
            subtitle: subtitle,
            accentColor: tintColor,
            backItemAction: { presentationMode.wrappedValue.dismiss() }
        ))
            .background(
                backgroundColor.ignoresSafeArea(edges: .top)
            )
    }
}

#if DEBUG
struct NavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NavigationBarView(
                showBackButton: true,
                title: "Title",
                subtitle: "Subtitle",
                backgroundColor: .green,
                tintColor: .white
            )
            Spacer()
        }
    }
}
#endif
