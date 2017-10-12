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

    private lazy var contactInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.addSubview(self.contactInfoStackView)

        return view
    }()

    private lazy var contactInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .black
        stackView.addArrangedSubview(self.nameLabel)

        return stackView
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

        self.createContraints()
    }

    // MARK: - Layout

    private func createContraints() {

        self.contactInfoView.snp.makeConstraints {
            (make) in
            make.left.top.right.equalTo(self.view)
            make.height.equalTo(300)
        }

        self.contactInfoStackView.snp.makeConstraints {
            (make) in
            make.edges.equalTo(self.contactInfoView)
        }
    }

}
