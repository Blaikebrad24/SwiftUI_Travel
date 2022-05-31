//
//  TrendingCreatorsView.swift
//  TravelDemo
//
//  Created by Blaike Bradford on 4/27/22.
//

import SwiftUI



/*
 View - TrendingCreatorsView
 */

struct TrendingCreatorsView: View {
    let users: [Users] = [
        .init(id: 1, name: "Amy Adams", imageName: "amy"),
        .init(id: 2, name: "Billy", imageName: "billy"),
        .init(id: 3, name: "Sam Smith", imageName: "sam")
    ]
    
    var body: some View {
        
        HStack {
            Text("Trending Creators")
                .font(.system(size: 14, weight: .semibold))
            Spacer()
            Text("See All")
                .font(.system(size: 14, weight: .semibold))

        }.padding(.horizontal)
            .padding(.top)
        ScrollView(.horizontal, showsIndicators: false){
            HStack(alignment: .top, spacing: 12){
                //generate array
                ForEach(users, id: \.self) { user in
                    NavigationLink(
                        destination:  NavigationLazyView(UserDetailsView(user:user)),
                     label: {
                        DiscoverUserView(user: user)
                    })
                }
            }.padding(.horizontal).padding(.horizontal)

        }.padding(.top)
    }
}


struct DiscoverUserView: View {
    
    let user: Users
    var body: some View {
        VStack {
            Image(user.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .cornerRadius(.infinity)
            Text(user.name)
                .font(.system(size: 12, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.label))
            
        }.frame(width: 60)
        .shadow(color: .gray, radius: 4, x: 0.0, y: 2)
            .padding(.bottom)
    }
}

struct TrendingCreatorsView_Previews: PreviewProvider {
    static var previews: some View {
        
        DiscoveryView()
    }
}
