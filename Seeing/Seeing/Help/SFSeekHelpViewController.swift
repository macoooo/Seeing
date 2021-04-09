//
//  SFSeekHelpViewController.swift
//  Seeing
//
//  Created by qiangshuting on 2021/3/16.
//

import UIKit
import SnapKit
import RxSwift
import Toast_Swift
import Material

enum CallingUserRemoveReason: UInt32 {
    case leave = 0
    case reject
    case noresp
    case busy
}

protocol CallingViewControllerResponder: UIViewController {
    var dismissBlock: (()->Void)? { get set }
    var curSponsor: CallingUserModel? { get }
    func enterUser(user: CallingUserModel)
    func leaveUser(user: CallingUserModel)
    func updateUser(user: CallingUserModel, animated: Bool)
    func updateUserVolume(user: CallingUserModel) // 更新用户音量
    func disMiss()
    func getUserById(userId: String) -> CallingUserModel?
    func resetWithUserList(users: [CallingUserModel], isInit: Bool)
    static func getRenderView(userId: String) -> VideoCallingRenderView?
}

class SFSeekHelpViewController: UIViewController, TRTCCallingDelegate {
    var callVC: CallingViewControllerResponder? = nil
    var callType: CallType = .video

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "视频"
        let bgImage = UIImage(named: "login_bg")
        self.view.layer.contents = bgImage?.cgImage
        
        let seekLabel = UILabel()
        self.view.addSubview(seekLabel)
        seekLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(300)
        }
        seekLabel.font = UIFont.systemFont(ofSize: 80)
        seekLabel.text = "长按屏幕向志愿者发起请求"
        seekLabel.textColor = .white
        seekLabel.numberOfLines = 0
        seekLabel.textAlignment = .center

        let guesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_ :)))
        self.view.addGestureRecognizer(guesture)
        TRTCCalling.shareInstance().add(self)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let userID = "18391741628"
//        let userSig = ProfileManager.shared.curUserSig()
        let userSig = GenerateTestUserSig.genTestUserSig(userID)
        var sdkBusiId: Int32 = 0
        #if DEBUG
            sdkBusiId = 18069
        #else
            sdkBusiId = 18070
        #endif
//        if V2TIMManager.sharedInstance()?.getLoginUser() == userID {
            TRTCCalling.shareInstance().imBusinessID = sdkBusiId
            TRTCCalling.shareInstance().deviceToken = AppUtils.shared.appDelegate.deviceToken
            ProfileManager.shared.IMLogin(userSig: userSig) {
                TRTCCalling.shareInstance().login(sdkAppID: UInt32(SDKAPPID), user: userID , userSig: userSig) {
                    print("Video Call login成功")
                } failed: { (code, error) in
                    print("Video Call login失败\(error)")
                }

            } failed: { (error) in
                print("登录IM失败\(error)")
            }

//        }
    }
    
    @objc func longPress(_ gusture:UILongPressGestureRecognizer) {
        if(gusture.state == UIGestureRecognizer.State.began) {
            var calledUser = CallingUserModel()
            calledUser.name = "yantin"
            calledUser.userId = "18191438102"
            calledUser.isVideoAvaliable = true
            self.showCallVC(invitedList: [calledUser])
            TRTCCalling.shareInstance().call(userID: calledUser.userId, type: .video)
        }
    }
    
    func onError(code: Int32, msg: String?) {
        debugPrint("onError: code \(code), msg: \(String(describing: msg))")
    }
    
    func onInvited(sponsor: String, userIds: [String], isFromGroup: Bool, callType: CallType) {
        debugPrint("log: onInvited sponsor:\(sponsor) userIds:\(userIds)")
        self.callType  = callType
        ProfileManager.shared.queryUserInfo(userID: sponsor, success: { [weak self] (user) in
            guard let self = self else {return}
            ProfileManager.shared.queryUserListInfo(userIDs: userIds, success: { (usermodels) in
                var list:[CallingUserModel] = []
                for UserModel in usermodels {
                    list.append(self.covertUser(user: UserModel))
                }
                self.showCallVC(invitedList: list, sponsor: self.covertUser(user: user, isEnter: true))
            }) { (error) in
                
            }
        }) { (error) in
            
        }
    }
    
    private func onGroupCallInviteeListUpdate(userIds: [String]) {
        debugPrint("log: onGroupCallInviteeListUpdate userIds:\(userIds)")
    }
    
    func onUserEnter(uid: String) {
        debugPrint("log: onUserEnter: \(uid)")
        if let vc = callVC {
            ProfileManager.shared.queryUserInfo(userID: uid, success: { [weak self, weak vc] (UserModel) in
                guard let self = self else {return}
                vc?.enterUser(user: self.covertUser(user: UserModel, isEnter: true))
                vc?.view.makeToast("\(UserModel.name) \(String.enterConvText)")
            }) { (error) in
                
            }
        }
    }
    
    func onUserLeave(uid: String) {
        debugPrint("log: onUserLeave: \(uid)")
        removeUserFromCallVC(uid: uid, reason: .leave)
    }
    
    func onReject(uid: String) {
        debugPrint("log: onReject: \(uid)")
        removeUserFromCallVC(uid: uid, reason: .reject)
    }
    
    func onNoResp(uid: String) {
        debugPrint("log: onNoResp: \(uid)")
        removeUserFromCallVC(uid: uid, reason: .noresp)
    }
    
    func onLineBusy(uid: String) {
        debugPrint("log: onLineBusy: \(uid)")
        removeUserFromCallVC(uid: uid, reason: .busy)
    }
    
    func onCallingCancel(uid: String) {
        debugPrint("log: onCallingCancel")
        if let vc = callVC {
            view.makeToast("\((vc.curSponsor?.name) ?? "")\(String.cancelConvText)")
            vc.disMiss()
        }
    }
    
    func onCallingTimeOut() {
        debugPrint("log: onCallingTimeOut")
        if let vc = callVC {
            view.makeToast(.callTimeOutText)
            vc.disMiss()
        }
    }
    
    func onCallEnd() {
        debugPrint("log: onCallEnd")
        if let vc = callVC {
            vc.disMiss()
        }
    }
    
    func onUserAudioAvailable(uid: String, available: Bool) {
        debugPrint("log: onUserAudioAvailable , uid: \(uid), available: \(available)")
    }
    
    func onUserVoiceVolume(uid: String, volume: UInt32) {
        if let vc = callVC {
            if let user = vc.getUserById(userId: uid) {
                var newUser = user
                newUser.volume = Float(volume) / 100
                if callType == .audio {
                    vc.updateUser(user: newUser, animated: false)
                } else {
                    vc.updateUserVolume(user: newUser)
                }
                
            } else {
                ProfileManager.shared.queryUserInfo(userID: uid, success: { (UserModel) in
                    vc.enterUser(user: self.covertUser(user: UserModel, volume: volume, isEnter: true))
                }) { (error) in
                    
                }
            }
        }
    }
    
    func onUserVideoAvailable(uid: String, available: Bool) {
        debugPrint("log: onUserVideoAvailable , uid: \(uid), available: \(available)")
        if let vc = callVC {
            if let user = vc.getUserById(userId: uid) {
                var newUser = user
                newUser.isEnter = true
                newUser.isVideoAvaliable = available
                vc.updateUser(user: newUser, animated: false)
            } else {
                ProfileManager.shared.queryUserInfo(userID: uid, success: { (UserModel) in
                    var newUser = self.covertUser(user: UserModel, isEnter: true)
                    newUser.isVideoAvaliable = available
                    vc.enterUser(user: newUser)
                }) { (error) in
                    
                }
            }
        }
    }
    
    func covertUser(user: UserModel,
                    volume: UInt32 = 0,
                    isEnter: Bool = false) -> CallingUserModel {
        var dstUser = CallingUserModel()
        dstUser.name = user.name
        dstUser.avatarUrl = user.avatar
        dstUser.userId = user.userId
        dstUser.isEnter = isEnter
        dstUser.volume = Float(volume) / 100
        if let vc = callVC {
            if let oldUser = vc.getUserById(userId: user.userId) {
                dstUser.isVideoAvaliable = oldUser.isVideoAvaliable
            }
        }
        return dstUser
    }
    
    func removeUserFromCallVC(uid: String, reason: CallingUserRemoveReason = .noresp) {
        if let vc = callVC {
            ProfileManager.shared.queryUserInfo(userID: uid, success: { [weak self, weak vc] (UserModel) in
                guard let self = self else {return}
                let userInfo = self.covertUser(user: UserModel)
                vc?.leaveUser(user: userInfo)
                var toast = "\(userInfo.name)"
                switch reason {
                case .reject:
                    toast += .rejectToastText
                    break
                case .leave:
                    toast += .leaveToastText
                    break
                case .noresp:
                    toast += .norespToastText
                    break
                case .busy:
                    toast += .busyToastText
                    break
                }
                vc?.view.makeToast(toast)
                self.view.makeToast(toast)
            }) { (error) in
                
            }
        }
    }

    /// show calling view
    /// - Parameters:
    ///   - invitedList: invitee userlist
    ///   - sponsor: passive call should not be nil,
    ///     otherwise sponsor call this mothed should ignore this parameter
    func showCallVC(invitedList: [CallingUserModel], sponsor: CallingUserModel? = nil) {
        if callType == .audio {
            callVC = TRTCCallingAuidoViewController.init(sponsor: sponsor)
        } else  {
            callVC = TRTCCallingVideoViewController.init(sponsor: sponsor)
        }
        
        callVC?.dismissBlock = {[weak self] in
            guard let self = self else {return}
            self.callVC = nil
        }
        if let vc = callVC {
            vc.modalPresentationStyle = .fullScreen
            vc.resetWithUserList(users: invitedList, isInit: true)
            
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                if let navigationVC = topController as? UINavigationController {
                    if navigationVC.viewControllers.contains(self) {
                        present(vc, animated: false, completion: nil)
                    } else {
                        navigationVC.popToRootViewController(animated: false)
                        navigationVC.pushViewController(self, animated: false)
                        navigationVC.present(vc, animated: false, completion: nil)
                    }
                } else {
                    topController.present(vc, animated: false, completion: nil)
                }
            }
        }
    }
}

private extension String {
    static let yourUserNameText = String.localized(of: "您的手机号")
    static let searchPhoneNumberText = String.localized(of: "搜索手机号")
    static let searchText = String.localized(of: "搜索")
    static let backgroundTipsText = String.localized(of: "搜索添加已注册用户\n以发起通话")
    static let enterConvText = String.localized(of: "进入通话")
    static let cancelConvText = String.localized(of: "通话取消")
    static let callTimeOutText = String.localized(of: "通话超时")
    static let rejectToastText = String.localized(of: "拒绝了通话")
    static let leaveToastText = String.localized(of: "离开了通话")
    static let norespToastText = String.localized(of: "未响应")
    static let busyToastText = String.localized(of: "忙线")
    
    static func localized(of key: String, comment: String = "") -> String {
        return NSLocalizedString(key,
                                 tableName: "Localizable",
                                 bundle: Bundle.main,
                                 comment: comment)
    }
}



