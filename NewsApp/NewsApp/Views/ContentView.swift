//
//  ContentView.swift
//  NewsApp
//
//  Created by kSenexie on 6.12.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = NewsListViewModel()
    
    enum NewsCategory: String, CaseIterable, Identifiable {
        case all = "All"
        case favorite = "Favorite"
        case blocked = "Blocked"
        var id: String { self.rawValue }
        
        var emptyMessage: String {
            switch self {
            case .all:
                return "No results"
            case .favorite:
                return "No favorite news"
            case .blocked:
                return "No blocked news"
            }
        }
    }
    
    @State private var selectedCategory: NewsCategory = .all
    @State private var selectedURL: URL?
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 0) {
                Picker("Категория", selection: $selectedCategory) {
                    ForEach(NewsCategory.allCases) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .padding([.horizontal, .bottom], 16)
                
                let filteredItems = vm.items(for: selectedCategory)
                if filteredItems.isEmpty && !vm.isLoading {
                    VStack {
                        Spacer()
                        
                        Image(systemName: selectedCategory == .favorite ? "heart.circle.fill" : (selectedCategory == .blocked ? "nosign" : "exclamationmark.circle.fill"))
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                            .foregroundColor(.customBlue)
                            .padding(.bottom, 8)
                        
                        Text(selectedCategory.emptyMessage)
                            .font(.system(size: 17))
                            .fontWeight(.bold)
                            .foregroundColor(.customBlack)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        if selectedCategory == .all {
                            Button {
                                Task {
                                    await vm.loadData()
                                }
                            } label: {
                                Text("Refresh")
                                    .font(.system(size: 17))
                                    .fontWeight(.bold)
                                    .background(Color.customBlue)
                                    .foregroundColor(.white)
                                    
                            }
                            .frame(width: 328, height: 44)
                            .background(Color.customBlue)
                            .cornerRadius(4)
                            
                        }
                        
                        Spacer()
                        Spacer()
                    }
                                        
                } else if vm.isLoading && vm.items.isEmpty {
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(filteredItems, id: \.self) { item in
                            switch item {
                            case .news(let article):
                                ArticleRowView(article: article,
                                               isFavorite: vm.favoriteIds.contains(article.id),
                                               isBlocked: vm.blockedIds.contains(article.id),
                                               onFavoriteToggle: { vm.toggleFavorite(articleId: article.id)},
                                               onBlockedToggle: { vm.toggleBlocked(articleId: article.id)}
                                )
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets())
                                
                                .onTapGesture {
                                    if !vm.blockedIds.contains(article.id) {
                                        if let validURL = URL(string: article.url) {
                                            selectedURL = validURL
                                        }
                                    }
                                }
                                
                            case .ad(let adBlock):
                                AdRowView(ad: adBlock)
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(EdgeInsets())
                            }
                        }
                        .padding(.bottom, 8)
                        .background(Color(.systemGray6))
                    }
                    .padding(.horizontal)
                    .listStyle(.plain)
                    .sheet(item: $selectedURL) { url in
                        SafariView(url: url)
                            .ignoresSafeArea()
                    }
                }
                
            }
            .background(Color(.systemGray6))
            .navigationTitle("News")
            .navigationBarTitleDisplayMode(.large)
        }
        
        .onAppear {
            Task {
                await vm.loadData()
            }
        }
    }
}

extension URL: Identifiable {
    public var id: URL {self}
}

#Preview {
    ContentView()
}
