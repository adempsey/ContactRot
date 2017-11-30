//
//  ContactListTableViewCell.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/18/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import UIKit

class ContactListTableViewCell: UITableViewCell {
    
    // MARK: Private Properties
    
    private var contact: Contact?
    
    private lazy var miniNameLabel: UILabel = {
        let label = UILabel()
        
        let firstInitial = String(describing: self.contact?.givenName.uppercased().first ?? Character(" "))
        let secondInitial = String(describing: self.contact?.familyName.uppercased().first ?? Character(" "))
        label.text = String(format: "%@%@", firstInitial, secondInitial)
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    private lazy var contactThumbnailView: UIView = {
        
        let view: UIView = {
            if let thumbnailData = self.contact?.thumbnailData {
                let imageView = UIImageView()
                if let imageData = self.contact?.thumbnailData {
                    imageView.image = UIImage(data: imageData)
                }
                
                imageView.clipsToBounds = true
                imageView.autoresizesSubviews = true
                
                return imageView
                
            } else {
                let view = UIView()
                view.backgroundColor = UIColor(white: 0.4, alpha: 1.0)
                view.addSubview(self.miniNameLabel)
                
                return view
            }
        }()
        
        view.layer.cornerRadius = 22
        view.layer.masksToBounds = true
        
        if let contact = self.contact {
            view.alpha = UIColor.alphaForDate(contact.lastContactDate)
        }
        
        return view
    }()

    // MARK: - Initialization
    
    convenience init(_ contact: Contact, reuseIdentifier: String) {
        self.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.contact = contact
        self.backgroundColor = UIColor.contactRotGray()
        self.textLabel?.textColor = UIColor.contactRotTextColor()
        self.detailTextLabel?.textColor = UIColor.contactRotTextColor()
        
        self.contentView.addSubview(self.contactThumbnailView)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.contact = nil
        super.init(coder: aDecoder)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contactThumbnailView.frame = CGRect(x: 14,
                                                 y: 8,
                                                 width: 44,
                                                 height: 44)
        
        if let textLabelFrame = self.textLabel?.frame {
            var newFrame = textLabelFrame
            newFrame.origin.x = self.contactThumbnailView.frame.origin.x + 10 + self.contactThumbnailView.frame.size.width
            self.textLabel?.frame = newFrame
        }
        
        if let detailTextLabelFrame = self.detailTextLabel?.frame {
            var newFrame = detailTextLabelFrame
            newFrame.origin.x = self.contactThumbnailView.frame.origin.x + 10 + self.contactThumbnailView.frame.size.width
            self.detailTextLabel?.frame = newFrame
        }
        
        var miniNameLabelFrame = self.contactThumbnailView.frame
        miniNameLabelFrame.origin.x = 0
        miniNameLabelFrame.origin.y = 0
        self.miniNameLabel.frame = miniNameLabelFrame
    }

}
