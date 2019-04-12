//
//  TableViewCell.swift
//  lectorRSS
//
//  Created by Dev1 on 10/04/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit

class NoticiasTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fotoNoticia: UIImageView!
    @IBOutlet weak var tituloNoticia: UILabel!
    @IBOutlet weak var resumenNoticia: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    override func prepareForReuse() {
        fotoNoticia.image = nil
        tituloNoticia.text = nil
        resumenNoticia.text = nil
    }
}
