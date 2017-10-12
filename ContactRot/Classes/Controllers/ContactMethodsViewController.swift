//
//  ContactMethodsViewController.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/11/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import UIKit
import MessageUI

class ContactMethodsViewController: UIViewController {

    private let contact: Contact?

    private lazy var contactMethodsView: ContactMethodsView = {
        let view = ContactMethodsView(contact: contact!)
        view.delegate = self
        return view
    }()

    // MARK: - Initialization

    init(contact: Contact) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
        self.view = self.contactMethodsView
    }

    required init?(coder aDecoder: NSCoder) {
        self.contact = nil
        super.init(coder: aDecoder)
    }

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func composeEmail(to address: String) {
        if MFMailComposeViewController.canSendMail() {
            let mailController = MFMailComposeViewController()
            mailController.mailComposeDelegate = self
            mailController.setToRecipients([address])
            self.present(mailController, animated: true)
        }
    }

}

extension ContactMethodsViewController: ContactMethodsViewDelegate {

    func didSelectEmailAddress(_ methodsView: ContactMethodsView, address: String) {
        self.composeEmail(to: address)
    }

}

extension ContactMethodsViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true)
    }

}

