//
//  BaseIntent.swift
//  share_api
//
//  Created by Albert Richard Sanyoto on 2019-01-11.
//

protocol ShareIntent {
    func isPackageInstalled() -> Bool
    func execute(function: String, arguments: Dictionary<String, String?>, result: @escaping FlutterResult)
    var urlSchemes: [String] {get set}
}

extension ShareIntent {
    func isPackageInstalled() -> Bool {
        return urlSchemes.contains {
            let appUrl = URL(string: $0)
            return UIApplication.shared.canOpenURL(appUrl! as URL)
        }
    }
}
