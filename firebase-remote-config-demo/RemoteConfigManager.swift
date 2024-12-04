//
//  RemoteConfigManager.swift
//  firebase-remote-config-demo
//
//  Created by Vladimir Cezar on 2024.12.04.
//


import SwiftUI
import FirebaseRemoteConfig

class RemoteConfigManager: ObservableObject {
  private var remoteConfig: RemoteConfig
  private var settings: RemoteConfigSettings
  
  @Published var featureEnabled: Bool = false
  
  init() {
    remoteConfig = RemoteConfig.remoteConfig()
    settings = RemoteConfigSettings()
    
    settings.minimumFetchInterval = 0
    remoteConfig.configSettings = self.settings
    
    remoteConfig.addOnConfigUpdateListener { configUpdate, error in
      guard let configUpdate, error == nil else {
        print("Error listening for config updates.")
        return
      }
      
      if configUpdate.updatedKeys.contains("feature_enabled") {
        self.remoteConfig.activate()
        DispatchQueue.main.async {
          self.featureEnabled = self.remoteConfig.configValue(forKey: "feature_enabled").boolValue
          print(self.featureEnabled)
        }
      }
    }
  }
  
  func fetchRemoteConfig() async {
    do {
      let fetchStatus = try await remoteConfig.fetch(withExpirationDuration: 3600)
      
      if fetchStatus == .success {
        print("Activating...")
        try await remoteConfig.activate()
        DispatchQueue.main.async {
          self.featureEnabled = self.remoteConfig.configValue(forKey: "feature_enabled").boolValue
          print(self.featureEnabled)
        }
      } else {
        print("Remote Config fetch failed with status: \(fetchStatus)")
      }
    } catch {
      print("Error fetching remote config: \(error.localizedDescription)")
    }
  }
  
  func getConfigValue(forKey key: String) -> String? {
    return remoteConfig.configValue(forKey: key).stringValue
  }
}
