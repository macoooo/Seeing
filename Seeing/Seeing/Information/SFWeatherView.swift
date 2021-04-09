//
//  SFWeatherView.swift
//  Seeing
//
//  Created by qiangshuting on 2021/3/19.
//

import UIKit

class SFWeatherView: UIView {
    let cityLabel: UILabel = UILabel()
    let conditionLabel: UILabel = UILabel()
    let conditionImageView: UIImageView = UIImageView()
    let currentTemLabel: UILabel = UILabel()
    let mostTemLabel: UILabel = UILabel()
    let airTipsLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        let bgImage = UIImage(named: "login_bg")
        self.layer.contents = bgImage?.cgImage
        cityLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        cityLabel.textColor = .black
        cityLabel.textAlignment = .center
        self.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(10)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
        
        conditionLabel.font = UIFont.systemFont(ofSize: 16)
        conditionLabel.textColor = .black
        conditionLabel.textAlignment = .center
        self.addSubview(conditionLabel)
        conditionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(cityLabel.snp.left).offset(5)
            make.top.equalTo(cityLabel.snp.bottom).offset(5)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        self.addSubview(conditionImageView)
        conditionImageView.snp.makeConstraints { (make) in
            make.left.equalTo(conditionLabel.snp.right).offset(5)
            make.top.equalTo(conditionLabel.snp.top)
            make.width.height.equalTo(30)
        }
        
        currentTemLabel.font = UIFont.systemFont(ofSize: 17)
        currentTemLabel.textColor = .black
        currentTemLabel.textAlignment = .left
        self.addSubview(currentTemLabel)
        currentTemLabel.snp.makeConstraints { (make) in
            make.left.equalTo(cityLabel.snp.right).offset(20)
            make.top.equalTo(cityLabel.snp.top)
            make.right.equalTo(-10)
            make.height.equalTo(30)
        }
        
        mostTemLabel.font = UIFont.systemFont(ofSize: 17)
        mostTemLabel.textColor = .black
        mostTemLabel.textAlignment = .left
        self.addSubview(mostTemLabel)
        mostTemLabel.snp.makeConstraints { (make) in
            make.left.equalTo(currentTemLabel.snp.left)
            make.top.equalTo(currentTemLabel.snp.bottom).offset(5)
            make.right.equalTo(-10)
            make.height.equalTo(30)
        }
        
        airTipsLabel.font = UIFont.systemFont(ofSize: 17)
        airTipsLabel.textColor = .black
        airTipsLabel.textAlignment = .left
        airTipsLabel.numberOfLines = 0
        self.addSubview(airTipsLabel)
        airTipsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(currentTemLabel.snp.left)
            make.top.equalTo(mostTemLabel.snp.bottom).offset(5)
            make.right.equalTo(-10)
            make.bottom.equalTo(-5)
        }
    }
    
    func setThings(city: String,
                   condition: String,
                   conditionImg: String,
                   tmp: String,
                   maxTmp: String,
                   minTmp: String,
                   tip: String) {
        cityLabel.text = city
        conditionLabel.text = condition
        conditionImageView.image = UIImage(named: conditionImg)
        currentTemLabel.text = "当前温度: " + tmp + "℃"
        mostTemLabel.text = "最高温度: \(maxTmp)" + "      最低温度: \(minTmp)"
        airTipsLabel.text = tip
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
