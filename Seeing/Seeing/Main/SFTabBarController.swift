//
//  SFTabBarController.swift
//  Seeing
//
//  Created by shutingqiang on 2021/2/7.
//

import UIKit

enum TabBarIndex {
    case video
    case life
    case map
    case mine
}

class SFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        buildControllers()
        // Do any additional setup after loading the view.
    }
    
    func buildControllers() {
        let tabItems: [TabBarIndex] = [.video, .life, .map, .mine]
        var navs: [UINavigationController] = []
        tabItems.enumerated().forEach { (index, tab) in
            let item = UITabBarItem(title: tabBarItemTitleWithIndex(index: tab), image: tabBarItemImageWithIndex(index: tab), selectedImage: tabBarItemTSeletcedImageWithIndex(index: tab))
            item.tag = index
            item.setTitleTextAttributes([.foregroundColor: UIColor.themeTintColor], for: .selected)
            item.setTitleTextAttributes([.foregroundColor: UIColor.themeNavigationBarTitleColor], for: .normal)
            
            let vc = viewControllerWithIndex(index: tab)
            let nav = UINavigationController(rootViewController: vc)
            navs.append(nav)
            nav.tabBarItem = item
        }
        
        self.viewControllers = navs
    }
    
    func viewControllerWithIndex(index: TabBarIndex) -> UIViewController {
        return UIViewController()
    }
    
    func tabBarItemTitleWithIndex(index: TabBarIndex) -> String? {
        switch index {
        case .video:
            return "视频"
        default:
            return "生活"
        }
    }
    
    func tabBarItemImageWithIndex(index: TabBarIndex) -> UIImage? {
        switch index {
        case .video:
            return UIImage(named: "video_icon")
        case .life:
            return UIImage(named: "life_icon")
        default:
            return UIImage(named: "login_icon")
        }
    }
    
    func tabBarItemTSeletcedImageWithIndex(index: TabBarIndex) -> UIImage? {
        switch index {
        case .video:
            return UIImage(named: "login_icon")
        default:
            return UIImage(named: "login_icon")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
