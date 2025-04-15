import SwiftUI

struct DetailView: View {
    
    var new: NewsModel

    init(new: NewsModel) {
        self.new = new
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Text(new.title.capitalized)
                        .font(.headline)
                        .padding(.bottom, 2)
                    
                    Text(new.body)
                        .font(.body)
                }
                Spacer()
            }
            .padding()
            Spacer()
        }.navigationBarTitle(NSLocalizedString("DetailTitle", comment: ""), displayMode: .inline)
    }
}
