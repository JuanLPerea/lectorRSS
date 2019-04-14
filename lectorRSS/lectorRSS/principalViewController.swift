//
//  principalViewController.swift
//  lectorRSS
//
//  Created by Dev1 on 10/04/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class principalViewController: UITableViewController {
    
    var urlSeleccionado:URL!
    
    // Recuperamos los datos con una consulta a CoreData
    lazy var noticiasResult:NSFetchedResultsController<Noticias> = {
        let fetchNoticias:NSFetchRequest<Noticias> = Noticias.fetchRequest()
        fetchNoticias.sortDescriptors = [NSSortDescriptor(key: #keyPath(Noticias.id), ascending: true)]
        let consulta = NSFetchedResultsController(fetchRequest: fetchNoticias, managedObjectContext: ctx, sectionNameKeyPath: nil, cacheName: nil)
        print ("Recuperar Noticias \(consulta.fetchedObjects?.count ?? 0)")
        return consulta
    }()
    
    func reloadTableData() {
        DispatchQueue.main.async { [weak self] in
            do {
                try self?.noticiasResult.performFetch()
            } catch {
                print("Error en la consulta")
            }
            self?.tableView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conexionRSS()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("OKCARGA"), object: nil, queue: OperationQueue.main) { [weak self] _ in
            self?.reloadTableData()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print ("Numero de noticias \(noticiasResult.sections?[section].numberOfObjects ?? 0)")
        return noticiasResult.sections?[section].numberOfObjects ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "micelda", for: indexPath) as! NoticiasTableViewCell

        
        let datosNoticia = noticiasResult.object(at: indexPath)

        //cell.fotoNoticia.image = UIImage(named: "camera")
        
        if let imagen = datosNoticia.imagenDatos {
            cell.fotoNoticia.image = UIImage(data: imagen)
        } else {
            if let imagenURL = datosNoticia.imagenURL {
                recuperarImagen(url: imagenURL) { imagen in
                    if let resize = imagen.resizeImage(newWidth: cell.fotoNoticia.frame.size.width) {
                        if tableView.visibleCells.contains(cell) {
                            cell.fotoNoticia.image = resize
                        }
                        datosNoticia.imagenDatos = resize.pngData()
                        saveContext()
                    }
                }
            }
        }
  
        
        cell.tituloNoticia.text = datosNoticia.titulo?.htmlString
        cell.resumenNoticia.text = datosNoticia.descripcion?.htmlString

        
        return cell
    }
    
    // lanzar el Web View cuando pulsamos en una celda...
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dato = noticiasResult.object(at: indexPath)
        urlSeleccionado = dato.enlaceNoticia
        
        performSegue(withIdentifier: "mostrarNoticia", sender: Any?.self)
    }
    
    // Pasar la url de la celda seleccionada al visor Web
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mostrarNoticia" {
            
            let vc = segue.destination as! WebViewController
            vc.urlNoticia = urlSeleccionado
            
        }
    }
    
    // Unwind segue para volver a la pantalla de las noticias
    @IBAction func unwindToNoticias(segue: UIStoryboardSegue) {}
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("OKCARGA"), object: nil)
    }
    
    //recuperar imagen
    func recuperaURL(url:URL, callback:@escaping (UIImage) -> Void) {
        let sesion = URLSession.shared
        
        sesion.dataTask(with: url) { (data, response, error) in
            
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                if let error = error {
                    print("Error al descargar imagen \(error.localizedDescription)")
                }
                return
            }
            
            if response.statusCode == 200 {
                if let imagenDescargada = UIImage(data: data) {
                    callback(imagenDescargada)
                }
            }
            }.resume()
    }

}
