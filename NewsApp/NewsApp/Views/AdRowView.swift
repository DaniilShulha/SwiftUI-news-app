//
//  AdRowView.swift
//  NewsApp
//
//  Created by kSenexie on 6.12.25.
//

import SwiftUI

// AdRowView.swift

struct AdRowView: View {
    let ad: AdBlock
    
    var body: some View {
        VStack(spacing: 8) {
            if let symbol = ad.titleSymbol {
                Image(systemName: symbol)
                    .foregroundStyle(.blue)
                    .font(.system(size: 24))
            }
            
            Text(ad.title)
                .font(.system(size: 17))
                .fontWeight(.bold)
                .foregroundStyle(.customBlack)
            
            if let subtitle = ad.subtitle {
                Text(subtitle)
                    .fontWeight(.medium)
                    .foregroundStyle(.customGrey)
                    .font(.system(size: 15))
            }
                        
            if let buttonTitle = ad.buttonTitle {
                Button {
                    print("1234567890")
                } label: {
                    ZStack {
                        HStack {
                            Spacer()
                            if let buttonSymbol = ad.buttonSymbol {
                                Image(systemName: buttonSymbol)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 24))
                                    .padding(.trailing, 10)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        Text(buttonTitle)
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .font(.system(size: 17))
                    }
                }
                .frame(width: 328, height: 44)
                .background(Color(.systemBlue))
                .cornerRadius(4)
            }
        }
        .frame(width: 361, height: 144)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    AdRowView(ad: AdBlock(id: 1,
                          title: "All news in one place",
                          subtitle: "Stay inform, quickly and conveniently",
                          titleSymbol: nil,
                          buttonTitle: "Go",
                          buttonSymbol: "arrow.right"
                         ))
    .padding()
}
