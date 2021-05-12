//
//  SFPOIKeywordSearchViewModel.swift
//  Seeing
//
//  Created by qiangshuting on 2021/5/6.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class SFMapResultModel: NSObject, Codable {
    var code: Int = -1
    @objc var message: String = ""
    var result: [SFLocationCoordinate2D]? = nil
    var total: Int? = 0
}

class SFLocationCoordinate2D: Codable {
    var latitude: Double
    var longitude: Double
}

class SFPOIKeywordSearchViewModel {
    func findRecentBlindRoad(latitude: Double, longitude: Double) -> Observable<[SFLocationCoordinate2D]> {
           return Observable.create { (observer) -> Disposable in
               let url = "http://192.168.1.105:8081/blindRoad/" + "selectBlindRoad?latitude=\(latitude)&longitude=\(longitude)"
               AF.request(url, method: .get).response { (response) in
                   if let respData = response.data, respData.count > 0 {
                       let decoder = JSONDecoder()
                       guard let result = try? decoder.decode(SFMapResultModel.self, from: respData) else {
                           return
   //                        fatalError("getUserCount decode失败")
                       }
                       if result.code == 0, let countData = result.result {
                           observer.onNext(countData)
                           observer.onCompleted()
                       }
                   } else {
                       observer.onError(response.error!)
                   }
               }
               return Disposables.create()
           }
    }
}
