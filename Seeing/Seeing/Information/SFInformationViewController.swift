//
//  SFInformationViewController.swift
//  Seeing
//
//  Created by qiangshuting on 2021/3/18.
//

import UIKit
import RxSwift
import Kingfisher

class SFInformationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView = UITableView()
    private var dataSource: [SFNewsModel] = []
    private var viewModel = SFInformationViewModel()
    private let disposeBag = DisposeBag()
    let headerView = SFWeatherView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "信息"
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "infoCell")
        self.view.addSubview(tableView)
        
        viewModel.getNews().subscribe { [weak self] (news) in
            guard let self = self else {
                return
            }
            self.dataSource = news
            self.tableView.reloadData()
        } onError: { (error) in
            print("获取新闻错误\(error)")
        }.disposed(by: disposeBag)


        viewModel.getWeather().subscribe { [weak self] (weather) in
            guard let self = self else {
                return
            }
            self.headerView.setThings(city: weather.city,
                                 condition: weather.condition,
                                 conditionImg: weather.conditionImg,
                                 tmp: weather.tmp,
                                 maxTmp: weather.maxTmp,
                                 minTmp: weather.minTmp,
                                 tip: weather.tip)
        } onError: { (error) in
            print("获取新闻错误\(error)")
        }.disposed(by: disposeBag)
        
        
        tableView.tableHeaderView = headerView
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell = tableView.dequeueReusableCell(withIdentifier: "infoCell")
//        if (cell == nil) {
//            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "infoCell")
//        }
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "infoCell")
        let model = dataSource[indexPath.row]
        cell.textLabel?.text = model.title
        cell.textLabel?.numberOfLines = 2
        cell.imageView?.kf.setImage(with: URL(string: model.picUrl))
        let itemSize = CGSize(width: 100, height: 80)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
        let imageRect = CGRect(x: 10, y: 10, width: itemSize.width, height: itemSize.height)
        cell.imageView?.image?.draw(in: imageRect)
        cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        cell.detailTextLabel?.text = "\n" + model.source + "   " + model.ctime
        cell.detailTextLabel?.numberOfLines = 0
        return cell
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
