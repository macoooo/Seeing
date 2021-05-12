//
//  SFHelpViewModel.swift
//  Seeing
//
//  Created by shutingqiang on 2021/2/8.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

class SFHelpResultModel: NSObject, Codable {
    var code: Int = -1
    @objc var message: String = ""
    var result: SFUserCountModel? = nil
    var total: Int? = 0
}

class SFUserCountModel: Codable {
    var volunteerCount: Int
    var blindCount: Int
}

class SFHelpViewModel {
    func getUserCount() -> Observable<(SFUserCountModel)> {
        return Observable.create { (observer) -> Disposable in
            let url = userBaseUrl + "getUserCount"
            AF.request(url, method: .get).response { (response) in
                if let respData = response.data, respData.count > 0 {
                    let decoder = JSONDecoder()
                    guard let result = try? decoder.decode(SFHelpResultModel.self, from: respData) else {
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
