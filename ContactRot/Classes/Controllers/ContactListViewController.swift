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
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: self.reuseIdentifier)
        tableView.dataSource = self

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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,
                                                 for: indexPath)

        cell.textLabel?.text = self.dataProvider[indexPath.row].givenName

        return cell
    }
    
}
