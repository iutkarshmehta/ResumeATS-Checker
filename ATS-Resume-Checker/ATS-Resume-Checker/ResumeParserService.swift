//
//  ResumeParserService.swift
//  ATS-Resume-Checker
//
//  Created by Utkarsh  Mehta on 25/12/25.
//

import Foundation
import PDFKit
enum ResumeParserError: Error {
    case invalidPDF
    case permissionDenied
}

final class ResumeParserService {
    func parseResume(from url: URL) throws -> String {
        guard url.startAccessingSecurityScopedResource() else { throw ResumeParserError.permissionDenied }
        
        defer { url.stopAccessingSecurityScopedResource() }
        
        guard let pdf = PDFDocument(url: url) else {
            throw ResumeParserError.invalidPDF
        }
        
        var extractedText = String()
        
        for index in 0..<pdf.pageCount {
            extractedText += pdf.page(at: index)?.string ?? String()
        }
        return extractedText
    }
}
