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
import AuthenticationiOS
import SharedAPI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var rootViewController: UIViewController = {
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

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }


}

