//
//  RestaurantDetailsView.swift
//  TravelDemo
//
//  Created by Blaike Bradford on 5/6/22.
//

import SwiftUI
import Kingfisher


// view model object
struct RestaurantDetails: Decodable {
    let description: String
    let popularDishes: [Dish]
    let photos: [String]
    let reviews: [Review]
}

struct Review: Decodable, Hashable {
    let user: ReviewUser
    let rating: Int
    let text: String
}

struct ReviewUser: Decodable, Hashable {
    let id: Int
    let username, firstName, lastName, profileImage: String
}

struct Dish: Decodable, Hashable {
    let name, price, photo: String
    let numPhotos: Int
}


class RestaurantDetailsViewModel: ObservableObject {
    
    @Published var isLoading = true
    @Published var details: RestaurantDetails?
    init()
    {
        //fetched nested JSON
        let urlString = "https://travel.letsbuildthatapp.com/travel_discovery/restaurant?id=0"
        guard let url = URL(string: urlString) else{return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            // handle errors here
            guard let data = data else {return}
            
            DispatchQueue.main.async {
                
                self.details = try? JSONDecoder().decode(RestaurantDetails.self, from: data)
            }

            
        }.resume()
    }
}

struct RestaurantDetailsView: View {
    
    let restaurant: Restaurants
    @ObservedObject var vm = RestaurantDetailsViewModel()
    
    
    var body: some View {
        ScrollView{
            
            ZStack(alignment: .bottomLeading){
                Image(restaurant.imageName)
                        .resizable()
                        .scaledToFill()
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .center, endPoint: .bottom)
                HStack{
                    VStack{
                        Text(restaurant.name)
                            .foregroundColor(Color.white)
                            .font(.system(size: 18))
                        
                        HStack {
                            ForEach(0..<5, id: \.self){
                                num in
                                Image(systemName: "star.fill")
                            }.foregroundColor(.orange)
                        }
                    }
                    Spacer()
                    
                    NavigationLink (
                    destination: RestarauntPhotosView(),
                     label: {
                        Text("See more photos")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .semibold))
                            .frame(width: 80)
                            .multilineTextAlignment(.trailing)
                    })
                    

                }.padding()
    
            }
            VStack(alignment: .leading){
                
                Text("Location and Description").padding(.top, 8)
                    .font(.system(size: 14, weight: .semibold))
                Text("Tokyo, Japan")
                    .font(.system(size: 14, weight: .semibold))
                HStack{
                    ForEach(0..<5, id: \.self){
                        num in
                        Image(systemName: "dollarsign.circle.fill")
                    }.foregroundColor(.orange)
                }
                Text(vm.details?.description ?? "").padding(.top, 8)
                    .font(.system(size: 14, weight: .semibold))
            }.padding()
            HStack{

                Text("Popular Dishes").font(.system(size: 16, weight: .bold))
                Spacer()
            }.padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    ForEach(vm.details?.popularDishes ?? [], id: \.self){ dish in
                        DishCell(dish: dish)
                    }
                }.padding()

            }
            if let reviews = vm.details?.reviews {
                ReviewsList(reviews: reviews)

            }

        }
        .navigationBarTitle("Restaurant Details", displayMode: .inline)
    }
}



struct ReviewsList: View {
    
    let reviews: [Review]
    
    var body: some View{
        HStack{
            Text("Customer Reviews").font(.system(size: 16, weight: .bold))
            Spacer()
        }.padding(.horizontal)
//        if let reviews = vm.details?.reviews {
            ForEach(reviews, id: \.self){ review in
                VStack(alignment: .leading){
                    HStack{
                        KFImage(URL(string: review.user.profileImage))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 45)
                            .clipShape(Circle())
                        VStack{
                            
                            Text("\(review.user.firstName) \(review.user.lastName)")
                                .font(.system(size: 16, weight: .bold))
                            HStack(spacing: 4){
                                ForEach(0..<review.rating, id: \.self){
                                    num in
                                    Image(systemName: "star.fill")
                                }.foregroundColor(.orange)
                                    .font(.system(size: 12, weight: .bold))
                                ForEach(0..<5 - review.rating, id: \.self){
                                    num in
                                    Image(systemName: "star.fill")
                                }.foregroundColor(.gray)
                                    .font(.system(size: 12, weight: .bold))
                                
                            }
                        }
               
                        Spacer()
                        Text("May 2022").font(.system(size: 16, weight: .bold))
                    }
                    
                    Text(review.text)

                }.padding(.top)
                .padding(.horizontal)
            }
//        }
    }
}

struct DishCell: View {
    let dish: Dish
    
    var body: some View {
        VStack(alignment: .leading){
            ZStack(alignment: .bottomLeading){
                KFImage(URL(string: dish.photo))
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(5)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                    .shadow(radius: 2)
                    .padding(.vertical, 2)
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .center, endPoint: .bottom)
                Text(dish.price)
                    .foregroundColor(Color.white)
                    .font(.system(size: 13, weight: .bold))
                
            }.frame(height: 120).cornerRadius(5)
            Text(dish.name).font(.system(size: 14, weight: .bold))
                
            Text("\(dish.numPhotos) photos")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.gray)
        }
    }
}

struct RestaurantDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            
            RestaurantDetailsView(restaurant: .init(name: "Japan's Finest Tapas", imageName: "tapas"))
        }
    }
}
