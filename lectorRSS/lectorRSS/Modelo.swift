//
//  Modelo.swift
//  lectorRSS
//
//  Created by Dev1 on 10/04/2019.
//  Copyright © 2019 Dev1. All rights reserved.
//

import Foundation
import CoreData

let baseURL = URL(string: "https://applecoding.com/wp-json/wp/v2/posts")!

var persistentContainer:NSPersistentContainer = {
    let container = NSPersistentContainer(name: "BasedeDatos")
    container.loadPersistentStores { storeDescription, error in
        if let error = error as NSError? {
            fatalError("Error al abrir la base de datos")
        }
    }
    return container
}()

var ctx:NSManagedObjectContext {
    return persistentContainer.viewContext
}

func saveContext() {
    DispatchQueue.main.async {
        if ctx.hasChanges {
            do {
                try ctx.save()
            } catch {
                print("Error en la grabación")
            }
        }
    }
}

struct Post: Codable {
    let id: Int
    let date, dateGmt: String
    let guid: GUID
    let modified, modifiedGmt, slug: String
    let status: Status
    let type: TypeEnum
    let link: String
    let title: GUID
    let content, excerpt: Content
    let author, featuredMedia: Int
    let commentStatus: CommentStatus
    let pingStatus: PingStatus
    let sticky: Bool
    let template: String
    let format: Format
    let meta: Meta
    let categories, tags: [Int]
    // Aquí está el dato de la imágen
    let jetpackFeaturedMediaURL: String
    let views: String
    let links: Links
    
    enum CodingKeys: String, CodingKey {
        case id, date
        case dateGmt = "date_gmt"
        case guid, modified
        case modifiedGmt = "modified_gmt"
        case slug, status, type, link, title, content, excerpt, author
        case featuredMedia = "featured_media"
        case commentStatus = "comment_status"
        case pingStatus = "ping_status"
        case sticky, template, format, meta, categories, tags
        case jetpackFeaturedMediaURL = "jetpack_featured_media_url"
        case views
        case links = "_links"
    }
    
}

enum CommentStatus: String, Codable {
    case commentStatusOpen = "open"
}

struct Content: Codable {
    let rendered: String
    let protected: Bool
}

enum Format: String, Codable {
    case standard = "standard"
}

struct GUID: Codable {
    let rendered: String
}

struct Links: Codable {
    let linksSelf, collection, about: [About]
    let author, replies: [Author]
    let versionHistory: [VersionHistory]
    let predecessorVersion: [PredecessorVersion]
    let wpFeaturedmedia: [Author]
    let wpAttachment: [About]
    let wpTerm: [WpTerm]
    let curies: [Cury]
    
    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case collection, about, author, replies
        case versionHistory = "version-history"
        case predecessorVersion = "predecessor-version"
        case wpFeaturedmedia = "wp:featuredmedia"
        case wpAttachment = "wp:attachment"
        case wpTerm = "wp:term"
        case curies
    }
}

struct About: Codable {
    let href: String
}

struct Author: Codable {
    let embeddable: Bool
    let href: String
}

struct Cury: Codable {
    let name: Name
    let href: Href
    let templated: Bool
}

enum Href: String, Codable {
    case httpsAPIWOrgRel = "https://api.w.org/{rel}"
}

enum Name: String, Codable {
    case wp = "wp"
}

struct PredecessorVersion: Codable {
    let id: Int
    let href: String
}

struct VersionHistory: Codable {
    let count: Int
    let href: String
}

struct WpTerm: Codable {
    let taxonomy: Taxonomy
    let embeddable: Bool
    let href: String
}

enum Taxonomy: String, Codable {
    case category = "category"
    case postTag = "post_tag"
}

struct Meta: Codable {
    let ampStatus, spayEmail: String
    
    enum CodingKeys: String, CodingKey {
        case ampStatus = "amp_status"
        case spayEmail = "spay_email"
    }
}

enum PingStatus: String, Codable {
    case closed = "closed"
}

enum Status: String, Codable {
    case publish = "publish"
}

enum TypeEnum: String, Codable {
    case post = "post"
}

func conexionRSS() {
    
    let session = URLSession.shared
    var request = URLRequest(url: baseURL)
    request.httpMethod = "GET"
    request.addValue("*/*", forHTTPHeaderField: "Accept")
    session.dataTask(with: request) { data, response, error in
        guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
            if let error = error {
                print("ERROR : \(error)")
            }
            return
        }
        if response.statusCode == 200 {
            let decoder = JSONDecoder()
            do {
                let cargaDatos = try decoder.decode([Post].self, from: data)
                // let dato = cargaDatos[1].title.rendered
                if let rutaDoc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    print ("Ruta BD: \(rutaDoc)")
                }
                
                cargaDatos.forEach {dato in
                    if !noticiaExists(id: dato.id) {
                        let nuevaNoticia = Noticias(context: ctx)
                        
                        nuevaNoticia.id = Int64(dato.id)
                        nuevaNoticia.titulo = dato.title.rendered
                        nuevaNoticia.descripcion = dato.excerpt.rendered
                        nuevaNoticia.imagenURL = URL(string: dato.jetpackFeaturedMediaURL)
                        nuevaNoticia.enlaceNoticia = URL(string: dato.link)
                        nuevaNoticia.favorito = false
                        
                        
                    }
                }
                
                saveContext()
                
                
            } catch {
                print("Error en la serialización \(error)")
            }
               NotificationCenter.default.post(name: NSNotification.Name("OKCARGA"), object: nil)
        }
        }.resume()
    
}

func noticiaExists(id:Int) -> Bool {
    let consulta:NSFetchRequest<Noticias> = Noticias.fetchRequest()
    consulta.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
    return ((try? ctx.count(for: consulta)) ?? 0) > 0 ? true : false
}



