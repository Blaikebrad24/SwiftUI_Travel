//
//  ContentView.swift
//  TravelDemo
//
//  Created by Blaike Bradford on 4/16/22.
//

import SwiftUI


extension Color {
    static let discoverBackground = Color(.init(white: 0.95, alpha: 1))
    static let tileBackground = Color("tileBackground")
    static let defaultBackground = Color("defaultBackground")
}

struct DiscoveryView: View {
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor:UIColor.white]
    }
    
    //View is automatically aware of this environment variable
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView{
            
            ZStack{

                LinearGradient(gradient: Gradient(colors: [Color.init(UIColor(red: 220/255, green: 136/255, blue: 53/255, alpha: 1.0)),Color.init(UIColor(red: 255/255, green: 109/255, blue: 5/255, alpha: 1.0))]), startPoint: .top, endPoint: .center).ignoresSafeArea()
                
                Color.defaultBackground.offset(y:400)
                
                ScrollView {
                    HStack{
                        Image(systemName: "magnifyingglass")
                        Text("Where do you want to go?")
                        Spacer()
                    }.font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(.init(white: 1, alpha: 0.3)))
                        .cornerRadius(10)
                        .padding(10)
                    DiscoveryCategoryView()
                    
                    VStack{
                        PopularDestinationsView()
                        PopularRestuarantsView()
                        TrendingCreatorsView()
                    }
                    // added color Set
                    .background(Color.defaultBackground)
                        .cornerRadius(16)
                        .padding(.top,32)
                        

                    
                }.navigationTitle("Discover")
                    
            }

        }
  
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoveryView().colorScheme(.dark)
        DiscoveryView().colorScheme(.light)
    }
}






