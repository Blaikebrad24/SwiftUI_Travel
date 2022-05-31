//
//  PopularDestinationsView.swift
//  TravelDemo
//
//  Created by Blaike Bradford on 4/27/22.
//

import SwiftUI
import MapKit

//provide another hashable for dynamic data

/*
 View - PopularDestinationsView
 */
struct PopularDestinationsView: View {
    
    let destinations: [Destinations] = [
        .init(name: "Tokyo", country: "Japan", imageName: "japan", latitude: 35.6955837652221, longitude: 139.764962534935),
        .init(name: "Paris", country: "France", imageName: "eiffel_tower", latitude: 48.859565, longitude: 2.353235),
        .init(name: "New York", country: "USA", imageName: "new_york", latitude: 40.74710582469346, longitude: -73.97834052683451)
    ]

   var body: some View{
       VStack {
           HStack {
               Text("Popular Destinations")
                   .font(.system(size: 14, weight: .semibold))
               Spacer()
               Text("See All")
                   .font(.system(size: 14, weight: .semibold))

           }.padding(.horizontal)
               .padding(.top)
           
           ScrollView(.horizontal){
               HStack(spacing: 8.0){
                   ForEach(destinations, id: \.self){ destination in
                       NavigationLink(
                       destination:
                        NavigationLazyView(
                        PopularDestinationDetailedView(destination: destination)),
                       label: {
                           PopularDestinationTile(destination: destination)
                               
                               .padding(.bottom)
                            
                       })
                
                   }
               }.padding(.horizontal)
           }
       }
   }
}

struct CustomMapAnnotation: View {
    
    let attraction: Attraction
    
    var body: some View{
        VStack{
            
            Image(attraction.imageName)
                .resizable()
                .frame(width: 80, height: 60)
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(.init(white: 0, alpha: 0.5))))
            Text(attraction.name)
                .padding(.horizontal,6)
                .padding(.vertical, 4)
                .background(LinearGradient(colors: [Color.red, Color.blue], startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(.init(white: 0, alpha: 0.5))))
        }.shadow(radius: 5)
    }
}

struct Attraction: Identifiable{

    let id = UUID().uuidString
    let name, imageName: String
    let latitude, longitude: Double
}

struct DestinationDetails: Decodable {
    let photos: [String]
    let description: String
}
    
class DestinationDetailsViewModel: ObservableObject {
    
    //PopularDestinationsView is monitoring the view Mdoel
    // @ Published - describes error that can be recoverable
    // by other methods
    @Published var isLoading = true
    @Published var destinationDetails: DestinationDetails?
    
    init(name: String){

        let fixedURLString = "https://travel.letsbuildthatapp.com/travel_discovery/destination?name=\(name.lowercased())"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: fixedURLString) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            DispatchQueue.main.async {
                // check error and response
                guard let data = data else {return}
    //            print(String(data: data, encoding: .utf8))
                
                do {
                    self.destinationDetails = try JSONDecoder().decode(DestinationDetails.self, from: data)
                    
                }catch {
                    print("Failed to decode JSON - \(error)")
            }

            }
        }.resume()
    }
}


struct PopularDestinationDetailedView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var vm: DestinationDetailsViewModel
    
    let destination: Destinations
//    @State var region = MKCoordinateRegion(center: .init(latitude: 48.859565, longitude: 2.353235), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @State var region: MKCoordinateRegion // going to mutate over time
    @State var isShowingAttaction = false
    init(destination: Destinations){
        // hits network here
        self.destination = destination
        self._region = State(initialValue: MKCoordinateRegion(center: .init(latitude: destination.latitude, longitude: destination.longitude), span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))
        self.vm = .init(name: destination.name)
    }
    

    
    let attractions: [Attraction] = [
        .init(name: "Eiffel Tower", imageName: "eiffel_tower", latitude: 48.858605, longitude: 2.2946),
        .init(name: "Champs-Elysees", imageName: "new_york", latitude: 48.866867, longitude: 2.311780),
        .init(name: "Louvre Museum", imageName: "chicago", latitude: 48.860288, longitude: 2.337789)


    ]
    
    var body: some View {
        ScrollView{
            
            if let photos = vm.destinationDetails?.photos {
            DestinationHeaderContainer(imageNames: photos)
                .frame(height: 350)
            }

            VStack(alignment: .leading){
                Text(destination.name)
                    .font(.system(size: 18, weight: .bold))
                    
                Text(destination.country)
                
                HStack{
                    ForEach(0..<5, id: \.self){
                        num in
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                    }
                }.padding(.top,2)
                HStack{
                    Text(vm.destinationDetails?.description ?? "")
                        .padding(.top, 4)
                        .font(.system(size: 14))
                    Spacer()
                }
//                HStack{Spacer()}
            }
            .padding(.horizontal)
            HStack{
                Text("Location")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
                
                Button(action: {isShowingAttaction.toggle()},label: {
                    Text("\(isShowingAttaction ? "Hide" : "Show") Attractions").font(.system(size: 12, weight: .semibold))
                })
                Toggle("", isOn: $isShowingAttaction).labelsHidden()
            }.padding(.horizontal)
            
            
            
            Map(coordinateRegion: $region, annotationItems: isShowingAttaction ? attractions : []) {
                attraction in
//              MapMarker(coordinate: .init(latitude: attraction.latitude, longitude: attraction.longitude), tint: .red)
                MapAnnotation(coordinate: .init(latitude: attraction.latitude, longitude: attraction.longitude)) {
                    CustomMapAnnotation(attraction: attraction)
                    
                }
                
            }.frame(height: 300)
            
        }.navigationBarTitle(destination.name, displayMode: .inline)
    }

}

     

struct PopularDestinationTile: View {
    
    let destination: Destinations
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Image(destination.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 125, height: 125)
                .cornerRadius(5)// has to be above padding
                .padding(.horizontal, 6)
                .padding(.vertical, 6)
                
            
            Text(destination.name)
                .font(.system(size: 12, weight: .semibold))
                .padding(.horizontal, 12)
                .foregroundColor(.black)
            Text(destination.country)
                .font(.system(size: 12, weight: .semibold))
                .padding(.bottom, 8)
                .padding(.horizontal, 12)
        }
        .modifier(TileModifier())
            .padding(.bottom)
    }
}

struct PopularDestinationsView_Previews: PreviewProvider {
    static var previews: some View {
        
        PopularDestinationsView()
        NavigationView{
            PopularDestinationDetailedView(destination: .init(name: "Paris", country: "France", imageName: "eiffel_tower", latitude: 48.859565, longitude: 2.353235))
        }
        
        
        DiscoveryView()
    }
}
