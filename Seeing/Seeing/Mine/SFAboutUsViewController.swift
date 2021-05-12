//
//  SFAboutUsViewController.swift
//  Seeing
//
//  Created by qiangshuting on 2021/5/5.
//

import UIKit

class SFAboutUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let bgImage = UIImage(named: "login_bg")
        self.view.layer.contents = bgImage?.cgImage
        self.title = "关于我们"
        
        let centerLabel = UILabel(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: 300))
        self.view.addSubview(centerLabel)
        centerLabel.text = "开心\n就是\n每一天"
        centerLabel.textColor = .systemGreen
        centerLabel.numberOfLines = 0
        centerLabel.textAlignment = .center
        centerLabel.font = UIFont.systemFont(ofSize: 60, weight: .semibold)
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
