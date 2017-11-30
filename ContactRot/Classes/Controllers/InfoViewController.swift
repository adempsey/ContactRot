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

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        return scrollView
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.contactRotBackgroundColor()

        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ContactRot"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textColor = UIColor.contactRotTextColor()
        label.numberOfLines = 0

        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Copyright © 2017\nJonah Brucker-Cohen\nAndrew Dempsey"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = UIColor.contactRotTextColor()
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
        textView.textColor = UIColor.contactRotTextColor()
        textView.backgroundColor = UIColor.contactRotBackgroundColor()
        textView.textAlignment = .center
        textView.isScrollEnabled = false

        return textView
    }()

    private lazy var closeButton: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .stop,
                                          target: self,
                                          action: #selector(cancelButtonTapped(_:)))
        closeButton.tintColor = UIColor.contactRotTextColor()

        return closeButton
    }()

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.contactRotBackgroundColor()

        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.containerView)

        self.title = "About"
        self.navigationItem.leftBarButtonItem = self.closeButton

        self.containerView.addSubview(self.titleLabel)
        self.containerView.addSubview(self.authorLabel)
        self.containerView.addSubview(self.descriptionView)

        self.createConstraints()
    }

    // MARK: - Layout

    private func createConstraints() {

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
            make.bottom.equalTo(self.descriptionView)
        }

        self.titleLabel.snp.makeConstraints {
            (make) in
            make.centerX.equalTo(self.containerView)
            make.top.equalTo(self.containerView.snp.top).offset(40)
            make.width.equalTo(self.containerView).offset(-40)
        }

        self.authorLabel.snp.makeConstraints {
            (make) in
            make.centerX.equalTo(self.containerView)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.width.equalTo(self.containerView).offset(-40)
        }

        self.descriptionView.snp.makeConstraints {
            (make) in
            make.centerX.equalTo(self.containerView)
            make.top.equalTo(self.authorLabel.snp.bottom).offset(40)
            make.width.equalTo(self.containerView).offset(-40)

            let sizeThatFits = self.descriptionView.sizeThatFits(CGSize(width: self.view.frame.size.width,
                                                                        height: CGFloat(MAXFLOAT)))
            make.height.equalTo(sizeThatFits)
        }

    }

    // MARK: - Actions

    @objc private func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }

}
