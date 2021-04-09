//
//  SFSetPwdViewController.swift
//  Seeing
//
//  Created by qiangshuting on 2021/3/28.
//

import UIKit

class SFSetPwdViewController: UIViewController, UITextFieldDelegate {

    private lazy var pwdTextField: UITextField = UITextField()
    
    private lazy var surePwdTextField: UITextField = UITextField()
    
    private lazy var doneButton: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        let bgImage = UIImage(named: "login_bg")
        self.view.layer.contents = bgImage?.cgImage
        
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome to Seeing"
        welcomeLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        self.view.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(25)
            make.top.equalTo(200)
            make.right.equalTo(-25)
            make.height.equalTo(80)
        }
        
        pwdTextField.placeholder = "   设置密码"
        setTextField(textField: pwdTextField)
        self.view.addSubview(pwdTextField)
        pwdTextField.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.top.equalTo(welcomeLabel).offset(120)
            make.right.equalTo(-40)
            make.height.equalTo(46)
        }
        
        surePwdTextField.placeholder = "   确认密码"
        setTextField(textField: surePwdTextField)
        self.view.addSubview(surePwdTextField)
        surePwdTextField.snp.makeConstraints { (make) in
            make.left.equalTo(pwdTextField.snp.left)
            make.top.equalTo(pwdTextField.snp.bottom).offset(20)
            make.right.equalTo(pwdTextField.snp.right)
            make.height.equalTo(46)
        }
        
        doneButton.setTitle("完成", for: .normal)
        doneButton.layer.cornerRadius = 23
        doneButton.backgroundColor = .systemGreen
        self.view.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        doneButton.snp.makeConstraints { (make) in
            make.left.equalTo(pwdTextField)
            make.right.equalTo(pwdTextField)
            make.top.equalTo(surePwdTextField.snp.bottom).offset(60)
            make.height.equalTo(pwdTextField)
        }
    }
    
    private func setTextField(textField: UITextField) {
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.backgroundColor = .themeCellBackgroundColor
        textField.layer.cornerRadius = 23
        textField.delegate = self
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        textField.leftViewMode = .always
    }
    
    @objc func doneAction() {
        
    }
}
