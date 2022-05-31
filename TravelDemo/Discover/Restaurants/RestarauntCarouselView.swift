//
//  RestarauntCarouselView.swift
//  TravelDemo
//
//  Created by Blaike Bradford on 5/10/22.
//

import SwiftUI

import SwiftUI
import Kingfisher

struct RestarauntCarouselView: UIViewControllerRepresentable {
    
    let imageNames: [String]
    let selectedIndex: Int
    
    func makeUIViewController(context: Context) -> UIViewController {
//        let redVC = UIHostingController(rootView: Text("First View Controller "))
        let pvc = CarouselPageViewController(imageNames: imageNames, selectedIndex: selectedIndex)
        return pvc
    }

    typealias UIViewControllerType = UIViewController
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}

class CarouselPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        allControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        self.selectedIndex
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
    var selectedIndex: Int
    
    init(imageNames: [String], selectedIndex: Int){
        
        self.selectedIndex = selectedIndex
        
        allControllers = imageNames.map({
            imageName in
            let hostingController = UIHostingController(
                rootView:
                        ZStack{
                            Color.black
                            KFImage(URL(string: imageName)).resizable().scaledToFit()
                        }
                                
                
            )
            hostingController.view.clipsToBounds = true
            return hostingController
        })
        
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.systemGray5
        UIPageControl.appearance().currentPageIndicatorTintColor = .red
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        view.backgroundColor = .black
        
    
        
        // accessing crash here because
        // allControllers.first! == nil because passing [] array
        /*
         ORIGINAL:
         setViewControllers([allControllers.first!], direction: .forward, animated: true, completion: nil)
         */
        /*
         UPDATED
         */
//        if let first = allControllers.first {
//            setViewControllers([first], direction: .forward, animated: true, completion: nil)
//        }
        
        
        if selectedIndex < allControllers.count {
                setViewControllers([allControllers[selectedIndex]], direction: .forward, animated: true, completion: nil)

            }
        
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//struct RestarauntCarouselView_Previews: PreviewProvider {
//    static var previews: some View {
//        RestarauntCarouselView()
//    }
//}
