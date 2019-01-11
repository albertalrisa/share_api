//
//  Instagram.swift
//  share_api
//
//  Created by Albert Richard Sanyoto on 2019-01-11.
//

class Instagram: ShareIntent {
    var urlSchemes = [
        "instagram-stories://share"
    ]
    
    func execute(function: String, arguments: Dictionary<String, String>, result: @escaping FlutterResult) {
        result(FlutterMethodNotImplemented)
    }
}
