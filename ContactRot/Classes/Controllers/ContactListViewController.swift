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

    fileprivate let reuseIdentifier = "contact_list_cell"

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    fileprivate let dataProvider = ContactListDataProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.createConstraints()

        self.dataProvider.retrieve()
        self.tableView.reloadData()
    }

    private func createConstraints() {
        self.tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }

}

extension ContactListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataProvider.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier) else {
                return UITableViewCell(style: .subtitle,
                                       reuseIdentifier: self.reuseIdentifier)
            }
            return cell
        }()

        let contact = self.dataProvider[indexPath.row]
        let alpha = 1.0 - (CGFloat(abs(contact.lastContactDate.timeIntervalSinceNow)) / CGFloat(Date.DateInterval.HalfYear.rawValue))

        cell.textLabel?.text = String(format: "%@ %@", contact.givenName, contact.familyName)
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
        let contact = self.dataProvider[indexPath.row]
        let viewController = ContactViewController(contact: contact)
        self.navigationController?.pushViewController(viewController,
                                                      animated: true)
    }

}
