//
//  RemoteConfigFirebaseManager.swift
//  MVVM-Coordinator
//
//  Created by nhocbangchu95 on 8/20/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

enum RemoteConfigKey: String {
    case lastestVersion = "lastest_version"
    case isForceUpdate = "is_force_update"
}

class RemoteConfigFirebaseManager {
    static let shared = RemoteConfigFirebaseManager()

    private var remoteConfig: RemoteConfig!
    private var settings: RemoteConfigSettings!

    private init() {
        remoteConfig = RemoteConfig.remoteConfig()
        var devDevelopment = false
        settings = RemoteConfigSettings(developerModeEnabled: devDevelopment)
        remoteConfig.configSettings = settings

        // Setting default value. If not value is empty (example: "")
        remoteConfig.setDefaults(fromPlist: "FirebaseRemoteConfigDefault")
    }

    private func lastestVersion() -> String? {
        return self.getValue(key: .lastestVersion)
    }

    func isForceUpdate() -> Bool? {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let lastestVersion = lastestVersion() else {
                return nil
        }

        if lastestVersion.isEmpty {
            return nil
        }

        if lastestVersion.compare(currentVersion, options: .numeric) == .orderedSame {
            // app version == lastestVersion
            return nil
        } else if lastestVersion.compare(currentVersion, options: .numeric) == .orderedDescending {
            // app version < lastestVersion
            return self.getValue(key: .isForceUpdate)
        } else {
            // app version > lastestVersion
            return nil
        }
    }

    func getValue(key: RemoteConfigKey) -> Bool {
        return remoteConfig.configValue(forKey: key.rawValue).boolValue
    }

    func getValue(key: RemoteConfigKey) -> String? {
        return remoteConfig.configValue(forKey: key.rawValue).stringValue
    }

    func fetchRemoteConfig(completed: ((Error?) -> Void)?) {
        remoteConfig.fetch(withExpirationDuration: 0) { (status, err) in
            guard status  == RemoteConfigFetchStatus.success  else {
                completed?(err)
                return
            }
            self.remoteConfig.activateFetched()
            completed?(nil)
        }
    }
}
