//
//  InfoViewController.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/18/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import UIKit
import SnapKit

class InfoViewController: UIViewController {

    // MARK: - Private Properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ContactRot"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.numberOfLines = 0

        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Copyright © 2017\nJonah Brucker-Cohen\nAndrew Dempsey"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.numberOfLines = 0

        return label
    }()

    private lazy var descriptionView: UITextView = {
        let textView = UITextView()
        textView.text = "ContactRot is a project intended to emphasize our increasing reliance on cloud storage for things like phone numbers, friends, etc... So much so that without it we begin to forget things. Ultimately these forms of storage act as memory for our brains, replacing what we used to keep there. When these items begin to disappear, we ultimately lose touch with people to the point of being forced to contact them in other ways (e.g., real life) to get the data back.\n\n\n\nCreated by Jonah Brucker-Cohen\nDeveloped by Andrew Dempsey"
        textView.font = UIFont.systemFont(ofSize: 14.0)

        return textView
    }()

    private lazy var closeButton: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop,
                                          target: self,
                                          action: #selector(cancelButtonTapped(_:)))
        closeButton.tintColor = UIColor(white: 0.4, alpha: 1.0)

        return closeButton
    }()

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        self.title = "About"
        self.navigationItem.leftBarButtonItem = self.closeButton

        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.authorLabel)
        self.view.addSubview(self.descriptionView)

        self.createConstraints()
    }

    // MARK: - Layout

    private func createConstraints() {

        self.titleLabel.snp.makeConstraints {
            (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(40)
            make.width.equalTo(self.view).offset(-40)
        }

        self.authorLabel.snp.makeConstraints {
            (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.width.equalTo(self.view).offset(-40)
        }

        self.descriptionView.snp.makeConstraints {
            (make) in
            make.centerX.bottom.equalTo(self.view)
            make.top.equalTo(self.authorLabel.snp.bottom).offset(40)
            make.width.equalTo(self.view).offset(-40)
        }

    }

    // MARK: - Actions

    @objc private func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }

}
