//
//  SFInformationViewModel.swift
//  Seeing
//
//  Created by qiangshuting on 2021/3/19.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift

struct SFNewsModel {
    let ctime: String
    let title: String
    let picUrl: String
    let url: String
    let source: String
}

struct SFWeatherModel {
    var city: String = ""
    var condition: String = ""
    var conditionImg: String = ""
    var tmp: String = ""
    var maxTmp: String = ""
    var minTmp: String = ""
    var tip: String = ""
}

class SFInformationViewModel {
    var dataSource: [SFNewsModel] = []
    
    func getNews() -> Observable<[SFNewsModel]> {
        return Observable<[SFNewsModel]>.create { [weak self] (observer) -> Disposable in
            AF.request("https://api.tianapi.com/topnews/index?key=998f0b9124489f49ffa2b0af557e6d27", method: HTTPMethod.get).responseJSON { (response) in
                if response.error == nil {
                    let dic = try! JSON(data: response.data!)
                    let newsArray = dic["newslist"]
                    newsArray.forEach { (_, new) in
                        var picString = new.dictionary?["picUrl"]?.string ?? ""
                        if picString.count > 0 {
                            picString.insert(Character("s"), at: picString.index(picString.startIndex, offsetBy: 4))
                        }
                        
                        print(picString)
                        let model = SFNewsModel(
                            ctime: self?.subString(new.dictionary?["ctime"]?.string ?? "") ?? "",
                            title: new.dictionary?["title"]?.string ?? "",
                            picUrl: picString,
                            url: new.dictionary?["url"]?.string ?? "",
                            source: new.dictionary?["source"]?.string ?? ""
                        )
                        self?.dataSource.append(model)
                    }
                    observer.onNext(self?.dataSource ?? [])
                    observer.onCompleted()
                } else {
                    observer.onError(response.error!)
                }
            }
            return Disposables.create()
        }
    }
    
    func getWeather() -> Observable<SFWeatherModel> {
        return Observable<SFWeatherModel>.create { (observer) -> Disposable in
            AF.request("https://www.tianqiapi.com/api?version=v6&appid=48653296&appsecret=3uIQBwsq", method: HTTPMethod.get).responseJSON { (response) in
                if response.error == nil {
                    let dic = try! JSON(data: response.data!)
                    var weatherModel: SFWeatherModel = SFWeatherModel()
                    weatherModel.city = dic["city"].string ?? ""
                    weatherModel.condition = dic["wea"].string ?? ""
                    weatherModel.conditionImg = dic["wea_img"].string ?? ""
                    weatherModel.tmp = dic["tem"].string ?? ""
                    weatherModel.maxTmp = dic["tem1"].string ?? ""
                    weatherModel.minTmp = dic["tem2"].string ?? ""
                    weatherModel.tip = dic["air_tips"].string ?? ""
                    observer.onNext(weatherModel)
                    observer.onCompleted()
                } else {
                    observer.onError(response.error!)
                }
            }
            return Disposables.create()
        }
    }
    
    private func subString(_ str: String) -> String {
        let range: Range = str.range(of: " ")!
        let location: Int = str.distance(from: str.startIndex, to: range.upperBound)
        let subStr = str.suffix(str.count - location)
        return String(subStr)
    }
}
