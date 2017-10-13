//
//  ContactViewController.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/10/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import UIKit
import SnapKit

class ContactViewController: UIViewController {

    // MARK: - Private Properties

    private let contact: Contact?

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = self.contact?.givenName
        label.textAlignment = .center

        return label
    }()

    private lazy var contactDateLabel: UILabel = {
        let label = UILabel()
        if let contact = self.contact {
            let text = String(format: "Last contacted %@", contact.lastContactDate.relativeFormat())
            label.text = text
        }
        label.textAlignment = .center

        return label
    }()

    private lazy var contactThumbnailView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 2, height: 2))
        if let imageData = self.contact?.thumbnailData {
            imageView.image = UIImage(data: imageData)
        }
        imageView.clipsToBounds = true
        imageView.autoresizesSubviews = true

        return imageView
    }()

    private lazy var contactInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.addSubview(self.contactThumbnailView)
        view.addSubview(self.nameLabel)
        view.addSubview(self.contactDateLabel)

        return view
    }()

    private lazy var contactMethodsViewController: ContactMethodsViewController = {
        let viewController = ContactMethodsViewController(contact: contact!)

        return viewController
    }()

    // MARK: - Initialization

    init(contact: Contact) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        self.contact = nil
        super.init(coder: aDecoder)
    }

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        self.view.addSubview(self.contactInfoView)

        self.addChildViewController(self.contactMethodsViewController)
        self.view.addSubview(self.contactMethodsViewController.view)

        self.createContraints()
    }

    // MARK: - Layout

    private func createContraints() {

        self.contactInfoView.snp.makeConstraints {
            (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
        }

        self.contactThumbnailView.snp.makeConstraints {
            (make) in
            make.centerX.equalTo(self.contactInfoView)
            make.top.equalTo(self.contactInfoView).offset(30)
            make.width.height.equalTo(80)
        }

        self.nameLabel.snp.makeConstraints {
            (make) in
            make.centerX.equalTo(self.contactInfoView)
            make.top.equalTo(self.contactThumbnailView.snp.bottom).offset(20)
            make.height.equalTo(24)
        }

        self.contactDateLabel.snp.makeConstraints {
            (make) in
            make.centerX.equalTo(self.nameLabel)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(20)
            make.bottom.equalTo(self.contactInfoView).offset(-30)
            make.height.equalTo(24)
        }

        self.contactMethodsViewController.view.snp.makeConstraints {
            (make) in
            make.top.equalTo(self.contactInfoView.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
    }

}
