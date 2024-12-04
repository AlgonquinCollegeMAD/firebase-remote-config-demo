//
//  ContentView.swift
//  firebase-remote-config-demo
//
//  Created by Vladimir Cezar on 2024.12.04.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var remoteConfigManager = RemoteConfigManager()
  
  @State private var showFeature = false
  
  var body: some View {
    TabView {
      // Tab 1
      Text("Welcome to this app!")
        .tabItem {
          VStack {
            Image(systemName: "globe")
            Text("Welcome")
          }
        }
      // Tab 2
      VStack {
        Text("Firebase Remote Config Example")
          .font(.largeTitle)
          .padding()
        
        if remoteConfigManager.featureEnabled {
          Text("The new feature is ENABLED!")
            .font(.title)
            .foregroundColor(.green)
        } else {
          Text("The new feature is DISABLED!")
            .font(.title)
            .foregroundColor(.red)
        }
      }
      .onAppear {
        Task {
          await remoteConfigManager.fetchRemoteConfig()
        }
      }
      .tabItem {
        VStack {
          Image(systemName: "gear")
          Text("Feature")
        }
      }
    }
  }
  
//  private func fetchRemoteConfig() {
//    Task {
//      await remoteConfigManager.fetchRemoteConfig()
//    }
//  }
}


#Preview {
  ContentView()
}
