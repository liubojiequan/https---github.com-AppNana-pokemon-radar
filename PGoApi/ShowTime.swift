//
//  ShowTime.swift
//  PGoApi
//
//  Created by apple on 16/9/22.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import MapKit

class ShowTime: UIViewController {
    var timeUse:Int = 0
    var timer = NSTimer()
    var mapView: MKMapView!
    var lat: Double = 0.0
    var log: Double = 0.0
    var id:Int32 = 0
    var name:String = ""
    let info2 = CustomPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    func useTimer(){
        annotate(lat,log: log, name: String(timeUse), id: id, mapView: mapView,time: String(timeUse))
        timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(1),
                                                       target:self,selector:Selector("tickDown:"),
                                                       userInfo:nil,repeats:true)
            }
    /**
     *计时器每秒触发事件
     **/
    func tickDown(time:NSTimer)
    {
        timeUse -= 1
        if timeUse < 0 {
            mapView.removeAnnotation(info2)
            timer.invalidate()
        }else{
            print(timeUse)
            info2.subtitle = String(timeUse/60)+":"+String(timeUse%60)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func annotate(lat: Double, log: Double, name: String,id:Int32,mapView: MKMapView,time: String) {
        mapView.removeAnnotation(info2)
        info2.coordinate = CLLocationCoordinate2DMake(lat, log)
        info2.title = name
        info2.subtitle = time
        info2.imageName = String(id)+".png"
        mapView.addAnnotation(info2)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
