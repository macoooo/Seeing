//
//  SFRegisterViewController.swift
//  Seeing
//
//  Created by qiangshuting on 2021/3/28.
//

import UIKit
import RxSwift
import RxCocoa

class SFRegisterViewController: UIViewController, UITextFieldDelegate {

    private lazy var phoneTextField: UITextField = UITextField()
    
    private lazy var verifyCodeTextField: UITextField = UITextField()
    
    private lazy var registerButton: UIButton = UIButton()
    
    private lazy var getVerifyCodeButton: UIButton = UIButton(type: .custom)
    
    private let disposeBag = DisposeBag()
    
    var timer: Timer = Timer()
    var countDown: Int = 60
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
        
        phoneTextField.placeholder = "   请输入手机号"
        setTextField(textField: phoneTextField)
        phoneTextField.rx.text.orEmpty.bind(to: ProfileManager.shared.phone).disposed(by: disposeBag)
        self.view.addSubview(phoneTextField)
        phoneTextField.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.top.equalTo(welcomeLabel).offset(120)
            make.right.equalTo(-40)
            make.height.equalTo(46)
        }
        
        verifyCodeTextField.placeholder = "   请输入验证码"
        setTextField(textField: verifyCodeTextField)
        verifyCodeTextField.rx.text.orEmpty.bind(to: ProfileManager.shared.code).disposed(by: disposeBag)
        self.view.addSubview(verifyCodeTextField)
        verifyCodeTextField.snp.makeConstraints { (make) in
            make.left.equalTo(phoneTextField.snp.left)
            make.top.equalTo(phoneTextField.snp.bottom).offset(20)
            make.right.equalTo(phoneTextField.snp.right)
            make.height.equalTo(46)
        }
        
        registerButton.setTitle("完成", for: .normal)
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
        verifyCodeTextField.addSubview(getVerifyCodeButton)
        getVerifyCodeButton.addTarget(self, action: #selector(getVerifyCode), for: .touchUpInside)
        getVerifyCodeButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-2)
            make.width.equalTo(150)
            make.centerY.equalToSuperview()
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
        ProfileManager.shared.register { [weak self] in
            guard let self = self else {
                return
            }
            let vc = SFSetPwdViewController()
            if self.typeStr.count > 0 {
                vc.typeStr = self.typeStr
            }
            self.present(vc, animated: true, completion: nil)
            print("注册成功")
        } failed: { (errorString) in
            self.showAlert(info: ("注册失败", "请重新查验验证码"))
            print("注册失败:\(errorString)")
        }
    }
    
    @objc func getVerifyCode() {
        ProfileManager.shared.sendVerifyCode(typeStr: typeStr) { [weak self] in
            guard let self = self else {
                return
            }
            print("发送验证码成功")
            self.getVerifyCodeButton.isEnabled = false
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        } failed: { (errorString) in
            self.showAlert(info: ("提示", errorString))
            print("发送验证码失败:\(errorString)")
        }

    }
    
    @objc private func onTimer() {
        if countDown > 0 {
            getVerifyCodeButton.setTitle("\(countDown)秒重新获取", for: .disabled)
            countDown -= 1
        } else {
            countDown = 60
            timer.invalidate()
            timer = Timer()
            getVerifyCodeButton.setTitle("60s重新获取", for: .disabled)
            getVerifyCodeButton.setTitle("重发验证码", for: .normal)
            getVerifyCodeButton.isEnabled = true
            
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
