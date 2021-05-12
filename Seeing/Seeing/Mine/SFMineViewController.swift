//
//  SFMineViewController.swift
//  Seeing
//
//  Created by qiangshuting on 2021/3/17.
//

import UIKit
import SnapKit
import Alamofire
import RxSwift

class SFMineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    private var tableView = UITableView()
    private var textStringArray: [String] = []
    private var detailStringArray: [String] = []
    private var viewModel = SFMineViewModel()
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        let bgImage = UIImage(named: "login_bg")
        self.view.layer.contents = bgImage?.cgImage
        self.title = "我"
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "mineCell")
        self.view.addSubview(tableView)
        
        let userModel = ProfileManager.shared.curUserModel
        var typeStr: String = ""
        var numberStr: String = ""
        if userModel?.userModel.type == 0 {
            typeStr = "视障人士"
            numberStr = "被帮助次数"
        } else {
            typeStr = "志愿者"
            numberStr = "帮助次数"
        }
        textStringArray = ["用户名", "用户类型", numberStr, "更改密码", "关于我们", "设置"]
        detailStringArray = [userModel?.name ?? "", typeStr, String(ProfileManager.shared.curUserModel?.userModel.callNumber ?? 0), "", "", ""]
        
        let headerView = UIView(frame: CGRect(x: 0, y: 1, width: UIScreen.main.bounds.width, height: 100))
        tableView.tableHeaderView = headerView
        
        let loveImage = UIImage(named: "love_icon")
        let loveImageView = UIImageView(image: loveImage)
        headerView.addSubview(loveImageView)
        loveImageView.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.top.equalTo(15)
            make.width.height.equalTo(70)
        }
        
        let textLabel = UILabel()
        textLabel.text = "携手通行"
        textLabel.textColor = .systemGreen
        textLabel.font = UIFont.systemFont(ofSize: 50, weight: .semibold)
        textLabel.textAlignment = .left
        headerView.addSubview(textLabel)
        textLabel.snp.makeConstraints { (make) in
            make.left.equalTo(loveImageView.snp.right).offset(40)
            make.centerY.equalToSuperview()
            make.top.equalTo(loveImageView.snp.top)
        }
        
        let footerView = UIView(frame: CGRect(x: 0, y: 1, width: UIScreen.main.bounds.width, height: 100))
        tableView.tableFooterView = footerView
        let exitLoginButton = UIButton(type: .custom)
        exitLoginButton.frame = CGRect(x: 20, y: 10, width: UIScreen.main.bounds.width - 40, height: 50)
        exitLoginButton.setTitle("退出登录", for: .normal)
        exitLoginButton.layer.cornerRadius = 20
        exitLoginButton.backgroundColor = .lightGray
        exitLoginButton.addTarget(self, action: #selector(exitLoginAction), for: .touchUpInside)
        footerView.addSubview(exitLoginButton)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getHelpNumber().subscribe { [weak self] (model) in
            guard let self = self else {
                return
            }
            self.detailStringArray[2] = String(model)
            self.tableView.reloadData()
        } onError: { (error) in
            print("获取用户个数错误\(error)")
        }.disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textStringArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "mineCell")
        if indexPath.row == 3 {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "mineCell")
            cell.detailTextLabel?.text = detailStringArray[indexPath.row]
        }
        cell.textLabel?.text = textStringArray[indexPath.row]
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            self.navigationController?.pushViewController(SFChangePwdViewController(), animated: true)
        } else if indexPath.row == 4 {
            self.navigationController?.pushViewController(SFAboutUsViewController(), animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    @objc func exitLoginAction() {
        self.view.window?.rootViewController = SFLoginViewController()
        AF.request("http://192.168.1.105:8081/user/exitLogin?id=\(String(describing: ProfileManager.shared.curUserID()))", method: .get).response { (_) in }
        ProfileManager.shared.removeLoginCache()
    }

}
