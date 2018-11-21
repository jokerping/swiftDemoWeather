//
//  ViewController.swift
//  weather
//
//  Created by 王志平 on 2018/11/19.
//  Copyright © 2018 王志平. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,
CLLocationManagerDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var 天气图片: UIImageView!
    @IBOutlet weak var 城市: UILabel!
    @IBOutlet weak var 天气: UILabel!
    @IBOutlet weak var 温度: UILabel!
    @IBOutlet weak var 发布时间: UILabel!
    @IBOutlet weak var 风速: UILabel!
    @IBOutlet weak var 空气: UILabel!
    @IBOutlet weak var 湿度: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    /// 定位管理
    let manger = CLLocationManager.init()
    /// 当前城市
    var currentCity:String?
    var currentModel:WeatherModel?
    let cityKey = "city"
    let modelKey = "model"
    let timeKey = "time"
    let cellID = "cell"
    var allValue:[day] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    // MARK: - 
    // MARK: 设置数据源
   fileprivate func setupData() {
    let user = UserDefaults.standard
    currentCity = user.string(forKey: cityKey)
    currentModel = WeatherModel.deserialize(from: user.string(forKey: modelKey))
    let lastDay = Date.init(timeIntervalSince1970: user.double(forKey: timeKey))
    setupView()
    
    guard Calendar.current.isDateInToday(lastDay)  else {
        manger.delegate = self
        manger.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manger.requestWhenInUseAuthorization()
        manger.startUpdatingLocation()
        return
    }
    }
    // MARK: 设置页面
    fileprivate func setupView () {
        天气图片.image = UIImage.init(named: checkWeatherImage(name: currentModel?.result?.today?.weather ?? ""))
        城市.text = currentCity
        天气.text = currentModel?.result?.today?.weather
        温度.text = currentModel?.result?.sk?.temp
        发布时间.text = "发布时间 " + "\(Date())"
        风速.text = currentModel?.result?.sk?.wind_strength
        空气.text = currentModel?.result?.today?.uv_index
        湿度.text = currentModel?.result?.sk?.humidity
        if let values = currentModel?.result?.future {
            for (_,value) in values {
                allValue.append(value)
            }
        }
        collectionView.reloadData()
    }
    // MARK: 转化天气名称
    func checkWeatherImage(name: String) -> String {
        switch name {
        case "晴转多云":
            return "cloudy"
        case "多云转晴":
            return "sun"
        case "晴":
            return "sun"
        case "阴":
            return "yin"
        case "雪":
            return "snow"
        case "雾":
            return "fog"
        case "阵雨":
            return "zhenyu"
        case "雷阵雨":
            return "leizhenyu"
        default:
            return "sun"
        }
    }
    
    // MARK: - delegate - 请求位置
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard (currentCity != nil) else {
            if let nowCity = locations.first {
                let geoCoder = CLGeocoder.init()
                geoCoder.reverseGeocodeLocation(nowCity, completionHandler: { placemarks, error in
                    if let placeMark = placemarks?.first {
                        self.currentCity = placeMark.locality
                        if let city = self.currentCity {
                            MainNetManger.requestWeather(self.currentCity, handler: { (data) in
                                if data.result.isSuccess {
                                    if let json = data.result.value {
                                        self.currentModel = WeatherModel.deserialize(from: json)
                                        let user = UserDefaults.standard
                                        user.set(json, forKey: self.modelKey)
                                        user.set(city, forKey: self.cityKey)
                                        let time = Date.init().timeIntervalSince1970
                                        user.set(time, forKey: self.timeKey)
                                        self.setupView()
                                    }
                                }
                            })
                        }
                    }
                })
            }
            return
        }
     }
    // MARK: - delegate - collection
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allValue.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        let week = cell.viewWithTag(1) as! UILabel
        let weather = cell.viewWithTag(2) as! UIImageView
        let wendu = cell.viewWithTag(3) as! UILabel
        week.text = allValue[indexPath.item].week
        weather.image = UIImage.init(named: checkWeatherImage(name: allValue[indexPath.row].weather ?? ""))
        wendu.text = allValue[indexPath.item].temperature
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.size.width / 4, height: UIScreen.main.bounds.size.height * 0.2)
    }
}

