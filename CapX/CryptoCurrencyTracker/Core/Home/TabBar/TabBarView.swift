//
//  TabBarView.swift
//  CapX
//
//  Created by Sameer Nikhil on 13/10/24.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var vm: HomeViewModel  // Access shared HomeViewModel
    @StateObject private var viewModel = HomeViewModel()
    @State private var showLaunchView: Bool = true
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    @State private var showPortfolioView: Bool = false
    var body: some View {
        TabView {
            // First Tab: FinalHomeView
            NavigationView {
                FinalHomeView(coins: vm.allCoins)
                    .navigationBarHidden(true)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(vm)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            // Second Tab:
           // WishlistView(coins: vm.allCoins)
                NewsListView()          //Random News API
                .tabItem {
                    Image(systemName: "newspaper.fill")
                    Text("Wishlist")
                }
            
            // Example for a third tab, if needed
            PortfolioView(showPortfolioView: $showPortfolioView)
                           .tabItem {
                               Image(systemName: "person.fill")
                               Text("Portfolio")
                           }
        }
        .accentColor(Color.theme.accent)  
    }
}
