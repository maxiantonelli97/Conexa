import SwiftUI

struct NewsView: View {
    
    @ObservedObject var viewModel = NewsViewModel(dataAccess: NewsDataAccess())
    @State private var searchText = ""
    
    var filteredNews: [NewsModel] {
            if searchText.isEmpty {
                return viewModel.news ?? []
            } else {
                return viewModel.news?.filter {
                    $0.title.localizedCaseInsensitiveContains(searchText) ||
                    $0.body.localizedCaseInsensitiveContains(searchText)
                } ?? []
            }
        }
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case StatesEnum.error :
                ErrorView(onClick: {
                    viewModel.getNews()
                })
            case StatesEnum.loading :
                LoadingView()
        case StatesEnum.success :
            if (viewModel.news == nil) {
                Text(NSLocalizedString("NoNews", comment: ""))
            } else {
                VStack {
                    TextField(NSLocalizedString("Search", comment: ""), text: $searchText)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    if (filteredNews.isEmpty) {
                        Spacer()
                        Text(NSLocalizedString("NoNews", comment: ""))
                        Spacer()
                    } else {
                        List(filteredNews) { new in
                            NavigationLink(destination: DetailView(new: new)) {
                                HStack {
                                    Spacer()
                                    VStack {
                                        Text(new.title.capitalized)
                                            .font(.headline)
                                            .padding(.bottom, 2)
                                        Text(new.body)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                            .font(.body)
                                            .padding(.bottom, 8)
                                        
                                        Text(NSLocalizedString("TapMore", comment: ""))
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
            }
        }
        .onAppear {
            viewModel.getNews()
        }
    }
}

