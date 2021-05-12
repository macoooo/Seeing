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
    var typeStr: String = ""
    
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
//        textField.isSecureTextEntry = true
        textField.leftViewMode = .always
    }
    
    @objc func doneAction() {
        guard let pwd = pwdTextField.text, pwd.count >= 8, let surePwd = surePwdTextField.text, surePwd.count >= 8 else {
            self.showAlert(info: ("提示", "您输入的密码长度不满足8位"))
            return
        }
        if pwdTextField.text != surePwdTextField.text {
            self.showAlert(info: ("提示", message: "您输入的密码长度不一致，请重新确认"))
        } else {
            if typeStr == "forgetPwd" {
                ProfileManager.shared.forgetSetPwd(pwd: pwdTextField.text ?? "") {
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                } failed: { (errorMessage) in
                    self.showAlert(info: ("提示", message: "设置密码失败"))
                    print("设置密码失败:\(errorMessage)")
                }

            } else {
                ProfileManager.shared.setPwd(pwd: pwdTextField.text ?? "") {
                    self.present(SFChooseTypeViewController(), animated: true, completion: nil)
                    print("设置密码成功")
                } failed: { (errorString) in
                    self.showAlert(info: ("提示", message: "设置密码失败"))
                    print("设置密码失败:\(errorString)")
                }
            }
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
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
