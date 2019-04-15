//
//  celdasFavoritosController.swift
//  lectorRSS
//
//  Created by Juan Luis on 15/04/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit

class celdasFavoritosController: UICollectionViewCell {
    
    
    @IBOutlet weak var imagenFavoritos: UIImageView!
    @IBOutlet weak var tituloFavorito: UILabel!
    
    override func prepareForReuse() {
      //  imagenFavoritos = nil
      //  tituloFavorito = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
