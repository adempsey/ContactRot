//
//  ContactListViewController.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/5/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import UIKit
import SnapKit

class ContactListViewController: UIViewController {

    // MARK: - Private Properties

    fileprivate let reuseIdentifier = "contact_list_cell"

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = UITableViewAutomaticDimension

        return tableView
    }()

    fileprivate let dataProvider = ContactListDataProvider()

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "ContactRot"

        self.view.addSubview(self.tableView)
        self.createConstraints()

        self.dataProvider.retrieve()
        self.tableView.reloadData()
    }

    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // Sorry
        self.tableView.reloadData()
    }

    // MARK: - Layout

    private func createConstraints() {
        self.tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }

}

extension ContactListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 26
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataProvider[section]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier) else {
                return UITableViewCell(style: .subtitle,
                                       reuseIdentifier: self.reuseIdentifier)
            }
            return cell
        }()

        guard let contactList = self.dataProvider[indexPath.section] else {
            return cell
        }

        let contact = contactList[indexPath.row]
        let alpha = UIColor.alphaForDate(contact.lastContactDate)

        cell.textLabel?.text = String(format: "%@ %@", contact.givenName, contact.familyName)
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        cell.textLabel?.alpha = alpha

        let detailText = String(format: "Last contacted %@", contact.lastContactDate.relativeFormat())
        cell.detailTextLabel?.text = detailText
        cell.detailTextLabel?.alpha = alpha

        return cell
    }

}

extension ContactListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let contactList = self.dataProvider[indexPath.section] else {
            return
        }

        let contact = contactList[indexPath.row]
        let viewController = ContactViewController(contact: contact)
        self.navigationController?.pushViewController(viewController,
                                                      animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.dataProvider[section] != nil ? 24 : 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.dataProvider[section] == nil {
            return nil
        }

        let offset = self.tableView.separatorInset.left

        let view = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: self.view.frame.size.width,
                                        height: 24))

        let label = UILabel(frame: CGRect(x: offset,
                                          y: 0,
                                          width: self.view.frame.size.width - offset,
                                          height: 24))
        label.text = String(UnicodeScalar(UInt8(section + 65)))
        label.font = UIFont.boldSystemFont(ofSize: 14)

        view.addSubview(label)

        return view
    }
}
