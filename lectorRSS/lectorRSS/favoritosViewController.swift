//
//  favoritosViewController.swift
//  lectorRSS
//
//  Created by Juan Luis on 15/04/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit
import CoreData


class favoritosViewController: UICollectionViewController {
    
    lazy var favoritosResult:NSFetchedResultsController<Noticias> = {
        let fetchFavorito:NSFetchRequest<Noticias> = Noticias.fetchRequest()
        fetchFavorito.sortDescriptors = [NSSortDescriptor(key: #keyPath(Noticias.id), ascending: true)]
        fetchFavorito.predicate = NSPredicate(format: "favorito = %@", NSNumber(value: true))
        return NSFetchedResultsController(fetchRequest: fetchFavorito, managedObjectContext: ctx, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    func reloadTableData() {
        DispatchQueue.main.async { [weak self] in
            do {
                try self?.favoritosResult.performFetch()
            } catch {
                print("Error en la consulta de Favoritos")
            }
            self?.collectionView.reloadData()
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        reloadTableData()
       
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return favoritosResult.sections?[section].numberOfObjects ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "micoleccion", for: indexPath) as! celdasFavoritosController
        
        let dato = favoritosResult.object(at: indexPath)
        
        cell.tituloFavorito.text = dato.titulo?.htmlString
        
        if let imagen = dato.imagenDatos {
            cell.imagenFavoritos.image = UIImage(data: imagen)
        } else {
            cell.imagenFavoritos.image = UIImage(named: "camera")
        }
        
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
