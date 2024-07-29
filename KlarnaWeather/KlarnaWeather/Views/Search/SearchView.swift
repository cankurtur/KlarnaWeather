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
            if !viewModel.searchResults.isEmpty {
                searchListView
            } else {
                if viewModel.hasConnection {
                    emptyView
                } else{
                    connectionIssueView
                }
            }
        }
        .searchable(text: $viewModel.searchText)
        .padding(.top)
    }
    
    private var searchListView: some View {
        List(viewModel.searchResults, selection: $selection) { info in
            Text(info.cityWithCountry)
                .onTapGesture {
                    selectedLocationCoordinates = LocationCoordinates(lat: info.latitude, lon: info.longitude)
                    dismiss()
                }
        }.listStyle(.plain)
    }
    
    private var emptyView: some View {
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
    
    private var connectionIssueView: some View {
        VStack(spacing: 10) {
            Image(systemName: "wifi.slash")
                .foregroundStyle(Color.red)
            Text("Seems like your network connection is offline.\nPlease check your connection.")
                .font(.secondaryTitle)
                .multilineTextAlignment(.center)
        }
        .foregroundStyle(Color.gray)
        .padding(.horizontal, 60)
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel(), selectedLocationCoordinates: .constant(LocationCoordinates(lat: 0, lon: 0)))
}

