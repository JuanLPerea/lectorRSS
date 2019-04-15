//
//  favoritosViewController.swift
//  lectorRSS
//
//  Created by Juan Luis on 15/04/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit
import CoreData


class favoritosViewController: UICollectionViewController, UITabBarControllerDelegate {
    
    var urlSeleccionado:URL!
    var idSeleccionado:Int64!
    
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
        tabBarController?.delegate = self
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        let secciones = favoritosResult.sections?.count ?? 0
        return secciones
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let totalfav = favoritosResult.sections?[section].numberOfObjects ?? 0
    //    print ("Numero de favoritos: \(totalfav)")
        return totalfav
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "celdacoleccion", for: indexPath) as! celdasFavoritosController
        

        
        let dato = favoritosResult.object(at: indexPath)
        
      //  if let titulo = cell.tituloFavorito {
            cell.tituloFavorito.text = dato.titulo?.htmlString
     //   }

     //   if let foto = cell.imagenFavoritos {
            if let imagen = dato.imagenDatos {
                cell.imagenFavoritos.image = UIImage(data: imagen)
            }
     //  }


        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // print("Has pulsado en: \(indexPath.item)")
        
        let dato = favoritosResult.object(at: indexPath)
        urlSeleccionado = dato.enlaceNoticia
        idSeleccionado = dato.id
        
        performSegue(withIdentifier: "vernoticiafavorita", sender: Any?.self)
        
    }

    // Pasar la url de la celda seleccionada al visor Web
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "vernoticiafavorita" {
            
            let vc = segue.destination as! WebViewController
            vc.urlNoticia = urlSeleccionado
            vc.idNoticia = idSeleccionado
            
        }
    }

    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 1 {
       //     print("Recargar Datos Favoritos")
            self.reloadTableData()
        }
    }
    

}
