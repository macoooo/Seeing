//
//  SFChooseTypeViewController.swift
//  Seeing
//
//  Created by qiangshuting on 2021/4/30.
//

import UIKit
import SnapKit

class SFChooseTypeViewController: UIViewController {

    private lazy var blindButton: UIButton = UIButton(type: .roundedRect)
    private lazy var volunteerButton: UIButton = UIButton(type: .roundedRect)
    let buttonSize = UIScreen.main.bounds.width / 4

    override func viewDidLoad() {
        super.viewDidLoad()

        let bgImage = UIImage(named: "login_bg")
        self.view.layer.contents = bgImage?.cgImage
        
        blindButton.layer.cornerRadius = buttonSize / 2
        blindButton.backgroundColor = UIColor(white: 0.89, alpha: 1)
        blindButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonSize * 0.4)
        blindButton.setTitle("盲", for: .normal)
        self.view.addSubview(blindButton)
        blindButton.addTarget(self, action: #selector(blindAction), for: .touchUpInside)
        blindButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height / 4)
            make.width.equalTo(buttonSize)
            make.height.equalTo(buttonSize)
        }
        
        volunteerButton.layer.cornerRadius = buttonSize / 2
        volunteerButton.backgroundColor = UIColor(white: 0.89, alpha: 1)
        volunteerButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonSize * 0.4)
        volunteerButton.setTitle("志", for: .normal)
        self.view.addSubview(volunteerButton)
        volunteerButton.addTarget(self, action: #selector(volunteerAction), for: .touchUpInside)
        volunteerButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-UIScreen.main.bounds.height / 4)
            make.width.equalTo(buttonSize)
            make.height.equalTo(buttonSize)
        }
        // Do any additional setup after loading the view.
    }

    @objc func blindAction() {
        setType(type: 0)
    }

    @objc func volunteerAction() {
        setType(type: 1)
    }
    
    private func setType(type: Int) {
        ProfileManager.shared.setType(type: type) {
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        } failed: { (error) in
            self.showAlert(info: ("提示", "设置类型失败, 请稍等"))
        }
    }
    
    func showAlert(info: (title: String, message: String), leftAction: (() -> Void)? = nil, rightAction: (() -> Void)? = nil) {
        let alertController = UIAlertController.init(title: info.title, message: info.message, preferredStyle: .alert)
        let leftAlertAction = UIAlertAction.init(title: "确定", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
            leftAction?()
        }
        alertController.addAction(leftAlertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
