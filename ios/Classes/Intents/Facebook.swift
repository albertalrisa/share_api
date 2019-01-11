//
//  Facebook.swift
//  share_api
//
//  Created by Albert Richard Sanyoto on 2019-01-11.
//

class Facebook: ShareIntent {
    func execute(function: String, arguments: Dictionary<String, String>, result: @escaping FlutterResult) {
        result(FlutterMethodNotImplemented)
    }
    
    var urlSchemes = [
        "facebook-stories://share"
    ]
}
