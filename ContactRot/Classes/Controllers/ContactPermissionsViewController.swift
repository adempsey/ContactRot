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

    private lazy var topIconSpacerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear

        return view
    }()

    private lazy var bottomIconSpacerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear

        return view
    }()

    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon-main")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true

        return imageView
    }()

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
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0

        return label
    }()

    private lazy var grantAccessButton: UIButton = {
        let button = UIButton()
        button.setTitle("Grant Access", for: .normal)
        button.setTitleColor(UIColor.contactRotTextColor(), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self,
                         action: #selector(didTapGrantAccessButton(_:)),
                         for: .touchUpInside)

        return button
    }()

    // MARK: - View Controller Lifecycle

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.contactRotBackgroundColor()
        self.view.addSubview(self.topIconSpacerView)
        self.view.addSubview(self.iconView)
        self.view.addSubview(self.bottomIconSpacerView)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.detailLabel)
        self.view.addSubview(self.grantAccessButton)

        self.createConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.iconView.layer.cornerRadius = self.iconView.bounds.size.width / 2
    }

    // MARK: - Layout

    private func createConstraints() {

        self.topIconSpacerView.snp.makeConstraints {
            (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view).offset(40)
            make.bottom.equalTo(self.iconView.snp.top)
            make.height.greaterThanOrEqualTo(40)
        }

        self.iconView.snp.makeConstraints {
            (make) in
            make.centerX.equalTo(self.view)
            make.width.lessThanOrEqualTo(196)
            make.height.equalTo(self.iconView.snp.width)
        }

        self.bottomIconSpacerView.snp.makeConstraints {
            (make) in
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.titleLabel.snp.top)
            make.top.equalTo(self.iconView.snp.bottom)
            make.height.equalTo(self.topIconSpacerView)
        }

        self.titleLabel.snp.makeConstraints {
            (make) in
            make.width.equalTo(self.view).offset(-40)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view)
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
