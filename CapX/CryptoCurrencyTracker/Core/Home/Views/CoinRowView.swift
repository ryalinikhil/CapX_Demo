//
//  CoinRowView.swift
//  CryptoCurrencyTracker
//
//  Created by Sameer Nikhil on 13/10/24.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let showHoldingsColumn : Bool
    let showChart: Bool
    
    var body: some View {
        HStack(spacing: 0){
            leftColumn
            Spacer()
        /*    if showHoldingsColumn {
               centerColumn
            }*/
            if showChart {
                CoinChartView(coin: coin)
                    .frame(width: 100, height: 40)
            }
            Spacer()
            rightColumn
        }
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            CoinRowView(coin: dev.coin, showHoldingsColumn: true, showChart: true)
                .previewLayout(.sizeThatFits)
            CoinRowView(coin: dev.coin, showHoldingsColumn: true,showChart: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        }
        
    }
}

extension CoinRowView {
    
    private var leftColumn : some View {
        HStack(spacing: 0){
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading,6)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(Color.theme.accent)
    }
    
    private var rightColumn: some View {
        VStack (alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ?
                    Color.theme.green :
                    Color.theme.red
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
    
//    private var coininfo: some View {
//
//            VStack(alignment: .center){
//                CoinImageView(coin: coin)
//                    .frame(width: 30, height: 30)
//                    .padding(.top,10)
//                Spacer()
//                Text(coin.name)
//                    .font(.headline)
//                    .padding(.leading,6)
//                    .foregroundColor(Color.theme.accent)
//                Spacer()
//                Text(coin.currentPrice.asCurrencyWith6Decimals())
//                    .bold()
//                    .foregroundColor(Color.theme.accent)
//                    .padding(.horizontal, 10)
//                Spacer()
//                HStack {
//
//                    Image(systemName: "triangle.fill")
//                        .font(.caption)
//                        .rotationEffect(
//                            Angle(degrees:(coin.priceChangePercentage24H ?? 0) >= 0 ? 0 : 180))
//                        .foregroundColor(
//                            (coin.priceChangePercentage24H ?? 0) >= 0 ?
//                            Color.theme.green :
//                            Color.theme.red
//                        )
//
//
//                    Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
//                        .foregroundColor(
//                            (coin.priceChangePercentage24H ?? 0) >= 0 ?
//                            Color.theme.green :
//                            Color.theme.red
//                        )
//                }
//                .padding(.bottom,10)
//
//            }
//            .frame(width: 150, height: 150,alignment: .center)
//            .background(Color.theme.background)
//            .cornerRadius(10.0)
//            .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0.0, y: 10.0)
//            .padding()
//    }
}



import SwiftUI

struct CoinRowView2: View {
    let coin: CoinModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(coin.symbol.uppercased())
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                priceChangeView
            }
            
            Text(coin.name)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer().frame(height: 8)
            
            chartView
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var priceChangeView: some View {
        Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
            .font(.subheadline)
            .foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ? .green : .red)
    }
    
    private var chartView: some View {
        // Placeholder for the chart
        RoundedRectangle(cornerRadius: 4)
            .fill((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
            .frame(height: 32)
            .overlay(
                Path { path in
                    // This is a simple placeholder path. You'd replace this with actual chart data.
                    path.move(to: CGPoint(x: 0, y: 32))
                    path.addCurve(to: CGPoint(x: UIScreen.main.bounds.width - 40, y: 0),
                                  control1: CGPoint(x: 50, y: 0),
                                  control2: CGPoint(x: 100, y: 32))
                }
                .stroke((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.green : Color.red, lineWidth: 2)
            )
    }
}

struct CoinRowView_Previews2: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView2(coin: dev.coin)
                .previewLayout(.sizeThatFits)
                .padding()
            
            CoinRowView2(coin: dev.coin)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
                .padding()
        }
    }
}


