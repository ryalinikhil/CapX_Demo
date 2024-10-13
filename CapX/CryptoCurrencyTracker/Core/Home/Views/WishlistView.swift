//
//  WishlistView.swift
//  CapX
//
//  Created by Sameer Nikhil on 13/10/24.
//

import SwiftUI

struct WishlistView: View {
    let coins: [CoinModel]
    
    var body: some View {
        VStack(alignment: .leading) {
            // Wishlist Title
            HStack {
                Text("Wishlist")
                    .font(.system(size: 22))
                    .bold()
                Spacer()
            }
            .padding(.horizontal)
            
            // Scrollable Wishlist Section
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(coins.prefix(5).reversed()) { coin in  // Display only 5 coins
                        VStack(alignment: .leading) {
                            // Coin details like image, name, symbol
                            CoinRowSimpleView(coin: coin)
                                .frame(width: 150, height: 60)
                            Text("")
                            // Graph
                            ChartView2(coin: coin)
                                .frame(width: 150, height: 50)  // Adjust the size based on the look you're going for
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}

struct CoinRowSimpleView: View {
    let coin: CoinModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                CoinImageView(coin: coin)
                    .frame(width: 30, height: 30)
                Spacer()
                Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                    .font(.caption)
                    .foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.green : Color.red)
            }
            Text(coin.name)
                .font(.headline)
                .foregroundColor(.primary)
            Text(coin.symbol.uppercased())
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
    }
}

struct WishlistView_Previews: PreviewProvider {
    static var previews: some View {
        WishlistView(coins: [dev.coin])
    }
}

struct ChartView2: View {
    let coin: CoinModel
    
    var data: [Double] { coin.sparklineIn7D?.price ?? [] }
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    let yAxis = (data.max() ?? 1) - (data.min() ?? 0)
                    let yPosition = (1 - CGFloat((data[index] - (data.min() ?? 0)) / yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .stroke(Color.green, lineWidth: 2)
        }
    }
}




