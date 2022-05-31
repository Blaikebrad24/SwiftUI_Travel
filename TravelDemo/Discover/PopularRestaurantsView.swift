//
//  PopularRestaurantsView.swift
//  TravelDemo
//
//  Created by Blaike Bradford on 4/27/22.
//

import SwiftUI


/*
 View - PopularRestuarantsView
 */
struct PopularRestuarantsView: View {
    
    let restaurants: [Restaurants] = [
        .init(name: "Japans finest tapas", imageName: "tapas"),
        .init(name: "Bar & Grill", imageName: "bar_grill"),
    ]
   var body: some View{
       VStack {
           HStack {
               Text("Popular places to eat")
                   .font(.system(size: 14, weight: .semibold))
               Spacer()
               Text("See All")
                   .font(.system(size: 14, weight: .semibold))

           }.padding(.horizontal)
               .padding(.top)
           
           ScrollView(.horizontal){
               HStack(spacing: 8.0){
                   ForEach(restaurants, id: \.self){ restaurant in
                       NavigationLink(
                        destination: RestaurantDetailsView(restaurant: restaurant),
                        label: {RestaurantTile(restaurant: restaurant)})
                       
                   }
               }.padding(.horizontal)
           }
       }
   }
}




struct RestaurantTile: View {
    
    let restaurant: Restaurants
    
    var body: some View {
        HStack(spacing: 8){
            Image(restaurant.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipped()
                .padding(.leading, 6)
                .padding(.vertical, 6)
            
            VStack(alignment: .leading, spacing: 6){
                HStack{
                    Text(restaurant.name)
                        .foregroundColor(.black)
                    Spacer()
                    Button(action: {}, label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.gray)
                    })
                }
                   
                HStack{
                    Image(systemName: "star.fill")
                    Text("4.7 * Sushi * $$")
                }
                Text("Tokyo")

            }.font(.system(size: 12, weight: .semibold))
            Spacer()
        }
            
        .frame(width: 240)
        .modifier(TileModifier())
            .padding(.bottom)
        
    }
}


struct PopularRestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        PopularRestuarantsView()
        DiscoveryView()
    }
}
