//
//  WebviewVC.swift
//  Gogolook
//
//  Created by Claud on 2022/4/20.
//

import UIKit
import WebKit

class WebviewVC: UIViewController {
    
    private var webview:WKWebView = {
        let webview = WKWebView()
        return webview
    }()
    
    private var url:URL
    
    init(url:URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIInit()
    }
    
    private func UIInit(){
        webview.frame = getFrame()
        webview.uiDelegate = self
        webview.navigationDelegate = self
        view.addSubview(webview)
        
        webview.load(URLRequest(url: url))
    }
    

}

extension WebviewVC: WKUIDelegate {
    
}

extension WebviewVC: WKNavigationDelegate {
    
}
