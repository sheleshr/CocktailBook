import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    if let windowScene = scene as? UIWindowScene {
        let window = UIWindow(windowScene: windowScene)
//        window.rootViewController = MainScreenViewController()
        window.rootViewController = UIHostingController(rootView: MainScreenView())
        self.window = window
        window.makeKeyAndVisible()
    }
  }

  func sceneDidDisconnect(_ scene: UIScene) {}
  func sceneDidBecomeActive(_ scene: UIScene) {
      print("scene did become active")
      FavStore.shared.loadFavIDs()
  }
  func sceneWillResignActive(_ scene: UIScene) {}
  func sceneWillEnterForeground(_ scene: UIScene) {}
  func sceneDidEnterBackground(_ scene: UIScene) {
      print("scene did enter in background")
      FavStore.shared.saveFavIDs()
  }
}

