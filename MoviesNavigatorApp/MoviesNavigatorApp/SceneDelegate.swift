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
import Authentication
import SharedAPI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var store: TokenStore = {
        CodableTokenStore(storeURL: storeURL)
    }()
    
    private lazy var localTokenLoader: LocalTokenLoader = {
        LocalTokenLoader(store: store)
    }()
    
    private lazy var homeViewController: UIViewController = {
        HomeScreenComposer.composeWith(loader: makeLoadShowsRequest(), posterLoader: makeLoadPosterRequest())
    }()
    
    private lazy var loginViewController: UIViewController = {
        LoginUIComposer.compose(loginPublisher: makeLoginRequest(), onSuccess:  { })
    }()
    
    private let baseURL = URL(string: "https://api.themoviedb.org/3/")!
    private let storeURL = FileManager
        .default
        .urls(for: .documentDirectory, in: .userDomainMask)
        .first!
        .appendingPathComponent("TokenStore.store")
    private let imageBaseURL = URL(string: "https://image.tmdb.org/t/p/w1280/")!
    private let apiKey = "5c43afd0842f0fd15d2aba1eaaf17ec7"
    private var cancellable: AnyCancellable?
    
    convenience init(httpClient: HTTPClient, store: TokenStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
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
        window?.makeKeyAndVisible()
        cancellable = localTokenLoader
            .fetchTokenPublisher()
            .sink { [weak window, loginViewController] result in
                if case .failure(_) = result {
                    window?.rootViewController = loginViewController
                }
            } receiveValue: { [weak window, homeViewController] value in
                window?.rootViewController = homeViewController
            }
    }
    
    private func makeLoadShowsRequest() -> ((ShowsRequest) -> LoadShowsPublisher) {
        RequestMaker.makeLoadShowsRequest(httpClient: httpClient, baseURL: baseURL, apiKey: apiKey)
    }
    
    private func makeLoadPosterRequest() -> ((URL) -> LoadShowPosterPublisher) {
        RequestMaker.makeLoadPosterRequest(httpClient: httpClient, imageBaseURL: imageBaseURL)
    }
    
    private func makeLoginRequest() -> LoginPublisherHandler {
        RequestMaker.makeLoginRequest(httpClient: httpClient, baserURL: baseURL, apiKey: apiKey)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }


}

