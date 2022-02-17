//
//  SceneDelegate.swift
//  MoviesNavigatorApp
//
//  Created by Luis Francisco Piura Mejia on 27/12/21.
//

import UIKit
import Combine
import TVShows
import TVShowsiOS
import SharedAPI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var rootViewController: HomeViewController = {
        HomeScreenComposer.composeWith(loader: makeLoadShowsRequest(), posterLoader: makeLoadPosterRequest())
    }()
    
    private let baseURL = URL(string: "https://api.themoviedb.org/3/tv/")!
    private let imageBaseURL = URL(string: "https://image.tmdb.org/t/p/w1280/")!
    private let apiKey = "5c43afd0842f0fd15d2aba1eaaf17ec7"
    
    convenience init(httpClient: HTTPClient) {
        self.init()
        self.httpClient = httpClient
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        configure()
    }
    
    func configure() {
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
    
    private func makeLoadShowsRequest() -> ((ShowsRequest) -> LoadShowsPublisher) {
        RequestMaker.makeLoadShowsRequest(httpClient: httpClient, baseURL: baseURL, apiKey: apiKey)
    }
    
    private func makeLoadPosterRequest() -> ((URL) -> LoadShowPosterPublisher) {
        RequestMaker.makeLoadPosterRequest(httpClient: httpClient, imageBaseURL: imageBaseURL)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

