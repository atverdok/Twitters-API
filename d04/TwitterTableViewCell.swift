//
//  TwitterTableViewCell.swift
//  d04
//
//  Created by Aleksey Tverdokhleb on 10/7/18.
//  Copyright © 2018 Aleksey Tverdokhleb. All rights reserved.
//

import UIKit

class TwitterTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var tweat : Tweet? {
        didSet {
            if let f = tweat {
                titleLabel?.text = f.name
                dataLabel?.text = f.date
                contentLabel?.text = f.text
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
