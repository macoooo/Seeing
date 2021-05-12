//
//  SFSeekHelpViewModel.swift
//  Seeing
//
//  Created by qiangshuting on 2021/5/3.
//

import Foundation
import Alamofire
import RxSwift

class SFSeekHelpResultModel: NSObject, Codable {
    var code: Int = -1
    @objc var message: String = ""
    var result: SFVolunteerModel? = nil
    var total: Int? = 0
}

class SFVolunteerModel: Codable {
    var id: String
    var userName: String
    var userPassword: String
    var phone: String
    var sex: Int
    var helpNumber: Int
    var loginStatus: Int
}

class SFSeekHelpViewModel {
    func seekVolunteer() -> Observable<(SFVolunteerModel, String)> {
        return Observable.create { (observer) -> Disposable in
            let url = userBaseUrl + "findHelper?id=\( ProfileManager.shared.curUserID() ?? "")"
            AF.request(url, method: .get).response { (response) in
                if let respData = response.data, respData.count > 0 {
                    let decoder = JSONDecoder()
                    guard let result = try? decoder.decode(SFSeekHelpResultModel.self, from: respData) else {
                        fatalError("seekHelpResultInfoModel decode失败")
                    }
                    if result.code == 0, let volunteerData = result.result {
                        observer.onNext((volunteerData, result.message))
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
