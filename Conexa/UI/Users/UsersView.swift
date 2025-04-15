import SwiftUI

struct UsersView: View {
    
    @ObservedObject var viewModel = UsersViewModel(dataAccess: UsersDataAccess())
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case StatesEnum.error :
                ErrorView(onClick: {
                    viewModel.getUsers()
                })
            case StatesEnum.loading :
                LoadingView()
            case StatesEnum.success :
                if (viewModel.users == nil) {
                    Text(NSLocalizedString("NoUsers", comment: ""))
                } else {
                    List(viewModel.users!) { user in
                        NavigationLink(destination: MapView(user: user)) {
                            HStack {
                                Spacer()
                                VStack {
                                    Text(user.name)
                                        .font(.headline)
                                        .padding(.bottom, 2)
                                    
                                    Text(user.username)
                                        .font(.body)
                                        .padding(.bottom, 8)
                                    
                                    Text(NSLocalizedString("TapLocation", comment: ""))
                                        .font(.subheadline)
                                }
                                Spacer()
                            }
                        }
                        .listRowSeparator(.hidden)
                        .padding()
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                        .listStyle(PlainListStyle())
                    }
                }
            }
        }
        .onAppear {
            viewModel.getUsers()
        }
    }
}
