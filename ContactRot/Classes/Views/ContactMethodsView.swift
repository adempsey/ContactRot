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

    fileprivate enum TableViewSections: Int {
        case Phone
        case Email
    }

    private let reuseIdentifier = "cellidentifier"

    private let contact: Contact?

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    init(contact: Contact) {
        self.contact = contact
        super.init(frame: .zero)
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
        let cell: ContactPhoneNumberTableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier) else {
                return ContactPhoneNumberTableViewCell(style: .default, reuseIdentifier: self.reuseIdentifier)
            }

            return cell as! ContactPhoneNumberTableViewCell
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

        cell.delegate = self
        cell.textLabel?.text = title

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
        return 44.0
    }

}

extension ContactMethodsView: ContactPhoneNumberTableViewCellDelegate {

    func contactPhoneNumberCellDidSelectCallButton(_ cell: ContactPhoneNumberTableViewCell) {
        let number = cell.textLabel!.text!.filter {
            "0123456789".characters.contains($0)
        }
        self.delegate?.didSelectCallButton(self, number: number)
    }

    func contactPhoneNumberCellDidSelectMessageButton(_ cell: ContactPhoneNumberTableViewCell) {
        print("message ".appending(cell.textLabel!.text!))
    }

}
