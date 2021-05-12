//
//  SFMineViewModel.swift
//  Seeing
//
//  Created by qiangshuting on 2021/3/18.
//

import Foundation
import RxSwift
import Alamofire

class SFMineResultModel: NSObject, Codable {
    var code: Int = -1
    @objc var message: String = ""
    var result: Int? = 0
    var total: Int? = 0
}

class SFMineViewModel {
    func getHelpNumber() -> Observable<Int> {
        return Observable.create { (observer) -> Disposable in
            let url = userBaseUrl + "getHelpNumber?id=\(ProfileManager.shared.curUserID() ?? "")"
            AF.request(url, method: .get).response { (response) in
                if let respData = response.data, respData.count > 0 {
                    let decoder = JSONDecoder()
                    guard let result = try? decoder.decode(SFMineResultModel.self, from: respData) else {
                        return
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
