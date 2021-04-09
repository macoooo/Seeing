//
//  SFRegisterViewController.swift
//  Seeing
//
//  Created by qiangshuting on 2021/3/28.
//

import UIKit

class SFRegisterViewController: UIViewController, UITextFieldDelegate {

    private lazy var phoneTextField: UITextField = UITextField()
    
    private lazy var verifyCodeTextField: UITextField = UITextField()
    
    private lazy var registerButton: UIButton = UIButton()
    
    private lazy var getVerifyCodeButton: UIButton = UIButton()

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
        
        phoneTextField.placeholder = "   请输入手机号"
        setTextField(textField: phoneTextField)
        self.view.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.top.equalTo(welcomeLabel).offset(120)
            make.right.equalTo(-40)
            make.height.equalTo(46)
        }
        
        verifyCodeTextField.placeholder = "   请输入验证码"
        setTextField(textField: verifyCodeTextField)
        self.view.addSubview(verifyCodeTextField)
        verifyCodeTextField.snp.makeConstraints { (make) in
            make.left.equalTo(phoneTextField.snp.left)
            make.top.equalTo(phoneTextField.snp.bottom).offset(20)
            make.right.equalTo(phoneTextField.snp.right)
            make.height.equalTo(46)
        }
        
        registerButton.setTitle("注册", for: .normal)
        registerButton.layer.cornerRadius = 23
        registerButton.backgroundColor = .systemGreen
        self.view.addSubview(registerButton)
        registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        registerButton.snp.makeConstraints { (make) in
            make.left.equalTo(phoneTextField)
            make.right.equalTo(phoneTextField)
            make.top.equalTo(verifyCodeTextField.snp.bottom).offset(60)
            make.height.equalTo(phoneTextField)
        }
        
        getVerifyCodeButton.setTitle("获取验证码", for: .normal)
        getVerifyCodeButton.setTitleColor(.gray, for: .normal)
        getVerifyCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(getVerifyCodeButton)
        getVerifyCodeButton.snp.makeConstraints { (make) in
            make.right.equalTo(registerButton.snp.right).offset(-8)
            make.width.equalTo(62)
            make.top.equalTo(registerButton.snp.bottom).offset(5)
        }
        // Do any additional setup after loading the view.
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
    
    @objc func registerAction() {
        
    }
}
