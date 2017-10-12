//
//  ContactPhoneNumberTableViewCell.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/12/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import UIKit
import SnapKit

protocol ContactPhoneNumberTableViewCellDelegate: NSObjectProtocol {
    func contactPhoneNumberCellDidSelectCallButton(_ cell: ContactPhoneNumberTableViewCell)
}

class ContactPhoneNumberTableViewCell: UITableViewCell {

    // MARK: - Public Properties

    public weak var delegate: ContactPhoneNumberTableViewCellDelegate?

    // MARK: - Private Properties

    private lazy var contactButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal

        stackView.addArrangedSubview(self.phoneButton)
        stackView.addArrangedSubview(self.messageButton)

        return stackView
    }()

    private lazy var phoneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.addTarget(self,
                         action: #selector(didSelectCallButton(_:)),
                         for: .touchUpInside)

        return button
    }()

    private lazy var messageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue

        return button
    }()

    // MARK: - Initialization

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(self.contactButtonStackView)

        self.createConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Layout

    private func createConstraints() {
        self.contactButtonStackView.snp.makeConstraints {
            (make) in
            make.top.right.bottom.equalTo(self.contentView)
        }
    }

    // MARK: - Actions

    @objc private func didSelectCallButton(_ sender: Any) {
        self.delegate?.contactPhoneNumberCellDidSelectCallButton(self)
    }

}
