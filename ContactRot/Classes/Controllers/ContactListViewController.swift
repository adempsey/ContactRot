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
        if #available(iOS 11.0, *) {
            tableView.insetsContentViewsToSafeArea = false
        }
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.sectionIndexBackgroundColor = UIColor.contactRotIndexColor()
        tableView.sectionIndexColor = UIColor.contactRotBlue()
        tableView.register(ContactListTableViewCell.self,
                           forCellReuseIdentifier: self.reuseIdentifier)

        return tableView
    }()

    fileprivate let dataProvider = ContactListDataProvider()

    private lazy var infoButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "ⓘ",
                                     style: .plain,
                                     target: self,
                                     action: #selector(infoButtonTapped(_:)))

        return button
    }()

    // MARK: - View Controller Lifecycle

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .all
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "ContactRot"
        self.navigationItem.leftBarButtonItem = self.infoButton

        self.view.addSubview(self.tableView)
        self.createConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataProvider.retrieve()
        self.tableView.reloadData()

        // Reset colors that may have changed
        self.tableView.sectionIndexBackgroundColor = UIColor.contactRotIndexColor()
    }

    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {

        coordinator.animate(alongsideTransition: { (_) in
            // Sorry
            self.tableView.reloadData()
        })

        super.viewWillTransition(to: size, with: coordinator)

    }

    // MARK: - Layout

    private func createConstraints() {
        self.tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }

    // MARK: - Actions

    @objc private func infoButtonTapped(_ id: Any) {
        let infoViewController = InfoViewController()
        let navigationController = UINavigationController(rootViewController: infoViewController)
        self.present(navigationController, animated: true)
    }

}

extension ContactListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataProvider.sectionTitles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataProvider[section]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let contactList = self.dataProvider[indexPath.section] else {
            return ContactListTableViewCell()
        }
        
        let contact = contactList[indexPath.row]

        let cell = ContactListTableViewCell(contact, reuseIdentifier: self.reuseIdentifier)
        
        let alpha = UIColor.alphaForDate(contact.lastContactDate)
        
        cell.textLabel?.text = contact.fullNameWithEntropy
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        cell.textLabel?.alpha = alpha
        
        let detailText = contact.contactDateDescription()
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
        label.text = self.dataProvider.sectionTitles[section].capitalized
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.contactRotTextColor()

        view.addSubview(label)

        return view
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.dataProvider.sectionTitles
    }

}
