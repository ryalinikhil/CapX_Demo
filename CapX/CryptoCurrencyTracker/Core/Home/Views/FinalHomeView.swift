//
//  FinalHomeView.swift
//  CapX
//
//  Created by Sameer Nikhil on 13/10/24.
//

import SwiftUI

struct FinalHomeView: View {
    let coins: [CoinModel]
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
   // @EnvironmentObject private var vm: HomeViewModel
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var vm: HomeViewModel
    var body: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
            
            VStack{
                //MARK: - Title
                
                HStack{
                    Text("CapX")
                        .font(.system(size: 22))
                        .bold()
                    Spacer()
                    
                    Image(systemName: "bell.fill")
                    
                }
                .padding()
                
                
                VStack{
                    HStack{
                        
                        Text("Portfolio value")
                            .font(Font.custom("Inter", size: 14))
                            .foregroundColor(Color(red: 0.64, green: 0.67, blue: 0.73));
                        Spacer()
                        
                        
                    }
                    HStack{
                        Text("$13,240.11")
                            .font(.system(size: 24))
                            .bold()
                            .padding(.trailing)
                        Spacer()
                        
                        Image("graph")
                            .resizable().aspectRatio(contentMode: .fit)
                            .scaleEffect(0.4)
                            .padding(.leading)
                            .padding(.trailing,-70)
                        
                    }
                   // .padding(.vertical)
                    
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: -12) {  // Add spacing between coin views
                        ForEach(coins) { coin in
                            CoinRowView(coin: coin, showHoldingsColumn: false, showChart: false)
                                .padding()
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    }
                }
              
                WishlistView(coins: vm.allCoins)
                
            /*
             
             HStack{
                 Text("Wishlist")
                     .font(.system(size: 22))
                     .bold()
                 Spacer()
             }
             .padding()
             
             ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: -12) {  // Add spacing between coin views
                        ForEach(coins) { coin in
                            VStack{
                                CoinRowView(coin: coin, showHoldingsColumn: false, showChart: true)
                                
                                
                        
                            }
                                .padding()
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    }
                }*/
                
                
  

                
                HStack{
                    Text("Stocks")
                        .font(.system(size: 22))
                        .bold()
                    Spacer()
                }
                .padding()
                
                VStack{
                    
                    columnTitles
                        allCoinsList
                        .transition(.move(edge: .leading))
                    
                    
                }
                
                
                Spacer()
                
            }
        }
        .background(
            NavigationLink(
                destination: DetailLoadingView(coin: $selectedCoin),
                isActive: $showDetailView,
                label: { EmptyView() })
        )
    }
}

extension FinalHomeView {
    
    
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false, showChart: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false, showChart: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var portfolioEmptyText: some View {
        Text("Click the + Button to add any coins to your portfolio and get started !")
            .font(.callout)
            .foregroundColor(Color.theme.accent)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(50)
    }
    
    private func segue(coin: CoinModel){
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var columnTitles: some View {
        HStack{
            HStack(spacing: 4){
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()

            HStack(spacing: 4){
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))

            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            
            Button(action: {
                withAnimation(.linear(duration:2.0)){
                    vm.reloadData()
                }
            }, label: {
                Image(systemName: "goforward")
            })
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)

        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }

}


struct ContentView_Previews44: PreviewProvider {
    static var previews: some View {
        NavigationView{
        FinalHomeView(coins: [dev2.coin,dev2.coin,dev2.coin])
        }
        .environmentObject(dev.homeVM)
    }
}

// Assuming you have a development namespace like this:
extension PreviewProvider {
    static var dev2: DeveloperPreview2 {
        return DeveloperPreview2.instance
    }
}

struct DeveloperPreview2 {
    static let instance = DeveloperPreview2()
    let coin = CoinModel(id: "solana", symbol: "SOL", name: "Solana", image: "https://example.com/btc.png", currentPrice: 34562, marketCap: 12345678900, marketCapRank: 1, fullyDilutedValuation: 98765432100, totalVolume: 23456789000, high24H: 35000, low24H: 34000, priceChange24H: 562, priceChangePercentage24H: 1.65, marketCapChange24H: 1234567890, marketCapChangePercentage24H: 1.23, circulatingSupply: 18700000, totalSupply: 21000000, maxSupply: 21000000, ath: 64805, athChangePercentage: -46.59, athDate: "2021-04-14T11:54:46.763Z", atl: 67.81, atlChangePercentage: 50882.53, atlDate: "2013-07-06T00:00:00.000Z", lastUpdated: "2021-07-30T11:54:46.763Z", sparklineIn7D: nil, priceChangePercentage24HInCurrency: 1.65, currentHoldings: 1.5)
}




import SwiftUI

struct CoinChartView: View {
    let data: [Double]
    let maxY: Double
    let minY: Double
    let lineColor: Color
    let startingDate: Date
    let endingDate: Date
    @State private var percentage: CGFloat = 0
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.green : Color.red
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
           // .shadow(color: lineColor, radius: 10, x: 0.0, y: 10)
           // .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0.0, y: 20)
           // .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0.0, y: 30)
           // .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0.0, y: 40)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}
