//
//  ContainerController.swift
//  TwitterTutorial
//
//  Created by Stephen Dowless on 3/25/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import UIKit
import Firebase

class ContainerController: UIViewController {
    
    // MARK: - Properties
    
    private var centerController: UINavigationController!
    private var menu: MenuController!
    private var shadowView: UIView!
    private var isExpanded = false
    
    var user: User? {
        didSet {
            configureFeedController()
            configureMenuController()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .twitterBlue
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }
    
    // MARK: - Selectors
    
    @objc func dismissMenu() {
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded)
    }
        
    // MARK: - Helper Functions
    
    func hideActionButton(shouldHide: Bool) {
        guard let controller = self.tabBarController as? MainTabController else { return }
        controller.actionButton.isHidden = shouldHide
    }
    
    func animateMenu(shouldExpand: Bool, completion: ((Bool) -> Void)? = nil) {
        self.tabBarController?.tabBar.isHidden = shouldExpand
        let xOrigin = self.view.frame.width - 80

        if shouldExpand {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = xOrigin
                self.shadowView.alpha = 1
                self.shadowView.frame = CGRect(x: xOrigin, y: 0, width: 80, height: self.view.frame.height)
            })
        } else {
            shadowView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }, completion: completion)
        }
        animateStatusBar()
        hideActionButton(shouldHide: shouldExpand)
    }
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    func configureFeedController() {
        guard centerController == nil else { return }
        guard let user = user else { return }
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        feed.delegate = self
        feed.user = user
        
        centerController = UINavigationController(rootViewController: feed)
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    
    func configureMenuController() {
        guard menu == nil else { return }
        guard let user = user else { return }
        
        menu = MenuController(user: user)
        menu.delegate = self
        
        view.insertSubview(menu.view, at: 0)
        addChild(menu)
        menu.didMove(toParent: self)
        
        configureShadowView()
    }
    
    func configureShadowView() {
        self.shadowView = UIView(frame: self.view.bounds)
        self.shadowView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.shadowView.alpha = 0
        view.addSubview(shadowView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissMenu))
        self.shadowView.addGestureRecognizer(tap)
    }
}

// MARK: - FeedControllerDelegate

extension ContainerController: FeedControllerDelegate {
    func handleMenuToggle() {
        isExpanded.toggle()
        animateMenu(shouldExpand: isExpanded)
    }
}

// MARK: - MenuControllerDelegate

extension ContainerController: MenuControllerDelegate {
    func didSelect(option: MenuOptions) {
        isExpanded.toggle()
        
        switch option {
        case .logout:
            animateMenu(shouldExpand: isExpanded) { _ in
                let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
                alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
                    AuthService.shared.signOut(completion: { (success) in
                        let nav = UINavigationController(rootViewController: LoginController())
                        nav.navigationBar.barStyle = .black
                        nav.modalPresentationStyle = .fullScreen
                        self.present(nav, animated: true, completion: nil)
                    })
                }))
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        case .profile:
            guard let user = self.user else { return }
            let controller = ProfileController(user: user)
            centerController.pushViewController(controller, animated: true)
            animateMenu(shouldExpand: isExpanded)
        case .lists:
            break
        }
    }
}
