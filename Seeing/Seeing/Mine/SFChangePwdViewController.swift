//
//  SFChangePwdViewController.swift
//  Seeing
//
//  Created by qiangshuting on 2021/3/18.
//

import UIKit

class SFChangePwdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.04, alpha: 0.04)
        self.title = "修改密码"
        //导航栏高度 + 状态栏高度
        let height = UIApplication.shared.statusBarFrame.size.height + 44

        let oldPwdView = SFPwdView(frame: .zero)
        self.view.addSubview(oldPwdView)
        oldPwdView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(8 + height)
            make.height.equalTo(60)
        }
        oldPwdView.setText(leftText: "旧密码", placeholder: "请输入旧密码")
        
        let newPwdView = SFPwdView(frame: .zero)
        self.view.addSubview(newPwdView)
        newPwdView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(oldPwdView.snp.bottom).offset(4)
            make.height.equalTo(60)
        }
        newPwdView.setText(leftText: "新密码", placeholder: "请输入6-18位字母和数字的组合")
        
        let doneButton = UIButton()
        doneButton.setTitle("完成", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.backgroundColor = .lightGray
        doneButton.layer.cornerRadius = 30
        self.view.addSubview(doneButton)
        doneButton.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.top.equalTo(newPwdView.snp.bottom).offset(60)
            make.height.equalTo(50)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
class SFPwdView: UIView, UITextFieldDelegate {
    let textLabel: UILabel = UILabel()
    let textField: UITextField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white

        self.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(5)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        textLabel.font = UIFont.systemFont(ofSize: 15)
        textLabel.textAlignment = .center
        
        self.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(textLabel.snp.right).offset(20)
            make.top.equalTo(textLabel.snp.top)
            make.height.equalTo(50)
            make.right.equalToSuperview()
        }
        textField.returnKeyType = .done
        textField.delegate = self
    }
    
    func setText(leftText: String, placeholder: String) {
        textLabel.text = leftText
        textField.placeholder = placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
}
