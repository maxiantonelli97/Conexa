import SwiftUI

struct ErrorView: View {
    
    var onClick: () -> Void = {}
    
    init(onClick: @escaping () -> Void) {
        self.onClick = onClick
    }
        
    var body: some View {
        VStack {
            Label(NSLocalizedString("ErrorRefresh", comment: ""), systemImage: "arrow.clockwise")
        }
        .scaledToFill()
        .onTapGesture {
            onClick()
        }
    }
}
