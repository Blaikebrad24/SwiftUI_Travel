//
//  DiscoverCatergoriesView.swift
//  TravelDemo
//
//  Created by Blaike Bradford on 4/27/22.
//

import SwiftUI


/*
 struct - NavigationLazyView (stackoverflow)
 description - subclass "View" Protocol
               so conform with "body" Content
               declared inializer view with build parameter
               closure function that returns content
               Content is generic that will conform to View
 
 */
struct NavigationLazyView<T: View>: View {
    let build: () -> T
    init(_ build: @autoclosure @escaping () -> T){
        self.build = build
    }
    var body: T {
        build()
    }
}



/*
 View - DiscoveryCatergoryView
 */

struct DiscoveryCategoryView: View {
    let categoriesObj : [Category] = [
        .init(name: "Art", imageName: "paintpalette.fill"),
        .init(name: "Sports", imageName: "sportscourt.fill"),
        .init(name: "Live Events", imageName: "music.mic"),
        .init(name: "Food", imageName: "leaf.fill"),
        .init(name: "History", imageName: "books.vertical.fill"),

    ]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(alignment: .top, spacing: 25){
                //generate array
                ForEach(categoriesObj, id: \.self) { category in
                        NavigationLink(
                            destination: NavigationLazyView(CategoryDetailedView(name: category.name)),
                            label: {
                                VStack(spacing: 8) {
            //                        Spacer()
                                    Image(systemName: category.imageName)
                                        .frame(width: 64, height: 64)
                                        .font(.system(size: 20))
                                        .background(Color.white)
                                        .cornerRadius(64)
                                        .shadow(color: .gray, radius: 4, x: 0.0, y: 2)
                                        .foregroundColor(Color.orange)
                                    Text(category.name)
                                        .font(.system(size: 12, weight: .semibold))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                }.frame(width: 68)})
              
                    
                }
                
            }.padding(.horizontal)

        }
    }
}








struct DiscoverCategoryView_Previews: PreviewProvider {
    static var previews: some View {

        DiscoveryView()
//        ZStack{
//            DiscoveryCategoryView()
//            DiscoveryView()
//        }
        //
//
    }
}
//NavigationView{
//            NavigationLink(destination: {Text("Transiton Screen")}, label: {
//                Text("Link")
//            })
//        }
