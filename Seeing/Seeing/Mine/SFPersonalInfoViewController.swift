////
////  SFPersonalInfoViewController.swift
////  Seeing
////
////  Created by qiangshuting on 2021/5/5.
////
//
//import UIKit
//
//class SFPersonalInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    private var tableView = UITableView()
//    private var textStringArray: [String] = []
//    private var detailStringArray: [String] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let bgImage = UIImage(named: "login_bg")
//        self.view.layer.contents = bgImage?.cgImage
//        self.title = "我"
//
//        tableView = UITableView(frame: self.view.bounds, style: .grouped)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "personInfoCell")
//        self.view.addSubview(tableView)
//
//        // Do any additional setup after loading the view.
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
