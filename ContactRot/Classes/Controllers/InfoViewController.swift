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
        label.textColor = UIColor.contactRotLightGray()
        label.numberOfLines = 0

        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Copyright © 2017\nJonah Brucker-Cohen\nAndrew Dempsey"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = UIColor.contactRotLightGray()
        label.numberOfLines = 0

        return label
    }()

    private lazy var descriptionView: UITextView = {
        let textView = UITextView()
        let text = "ContactRot is an art project and live address book application intended to emphasize our increasing reliance on cloud storage for things like phone numbers, friends, etc... So much that without it we begin to forget things. Ultimately these forms of storage act as artificial memory for our brains, replacing what we used to keep there. When names and personal information begin to disappear, we ultimately lose touch with people to the point of being forced to contact them in other ways (e.g., real life) to get the data back.\n\nCreated by Jonah Brucker-Cohen\nhttp://www.coin-operated.com\n@coinop29\n\nDeveloped by Andrew Dempsey\nhttps://adempsey.github.io/"
        
        let attributedText = NSMutableAttributedString(string: text)
        if let jonahWebsiteRange = text.range(of: "http://www.coin-operated.com") {
            attributedText.addAttributes([.link: "http://www.coin-operated.com"],
                                         range: NSRange(jonahWebsiteRange, in: text))
        }
        
        if let jonahTwitterRange = text.range(of: "@coinop29") {
            attributedText.addAttributes([.link: "https://twitter.com/@coinop29"],
                                         range: NSRange(jonahTwitterRange, in: text))
        }
        
        if let andrewWebsiteRange = text.range(of: "https://adempsey.github.io/") {
            attributedText.addAttributes([.link: "https://adempsey.github.io/"],
                                         range: NSRange(andrewWebsiteRange, in: text))
        }
        
        textView.attributedText = attributedText
        
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 14.0)
        textView.textColor = UIColor.contactRotLightGray()
        textView.backgroundColor = UIColor.contactRotDarkGray()
        textView.textAlignment = .center

        return textView
    }()

    private lazy var closeButton: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop,
                                          target: self,
                                          action: #selector(cancelButtonTapped(_:)))
        closeButton.tintColor = UIColor.contactRotLightGray()

        return closeButton
    }()

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.contactRotDarkGray()

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
