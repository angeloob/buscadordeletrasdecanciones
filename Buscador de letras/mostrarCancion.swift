//
//  mostrarCancion.swift
//  Buscador de letras
//
//  Created by Angel Olvera on 2/22/19.
//  Copyright © 2019 Angel Olvera. All rights reserved.
//

import UIKit
import CoreData
/**
    mostrarCancion es la clase que recive los datos, interpreta y despliega en la pantalla para que el usuario pueda interactuar
 */
class mostrarCancion: UIViewController {
    var artista = ""
    var titulo = ""
    var nuevo = ""
    var datosRecibidos : Canciones!
    
    @IBOutlet weak var leerCancion: UITextView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    /**
     Al presionar el botón guardar el usuario hace una llamada al coreData y almacena los registros de grupo y titulo en dos variables para que despues el usuario tenga facil acceso a ellos
 */
    @IBAction func guardar(_ sender: UIBarButtonItem) {
        let contexto = conexion()
        let entidadCanciones = NSEntityDescription.insertNewObject(forEntityName: "Canciones", into: contexto) as! Canciones
        entidadCanciones.grupo = artista
        entidadCanciones.titulo = titulo
        do {
            try contexto.save()
            alerta()
            print("guardado")
        } catch let error as NSError {
            print("Error al guardar", error.localizedDescription)
        }
    }
    
    
    
    /**
     Se hace una referencia al NSManagedObjectContext
 */
    func conexion()-> NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    
    /**
     despliega un mensaje al usuario que avisa que la letra de la canción  fue guardada
 */
    func alerta() {
        let alertView = UIAlertController(title: "Guardado",
                                          message: "La canción ha sido guardada exitosamente",
                                          preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Entendido", style: .default)
        alertView.addAction(okAction)
        self.present(alertView, animated: true)
    }
    
    
    
    
    override func viewDidLoad() {
//        print(datosRecibidos.grupo)
        navItem.title = artista + " - " + titulo
        /**
         Si la cancion ya fue guardada deshabilita el botón de guardar
 */
        if nuevo == "si"{
            navItem.rightBarButtonItem?.isEnabled = true
        }
        else{
            navItem.rightBarButtonItem?.isEnabled = false
        }
        
        super.viewDidLoad()
        /**
         ingrersamos el Url y en caso de que el usuario ingresara mas de una palabra se remplazan los espacion con %20
 */
        let url = "https://api.lyrics.ovh/v1/\(artista.replacingOccurrences(of: " ", with: "%20"))/\(titulo.replacingOccurrences(of: " ", with: "%20"))"
        let objetoUrl = URL(string:url)
        print("esta es la vista 2: ", leerCancion.text!)
        let tarea = URLSession.shared.dataTask(with: objetoUrl!) { (datos, respuesta, error) in
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                do{
                    let json = try JSONSerialization.jsonObject(with: datos!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                    
                    if json["error"] == nil {
                        print("nulo")
                        let querySubJsonLyrircs = json["lyrics"] as! String
                        print(querySubJsonLyrircs)
                        DispatchQueue.main.async {
                            self.leerCancion.text = querySubJsonLyrircs
                            
                            
                        }
                    }
                    else{
                        print(json.values)
                    }
                    
                }catch {
                    
                    print("El Procesamiento del JSON tuvo un error")
                    
                }
                
            }
            
        }
        
        tarea.resume()
        // Do any additional setup after loading the view.
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
