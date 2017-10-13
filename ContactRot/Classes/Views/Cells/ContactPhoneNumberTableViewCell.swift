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
    func contactPhoneNumberCellDidSelectMessageButton(_ cell: ContactPhoneNumberTableViewCell)
}

class ContactPhoneNumberTableViewCell: UITableViewCell {

    // MARK: - Public Properties

    public weak var delegate: ContactPhoneNumberTableViewCellDelegate?

    // MARK: - Private Properties

    private lazy var phoneButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon-phone"), for: .normal)
        button.addTarget(self,
                         action: #selector(didSelectCallButton(_:)),
                         for: .touchUpInside)

        return button
    }()

    private lazy var messageButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon-message"), for: .normal)
        button.addTarget(self,
                         action: #selector(didSelectMessageButton(_:)),
                         for: .touchUpInside)

        return button
    }()

    // MARK: - Initialization

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(self.phoneButton)
        self.contentView.addSubview(self.messageButton)

        self.createConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Layout

    private func createConstraints() {

        self.messageButton.snp.makeConstraints {
            (make) in
            make.width.height.equalTo(36)
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-20)
        }

        self.phoneButton.snp.makeConstraints {
            (make) in
            make.width.height.equalTo(36)
            make.centerY.equalTo(self)
            make.right.equalTo(self.messageButton.snp.left).offset(-20)
        }
    }

    // MARK: - Actions

    @objc private func didSelectCallButton(_ sender: Any) {
        self.delegate?.contactPhoneNumberCellDidSelectCallButton(self)
    }

    @objc private func didSelectMessageButton(_ sender: Any) {
        self.delegate?.contactPhoneNumberCellDidSelectMessageButton(self)
    }

}
