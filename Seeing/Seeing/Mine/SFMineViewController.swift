//
//  SFMineViewController.swift
//  Seeing
//
//  Created by qiangshuting on 2021/3/17.
//

import UIKit
import SnapKit

class SFMineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    private var tableView = UITableView()
    private var textStringArray: [String] = []
    private var detailStringArray: [String] = []

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
        
        textStringArray = ["用户名", "用户类型", "更改密码", "关于我们", "设置"]
        detailStringArray = ["小志", "志愿者", "", "", ""]
        
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

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textStringArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "mineCell")
        if indexPath.row == 2 {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "mineCell")
            cell.detailTextLabel?.text = detailStringArray[indexPath.row]
        }
        cell.textLabel?.text = textStringArray[indexPath.row]
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            self.navigationController?.pushViewController(SFChangePwdViewController(), animated: true)
        }
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
