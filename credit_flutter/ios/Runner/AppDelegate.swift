import UIKit
import Flutter
import Foundation
//MARK: - 推送
import UserNotifications
import PushKit
import AVFoundation
import GTSDK
//MARK: - 广告归因
import AdSupport
import AdServices
import iAd
import AppTrackingTransparency
import Alamofire




/// appid 在开放平台进行应用创建，通过审核后获得
public let WXAppId = "wxf0bb015426aa0b8c"
/// 通用连接，用于直接拉起本应用，通过apple平台及后台配置
public let UniversalLink    = "https://api.nowcheck.cn"

public let kGtAppId = "LBhitAXxDm7noD7ujXNm9"
public let kGtAppKey = "pJhSlwDppF8ldU8vV8hEYA"
public let kGtAppSecret = "uOei1YOEq2AsIAajpkU0R7"

@main
@objc class AppDelegate: FlutterAppDelegate, WXApiDelegate {
    private var copyStr = ""
    private var clientIdStr = ""
    
    var channel:FlutterMethodChannel?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self);
        listenNotification()
        registerApp()
        flutterChannel()
        //        UMConfigure.initWithAppkey("64351369ba6a5259c43595c3", channel:nil);
        UMConfigure.setLogEnabled(true);
        
        
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        WXApi.handleOpen(url, delegate: self)
        AlipaySDK.defaultService()?.processOrder(withPaymentResult: url, standbyCallback: nil)
        MobClick.handle(url)
        return true
    }
    
    override func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        MobClick.handle(url)
        return true
    }
    
    
    override func application(_ application: UIApplication, continue continueUserActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        WXApi.handleOpenUniversalLink(continueUserActivity, delegate: self)
        // [ GTSDK ]：处理个推APPLink回执统计
               // APPLink url 示例：https://link.gl.ink/getui?n=payload&p=mid， 其中 n=payload 字段存储用户透传信息，可以根据透传内容进行业务操作。
               //    GeTuiSdk.handleApplinkFeedback(userActivity.webpageURL)
//               if let url = continueUserActivity.webpageURL {
//                 let payload = GeTuiSdk.handleApplinkFeedback(url)
//                 NSLog("[ TestDemo ]  个推APPLink中携带的用户payload信息:\(url), payload:\(String(describing: payload)) \n\n")
//                 // TODO: 用户可根据具体 payload 进行业务处理
//               }
        return true
    }
    
    func registerApp() {
        let wxSDK = WXApi.registerApp(WXAppId, universalLink: UniversalLink)
        print(wxSDK)
        _ = WXApi.getVersion()
        
        // [ GTSDK ]：使用APPID/APPKEY/APPSECRENT启动个推
//        GeTuiSdk.start(withAppId: kGtAppId, appKey: kGtAppKey, appSecret: kGtAppSecret, delegate: self)
        /// 注册远程通知
//        GeTuiSdk.registerRemoteNotification([.alert, .badge, .sound])
        /// 注册个推多媒体通道
//        self.voipRegistration()
    }
    
    func flutterChannel(){
        let controller:FlutterViewController = window.rootViewController as! FlutterViewController
        controller.view.backgroundColor = .white
        channel = FlutterMethodChannel(name: "com.flutter.native", binaryMessenger: controller.binaryMessenger)
        channel!.setMethodCallHandler { [self] (call, result) in
            guard let t = call.arguments as? NSDictionary else {
                return result(FlutterMethodNotImplemented)
            }
            let str: String = t["context"] as! String;
            if "AliPay" == call.method{
                let text: String = str
                let appScheme = "ali2021003122631129"
                let orderString = text
                AlipaySDK.defaultService().payOrder(orderString, dynamicLaunch: true, fromScheme: appScheme) { (resultDic) in
                    if let Alipayjson = resultDic as? NSDictionary{
                        if Alipayjson.allKeys.count > 0 {
                            let resultStatus = Alipayjson.value(forKey: "resultStatus") as! String
                            result(["resultStatus": resultStatus]);
                        }else{
                            result(["resultStatus": "90001"]);
                        }
                    }
                };
            }else if "WechatPay" == call.method{
            }
            else if "Certification" == call.method{
                let token: String = t["verifyToken"] as! String;
                certification(token: token)
            }
            else if "CertificationProcess" == call.method{
                let url:String = t["url"] as! String
                jumpPage(url: url)
            }
            else if "getUUID" == call.method{
//                let uuid = NSUUID.init()
//                let uuidString = uuid.uuidString
                
                let uuidString = OpenUDID.value()
                
                result(["UUID": uuidString]);
            } else if "getClientId" == call.method{
                
                if clientIdStr.isEmpty == false {
                    result(["clientId": clientIdStr]);
                }
                
            }else if "APPAscribe" == call.method{
                LXADSHelper.initSDK()
            }
            else{
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    func listenNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(returnSignNotificationAction), name: Notification.Name("SignResult"), object: nil)
    }
    
    func onResp(_ resp: BaseResp) {
        
        if let r = resp as? PayResp {
            
            if r.errCode != 0 {
                
                channel?.invokeMethod("wechatPayFinish", arguments:(["resultStatus": "90001"]), result: { result in
                })
                return
            }
            print("微信返回的支付结果：\(r.returnKey)")
            print("支付成功");
            channel?.invokeMethod("wechatPayFinish", arguments:(["resultStatus": "9000"]), result: { result in
                
            })
            
            
        }
    }
    
    func onReq(_ req: BaseReq) {
        print(req)
    }
    
    func certification(token:String){
        
        //        RPSDK.start(withVerifyToken: token, viewController: window.rootViewController!){ result in
        //            switch result.state {
        //            case .pass:
        //                // 认证通过。
        //                self.channel?.invokeMethod("CertificationFinish", arguments:(["resultStatus": "1"]), result: { _ in})
        //                break
        //            case .fail:
        //                // 认证不通过。
        //                self.channel?.invokeMethod("CertificationFinish", arguments:(["resultStatus": "2"]), result: { _ in})
        //                break
        //            case .notVerify:
        //                // 未认证。
        //                // 通常是用户主动退出或者姓名身份证号实名校验不匹配等原因导致。
        //                // 具体原因可通过result.errorCode来区分（详见文末错误码说明表格）。
        //                self.channel?.invokeMethod("CertificationFinish", arguments:(["resultStatus": "-1"]), result: { _ in})
        //                break
        //            default:
        //                break
        //            }
        //
        //        }
    }
    
    func jumpPage(url: String)  {
        
        let webViewController = WebSignViewController()
        webViewController.realnameUrl = url
        
        let controller:FlutterViewController = window.rootViewController as! FlutterViewController
        //        webViewController.modalPresentationStyle = .fullScreen
        
        controller.present(webViewController, animated: true)
    }
    
    @objc private func returnSignNotificationAction(noti: Notification){
        let result = noti.userInfo?["result"]
        channel?.invokeMethod("SignFinish", arguments:(["result": result]), result:{ _ in})
    }
}

//extension AppDelegate: GeTuiSdkDelegate, PKPushRegistryDelegate {
//    /// [ GTSDK回调 ] SDK启动成功返回cid
//    func geTuiSdkDidRegisterClient(_ clientId: String) {
//        let msg = "[ geTuiSdkDidRegisterClient >>  ] \(clientId)"
//        clientIdStr = clientId
//        
//        copyStr.append("clientId >> \(clientId)")
//        let pb = UIPasteboard.general
//        pb.string = copyStr
//        
//        let alert:UIAlertController = UIAlertController(title: "RegisterClient", message: "\(clientId)", preferredStyle: UIAlertController.Style.alert)
//               let yesAction = UIAlertAction(title: "确定", style: .cancel) { (UIAlertAction) in
//               }
//               alert.addAction(yesAction)
//               //以模态方式弹出
//        window.rootViewController?.present(alert, animated: true)
//       
//        print(msg)
//    }
//    /// [ GTSDK回调 ] SDK运行状态通知
//    func geTuiSDkDidNotifySdkState(_ aStatus: SdkStatus) {
//        let msg = "[ TestDemo ] \(#function):\(aStatus.title)"
//        print(msg)
//    }
//    
//    func getuiSdkGrantAuthorization(_ granted: Bool, error: Error?) {
//      let msg = "[ TestDemo ] \(#function) \(granted ? "Granted":"NO Granted")"
//        print(msg)
//    }
//    
//    
//    
//    
//    
//    /// [ GTSDK回调 ] SDK错误反馈
//    func geTuiSdkDidOccurError(_ error: Error) {
//        let msg = "[ TestDemo ] \(#function) \(error.localizedDescription)"
//        print(msg)
//        
//        let alert:UIAlertController = UIAlertController(title: "geTuiError", message: " \(error.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
//               let yesAction = UIAlertAction(title: "确定", style: .cancel) { (UIAlertAction) in
//                   
//               }
//               alert.addAction(yesAction)
//               //以模态方式弹出
//        window.rootViewController?.present(alert, animated: true)
//    }
//    
//    //MARK: - 通知回调
//    /// [ 系统回调 ] iOS 10及以上  APNs通知将要显示时触发
//    @available(iOS 10.0, *)
//    func geTuiSdkNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let msg = "[ TestDemo ] \(#function)"
//        print(msg)
//        // [ 参考代码，开发者注意根据实际需求自行修改 ] 根据APP需要，判断是否要提示用户Badge、Sound、Alert等
//        let alert:UIAlertController = UIAlertController(title: "收到push", message: "userInfo", preferredStyle: UIAlertController.Style.alert)
//               let yesAction = UIAlertAction(title: "确定", style: .cancel) { (UIAlertAction) in
//                   
//               }
//               alert.addAction(yesAction)
//               //以模态方式弹出
//        window.rootViewController?.present(alert, animated: true)
//        completionHandler([.badge, .sound, .alert])
//    }
//    
//    @available(iOS 10.0, *)
//    func geTuiSdkDidReceiveNotification(_ userInfo: [AnyHashable : Any], notificationCenter center: UNUserNotificationCenter?, response: UNNotificationResponse?, fetchCompletionHandler completionHandler: ((UIBackgroundFetchResult) -> Void)? = nil) {
//      let msg = "[ TestDemo ] \(#function) \(userInfo)"
//     print(msg)
//      // [ 参考代码，开发者注意根据实际需求自行修改 ]
//        
//        let alert:UIAlertController = UIAlertController(title: "点击push进入", message: "\(userInfo)", preferredStyle: UIAlertController.Style.alert)
//               let yesAction = UIAlertAction(title: "确定", style: .cancel) { (UIAlertAction) in
//                   
//               }
//               alert.addAction(yesAction)
//               //以模态方式弹出
//        window.rootViewController?.present(alert, animated: true)
//
//      completionHandler?(.noData)
//    }
//    
//   
//    
//    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        var token = ""
//        for byte in deviceToken {
//            token += String(format: "%02X", byte)
//        }
//        
//        // [ GTSDK ]：向个推服务器注册deviceToken
//        // 2.5.2.0 之前版本需要调用：
//        // homePage.updateDeviceToken(token)
//        let msg = "[ TestDemo ] \(#function):\(token)"
//        
//        copyStr.append("token >> \(token)")
//        
//        let alert:UIAlertController = UIAlertController(title: "deviceToken", message: "\(token)", preferredStyle: UIAlertController.Style.alert)
//               let yesAction = UIAlertAction(title: "确定", style: .cancel) { (UIAlertAction) in
//                   
//               }
//               alert.addAction(yesAction)
//               //以模态方式弹出
//        window.rootViewController?.present(alert, animated: true)
//        print(msg)
//        
//        
////        GeTuiSdk.registerDeviceToken(token)
//    }
//    
//    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        let alert:UIAlertController = UIAlertController(title: "error", message: "\(error)", preferredStyle: UIAlertController.Style.alert)
//               let yesAction = UIAlertAction(title: "确定", style: .cancel) { (UIAlertAction) in
//                   
//               }
//               alert.addAction(yesAction)
//               //以模态方式弹出
//        window.rootViewController?.present(alert, animated: true)
//    }
//    
//    func voipRegistration() {
//      let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
//      voipRegistry.delegate = self
//      if #available(iOS 9.0, *) {
//        voipRegistry.desiredPushTypes = [.voIP]
//      }
//    }
//    
//    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
//      // [ GTSDK ]：（新版）向个推服务器注册 VoipToken
//      GeTuiSdk.registerVoipTokenCredentials(credentials.token)
//      NSLog("[ TestDemo ] [ VoipToken(NSData) ]: %@\n\n", NSData(data: credentials.token))
//    }
//    
//    /**
//     * [ 系统回调 ] 收到voip推送信息
//     * 接收VOIP推送中的payload进行业务逻辑处理（一般在这里调起本地通知实现连续响铃、接收视频呼叫请求等操作），并执行个推VOIP回执统计
//     */
//    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
//      //  [ GTSDK ]：个推VOIP回执统计
//      GeTuiSdk.handleVoipNotification(payload.dictionaryPayload)
//      
//      // [ 测试代码 ] 接受VOIP推送中的payload内容进行具体业务逻辑处理
//      NSLog("[ TestDemo ] [ Voip Payload ]: %@, %@", payload, payload.dictionaryPayload)
//    }
//    
//}
//
//extension SdkStatus {
//  var title: String {
//    switch self {
//    case .starting:
//      return "正在启动"
//    case .started:
//      return "已启动"
//    case .offline:
//      return "已离线"
//    default:
//      return "已停止"
//    }
//  }
//}




class LXADSHelper{
    
    class func initSDK() {
        //苹果ASA；延迟1秒再发送，等ATT用户操作结果，可能有IDFA
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let defaultStand = UserDefaults.standard
            let pushedADS = defaultStand.value(forKey: "pushedADS")
            guard Platform.isSimulator else{
                if  pushedADS == nil {
                    self.logAds()
                }
                return
            }
        }
    }
    /// 苹果Ads广告
    /// TODO：有些旧设备新系统(iPhone8)，会出现token为空的问题
    class func logAds() {
        if #available(iOS 14.3, *) {
            var token: String? = nil
            do {
                token = try AAAttribution.attributionToken()
            } catch {
            }
            
            if let token = token {
                // 1、发送POST给苹果得到归因数据
                sendToken(getANullableString("token", content: token)) { attrData in
                    // 异步，会延后
                    // TODO::发送数据给服务端
                    // ... ...
                    if attrData != nil {
                        var attrDataL:[String:Any] = attrData!
                        // 添加userId
                        attrDataL["type"] = "1"
                        let defaultStand = UserDefaults.standard
                        defaultStand.set(attrDataL, forKey:"pushADSDic")
                        defaultStand.synchronize()
                        self.logOpen()
                    }
                }
            }
        }else{
            if ADClient.shared().responds(to: #selector(ADClient.requestAttributionDetails(_:))) {
                ADClient.shared().requestAttributionDetails({ attrData, error in
                    // 异步，会延后
                    // TODO::发送数据给服务端
                    if attrData != nil {
                        var haveVersion :Int = 0
                        var haveVersionStr :String = "Version"
                        for  keystr in attrData!.keys {
                            if keystr.contains("Version") {
                                haveVersion = 1
                                haveVersionStr = keystr
                            }
                        }
                        if haveVersion == 1 {
                            var attrDataLL : [String:Any] = [:]
                            let attrDataL:[String:Any] = attrData![haveVersionStr] as! [String : Any]
                            // 旧数据统一处理一下
                            attrDataLL["iadPurchaseDate"] = attrDataL["iad-purchase-date"]
                            attrDataLL["iadLineitemId"] = attrDataL["iad-lineitem-id"]
                            attrDataLL["iadOrgName"] = attrDataL["iad-org-name"]
                            attrDataLL["iadCreativesetId"] = attrDataL["iad-creativeset-id"]
                            attrDataLL["iadCreativesetName"] = attrDataL["iad-creativeset-name"]
                            attrDataLL["iadOrgId"] = attrDataL["iad-org-id"]
                            attrDataLL["iadLineitemName"] = attrDataL["iad-lineitem-name"]
                            attrDataLL["iadAdgroupName"] = attrDataL["iad-adgroup-name"]
                            attrDataLL["iadConversionDate"] = attrDataL["iad-conversion-date"]
                            attrDataLL["iadClickDate"] = attrDataL["iad-click-date"]
                            attrDataLL["iadKeywordMatchtype"] = attrDataL["iad-keyword-matchtype"]
                            attrDataLL["iadCountryOrRegion"] = attrDataL["iad-country-or-region"]
                            attrDataLL["iadConversionType"] = attrDataL["iad-conversion-type"]
                            attrDataLL["iadKeywordId"] = attrDataL["iad-keyword-id"]
                            attrDataLL["iadCampaignId"] = attrDataL["iad-campaign-id"]
                            attrDataLL["iadAttribution"] = attrDataL["iad-attribution"]
                            attrDataLL["iadCampaignName"] = attrDataL["iad-campaign-name"]
                            attrDataLL["iadKeyword"] = attrDataL["iad-keyword"]
                            attrDataLL["iadAdgroupId"] = attrDataL["iad-adgroup-id"]
                            //
                            attrDataLL["type"] = "2"
                            let defaultStand = UserDefaults.standard
                            defaultStand.set(attrDataLL, forKey:"pushADSDic")
                            defaultStand.synchronize()
                            self.logOpen()
                        }
                    }
                })
            }
        }
    }
    /// 读取可能为空的字符串
    class func getANullableString(_ desc: String?, content: String?) -> String? {
        if content == nil {
            return ""
        }
        return "\(content ?? "")"
    }
    /// 发送归因token得到数据
    class func sendToken(_ token: String?, completeBlock: @escaping (_ data: [String : Any]?) -> Void) {
        let url = "https://api-adservices.apple.com/api/v1/"
        var request: URLRequest? = nil
        if let url1 = URL(string: url) {
            request = URLRequest(url: url1)
        }
        request?.httpMethod = "POST"
        request?.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        let postData = token?.data(using: .utf8)
        request?.httpBody = postData
        // 发出请求
        URLSession.shared.dataTask(with: request!) { data, response, error in
            var result: [String : Any]? = nil
            if error != nil {
                // 请求失败
                
                let nulldict: [String : Any] = [:]
                completeBlock(nulldict)
            }else{
                // 请求成功
                var resDic: [String : Any]? = nil
                do {
                    resDic = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                } catch _ {
                }
                result = resDic
                completeBlock(result)
            }
        }.resume()
    }
    
    /// 激活日志，这里登录后发送
    class func logOpen() {
        
        let defaultStand = UserDefaults.standard
        let pushedADS = defaultStand.value(forKey: "pushedADS")
        if  pushedADS == nil{
            
            var attrData:[String:Any] = defaultStand.value(forKey: "pushADSDic") as! [String : Any]
            if attrData.keys.count > 0 {
                // 上传数据
                DispatchQueue.main.async {
                    // 构建URL
                    let url:URL = URL(string: "https://api.nowcheck.cn/common/apple/analytics")!
                    let headers: HTTPHeaders = ["Content-Type": "application/json"]
                    //获取uuid
//                    let uuid = NSUUID.init()
//                    let uuidString = uuid.uuidString
                    let uuidString = OpenUDID.value()
                   let dstr =  uuidString?.md5
                    attrData["modelId"] = dstr
                    
                    AF.request(url,method: .post,parameters: attrData,encoding: URLEncoding.queryString , headers: headers).responseJSON{ response in
                        
                        switch response.result {
                        case .success:
                            let dict = try? JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
                            if dict!["code"] as! String == "200" {
                                let defaultStand = UserDefaults.standard
                                defaultStand.set(true, forKey:"pushedADS")
                                defaultStand.synchronize()
                            }
                            break
                        case .failure:
                            print("failure")
                            break
                        }
                    }
                }
            }
        }
    }
    
    struct Platform {
        static let isSimulator: Bool = {
            var isSim = false
#if arch(i386) || arch(x86_64)
            isSim = true
#endif
            return isSim
        }()
    }
}


import CommonCrypto
public extension String {
    /* ################################################################## */
    /**
     - returns: the String, as an MD5 hash.
     */
    var md5: String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()

        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate()
        return hash as String
    }
}




