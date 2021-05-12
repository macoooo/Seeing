//
//  WKWebViewController.swift
//  Seeing
//
//  Created by qiangshuting on 2021/5/5.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController {
    private var url: URL
    let wkWebView = WKWebView()
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "详细报道"
        //导航栏高度 + 状态栏高度
        let height = UIApplication.shared.statusBarFrame.size.height + 44
        wkWebView.frame = CGRect(x: 0, y: height, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(wkWebView)
        wkWebView.load(URLRequest(url: self.url))
        // Do any additional setup after loading the view.
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
