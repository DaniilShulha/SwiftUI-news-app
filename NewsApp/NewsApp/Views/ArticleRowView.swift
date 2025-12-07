//
//  ArticleRowView.swift
//  NewsApp
//
//  Created by kSenexie on 6.12.25.
//

import SwiftUI

import SwiftUI



struct ArticleRowView: View {
    let article: Article
    private var metadata: String {
        "\(article.section) • \(article.publishedDate)"
    }
    
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
                    
                    Button {
                        // TODO: Здесь будет вызов меню действий (избранное/заблокировать)
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.gray)
                            .padding(.trailing, 4)
                            .font(.system(size: 24))
                    }
                }

                Text(article.abstract)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.customGrey)
                    .lineLimit(2)
                
                Spacer()

                
                Text("\(article.section) • \(article.publishedDate)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.customGrey)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        //.shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2) //
        .frame(width: 361, height: 96)
    }
}

#Preview {
    ArticleRowView(article: Article.template)
}
