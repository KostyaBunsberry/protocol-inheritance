import SwiftUI

protocol BaseButton: View {
    associatedtype Label: View
    associatedtype Style: PrimitiveButtonStyle

    var label: Label { get }
    var style: Style { get }
    var action: () -> Void { get }
}

extension BaseButton {
    var body: some View {
        Button(
            action: self.action,
            label: { self.label }
        )
        .buttonStyle(style)
    }
}

// To make stretched label should be expandable

// make a style

// make a structure with content and style
