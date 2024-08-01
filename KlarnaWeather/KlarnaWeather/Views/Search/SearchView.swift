//
//  SearchView.swift
//  KlarnaWeather
//
//  Created by Can Kurtur on 28.07.2024.
//

import SwiftUI

// MARK: - SearchView

struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    @Binding var selectedLocationCoordinates: LocationCoordinates?
    @State private var selection: GeographicalInfoModel?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            if viewModel.searchResults.isEmpty {
                if viewModel.hasNetworkConnection {
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
        .alert("Something went wrong", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}

// MARK: - Views

private extension SearchView {
    var searchListView: some View {
        List(viewModel.searchResults, selection: $selection) { info in
            HStack {
                Text(info.fullname)
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
            Text(Localizable.findYourCity)
                .font(.primaryTitle)
            Text(Localizable.startSearching)
                .font(.secondaryTitle)
                .multilineTextAlignment(.center)
        }
        .foregroundStyle(Color.gray)
        .padding()
    }
    
    var connectionIssueView: some View {
        VStack(spacing: 10) {
            Images.wifiSlash
                .foregroundStyle(Color.red)
            Text(Localizable.searchLostConnection)
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
