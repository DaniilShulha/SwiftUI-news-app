//
//  SafariView.swift
//  NewsApp
//
//  Created by kSenexie on 6.12.25.
//

import SwiftUI

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let vc = SFSafariViewController(url: url)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
    }
}

#Preview {
    SafariView(url: URL(string: "https://www.nytimes.com/2025/04/18/business/trump-harvard-letter-mistake.html")!)
        .ignoresSafeArea()
}
