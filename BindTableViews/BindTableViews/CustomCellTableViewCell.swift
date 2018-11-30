//
//  CustomCellTableViewCell.swift
//  BindTableViews
//
//  Created by Tim Beals on 2018-10-09.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {

    static let resuseID = "customCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupForContributor(_ contributor: Contributor) {
        self.textLabel?.text = "\(contributor.name)"
        self.detailTextLabel?.text = "\(contributor.email)"
    }

}
