//
//  WeatherModel.swift
//  weather
//
//  Created by 王志平 on 2018/11/21.
//  Copyright © 2018 王志平. All rights reserved.
//

import Foundation
import HandyJSON

class WeatherModel: HandyJSON {
    
    var charge : Bool?
    var message : String?
    var result : Result?
    var status : String?
    required init() {}

}

class Result : HandyJSON{
    var future : [String:day]?
    var sk : Sk?
    var today : day?
    required init() {}
}

class day : HandyJSON{
    
    var city : String?
    var comfortIndex : String?
    var date_y : String?
    var dressing_advice : String?
    var dressing_index : String?
    var drying_index : String?
    var exercise_index : String?
    var temperature : String?
    var travel_index : String?
    var uv_index : String?
    var wash_index : String?
    var weather : String?
    var weather_id : WeatherId?
    var week : String?
    var wind : String?
    var date : String?
    required init() {}
}

class Sk : HandyJSON{
    
    var humidity : String?
    var temp : String?
    var time : String?
    var wind_direction : String?
    var wind_strength : String?
    required init() {}
}

class WeatherId : HandyJSON{
    
    var fa : String?
    var fb : String?
    required init() {}
    
}
