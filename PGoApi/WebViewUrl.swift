//
//  WebViewUrl.swift
//  PGoApi
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import CoreLocation
import PGoApi
class WebViewUrl: UIViewController, UIWebViewDelegate,PGoAuthDelegate, PGoApiDelegate   {
    @IBOutlet var webView:UIWebView!
    var loading: UIActivityIndicatorView!
    var username = ""
    var auth: PGoAuth!
    var request = PGoApiRequest()
    var mapCells = Pogoprotos.Networking.Responses.GetMapObjectsResponse()
    var flag = true
    var csrftoken = ""
    var postString = ""
    var url2str = "https://club.pokemon.com/us/pokemon-trainer-club/sign-up/?theme=go"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url2 = NSURL(string: url2str)
        let request2 = NSMutableURLRequest(URL: url2!)
        var cookiesUse=[NSHTTPCookie]()
        let url = NSURL(string:"https://club.pokemon.com/us/pokemon-trainer-club/sign-up/")
        let request = NSMutableURLRequest(URL:url!)
        request.HTTPMethod = "GET"
        let configuration:NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session:NSURLSession = NSURLSession(configuration: configuration)
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if let httpResponse = response as? NSHTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                let cookies = NSHTTPCookie.cookiesWithResponseHeaderFields(fields, forURL: response!.URL!)
                NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookies, forURL: response!.URL!, mainDocumentURL: nil)
                for cookie in cookies {
                    var cookieProperties = [String: AnyObject]()
                    cookieProperties[NSHTTPCookieName] = cookie.name
                    cookieProperties[NSHTTPCookieValue] = cookie.value
                    cookieProperties[NSHTTPCookieDomain] = cookie.domain
                    cookieProperties[NSHTTPCookiePath] = cookie.path
                    cookieProperties[NSHTTPCookieVersion] = NSNumber(integer: cookie.version)
                    cookieProperties[NSHTTPCookieExpires] = NSDate().dateByAddingTimeInterval(31536000)
                    if cookie.name == "csrftoken"{
                        self.csrftoken = cookie.value
                        self.postString = "csrfmiddlewaretoken=\(self.csrftoken)&dob=1990-09-26&country=CA&country=CA"
                    }
                    let newCookie = NSHTTPCookie(properties: cookieProperties)
                    NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(newCookie!)
                    
                    print("name: \(cookie.name) value: \(cookie.value)")
                }
                //add by liubo
                cookiesUse = cookies
                //end by liubo
            }
            
            
        }
        task.resume()
        
        sleep(4)
        request2.HTTPMethod = "POST"
        NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookies(cookiesUse, forURL: url2, mainDocumentURL: nil)
        print (self.postString)
        request2.HTTPBody = self.postString.dataUsingEncoding(NSUTF8StringEncoding)
        request2.addValue("https://club.pokemon.com/us/pokemon-trainer-club/sign-up/?theme=go", forHTTPHeaderField: "Referer")
        request2.addValue("https://club.pokemon.com", forHTTPHeaderField: "Origin")
        request2.addValue("Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_5 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13G36 Safari/601.1", forHTTPHeaderField: "User-Agent")
        
        webView.scalesPageToFit=true
        webView.loadRequest(request2)
        webView.delegate = self
        //        webView.load
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webViewDidStartLoad(webView : UIWebView) {
        let webUrl = webView.request!.URL!.absoluteString
        if webUrl=="https://club.pokemon.com/us/pokemon-trainer-club/parents/email"{
            if flag{
                auth = PtcOAuth()
                auth.delegate = self
                auth.login(withUsername: username, withPassword: "Aa111111")
                flag = false
                
            }
        }
    }
    //网页结束载入
    func webViewDidFinishLoad(webView : UIWebView) {
        let webUrl = webView.request!.URL!.absoluteString
        if webUrl=="https://club.pokemon.com/us/pokemon-trainer-club/parents/email"{
            loading = UIActivityIndicatorView()
            loading.center = CGPointMake((UIScreen.mainScreen().bounds.width)/2, (UIScreen.mainScreen().bounds.height)/2)
            loading.startAnimating()
            self.view.addSubview(loading)
        }else{
            let str = RandomString.sharedInstance.getRandomStringOfLength(12)
            print (str)
            username = str
            webView.stringByEvaluatingJavaScriptFromString("document.getElementById(\"id_username\").value=\"\(str)\";")
            webView.stringByEvaluatingJavaScriptFromString("document.getElementById(\"id_password\").value=\"Aa111111\";")
            webView.stringByEvaluatingJavaScriptFromString("document.getElementById(\"id_confirm_password\").value=\"Aa111111\";")
            webView.stringByEvaluatingJavaScriptFromString("document.getElementById(\"id_email\").value=\"\(str)@163.com\";")
            webView.stringByEvaluatingJavaScriptFromString("document.getElementById(\"id_confirm_email\").value=\"\(str)@163.com\";")
            
            webView.stringByEvaluatingJavaScriptFromString("document.getElementById(\"id_public_profile_opt_in_1\").checked=true;")
            webView.stringByEvaluatingJavaScriptFromString("document.getElementById(\"id_public_profile_opt_in_0\").checked=false;")
            
            webView.stringByEvaluatingJavaScriptFromString("document.getElementById(\"id_terms\").checked=true;")
            webView.stringByEvaluatingJavaScriptFromString("document.getElementsByTagName(\"footer\")[0].style.display=\"none\"")
            webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName(\"section user-account\")[0].style.display=\"none\"")
            webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName(\"section user-account\")[1].style.display=\"none\"")
            webView.stringByEvaluatingJavaScriptFromString("document.getElementById(\"gus-wrapper\").style.display=\"none\"")
            webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName(\"main\")[0].style.display=\"none\"")
        }
    }
    func didReceiveAuth() {
        print("Auth received!!")
        print("Starting simulation...")
        
        // Init the api with successful auth
        request = PGoApiRequest(auth: auth)
        request.setLocation(Double("37.33161821509")!, longitude: Double("-122.0298043927")!, altitude: 10)
        // Simulate the start, which cues methods:
        // getPlayer(), getHatchedEggs(), getInventory(), checkAwardedBadges(), downloadSettings()
        // Results can be accessed in subresponse for intent .Login under didReceiveApiResponse()
        request.simulateAppStart()
        request.makeRequest(.Login, delegate: self)
    }
    
    func didNotReceiveAuth() {
        showAlert("Error", message: "Failed to auth.")
        print("Failed to auth!")
    }
    
    func didReceiveApiResponse(intent: PGoApiIntent, response: PGoApiResponse) {
        print("Got that API response: \(intent)")
        // Uncomment the following to view the responses
        // print(response.response)
        // print(response.subresponses)
        
        if (intent == .Login) {
            // App simulation complete, now requesting map objects
            request.getMapObjects()
            request.makeRequest(.GetMapObjects, delegate: self)
        } else if (intent == .GetMapObjects) {
            print("Got map objects!")
            
            // Map cells are the first subresponse
            mapCells = response.subresponses[0] as! Pogoprotos.Networking.Responses.GetMapObjectsResponse
            loading.stopAnimating()
            performSegueWithIdentifier("showMap", sender: nil)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showMap") {
            let pokeMap:PokemonMap = segue.destinationViewController as! PokemonMap
            pokeMap.mapCells = mapCells
            pokeMap.auth = auth
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func didReceiveApiError(intent: PGoApiIntent, statusCode: Int?) {
        print("API Error: \(statusCode)")
    }
}
/// 随机字符串生成
class RandomString {
    let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    
    /**
     生成随机字符串,
     
     - parameter length: 生成的字符串的长度
     
     - returns: 随机生成的字符串
     */
    func getRandomStringOfLength(length: Int) -> String {
        var ranStr = ""
        for _ in 0..<length {
            let index = Int(arc4random_uniform(UInt32(characters.characters.count)))
            ranStr.append(characters[characters.startIndex.advancedBy(index)])
        }
        return ranStr
        
    }
    
    
    private init() {
        
    }
    static let sharedInstance = RandomString()
    
}
