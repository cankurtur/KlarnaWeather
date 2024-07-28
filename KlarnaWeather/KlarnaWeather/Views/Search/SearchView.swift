//
//  SearchView.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel = SearchViewModel()
    @Binding var selectedLocationCoordinates: LocationCoordinates?
    @State private var selection: GeographicalInfoModel?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Group{
                if !viewModel.searchResults.isEmpty {
                    List(viewModel.searchResults, selection: $selection) { info in
                        Text(info.cityWithCountry)
                            .onTapGesture {
                                selectedLocationCoordinates = LocationCoordinates(lat: info.latitude, lon: info.longitude)
                                dismiss()
                            }
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
            }
        }
        .searchable(text: $viewModel.searchText)
        .padding(.top)
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel(), selectedLocationCoordinates: .constant(LocationCoordinates(lat: 0, lon: 0)))
}

