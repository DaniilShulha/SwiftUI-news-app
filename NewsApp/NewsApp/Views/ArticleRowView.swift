//
//  ArticleRowView.swift
//  NewsApp
//
//  Created by kSenexie on 6.12.25.
//

import SwiftUI

struct ArticleRowView: View {
    let article: Article
    private var metadata: String {
        "\(article.section) • \(article.publishedDate)"
    }
    
    let isFavorite: Bool
    let isBlocked: Bool
    let onFavoriteToggle: () -> Void
    let onBlockedToggle: () -> Void
    
    @State private var showUnblockAlert = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            if let url = article.imageUrl {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        Image(systemName: "photo.fill").resizable().scaledToFit()
                            .foregroundColor(.gray)
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 94, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 1) {
                
                HStack {
                    Text(article.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .foregroundStyle(.customBlack)
                    
                    Spacer()
                    
                    Menu {
                        if isBlocked {
                            Button(role: .destructive) {
                                showUnblockAlert = true
                            } label: {
                                Label("Unblock", systemImage: "lock.open")
                            }
                            
                        } else {
                            Button {
                                onFavoriteToggle()
                            } label: {
                                Label(isFavorite ? "Remove from favorites" : "Add to favorites", systemImage: isFavorite ? "heart.slash" : "heart")
                            }
                            
                            Button(role: .destructive) {
                                onBlockedToggle()
                            } label: {
                                Label("Block", systemImage: "nosign")
                                    .foregroundStyle(Color.red)
                            }
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 22))
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                            .contentShape(Rectangle())
                    }
                }
                
                Text(article.abstract)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.customGrey)
                    .lineLimit(2)
                
                Spacer()
                
                Text(metadata)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.customGrey)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .frame(width: 361, height: 96)
        
        .alert("Do you want to unblock?", isPresented: $showUnblockAlert) {
            Button("Unblock", role: .destructive) {
                onBlockedToggle()
            }
            Button("Cancel", role: .cancel) {}
            
        } message: {
            Text("Confirm to unblock this news source")
        }
    }
}


#Preview {
    ArticleRowView(article: Article.template, isFavorite: false, isBlocked: true, onFavoriteToggle: {}, onBlockedToggle: {})
}
