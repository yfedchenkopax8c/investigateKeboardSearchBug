import SwiftUI

/// Replacement for the `NavigationLink` to work in conjunction with `NavigationViewDecorator`
///
/// Hides navigation bar and reveals back item for pushed view
public struct NavigationLinkDecorator<Destination: View, Label: View>: View {
    private let destination: () -> Destination
    private let label: Label

    @State
    private var isActive: Bool = false

    private var isActiveBinding: Binding<Bool>?

    public init(destination: @escaping () -> Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination
        self.label = label()
    }

    public init(
        isActive: Binding<Bool>,
        destination: @escaping () -> Destination,
        @ViewBuilder label: () -> Label
    ) {
        self.isActiveBinding = isActive
        self.destination = destination
        self.label = label()
    }

    public var body: some View {
        NavigationLink(
            isActive: isActiveBinding ?? $isActive,
            destination: {
                NavigationContainerView(content: {
                    destination().customNavigationBackButtonHidden(false)
                })
                    .navigationBarHidden(true)
            }, label: {
                if isActiveBinding != nil {
                    label
                } else {
                    label.onTapGesture {
                        isActive = true
                    }
                }
            })
    }
}

#if DEBUG
struct NavigationLinkDecorator_Previews: PreviewProvider {
    static var previews: some View {
        NavigationViewDecorator {
            NavigationLinkDecorator(
                destination: { Text("Destination") },
                label: { Text("NavigationLink") })
        }
    }
}
#endif
