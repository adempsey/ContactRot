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
        label.text = String(format: "%@ %@", self.contact?.givenName ?? "", self.contact?.familyName ?? "")
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        if let contact = self.contact {
            label.alpha = UIColor.alphaForDate(contact.lastContactDate)
        }

        return label
    }()

    private lazy var miniNameLabel: UILabel = {
        let label = UILabel()

        let firstInitial = String(describing: self.contact?.givenName.uppercased().first ?? Character(""))
        let secondInitial = String(describing: self.contact?.familyName.uppercased().first ?? Character(""))
        label.text = String(format: "%@%@", firstInitial, secondInitial)
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 36)

        return label
    }()

    private lazy var contactDateLabel: UILabel = {
        let label = UILabel()
        if let contact = self.contact {
            let text = String(format: "Last contacted %@", contact.lastContactDate.relativeFormat())
            label.text = text
            label.alpha = UIColor.alphaForDate(contact.lastContactDate)
        }
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)

        return label
    }()

    private lazy var contactThumbnailView: UIView = {

        let view: UIView = {
            if let thumbnailData = self.contact?.thumbnailData {
                let imageView = UIImageView()
                if let imageData = self.contact?.thumbnailData {
                    imageView.image = UIImage(data: imageData)
                }

                imageView.clipsToBounds = true
                imageView.autoresizesSubviews = true

                return imageView

            } else {
                let view = UIView()
                view.backgroundColor = UIColor(white: 0.4, alpha: 1.0)
                view.addSubview(self.miniNameLabel)

                return view
            }
        }()

        view.layer.cornerRadius = 40
        view.layer.masksToBounds = true

        if let contact = self.contact {
            view.alpha = UIColor.alphaForDate(contact.lastContactDate)
        }

        return view
    }()

    private lazy var contactInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        view.addSubview(self.contactThumbnailView)
        view.addSubview(self.nameLabel)
        view.addSubview(self.contactDateLabel)

        return view
    }()

    private lazy var contactMethodsViewController: ContactMethodsViewController = {
        let viewController = ContactMethodsViewController(contact: contact!)
        viewController.delegate = self

        return viewController
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: self.view.frame.size.width,
                                        height: self.view.frame.size.height)
        scrollView.backgroundColor = .white

        return scrollView
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white

        return view
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

        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.containerView)

        self.containerView.addSubview(self.contactInfoView)

        self.addChildViewController(self.contactMethodsViewController)
        self.containerView.addSubview(self.contactMethodsViewController.view)

        self.createContraints()
    }

    // MARK: - Layout

    private func createContraints() {

        self.scrollView.snp.makeConstraints {
            (make) in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
            make.leading.trailing.equalTo(self.view)
        }

        self.containerView.snp.makeConstraints {
            (make) in
            make.edges.equalTo(self.scrollView)
            make.width.equalTo(self.view)
        }

        self.contactInfoView.snp.makeConstraints {
            (make) in
            make.top.left.right.equalTo(self.containerView)
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
            make.left.bottom.right.equalTo(self.containerView)
            make.height.greaterThanOrEqualTo(300)
        }

        if self.miniNameLabel.isDescendant(of: self.contactThumbnailView) {
            self.miniNameLabel.snp.makeConstraints {
                (make) in
                make.edges.equalTo(self.contactThumbnailView)
            }
        }
    }

}

extension ContactViewController: ContactMethodsViewControllerDelegate {

    func didSuccessfullyContact(_ viewController: ContactMethodsViewController) {
        let newDate = Date()
        self.contact?.lastContactDate = newDate
        self.nameLabel.alpha = UIColor.alphaForDate(newDate)
        self.contactDateLabel.alpha = UIColor.alphaForDate(newDate)
        self.contactThumbnailView.alpha = UIColor.alphaForDate(newDate)

        self.contactDateLabel.text = String(format: "Last contacted %@", newDate.relativeFormat())
    }

}
