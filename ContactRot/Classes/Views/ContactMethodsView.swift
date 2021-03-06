//
//  ContactMethodsView.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/11/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import UIKit
import SnapKit

protocol ContactMethodsViewDelegate: NSObjectProtocol {
    func didSelectEmailAddress(_ methodsView: ContactMethodsView, address: String)
    func didSelectCallButton(_ methodsView: ContactMethodsView, number: String)
    func didSelectMessageButton(_ methodsView: ContactMethodsView, number: String)
}

class ContactMethodsView: UIView {

    public weak var delegate: ContactMethodsViewDelegate?

    public var contentHeight: CGFloat {
        self.tableView.layoutIfNeeded()
        return self.tableView.contentSize.height + 100
    }

    fileprivate enum TableViewSections: Int {
        case Phone
        case Email
    }

    private let phoneCellIdentifier = "phoneCellIdentifier"
    private let defaultCellIdentifier = "defaultCellIdentifier"

    private let contact: Contact?

    public lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false

        return tableView
    }()

    init(contact: Contact) {
        self.contact = contact
        super.init(frame: .zero)

        self.tableView.backgroundColor = UIColor.contactRotBackgroundColor()
        self.addSubview(self.tableView)
        self.createConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        self.contact = nil
        super.init(coder: aDecoder)
    }

    private func createConstraints() {
        self.tableView.snp.makeConstraints {
            (make) in
            make.edges.equalTo(self)
        }
    }

}

extension ContactMethodsView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.contact?.phoneNumbers.count ?? 0) + (self.contact?.emailAddresses.count ?? 0)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case TableViewSections.Phone.rawValue:
            return self.contact?.phoneNumbers.count ?? 0

        case TableViewSections.Email.rawValue:
            return self.contact?.emailAddresses.count ?? 0

        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {

            let identifier: String = {
                switch indexPath.section {
                    case TableViewSections.Phone.rawValue:
                        return self.phoneCellIdentifier
                    default:
                        return self.defaultCellIdentifier
                }
            }()

            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) else {

                if indexPath.section == TableViewSections.Phone.rawValue {
                    return ContactPhoneNumberTableViewCell(style: .default,
                                                           reuseIdentifier: identifier)
                } else {
                    return UITableViewCell(style: .default, reuseIdentifier: identifier)
                }

            }

            return cell
        }()

        let title: String = {
            switch indexPath.section {
            case TableViewSections.Phone.rawValue:
                return self.contact?.phoneNumbers[indexPath.row] ?? ""
            case TableViewSections.Email.rawValue:
                return self.contact?.emailAddresses[indexPath.row] ?? ""
            default:
                return ""
            }
        }()

        cell.backgroundColor = UIColor.contactRotNeutral()

        if let contactInterval = self.contact?.lastContactDate.timeIntervalSinceNow {
            cell.textLabel?.text = title.stringWithEntropy(contactInterval)
        } else {
            cell.textLabel?.text = title
        }

        var textColor = UIColor.contactRotTextColor()

        if let contactDate = self.contact?.lastContactDate {
            let alpha = UIColor.alphaForDate(contactDate)
            textColor = textColor.withAlphaComponent(alpha)
        }

        cell.textLabel?.textColor = textColor

        if let phoneCell = cell as? ContactPhoneNumberTableViewCell {
            phoneCell.delegate = self
        }

        return cell
    }

}

extension ContactMethodsView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case TableViewSections.Phone.rawValue:
            return "Numbers"
        case TableViewSections.Email.rawValue:
            return "Email Addresses"
        default:
            return ""
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.section {
        case TableViewSections.Phone.rawValue:
            break
        case TableViewSections.Email.rawValue:
            self.delegate?.didSelectEmailAddress(self, address: self.contact!.emailAddresses[indexPath.row])
            break
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

}

extension ContactMethodsView: ContactPhoneNumberTableViewCellDelegate {

    func contactPhoneNumberCellDidSelectCallButton(_ cell: ContactPhoneNumberTableViewCell) {
        let number = cell.textLabel!.text!.filter {
            "0123456789".contains($0)
        }
        self.delegate?.didSelectCallButton(self, number: number)
    }

    func contactPhoneNumberCellDidSelectMessageButton(_ cell: ContactPhoneNumberTableViewCell) {
        let number = cell.textLabel!.text!.filter {
            "0123456789".contains($0)
        }
        self.delegate?.didSelectMessageButton(self, number: number)
    }

}
