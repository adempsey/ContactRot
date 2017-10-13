//
//  ContactPermissionsViewController.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/13/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import UIKit
import Contacts
import SnapKit

protocol ContactPermissionsViewControllerDelegate: NSObjectProtocol {
    func permissionsViewControllerDidUpdatePermissions(_ viewController: UIViewController)
}

class ContactPermissionsViewController: UIViewController {

    // MARK: - Public Properties

    public weak var delegate: ContactPermissionsViewControllerDelegate?

    // MARK: - Private Properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        if CNContactStore.authorizationStatus(for: CNEntityType.contacts) == .notDetermined {
            label.text = "ContactRot is a live address book that only retains contacts if they stay relevant to your life"

        } else if CNContactStore.authorizationStatus(for: CNEntityType.contacts) == .restricted ||
            CNContactStore.authorizationStatus(for: CNEntityType.contacts) == .denied{
            label.text = "ContactRot requires access to your contacts to run"
        }

        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24)
        label.numberOfLines = 0

        return label
    }()

    private lazy var detailLabel: UILabel = {
        let label = UILabel()

        if CNContactStore.authorizationStatus(for: CNEntityType.contacts) == .notDetermined {
            label.text = "To begin, please grant access to your contacts. ContactRot will never alter or remove contacts from your main address book."
        } else {
            label.text = "You can do this from your device's settings"
        }

        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0

        return label
    }()

    private lazy var grantAccessButton: UIButton = {
        let button = UIButton()
        button.setTitle("Grant Access", for: .normal)
        button.setTitleColor(UIColor(white: 0.3, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self,
                         action: #selector(didTapGrantAccessButton(_:)),
                         for: .touchUpInside)

        return button
    }()

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.detailLabel)
        self.view.addSubview(self.grantAccessButton)

        self.createConstraints()
    }

    // MARK: - Layout

    private func createConstraints() {

        self.titleLabel.snp.makeConstraints {
            (make) in
            make.width.equalTo(self.view).offset(-40)
            make.centerX.equalTo(self.view)
            make.centerY.lessThanOrEqualTo(self.view)
        }

        self.detailLabel.snp.makeConstraints {
            (make) in
            make.width.equalTo(self.view).offset(-40)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(40)
        }

        self.grantAccessButton.snp.makeConstraints {
            (make) in
            make.centerX.equalTo(self.view)
            make.height.equalTo(30)
            make.width.equalTo(200)
            make.bottom.equalTo(self.bottomLayoutGuide.snp.top).offset(-40)
            make.top.equalTo(self.detailLabel.snp.bottom).offset(40)
        }

    }

    // MARK: - Actions

    @objc private func didTapGrantAccessButton(_ sender: Any) {

        if CNContactStore.authorizationStatus(for: CNEntityType.contacts) == .notDetermined {
            self.requestContactsAccess()

        } else if CNContactStore.authorizationStatus(for: CNEntityType.contacts) == .restricted ||
            CNContactStore.authorizationStatus(for: CNEntityType.contacts) == .denied{
            self.redirectToDeviceSettings()
        }
    }

    // MARK: - Internal Methods

    private func requestContactsAccess() {
        CNContactStore().requestAccess(for: CNEntityType.contacts) {
            (granted, error) in
            self.delegate?.permissionsViewControllerDidUpdatePermissions(self)
        }
    }

    private func redirectToDeviceSettings() {
        if let url = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

}
