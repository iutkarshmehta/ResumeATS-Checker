//
//  Untitled.swift
//  ATS-Resume-Checker
//
//  Created by Utkarsh  Mehta on 25/12/25.
//

import Foundation
internal import Combine

@MainActor
final class PDFSelectionViewModel: ObservableObject {
    var resumeText = String()
    var errorMessage = String()
    private var parser: ResumeParserService
    @Published var viewState: ViewState = .idle
    
    enum ViewState {
        case idle
        case success(String)
        case failure(String)
    }
    
    init(parser : ResumeParserService) {
        self.parser = parser
    }
    
    func handleSelectedFile(for url: URL) {
        do {
            resumeText = try parser.parseResume(from: url)
            viewState = .success(resumeText)
        } catch {
            viewState = .failure(error.localizedDescription)
        }
    }
}
