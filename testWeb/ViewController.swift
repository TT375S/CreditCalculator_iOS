//
//  ViewController.swift
//  testWeb
//
//  Created by T.T on 2017/02/04.
//  Copyright © 2017年 T.T. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate  {
    
    let webView : UIWebView = UIWebView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegate設定
        webView.delegate = self
        
        // Webページの大きさを画面に合わせる
        let rect:CGRect = self.view.frame
        webView.frame = rect
        webView.scalesPageToFit = true
        
        // インスタンスをビューに追加する
        self.view.addSubview(webView)
        
        // URLを指定
        let url: URL = URL(string: "https://my.waseda.jp/login/login")!
        let request: URLRequest = URLRequest(url: url)
        
        // リクエストを投げる
        webView.loadRequest(request)
    }
    
    
    // ロード時にインジケータをまわす
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        print("indicator on")
    }
    
    //昔でいうprepareForSegue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goResult"{
            print(type(of: segue.destination))
            let resultViewController:ResultViewController = segue.destination as! ResultViewController
            //let resultViewController = segue.destination as! ResultViewController
            resultViewController.recievedText = "aho!"
        }
    }
    
    // ロード完了
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //インジケータ非表示
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        print("indicator off")
        print("END")
        //iframeとかだと複数回呼ばれるので、一回だけ実行するためにisLoadingを確認する。
        if !webView.isLoading {
            //URL表示
            print(webView.stringByEvaluatingJavaScript(from: "document.URL") as Any)
            //タイトルをナビゲーションのタイトルにする
            self.navigationItem.title = webView.stringByEvaluatingJavaScript(from: "document.title")
            //htmlソースを表示
            var html = webView.stringByEvaluatingJavaScript(from: "document.body.innerHTML")
            //print(html as Any)
            
            //ログイン後の画面ならjavascriptのdoSubmit関数をオーバーライドして同じウィンドウ(?)で開く
            if webView.stringByEvaluatingJavaScript(from: "document.URL") == "https://coursereg.waseda.jp/portal/simpleportal.php?HID_P14=EN"{
                print("HITT")
                
                webView.stringByEvaluatingJavaScript(from: "function doSubmit ( strURL, strAuthGp, strAuth, strStatus, strWindow ) {strWindow='_self';intRtnVal=fncControlSubmit ( 10 );if ( intRtnVal == true ){window.open( '','_self','menubar=no,status=yes,scrollbars=yes,location=no,resizable=yes' );document.F01.url.value=strURL;document.F01.HID_P6.value=strAuthGp;document.F01.HID_P8.value=strAuth;document.F01.target='ap';document.F01.pageflag.value=1000;document.F01.status.value=strStatus;document.F01.target='_self';document.F01.submit();} else {alert ( 'ただいま処理中です。OKボタンを押して、しばらく待ってから再度メニューをクリックしてください。' );}}")
                
                //とりあえずこの下のやつをやれば成績画面は出る。
                //                    webView.stringByEvaluatingJavaScript(from: "doSubmit('https://www.wnp12.waseda.jp/kyomu/epb2050.htm', 'eStudent', 'ea02', '1', '_self');")
                
            }
            
            //成績表示画面に到達したらhtmlソースを渡して画面遷移
            if webView.stringByEvaluatingJavaScript(from: "document.URL") == "https://www.wnp12.waseda.jp/kyomu/epb2051e.htm"{
//                let storyboard = self.storyboard!
//                let resultView = storyboard.instantiateViewController(withIdentifier: "result")
//                self.present(resultView, animated: true, completion: nil)
                self.performSegue(withIdentifier: "goResult", sender: self)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
