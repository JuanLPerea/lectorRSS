//
//  WebViewController.swift
//  lectorRSS
//
//  Created by Juan Luis on 12/04/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import UIKit
import WebKit
import CoreData

enum TipoAlerta {
    case info, error
}



class WebViewController: UIViewController, WKNavigationDelegate{
    
    @IBOutlet weak var navegadorView: WKView!
    @IBOutlet weak var compartirBtnFrm: UIBarButtonItem!
    
    var urlNoticia:URL!
    var idNoticia:Int64!
    
    // Recuperamos los datos con una consulta a CoreData
    lazy var noticiaResult:NSFetchedResultsController<Noticias> = {
        let fetchNoticia:NSFetchRequest<Noticias> = Noticias.fetchRequest()
        fetchNoticia.sortDescriptors = [NSSortDescriptor(key: #keyPath(Noticias.id), ascending: true)]
        fetchNoticia.predicate = NSPredicate(format: "id = %@", NSNumber(value: idNoticia))
        return NSFetchedResultsController(fetchRequest: fetchNoticia, managedObjectContext: ctx, sectionNameKeyPath: nil, cacheName: nil)
    }()
    
    func reloadTableData() {
        DispatchQueue.main.async { [weak self] in
            do {
                try self?.noticiaResult.performFetch()
            } catch {
                print("Error en la consulta")
            }
         //   self?.navegadorView.reload()
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navegadorView.navigationDelegate = self
        
        // lanzar el navegador con la url correspondiente
        let url = urlNoticia!
        navegadorView.load(URLRequest(url: url))
        
        reloadTableData()
        
        
        
        
    }
    
    @IBAction func volverBtn(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "volverNoticias", sender: self)
    }
    
    @IBAction func favoritoBtn(_ sender: UIBarButtonItem) {
     //   print("Favorito: \(noticiaResult.fetchedObjects?.count ?? 0)")
        // Guardamos en la base de datos si la noticia es favorita o no
        let miNoticia = noticiaResult.object(at: .init(item: 0, section: 0))
     //   print("Descripcion: \(miNoticia.descripcion ?? "")")
        
        
        miNoticia.favorito.toggle()
        var mensaje = ""
        if miNoticia.favorito {
            mensaje = "Añadido a Favoritos"
        } else {
            mensaje = "Eliminado de Favoritos"
        }
        
        mostrarAlerta(mensaje: mensaje, tipo: .info, vc: self)

        
        saveContext()
        
   
        
    }
    
    @IBAction func compartirBtn(_ sender: UIBarButtonItem) {

        let activity = UIActivityViewController(activityItems: [urlNoticia ?? "Enlace a la noticia"], applicationActivities: nil)
        activity.excludedActivityTypes = [.addToReadingList, .mail]
        activity.completionWithItemsHandler = { (activityType, success, items, error) in
            if success {
                print("Compartidos los datos")
            }
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            activity.modalPresentationStyle = .popover
            activity.popoverPresentationController?.sourceRect = compartirBtnFrm.accessibilityFrame
            activity.popoverPresentationController?.sourceView = self.view
        }
        present(activity, animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    

}


func mostrarAlerta(mensaje:String, tipo:TipoAlerta, vc:UIViewController) {
    let alerta = UIAlertController(title: tipo == .info ? "Información" : "Error", message: mensaje, preferredStyle: .alert)
    let accion = UIAlertAction(title: "OK", style: .default, handler: nil)
    alerta.addAction(accion)
    vc.present(alerta, animated: true, completion: nil)
}
