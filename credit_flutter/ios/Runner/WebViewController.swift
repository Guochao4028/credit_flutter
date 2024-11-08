//
//  WebViewController.swift
//  Runner
//
//  Created by 郭超 on 2023/3/23.
//

import UIKit
import WebKit
import Foundation

@available(iOS 13.0, *)
public let statusBarManager = (UIApplication.shared.windows.filter {$0.isKeyWindow}.last)?.windowScene?.statusBarManager
//导航栏相关设置
@available(iOS 13.0, *)
public let kStatusBarHeight:CGFloat  = statusBarManager?.statusBarFrame.size.height ?? 0
public let kNavBarHeight:CGFloat     = 44.0
@available(iOS 13.0, *)
public let kTabBarHeight:CGFloat     = statusBarManager?.statusBarFrame.size.height ?? 0 > 20 ? 83.0 : 49.0
@available(iOS 13.0, *)
public let kTopHeight:CGFloat        = (kStatusBarHeight + CGFloat(kNavBarHeight))
@available(iOS 13.0, *)
public let kSafeBottomHeight:CGFloat = statusBarManager?.statusBarFrame.size.height ?? 0 > 20 ? 34.0 : 0.0

public let KScreenWidth      = UIScreen.main.bounds.size.width
public let KScreenHeight     = UIScreen.main.bounds.size.height

class WebViewController: UIViewController {
    
    var urlStr: String = "" {
        didSet {
            URLCache.shared.removeAllCachedResponses()
            self.requestData()
        }
    }
    
    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.preferences.minimumFontSize = 15;
        config.preferences.javaScriptEnabled = true;
        config.preferences.javaScriptCanOpenWindowsAutomatically = true;
        config.allowsInlineMediaPlayback = true
        config.userContentController = WKUserContentController()
        if #available(iOS 13.0, *) {
            config.defaultWebpagePreferences.preferredContentMode = .mobile
        }
        
        let view = WKWebView(frame:CGRect.zero, configuration: config)
        view.uiDelegate = self
        view.navigationDelegate = self
        return view
    }()
    
    deinit {
        self.webView.uiDelegate = nil
        self.webView.navigationDelegate = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(self.webView)
       
            // Fallback on earlier versions
        self.webView.frame = CGRect(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight - 100)
    
    }
    
    func requestData() {
        let request = NSMutableURLRequest()
        request.url = URL.init(string: self.urlStr)
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        self.webView.load(request as URLRequest)
    }
}

extension WebViewController:WKUIDelegate, WKNavigationDelegate {
    /// 页面开始加载
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    /// 加载失败
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    ///提交发生错误时调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    /// 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    ///接收到服务器跳转请求即服务重定向时之后调用
    func webView(_ webView: WKWebView, s navigation: WKNavigation!) {
        
    }
    
 
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // 判断服务器采用的验证方法
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust{
            // 如果没有错误的情况下 创建一个凭证，并使用证书
            if challenge.previousFailureCount == 0{
                let credential :URLCredential  =  URLCredential(trust: challenge.protectionSpace.serverTrust!)
                completionHandler(.useCredential, credential)
            }else{
                // 验证失败，取消本次验证
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        }else{
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}


extension WebViewController:RealnameDelegate {
    func realnameJumptoAlipay() {
        print("-----------------------")
        print("realnameJumptoAlipay")
        print("-----------------------")
    }
    
    func realnameZhimaCallback(_ callbackUrl: String!) {
        self.requestData()
    }
    func realnameResult(_ result: REALNAME_RESULT) {
        if result == .SUCCESS{
            print("-----------------------")
            print("REALNAME_RESULT_SUCCESS")
            print("-----------------------")
        }else if result == .FAILED{
            print("-----------------------")
            print("REALNAME_RESULT_FAILED")
            print("-----------------------")
        }
    }
    
    func signResult(_ result: Bool) {
        if result {
            print("-----------------------")
            print("signResult >>> result  >>> t")
            print("-----------------------")
        }else{
            print("-----------------------")
            print("signResult >>> result  >>> f")
            print("-----------------------")
        }
    }
}
