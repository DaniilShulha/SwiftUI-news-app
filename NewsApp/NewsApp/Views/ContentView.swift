//
//  ContentView.swift
//  NewsApp
//
//  Created by kSenexie on 6.12.25.
//

//
//  ContentView.swift
//  NewsApp
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject var vm = NewsListViewModel()
    
    enum NewsCategory: String, CaseIterable, Identifiable {
        case all = "All"
        case favorite = "Favorite"
        case blocked = "Blocked"
        var id: String { self.rawValue }
    }
    
    @State private var selectedCategory: NewsCategory = .all
    
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
                
                
                List {
                    ForEach(vm.items) { item in
                        switch item {
                        case .news(let article):
                            ArticleRowView(article: article)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets())
                            
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

#Preview {
    ContentView()
}
