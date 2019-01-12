//
//  Facebook.swift
//  share_api
//
//  Created by Albert Richard Sanyoto on 2019-01-11.
//

class Facebook: ShareIntent {
    func execute(function: String, arguments: Dictionary<String, String?>, result: @escaping FlutterResult) {
        switch function {
            "shareToStory": self.shareToStory(arguments, result);
        default: result(FlutterMethodNotImplemented);
        }
    }
    
    func shareToStory(arguments: Dictionary<String, String?>, result @escaping FlutterResult) {
        
    }
    
    var urlSchemes = [
        "facebook-stories://share"
    ]
}
