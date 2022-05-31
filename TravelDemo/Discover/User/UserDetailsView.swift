//
//  UserDetailsView.swift
//  TravelDemo
//
//  Created by Blaike Bradford on 5/11/22.
//

import SwiftUI
import Kingfisher


// https://travel.letsbuildthatapp.com/travel_discovery/user?id=0

struct UserDetails: Decodable {
    let username, firstName, lastName, profileImage: String
    let followers, following: Int
    let posts: [Post]
}

struct Post: Decodable, Hashable {
    let title, imageUrl, views: String
    let hashtags: [String]
}

// create View model object
class UserDetailsViewModel: ObservableObject {
    
    @Published var userDetails: UserDetails?
    
    init(userId: Int){
        
        
        guard let url = URL(string: "https://travel.letsbuildthatapp.com/travel_discovery/user?id=\(userId)") else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            DispatchQueue.main.async {
                guard let data = data else{return}
                print(data)
                do {
                    self.userDetails = try JSONDecoder().decode(UserDetails.self, from: data)
                } catch let jsonError {
                    print("Decoding failed for UserDetails : ", jsonError)
                }
                print(data)
            }

        }.resume()
    }
}

struct UserDetailsView : View {
    
    // network calls 3x so pass thhis view lazy
    @ObservedObject var vm: UserDetailsViewModel
    
    let user : Users
    
    init(user: Users){
        self.user = user
        self.vm = .init(userId: user.id)
    }
    
    var body: some View{
        ScrollView{
            VStack(spacing: 12){
                Image(user.imageName)
                    .resizable().scaledToFit()
                    .frame(width:60).clipShape(Circle())
                    .shadow(radius: 10).padding(.horizontal).padding(.top)
                
                Text("\(self.vm.userDetails?.firstName ?? "") \(self.vm.userDetails?.lastName ?? "")")
                    .font(.system(size: 12, weight: .semibold))
                
                HStack{
                    
                    Text("@\(self.vm.userDetails?.firstName ?? "") •")
                    Image(systemName: "hand.thumbsup.fill").font(.system(size: 10, weight: .semibold))
                    Text("2541")
                }.font(.system(size: 12, weight: .regular))
                Text("Youtuber, Vlogger, Travel Creator")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Color(.lightGray))
                
                HStack(spacing: 12){
                    VStack{
                           Text("59,394").font(.system(size: 12, weight: .semibold))
                           Text("Followers").font(.system(size: 9, weight: .semibold))
                       }
                    Spacer()
                        .frame(width: 2, height: 10)
                        .background(Color(.lightGray))
//                    Text("|")
//                        .font(.system(size: 10, weight: .regular))
//                        .foregroundColor(Color(.lightGray))
                    VStack{
                           Text("59,394").font(.system(size: 12, weight: .semibold))
                           Text("Followers").font(.system(size: 9, weight: .semibold))
                       }
                }
                HStack(spacing: 10){
                    Button(action: {}, label: {
                        HStack{
                            Spacer()
                            Text("Follow")
                                .foregroundColor(.white)
                            Spacer()

                        }.padding(.vertical,8).background(.orange).cornerRadius(100)
                       
                    })
                    Button(action: {}, label: {
                        HStack{
                            Spacer()
                            Text("Contact")
                                .foregroundColor(.black)
                            Spacer()

                        }.padding(.vertical,8).background(Color(white: 0.9)).cornerRadius(100)
                       
                    })
                }.padding(.horizontal)
                
                ForEach(vm.userDetails?.posts ?? [], id: \.self){
                    post in
                    VStack(alignment: .leading){
                        KFImage(URL(string: post.imageUrl))
                            .resizable()
                            .scaledToFill()
                        HStack{
                            Image(user.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 44)
                                .clipShape(Circle())
                            VStack(alignment: .leading){
                                
                                Text(post.title)
                                    .font(.system(size: 12, weight: .semibold))
                                
                                Text("\(post.views) views")
                                    .font(.system(size: 12, weight: .semibold))

                            }
                        }.padding(.horizontal,8)
                        
                        HStack{
                            ForEach(post.hashtags, id: \.self){
                                hashtag in
                                
                                Text("#\(hashtag)")
                                           .foregroundColor(.blue)
                                           .font(.system(size: 12, weight: .semibold))
                                           .padding(6)
                                           .background(Color(white:0.9))
                                           .cornerRadius(20)
                                           .padding(.horizontal,12)
                                           .padding(.vertical,2)
                            }
                        }.padding(.bottom).padding(.horizontal,8)
       
                    }
                        .background(Color(white: 1))
                        .cornerRadius(12)
                        .shadow(color: .init(white:0.8), radius: 10, x: 0, y: 4)
                       
                }

            }.padding(.horizontal)

        }.navigationBarTitle("Username", displayMode: .inline)
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            
            UserDetailsView(user: .init(id: 0, name: "Amy Adams", imageName: "amy"))
        }
    }
}
