//
//  SLLoginViewController.swift
//  Seeing
//
//  Created by shutingqiang on 2021/2/7.
//

import UIKit
import SnapKit

class SFLoginViewController: UIViewController, UITextFieldDelegate {
    
    private lazy var nameTextField: UITextField = UITextField()
    
    private lazy var pwdTextField: UITextField = UITextField()
    
    private lazy var loginButton: UIButton = UIButton()
    
    private lazy var registerButton: UIButton = UIButton()
    
    private lazy var forgotPwdButton: UIButton = UIButton()

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
        
        nameTextField.placeholder = "   请输入电话号码"
        setTextField(textField: nameTextField)
        self.view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.top.equalTo(welcomeLabel).offset(120)
            make.right.equalTo(-40)
            make.height.equalTo(46)
        }
        
        pwdTextField.placeholder = "   请输入密码"
        setTextField(textField: pwdTextField)
        self.view.addSubview(pwdTextField)
        pwdTextField.snp.makeConstraints { (make) in
            make.left.equalTo(nameTextField.snp.left)
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.right.equalTo(nameTextField.snp.right)
            make.height.equalTo(46)
        }
        
        loginButton.setTitle("登录", for: .normal)
        loginButton.layer.cornerRadius = 23
        loginButton.backgroundColor = .systemGreen
        self.view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        loginButton.snp.makeConstraints { (make) in
            make.left.equalTo(nameTextField)
            make.right.equalTo(nameTextField)
            make.top.equalTo(pwdTextField.snp.bottom).offset(60)
            make.height.equalTo(nameTextField)
        }
        
        registerButton.setTitle("立即注册", for: .normal)
        registerButton.setTitleColor(.gray, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(registerButton)
        registerButton.snp.makeConstraints { (make) in
            make.right.equalTo(loginButton.snp.right).offset(-8)
            make.width.equalTo(62)
            make.top.equalTo(loginButton.snp.bottom).offset(5)
        }
        
        let regLeftLabel = UILabel()
        regLeftLabel.text = "没有账号"
        regLeftLabel.textColor = .white
        regLeftLabel.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(regLeftLabel)
        regLeftLabel.snp.makeConstraints { (make) in
            make.right.equalTo(registerButton.snp.left).offset(5)
            make.width.equalTo(67)
            make.height.equalTo(30)
            make.top.equalTo(registerButton.snp.top)
        }
        
        forgotPwdButton.setTitle("忘记密码？", for: .normal)
        forgotPwdButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(forgotPwdButton)
        forgotPwdButton.snp.makeConstraints { (make) in
            make.left.equalTo(loginButton.snp.left).offset(8)
            make.width.equalTo(80)
            make.top.equalTo(loginButton.snp.bottom).offset(5)
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
    
    @objc func loginAction() {
        NotificationCenter.default.post(name: NotificationName.loginSucceed, object: nil)
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
