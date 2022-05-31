//
//  CategoryDetailedView.swift
//  TravelDemo
//
//  Created by Blaike Bradford on 4/27/22.
//

import SwiftUI

import Kingfisher


class CategoryDetailsViewModel: ObservableObject {
    //what do we want to do
    //instead of StateProperty Wrapper
    @Published var isLoading = true
    @Published var places = [Place]()
    @Published var errorMessage = ""
    
    init(name:String){
        //network code will happen here
        let urlString = "https://travel.letsbuildthatapp.com/travel_discovery/category?name=\(name.lowercased())".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        guard let url = URL(string: urlString) else{
            self.isLoading=false
            return
            
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            // check response statusCode and err
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                
                if let statusCode = (response as? HTTPURLResponse)?.statusCode,
                    statusCode >= 400 {
                    // casting response into htturlresponse
                    //hitting network through http if not silently crash
                    self.isLoading = false
                    self.errorMessage = "Bad Status: \(statusCode)"
                    return
                }
                
                guard let data = data else {return}
                do{
                    self.places = try JSONDecoder().decode([Place].self, from: data)
                    
                }catch{
                    print("Failed to decode JSON - \(error)")
                    self.errorMessage = error.localizedDescription
                }
                self.isLoading = false
            }
        }.resume()
        
        

    }
}


struct CategoryDetailedView: View {
//    @State var isLoading = false
//    let name: String
//
//    @ObservedObject var vm = CategoryDetailsViewModel()
    private let name: String
    @ObservedObject private var vm: CategoryDetailsViewModel
    
    init(name: String){
        print("\nLoaded category details view making request for \(name)")
        self.name = name
        self.vm = .init(name: name)
    }
    
    var body: some View {
        
        ZStack {
            if vm.isLoading {
                VStack{
                    ActivityIndicatorView()
                    Text("Currently Loading..")
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .semibold))
                }
                .padding()
                .background(Color.black)
                .cornerRadius(8)
                
            }else{
                ZStack{
                    if !vm.errorMessage.isEmpty{
                        VStack{
                            Image(systemName: "xmark.octagon.fill")
                                .font(.system(size: 64, weight: .semibold))
                                .foregroundColor(.red)
                            Text(vm.errorMessage)
                        }
                    }
                    ScrollView{
                        ForEach(vm.places, id: \.self){place in
                            
                            VStack(alignment: .leading, spacing: 0){
                                KFImage(URL(string: place.thumbnail))
                                    .resizable()
                                    .scaledToFill()
                                Text(place.name)
                                    .font(.system(size: 12, weight: .semibold))
                                    .padding()
                                    
                            }.modifier(TileModifier())
                                .padding()
                        }

                        
                    }.navigationBarTitle(name, displayMode: .inline)
                }

            }
        }


        
    }
}

struct CategoryDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            CategoryDetailedView(name: "Food")
        }
        DiscoveryView()
    }
}
