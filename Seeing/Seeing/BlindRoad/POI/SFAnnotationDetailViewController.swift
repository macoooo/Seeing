//
//  SFAnnotationDetailViewController.swift
//  Seeing
//
//  Created by qiangshuting on 2021/3/25.
//

import UIKit
import Alamofire
import RxSwift
import RxCocoa

class SFAnnotationDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {

    private var tableView = UITableView()
    private var textStringArray: [String] = []
    private var detailStringArray: [String] = []
    private var coordinate: CLLocationCoordinate2D
    private var reGeocode: AMapReGeocode
    var doneBlock: (() -> Void)?
    var addressHeight: CGFloat = 0
    var titles: [(String, UIImage?)] = [
        ("盲道被其他物品占用", nil),
        ("盲道道路被破坏", nil),
        ("其他", nil)
    ]
    private var reasonType: Int = 0
    private var reason: String = ""
    private let disposeBag = DisposeBag()
    let otherTextView = UITextView()
    
    init(coordinate: CLLocationCoordinate2D, reGeocode: AMapReGeocode) {
        self.coordinate = coordinate
        self.reGeocode = reGeocode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bgImage = UIImage(named: "login_bg")
        self.view.layer.contents = bgImage?.cgImage
        self.title = "详细信息"
        
        let rightBarButtonItem = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(rightBtnItem))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "annotationCell")
        self.view.addSubview(tableView)
        
        textStringArray = ["经度", "纬度", "地址"]
        detailStringArray = [String(coordinate.latitude), String(coordinate.longitude), String(reGeocode.formattedAddress)]
        addressHeight = reGeocode.formattedAddress.heightWithFont(font: UIFont.systemFont(ofSize: 17), fixedWidth: 300)
        print("盲道地址的高度为\(addressHeight)")
        
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 2 {
                return addressHeight > 20 ? addressHeight + 20: 44
            }
        }
        return 44
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
            
            let label = UILabel(frame: CGRect(x: 10, y: 10, width: 200, height: 30))
            label.text = "盲道的具体问题是什么"
            label.font = UIFont.systemFont(ofSize: 13)
            view.addSubview(label)
            
            let bounds = view.bounds;
            let width = bounds.width - 20;
            
            let mTextField = UITextField()
            mTextField.placeholder = "请选择具体原因"
            mTextField.isUserInteractionEnabled = false
            let textField = SFDropBoxTextField(frame: CGRect(x: 10, y: 50, width: width, height: 44), customTextField: mTextField)
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.lightGray.cgColor
            /// 设置选项内容
            textField.count = titles.count
            textField.itemForRowAt = { [weak self] (index) -> (String, UIImage?) in
                guard let title = self?.titles[index].0 else {
                    return ("", nil)
                }
                return (title, nil);
            }
            textField.didSelectedAt = { [weak self] (index, title, textField) in
                print("选中第 \(index) 行，标题 \(title)")
                guard let self = self else {
                    return
                }
                self.reasonType = index + 1
                self.reason = title
                textField.drawUp()
                if index == self.titles.count - 1,
                    title == "其他" {
                    self.otherTextView.frame = CGRect(x: 10, y: 100, width: width, height: 100)
                    self.otherTextView.layer.borderWidth = 1
                    self.otherTextView.layer.borderColor = UIColor.red.cgColor
                    self.otherTextView.isEditable = true
                    self.otherTextView.layer.cornerRadius = 10
                    self.otherTextView.delegate = self
                    self.otherTextView.returnKeyType = .done
//                    otherTextView.rx.text.orEmpty.bind(to: self.reason).disposed(by: disposeBag)
                    view.addSubview(self.otherTextView)
                }
            }
            view.addSubview(textField)
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 300
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "annotationCell")
        if indexPath.section == 0 {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "annotationCell")
        } else {
            
        }
        cell.textLabel?.text = textStringArray[indexPath.row]
        cell.detailTextLabel?.text = detailStringArray[indexPath.row]
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
    
    @objc func rightBtnItem() {
        self.navigationController?.popViewController(animated: true)
        self.doneBlock?()
        // 上传数据
        if reasonType == self.titles.count,  otherTextView.text.count > 0 {
            self.reason = otherTextView.text
        }
        let url = "http://192.168.105:8081/blindRoad/upload"
        let params = ["latitude": coordinate.latitude, "longitude": coordinate.longitude, "reasonType":reasonType, "reason":reason, "uploadAddress":reGeocode.formattedAddress ?? "", "uploaderUserId": ProfileManager.shared.curUserID() ?? "", "uploaderUserName": ProfileManager.shared.curUserModel?.name ?? "", "uploaderPhone": ProfileManager.shared.curUserModel?.phone ?? ""] as [String : Any]
        AF.request(url, method: .post, parameters: params).response { (response) in
            if let respData = response.data, respData.count > 0 {
                print("盲道数据上传成功\(respData)")
            } else {
                self.showAlert(info: ("提示","上传失败，请检查重试"))
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        /// 点击空白处回收键盘
        view.endEditing(false);
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
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
