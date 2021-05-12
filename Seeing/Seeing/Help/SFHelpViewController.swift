//
//  SFHelpViewController.swift
//  Seeing
//
//  Created by shutingqiang on 2021/2/8.
//

import UIKit
import SnapKit
import RxSwift

class SFHelpViewController: UIViewController {
    let viewModel = SFHelpViewModel()
    private var disposeBag = DisposeBag()
    private var userCountModel: SFUserCountModel?
    let blindLabel = UILabel()
    let volunteerLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let bgImage = UIImage(named: "login_bg")
        self.view.layer.contents = bgImage?.cgImage
        self.title = "Help"
        
        let aixinImage = UIImage(named: "aixin_icon")
        let aixinImageView = UIImageView(image: aixinImage)
        self.view.addSubview(aixinImageView)
        aixinImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(UIScreen.main.bounds.width / 2 - 50)
            make.top.equalTo(150)
            make.width.equalTo(100)
            make.height.equalTo(90)
        }

        blindLabel.textColor = .white
        blindLabel.numberOfLines = 0
        blindLabel.font = UIFont.systemFont(ofSize: 20)
        blindLabel.textAlignment = .center
        let blindNumber = userCountModel?.blindCount ?? 0
        blindLabel.text = "视障者\n\(blindNumber)"
        self.view.addSubview(blindLabel)
        blindLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(UIScreen.main.bounds.width / 2 - 140)
            make.top.equalTo(250)
            make.right.equalTo(aixinImageView).offset(-80)
            make.height.equalTo(80)
        }
        
        volunteerLabel.textColor = .white
        volunteerLabel.numberOfLines = 0
        volunteerLabel.font = UIFont.systemFont(ofSize: 20)
        volunteerLabel.textAlignment = .center
        let volunteerNumber = userCountModel?.volunteerCount ?? 0
        volunteerLabel.text = "志愿者\n\(volunteerNumber)"
        self.view.addSubview(volunteerLabel)
        volunteerLabel.snp.makeConstraints { (make) in
            make.left.equalTo(blindLabel.snp.right).offset(80)
            make.top.equalTo(blindLabel.snp.top)
            make.right.equalToSuperview().offset(-(UIScreen.main.bounds.width / 2 - 120))
            make.height.equalTo(80)
        }
        
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: 500))
        linePath.addLine(to: CGPoint(x: UIScreen.main.bounds.width / 2, y: 550))
        linePath.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 500))
        linePath.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height))
        linePath.addLine(to: CGPoint(x: 0, y: UIScreen.main.bounds.height))

        let lineLayer = CAShapeLayer()
        lineLayer.lineWidth = 1
        lineLayer.strokeColor = UIColor.green.cgColor
        lineLayer.path = linePath.cgPath
        lineLayer.fillColor = UIColor.white.cgColor
        self.view.layer.addSublayer(lineLayer)
        
        let helpTipView = UIView()
        helpTipView.layer.cornerRadius = 10
        helpTipView.layer.borderWidth = 0.5
        helpTipView.layer.borderColor = UIColor.lightGray.cgColor
        self.view.addSubview(helpTipView)
        helpTipView.layer.backgroundColor = UIColor.white.cgColor
        helpTipView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(UIScreen.main.bounds.width / 2 - 120)
            make.right.equalToSuperview().offset(-(UIScreen.main.bounds.width / 2 - 120))
            make.top.equalToSuperview().offset(440)
            make.height.equalTo(130)
        }
        helpTipView.layoutIfNeeded()
        
        let envelopePath = UIBezierPath()
        envelopePath.move(to: CGPoint(x: 0, y: 20))
        envelopePath.addLine(to: CGPoint(x: helpTipView.frame.width / 2, y: 130 / 2))
        envelopePath.addLine(to: CGPoint(x: helpTipView.frame.width, y: 20))
        envelopePath.addLine(to: CGPoint(x: helpTipView.frame.width, y: helpTipView.frame.height))
        envelopePath.addLine(to: CGPoint(x: 0, y: helpTipView.frame.height))
        
        let envelopeLayer = CAShapeLayer()
        envelopeLayer.lineWidth = 1
        envelopeLayer.strokeColor = UIColor.white.cgColor
        envelopeLayer.path = envelopePath.cgPath
        envelopeLayer.fillColor = UIColor(white: 0.05, alpha: 0.05).cgColor
        envelopeLayer.cornerRadius = 10
        helpTipView.layer.addSublayer(envelopeLayer)
        
        let helpTiplabel = UILabel()
        helpTiplabel.text = "当有人需要你的帮助时，您将收到通知。"
        helpTiplabel.textColor = .black
        helpTiplabel.textAlignment = .center
        helpTiplabel.font = UIFont.systemFont(ofSize: 12)
        helpTipView.addSubview(helpTiplabel)
        helpTiplabel.snp.makeConstraints { (make) in
            make.left.lessThanOrEqualTo(10)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(10)
            make.height.equalTo(60)
        }
        
        let tipImage = UIImage(named: "tixing_icon")
        let tipImageView = UIImageView(image: tipImage)
        helpTipView.addSubview(tipImageView)
        tipImageView.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.centerX.equalToSuperview()
            make.left.equalTo(helpTipView.frame.width / 2 - 15)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getUserCount().subscribe { [weak self] (model) in
            guard let self = self else {
                return
            }
            self.userCountModel = model
            self.blindLabel.text = "视障者\n\(model.blindCount)"
            self.volunteerLabel.text = "志愿者\n\(model.volunteerCount)"
        } onError: { (error) in
            print("获取用户个数错误\(error)")
        }.disposed(by: disposeBag)
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
