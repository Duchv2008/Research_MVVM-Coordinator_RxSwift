//
//  PushNotificationResponse.swift
//  MVVM-Coordinator
//
//  Created by nhocbangchu95 on 8/20/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import Foundation
import ObjectMapper

enum PushNotificationType: String {
    case keyPushFromServer
}

class PushNotificationResponse: Mappable {
    var title: String = ""
    var body: String = ""
    var badge: Int = 0
    var sound: String?
    var pushNotificationType: PushNotificationType?
    var imageUrl: String?
    var targetID: String?

    init() {

    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        title <- map["aps.alert.title"]
        body <- map["aps.alert.body"]
        badge <- map["aps.badge"]
        sound <- map["aps.sound"]
    }
}
