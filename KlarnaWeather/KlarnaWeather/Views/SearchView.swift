//
//  SearchView.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        NavigationView {
            Group{
                if viewModel.hasSearchData {
                    List(viewModel.searchResults) { info in
                        Text(info.cityWithCountry)
                    }.listStyle(.plain)
                } else {
                    VStack(spacing: 10) {
                        Text("Find your city")
                            .font(.primaryTitle)
                        Text("Start searching to find weather information of your city.")
                            .font(.secondaryTitle)
                            .multilineTextAlignment(.center)
                    }
                    .foregroundStyle(Color.gray)
                    .padding()
                }
            }.navigationTitle("Search")
        }
        .searchable(text: $viewModel.searchText)
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel())
}
