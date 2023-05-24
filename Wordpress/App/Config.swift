//
//  Config.swift
//  News
//
//  Created by Asil Arslan on 21.12.2020.
//

import Foundation
import SwiftUI

/// Purchase Code from https://codecanyon.net/downloads
var PURCHASE_CODE = ""

/// Wordpress URL
var WORDPRESS_URL = "https://asilarslan.com/"

/// Headline Category
/// All Category List -> www.YOUR_WORDPRESS_SITE/wp-json/wp/v2/categories
var HEADLINE_CATEGORY_ID = 36

///Onboard Data
var ONBOARD_DATA: [Onboard] = [
    Onboard(title: "Onboard 1", headline: "Headline", image: "logo", gradientColors: [Color("ColorBlue"), Color("ColorBlue")]),
    Onboard(title: "Onboard 2", headline: "Headline", image: "logo", gradientColors: [Color("ColorGreen"), Color("ColorGreen")]),
    Onboard(title: "Onboard 3", headline: "Headline", image: "logo", gradientColors: [Color("ColorRed"), Color("ColorRed")])
]

///In App Products. Note:  You must have extended license for in-app purchases. Contact me if you want upgrade.
var IN_APP_PRODUCTS = [
    //Use your product IDs instead
    "remove_ads",
    "donate"
]

///Category Tabs Visibilty
var IS_CATEGORIES_VISIBLE = true

///Headline Visibilty
var IS_HEADLINE_VISIBLE = true

///Headline Type
var HEADLINE_TYPE = HeadlineEnum.multiple
var EMPTY_IMAGE_URL = "https://seferihisar.com/wp-content/themes/shnews/assets/img/no-thumb.jpg"

var DATE_FORMAT = "dd MMM yyyy"

//Admob Interstital ad id
var INTERSTITIAL_AD_ID: String = "ca-app-pub-8915706349520340/3989286675"
var TEST_DEVICE: String = "b317b731f5490205b1f60b638837ea16"

///Settings
var DEVELOPER = "Asil ARSLAN"
var COMPABILITY = "iOS 14"
var WEBSITE_LABEL = "Blog"
var WEBSITE_LINK = "asilarslan.com"
var VERSION = "1.0.0"

enum HeadlineEnum {
    case single, multiple
}



////Your wordpress address
//var WORDPRESS_URL = "https://time.com/"//"https://asilarslan.com/"
//var HEADLINE_CATEGORY_ID = 208878//36 // Your Categories -> www.YOUR_WORDPRESS_SITE/wp-json/wp/v2/categories
