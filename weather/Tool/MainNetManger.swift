//
//  MainNetManger.swift
//  weather
//
//  Created by 王志平 on 2018/11/21.
//  Copyright © 2018 王志平. All rights reserved.
//

import UIKit
import Alamofire

class MainNetManger: NSObject {
    class func requestWeather(_ cityName: String? , handler: @escaping (DataResponse<String>) -> Void)
        -> Void {
        Alamofire.request("http://weatherapi.market.alicloudapi.com/weather/TodayTemperatureByCity",
                          method: .post,
                          parameters: ["cityName":cityName ?? ""],
                          encoding: URLEncoding.default,
                          headers: ["Authorization":"APPCODE 691a8c4d415449ffb69b1a7ac2a4000d"]).responseString(completionHandler: handler)
    }
}
