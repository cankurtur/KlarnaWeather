//
//  SearchView.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var appSettings: AppSettings
    @StateObject var viewModel = SearchViewModel()
    @Binding var selectedLocationCoordinates: LocationCoordinates?
    @State private var selection: GeographicalInfoModel?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            if viewModel.searchResults.isEmpty {
                if appSettings.hasNetworkConnection {
                    emptyView
                } else {
                    connectionIssueView
                }
            } else {
                searchListView
            }
        }
        .searchable(text: $viewModel.searchText)
        .autocorrectionDisabled()
        .padding(.top)
        .onReceive(appSettings.$hasNetworkConnection) { connection in
            viewModel.setConnectionStatus(with: connection)
        }
    }
}

// MARK: - Views

private extension SearchView {
    var searchListView: some View {
        List(viewModel.searchResults, selection: $selection) { info in
            HStack {
                Text(info.cityWithCountry)
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                selectedLocationCoordinates = LocationCoordinates(latitude: info.latitude, longitude: info.longitude)
                dismiss()
            }
        }.listStyle(.plain)
    }
    
    var emptyView: some View {
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
    
    var connectionIssueView: some View {
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
    SearchView(
        viewModel: SearchViewModel(),
        selectedLocationCoordinates: .constant(LocationCoordinates(
            latitude: 0,
            longitude: 0)
        )
    )
}
