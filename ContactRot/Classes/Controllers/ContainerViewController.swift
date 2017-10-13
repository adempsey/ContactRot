//
//  ContainerViewController.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/13/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import UIKit
import Contacts

class ContainerViewController: UIViewController {

    // MARK: - Private Properties

    private var authorizationViewController: ContactPermissionsViewController {
        let viewController = ContactPermissionsViewController()
        viewController.delegate = self

        return viewController
    }

    private var contactsListNavigationController: UINavigationController {
        let viewController = ContactListViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.tintColor = UIColor(white: 0.3, alpha: 1.0)

        return navigationController
    }

    private var currentViewController: UIViewController?

    // MARK: - Initialization

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveApplicationWillEnterForegroundNotification(_:)),
                                               name: .UIApplicationWillEnterForeground,
                                               object: nil)

        self.reloadChildView()
    }

    // MARK: - Layout

    private func reloadConstraints(for view: UIView) {

        view.snp.remakeConstraints {
            (make) in
            make.edges.equalTo(self.view)
        }

    }

    // MARK: - Notification Handlers

    @objc private func didReceiveApplicationWillEnterForegroundNotification(_ notification: Notification) {
        self.reloadChildView()
    }

    // MARK: - Internal Methods

    private func reloadChildView() {

        if let currentViewController = self.currentViewController {
            if currentViewController.view.isDescendant(of: self.view) {
                currentViewController.view.removeFromSuperview()
            }
            currentViewController.removeFromParentViewController()
        }

        self.currentViewController = {
            if CNContactStore.authorizationStatus(for: CNEntityType.contacts) == .authorized {
                return self.contactsListNavigationController

            } else {
                return self.authorizationViewController
            }
        }()

        if let currentViewController = self.currentViewController {
            self.addChildViewController(currentViewController)
            self.view.addSubview(currentViewController.view)
            self.reloadConstraints(for: currentViewController.view)
        }
    }

}

extension ContainerViewController: ContactPermissionsViewControllerDelegate {

    func permissionsViewControllerDidUpdatePermissions(_ viewController: UIViewController) {
        DispatchQueue.main.async {
            self.reloadChildView()
        }
    }

}
