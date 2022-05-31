//
//  DestinationHeaderContainer.swift
//  TravelDemo
//
//  Created by Blaike Bradford on 5/5/22.
//

import SwiftUI
import Kingfisher

struct DestinationHeaderContainer: UIViewControllerRepresentable {
    
    let imageNames: [String]
    
    func makeUIViewController(context: Context) -> UIViewController {
//        let redVC = UIHostingController(rootView: Text("First View Controller "))
        let pvc = CustomPageViewController(imageNames: imageNames)
        return pvc
    }

    typealias UIViewControllerType = UIViewController
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

class CustomPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        allControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = allControllers.firstIndex(of: viewController) else {return nil}
        
        if index == 0 { return nil}
        return allControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = allControllers.firstIndex(of: viewController) else {return nil}
        
        if index == allControllers.count - 1 { return nil}
        return allControllers[index + 1]
    }
    

    var allControllers: [UIViewController] = []
    
    init(imageNames: [String]){
        
        allControllers = imageNames.map({
            imageName in
            let hostingController = UIHostingController(
                rootView: KFImage(URL(string: imageName)).resizable().scaledToFill())
            
            
            hostingController.view.clipsToBounds = true
            return hostingController
        })
        
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.systemGray5
        UIPageControl.appearance().currentPageIndicatorTintColor = .red
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        view.backgroundColor = .clear
        
        // accessing crash here because
        // allControllers.first! == nil because passing [] array
        /*
         ORIGINAL:
         setViewControllers([allControllers.first!], direction: .forward, animated: true, completion: nil)
         */
        /*
         UPDATED
         */
        if let first = allControllers.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }

        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct DestinationHeaderContainer_Previews: PreviewProvider {
    
    static let imageURLStrings = ["https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/2240d474-2237-4cd3-9919-562cd1bb439e","https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/b1642068-5624-41cf-83f1-3f6dff8c1702","https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/6982cc9d-3104-4a54-98d7-45ee5d117531" ]
    static var previews: some View {
        DestinationHeaderContainer(imageNames: imageURLStrings)
            .frame(height: 300)
        NavigationView{
            PopularDestinationDetailedView(destination: .init(name: "Paris", country: "France", imageName: "eiffel_tower", latitude: 48.859565, longitude: 2.353235))
        }
    }
}
