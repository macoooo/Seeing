//
//  profileManager.swift
//  trtcScenesDemo
//
//  Created by xcoderliu on 12/23/19.
//  Copyright © 2019 xcoderliu. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import Alamofire

let userBaseUrl = "http://192.168.1.105:8081/user/"
var sdkBusiId: Int32 = 26641
//#if DEBUG
//    sdkBusiId = 26641
//#else
//    sdkBusiId = 26642
//#endif

//LoginModel
class ResultInfoModel: NSObject, Codable {
    var code: Int = -1
    @objc var message: String = ""
    var result: String? = ""
    var total: Int? = 0
}
class LoginModel: NSObject, Codable {
    var code: Int = -1
    @objc var message: String = ""
    var result: MyUserModel? = nil
    var total: Int? = 0
}

 class LoginResultModel: NSObject, Codable {
    @objc var token: String
    @objc var phone: String
    @objc var name: String
    @objc var avatar: String
    @objc var userId: String
    @objc var userSig: String = ""
    @objc var userModel: MyUserModel
    
    public init(userID: String, userModel: MyUserModel, userSig: String) {
        self.userId = userID
        self.token = userID
        self.phone = userID
//        name = "shutin"
        self.name = userModel.userName
        //客户端计算Sig的方法，现在改为服务端计算返回
//        userSig = GenerateTestUserSig.genTestUserSig(userID)
        self.userSig = userSig
        self.userModel = userModel
        avatar = ""
        super.init()
    }
}

class MyUserModel: NSObject, Codable {
    @objc var id: String
    @objc var phone: String
    @objc var userName: String
    @objc var userPassword: String
    @objc var sex: Int = 1
    @objc var type: Int = 1
    @objc var callNumber: Int = 0
    @objc var loginStatus: Int = 0
}

@objc class QueryModel: NSObject, Codable {
    @objc var errorCode: Int = -1
    @objc var errorMessage: String = ""
    var data: UserModel? = nil
}

@objc class QueryBatchModel: NSObject, Codable {
    @objc var errorCode: Int = -1
    @objc var errorMessage: String = ""
    var data: [UserModel]? = nil
}

@objc public class UserModel: NSObject, Codable {
    @objc var phone: String?
    @objc var name: String
    @objc var avatar: String
    @objc var userId: String
    
    public init(userID: String) {
        userId = userID
        name = userID
        avatar = ""
        phone = userID
        super.init()
    }
    
    func copy() -> UserModel {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else {
            fatalError("encode失败")
        }
        let decoder = JSONDecoder()
        guard let target = try? decoder.decode(UserModel.self, from: data) else {
           fatalError("decode失败")
        }
        return target
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        if let user = object as? UserModel {
            if user.userId == userId {
                return true
            }
        }
        return false
    }
}

//NameModel
@objc class NameModel: NSObject, Codable {
    @objc var errorCode:
        Int32 = -1
    @objc var errorMessage: String = ""
}

//VerifyModel
@objc class VerifyModel: NSObject, Codable {
    @objc var errorCode: Int32 = -1
    @objc var errorMessage: String = ""
    var data: VerifyResultModel? = nil
}

@objc class VerifyResultModel: NSObject, Codable {
    var sessionId: String? = nil
    var requestId: String? = nil
    var codeStr: String? = nil
}

public class ProfileManager: NSObject {
    public static let shared = ProfileManager()
    private override init() {}
    
    var phone = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    var code = BehaviorRelay<String>(value: "")
    var sessionId: String = ""
    var curUserModel: LoginResultModel? = nil
    
    /// 自动登录
    /// - Parameters:
    ///   - success: 成功回调
    ///   - failed: 失败回调
    ///   - error: 错误信息
    /// - Returns:是否可以自动登录
    public func autoLogin(success: @escaping ()->Void,
                          failed: @escaping (_ error: String)->Void) -> Bool {
        let tokenKey = "com.qst.Seeing"
        if let cacheData = UserDefaults.standard.object(forKey: tokenKey) as? Data {
            do {
                let cacheUser = try JSONDecoder().decode(LoginResultModel.self, from: cacheData)
                curUserModel = cacheUser
                print("用户model为\(curUserModel?.userSig)")
                let fail: (_ error: String)->Void = { err in
                    failed(err)
                    UserDefaults.standard.set(nil, forKey: tokenKey)
                }
                TRTCCalling.shareInstance().imBusinessID = sdkBusiId
                TRTCCalling.shareInstance().deviceToken = AppUtils.shared.appDelegate.deviceToken
                self.IMLogin(userId: curUserModel?.userId ?? "", userSig: curUserModel?.userSig ?? "") { [weak self] in
                    guard let self = self else {
                        return
                    }
                    TRTCCalling.shareInstance().login(sdkAppID: UInt32(SDKAPPID), user: self.curUserModel?.userId ?? "" , userSig: self.curUserModel?.userSig ?? "") {
                        print("\(self.curUserModel?.userId ?? "")Video Call login成功")
                        
                    } failed: { (code, error) in
                        print("\(self.curUserModel?.userId ?? "")Video Call login失败\(error)")
                    }
                } failed: { (error) in
                    print("IM登录失败\(error)")
                }
                login(success: success, failed: fail, auto: true)
                return true
            } catch {
                print("Retrieve Failed")
                return false
            }
        }
        return false
    }
    
    /// 发送验证码
    /// - Parameters:
    ///   - success: 成功
    ///   - failed: 失败
    ///   - error: 错误信息
    public func sendVerifyCode(typeStr: String, success: @escaping ()->Void,
                               failed: @escaping (_ error: String)-> Void) {
        let verifyCodeUrl = userBaseUrl + "sendSms?phone=\(phone.value)&typeStr=\(typeStr)"
        AF.request(verifyCodeUrl, method: .get).responseJSON { (response) in
            if let respData = response.data, respData.count > 0 {
                let decoder = JSONDecoder()
                guard let result = try? decoder.decode(ResultInfoModel.self, from: respData) else {
                    failed("发送验证码ResultInfoModel decode失败")
                    return
//                    fatalError("发送验证码ResultInfoModel decode失败")
                }
                if result.code == 0, result.message == "Ok" {
                    success()
                } else {
                    failed(result.message)
                }
            } else {
                failed("发送失败，请稍后重试")
            }
        }
    }
    
    /// 注册
    /// - Parameters:
    ///   - success: 成功
    ///   - failed: 失败
    @objc public func register(success: @escaping ()->Void,
                               failed: @escaping (_ error: String)->Void) {
        let registerUrl = userBaseUrl + "register"
        let params = ["phone":phone.value, "code":code.value] as [String : String]
        AF.request(registerUrl, method: .post, parameters: params).responseJSON { [weak self] (data) in
            guard self != nil else {return}
            if let respData = data.data, respData.count > 0 {
                let decoder = JSONDecoder()
                guard let result = try? decoder.decode(ResultInfoModel.self, from: respData) else {
                    failed("注册ResultInfoModel decode失败")
                    return
//                    fatalError("注册ResultInfoModel decode失败")
                }
                if result.code == 0 {
                    success()
                } else {
                    failed(result.message)
                }
            } else {
                failed("发送失败，请稍后重试")
            }
        }
    }
    
    /// 登录
    /// - Parameters:
    ///   - success: 登录成功
    ///   - failed: 登录失败
    ///   - error: 错误信息
    @objc public func login(success: @escaping ()->Void,
                            failed: @escaping (_ error: String)->Void , auto: Bool = false) {
        let phoneValue = phone.value
        let pwdValue = password.value
        let loginUrl = userBaseUrl + "login?phone=\(phoneValue)&pwd=\(pwdValue)"
        if !auto {
            AF.request(loginUrl, method: .get).responseJSON { [weak self] (data) in
                guard let self = self else {return}
                if let respData = data.data, respData.count > 0 {
                    
                    let decoder = JSONDecoder()
                    guard let result = try? decoder.decode(LoginModel.self, from: respData) else {
                        print("LoginModel decode失败\(respData)")
                        failed("LoginModel decode失败")
                        return
//                        fatalError("LoginModel decode失败")
                    }
                    if result.code == 0 , let userData = result.result {
                        self.curUserModel = LoginResultModel(userID: userData.id, userModel: userData, userSig: result.message)
                        let tokenKey = "com.qst.Seeing"
                        do {
                            let cacheData = try JSONEncoder().encode(self.curUserModel)
                            UserDefaults.standard.set(cacheData, forKey: tokenKey)
                        } catch {
                          print("Save Failed")
                        }
                        TRTCCalling.shareInstance().imBusinessID = sdkBusiId
                        TRTCCalling.shareInstance().deviceToken = AppUtils.shared.appDelegate.deviceToken
                        self.IMLogin(userId: userData.id, userSig: result.message) {
                            TRTCCalling.shareInstance().login(sdkAppID: UInt32(SDKAPPID), user: userData.id , userSig: result.message) {
                                print("\(userData.id)Video Call login成功")
                                
                            } failed: { (code, error) in
                                print("Video Call login失败\(error)")
                            }
                        } failed: { (error) in
                            print("IM登录失败\(error)")
                        }

                        success()
                    } else {
                        failed(result.message)
                    }
                } else {
                    failed("发送失败，请稍后重试")
                }
            }
        } else {
            success()
        }
    }
    
    /// 设置密码
    /// - Parameters:
    ///   - pwd: 密码
    ///   - success: 成功
    ///   - failed: 失败
    public func setPwd(pwd: String, success: @escaping ()->Void,
                       failed: @escaping (_ error: String)->Void) {
        let setPwdUrl = userBaseUrl + "setPwd"
        let params = ["phone": phone.value, "pwd": pwd] as [String : String]
        AF.request(setPwdUrl, method: .post, parameters: params).responseJSON { (data) in
            if let respData = data.data, respData.count > 0 {
                let decoder = JSONDecoder()
                guard let result = try? decoder.decode(ResultInfoModel.self, from: respData) else {
                    failed("设置密码ResultInfoModel decode失败")
                    return
//                    fatalError("设置密码ResultInfoModel decode失败")
                }
                if result.code == 0 {
                    success()
                } else {
                    failed(result.message)
                }
            } else {
                failed("发送失败，请稍后重试")
            }
        }
    }
    
    public func addHelpNumber(sponsorID: String, userID: String, success: @escaping ()->Void,
                       failed: @escaping (_ error: String)->Void) {
        let setPwdUrl = userBaseUrl + "addHelpNumberCount"
        let params = ["sponsorID": sponsorID, "userID": userID] as [String : String]
        AF.request(setPwdUrl, method: .post, parameters: params).responseJSON { (data) in
            if let respData = data.data, respData.count > 0 {
                let decoder = JSONDecoder()
                guard let result = try? decoder.decode(ResultInfoModel.self, from: respData) else {
                    failed("addHelpNumber ResultInfoModel decode失败")
                    return
                }
                if result.code == 0 {
                    success()
                } else {
                    failed(result.message)
                }
            } else {
                failed("发送失败，请稍后重试")
            }
        }
    }
    
    public func setType(type: Int, success: @escaping ()->Void,
                       failed: @escaping (_ error: String)->Void) {
        let setPwdUrl = userBaseUrl + "setUserType"
        let params = ["id": phone.value, "type": type] as [String : Any]
        AF.request(setPwdUrl, method: .post, parameters: params).responseJSON { (data) in
            if let respData = data.data, respData.count > 0 {
                let decoder = JSONDecoder()
                guard let result = try? decoder.decode(ResultInfoModel.self, from: respData) else {
                    failed("设置类型ResultInfoModel decode失败")
                    return
//                    fatalError("设置类型ResultInfoModel decode失败")
                }
                if result.code == 0 {
                    success()
                } else {
                    failed(result.message)
                }
            } else {
                failed("发送失败，请稍后重试")
            }
        }
    }
    
    @objc public func forgetSetPwd(pwd: String, success: @escaping ()->Void,
                                   failed: @escaping (_ error: String)->Void) {
        let url = userBaseUrl + "foretSoSetPwd"
        let params = ["id": phone.value, "pwd": pwd] as [String : String]
        AF.request(url, method: .post, parameters: params).responseJSON { (data) in
            if let respData = data.data, respData.count > 0 {
                let decoder = JSONDecoder()
                guard let result = try? decoder.decode(ResultInfoModel.self, from: respData) else {
                    failed("forgetSetPwd ResultInfoModel decode失败")
                    fatalError("forgetSetPwd ResultInfoModel decode失败")
                }
                if result.code == 0 {
                    success()
                } else {
                    failed(result.message)
                }
            } else {
                failed("发送失败，请稍后重试")
            }
        }
    }
    
    
    /// 设置昵称
    /// - Parameters:
    ///   - name: 昵称
    ///   - success: 成功回调
    ///   - failed: 失败回调
    ///   - error: 错误信息
    @objc public func setNickName(name: String, success: @escaping ()->Void,
                        failed: @escaping (_ error: String)->Void) {
        let nameUrl = userBaseUrl + "nickname"
        guard let userId = curUserModel?.userId else {
            failed("注册失败，请稍后重试")
            return
        }
        guard let token = curUserModel?.token else {
            failed("注册失败，请稍后重试")
            return
        }
        let params = ["userId":userId,"name":name,"token":token] as [String : Any]
        AF.request(nameUrl, method: .post, parameters: params).responseJSON { (data) in
            if let respData = data.data, respData.count > 0 {
                let decoder = JSONDecoder()
                guard let result = try? decoder.decode(NameModel.self, from: respData) else {
                    failed("NameModel decode失败")
                    return
//                    fatalError("NameModel decode失败")
                }
                if result.errorCode == 0 {
                    success()
                    debugPrint("\(result)")
                } else {
                    debugPrint("\(result.errorMessage)")
                    if result.errorCode == -1008 { //token失效 返回到登录页面
                        failed(result.errorMessage)
                    } else {
                        failed(result.errorMessage)
                    }
                }
            } else {
                failed("注册失败，请稍候重试")
            }
        }
    }
    
    /// 根据手机号查询用户信息
    /// - Parameters:
    ///   - phone: 手机号码
    ///   - success: 成功回调
    ///   - failed: 失败回调
    ///   - error: 错误信息
    @objc public func queryUserInfo(phone: String, success: @escaping (UserModel)->Void,
                              failed: @escaping (_ error: String)->Void) {
        if phone.count > 0 {
            success(UserModel.init(userID: phone))
        } else {
            failed("错误的userID")
        }
    }
    
    /// 查询单个用户信息
    /// - Parameters:
    ///   - userID: 用户id
    ///   - success: 成功回调
    ///   - failed: 失败回调
    ///   - error: 错误信息
    @objc public func queryUserInfo(userID: String, success: @escaping (UserModel)->Void,
                                    failed: @escaping (_ error: String)->Void) {
        if userID.count > 0 {
            success(UserModel.init(userID: userID))
        } else {
            failed("错误的userID")
        }
    }
    
    /// 查询多个用户信息
    /// - Parameters:
    ///   - userIDs: 用户id列表
    ///   - success: 成功回调
    ///   - failed: 失败回调
    ///   - error : 错误信息
    @objc public func queryUserListInfo(userIDs: [String], success: @escaping ([UserModel])->Void,
                                  failed: @escaping (_ error: String)->Void) {
        if userIDs.count > 0 {
            var models: [UserModel] = []
            for userID in userIDs {
                models.append(UserModel.init(userID: userID))
            }
            success(models)
        } else {
            failed("空userIDs")
        }
    }
    
    /// IM 登录当前用户
    /// - Parameters:
    ///   - success: 成功
    ///   - failed: 失败
    @objc func IMLogin(userId: String, userSig: String, success: @escaping ()->Void, failed: @escaping (_ error: String)->Void) {
        let config = TIMSdkConfig.init()
        config.sdkAppId = Int32(SDKAPPID)
        config.dbPath = NSHomeDirectory() + "/Documents/com_tencent_imsdk_data/"
        TIMManager.sharedInstance()?.initSdk(config)
        
//        guard let userID = curUserModel?.userId else {
//            failed("userID 错误")
//            return
//        }
//        let user = String(user)
//        let user = "18391741628"
        let loginParam = TIMLoginParam.init()
        loginParam.identifier = userId
        loginParam.userSig = userSig
        TIMManager.sharedInstance()?.login(loginParam, succ: {
            debugPrint("login success")
            success()
        }, fail: { (code, errorDes) in
            failed(errorDes ?? "")
            debugPrint("login failed, userId:\(userId) code:\(code), error: \(errorDes ?? "nil")")
        })
    }
    
    @objc func curUserID() -> String? {
        guard let userID = curUserModel?.userId else {
            return nil
        }
        return userID
    }
    
    @objc public func removeLoginCache() {
        let tokenKey = "com.qst.Seeing"
        UserDefaults.standard.set(nil, forKey: tokenKey)
    }
    
    public func getLoginCache() -> Data? {
        let tokenKey = "com.qst.Seeing"
        guard let cacheData = UserDefaults.standard.object(forKey: tokenKey) as? Data else {
            return nil
        }
        return cacheData
    }
    
    @objc public func curUserSig() -> String {
           return curUserModel?.userSig ?? ""
    }
}
