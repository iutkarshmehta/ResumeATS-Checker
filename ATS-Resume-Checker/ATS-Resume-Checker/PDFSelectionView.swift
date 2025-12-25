//
//  ContentView.swift
//  ATS-Resume-Checker
//
//  Created by Utkarsh  Mehta on 25/12/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct PDFSelectionView: View {
    @StateObject private var viewModel = PDFSelectionViewModel(parser: ResumeParserService())
    @State private var showFileImporter = false
    @State private var selectedPDFURL: URL?
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        NavigationStack {
            mainView
                .fileImporter(
                    isPresented: $showFileImporter,
                    allowedContentTypes: [.pdf],
                    allowsMultipleSelection: false
                ) { result in
                    switch result {
                    case let .success(urls):
                        guard let url = urls.first else { return }
                        viewModel.handleSelectedFile(for: url)
                    case let .failure(error):
                        print("File import failed:", error)
                    }
                }
                .navigationTitle("Pdf Selection View")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color(.systemBackground), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    @ViewBuilder
    private var mainView: some View {
        switch viewModel.viewState {
        case .idle:
            Button("Please select a resume...") {
                showFileImporter = true
            }
        case let .success(resumeText):
            resumeTextView(text: resumeText)
        case let .failure(error):
            Text(error)
                .foregroundStyle(.red)
        }
    }
    
    private func resumeTextView(text: String) -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(viewModel.resumeText)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .font(.body)
            }
            .padding()
        }
    }
}

#Preview {
    PDFSelectionView()
}
