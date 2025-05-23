//
//  SceneDelegate.swift
//  ToDo List
//
//  Created by Глеб Капустин on 13.03.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = TasksListModuleBuilder.build()
        window?.makeKeyAndVisible()
    }

}

