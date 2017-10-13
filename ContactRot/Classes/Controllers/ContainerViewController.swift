//
//  ContainerViewController.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/13/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    // MARK: - Private Properties

    private let settingsManager = SettingsDataManager()

    private let authorizationViewController = ContactPermissionsViewController()
    private let contactsListViewController = ContactListViewController()

    private lazy var contactsListNavigationController: UINavigationController = {
        let navigationController = UINavigationController(rootViewController: self.contactsListViewController)
        navigationController.navigationBar.tintColor = UIColor(white: 0.3, alpha: 1.0)

        return navigationController
    }()

    private var currentViewController: UIViewController?

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadChildView()
    }

    // MARK: - Layout

    private func reloadConstraints(for view: UIView) {

        view.snp.remakeConstraints {
            (make) in
            make.edges.equalTo(self.view)
        }

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
            if self.settingsManager.hasRequestedContactsPermission == false {
                return self.authorizationViewController

            } else if self.settingsManager.hasAuthorizedContactsAccess {
                return self.contactsListNavigationController
            }

            return nil
        }()

        if let currentViewController = self.currentViewController {
            self.addChildViewController(currentViewController)
            self.view.addSubview(currentViewController.view)
            self.reloadConstraints(for: currentViewController.view)
        }
    }

}
