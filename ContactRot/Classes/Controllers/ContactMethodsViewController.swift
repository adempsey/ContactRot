//
//  ContactMethodsViewController.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/11/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import UIKit
import MessageUI

protocol ContactMethodsViewControllerDelegate: NSObjectProtocol {
    func didSuccessfullyContact(_ viewController: ContactMethodsViewController)
}

class ContactMethodsViewController: UIViewController {

    public weak var delegate: ContactMethodsViewControllerDelegate?

    public var contactView: ContactMethodsView {
        return self.contactMethodsView
    }

    public var contentHeight: CGFloat {
        get {
            return self.contactMethodsView.contentHeight
        }
    }

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
    }

    required init?(coder aDecoder: NSCoder) {
        self.contact = nil
        super.init(coder: aDecoder)
    }

    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = self.contactMethodsView
    }

    private func composeEmail(to address: String) {
        if MFMailComposeViewController.canSendMail() {
            let mailController = MFMailComposeViewController()
            mailController.mailComposeDelegate = self
            mailController.setToRecipients([address])
            self.present(mailController, animated: true)
        }
    }

    private func composeMessage(to number: String) {
        if MFMessageComposeViewController.canSendText() {
            let composerController = MFMessageComposeViewController()
            composerController.messageComposeDelegate = self
            composerController.recipients = [number]
            self.present(composerController, animated: true)
        }
    }

}

extension ContactMethodsViewController: ContactMethodsViewDelegate {

    func didSelectEmailAddress(_ methodsView: ContactMethodsView, address: String) {
        self.composeEmail(to: address)
    }

    func didSelectCallButton(_ methodsView: ContactMethodsView, number: String) {
        if let url = URL(string: "telprompt://".appending(number)) {
            UIApplication.shared.open(url)
        }
    }

    func didSelectMessageButton(_ methodsView: ContactMethodsView, number: String) {
        self.composeMessage(to: number)
    }

}

extension ContactMethodsViewController: MFMailComposeViewControllerDelegate {

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {

        defer {
            controller.dismiss(animated: true)
        }

        if error == nil, result == .sent, let contact = self.contact {
            guard (try? ContactDataManager.sharedInstance.updateContactDate(for: [contact])) != nil else {
                return
            }

            self.delegate?.didSuccessfullyContact(self)
        }
    }

}

extension ContactMethodsViewController: MFMessageComposeViewControllerDelegate {

    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        defer {
            controller.dismiss(animated: true)
        }

        if result == .sent, let contact = self.contact {
            guard (try? ContactDataManager.sharedInstance.updateContactDate(for: [contact])) != nil else {
                return
            }

            self.delegate?.didSuccessfullyContact(self)
        }
    }

}

