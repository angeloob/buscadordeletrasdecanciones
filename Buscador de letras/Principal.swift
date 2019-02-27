//
//  ViewController.swift
//  Buscador de letras
//
//  Created by Angel Olvera on 2/22/19.
//  Copyright © 2019 Angel Olvera. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    /**
     funcion para enviar un mensaje al usuario de que hay un error con la app.
     - Parameter mensaje: recibe el texto que desplegará en pantalla.
 */
    func alerta(mensaje: String) {
        let alertView = UIAlertController(title: "Error",
                                          message: mensaje,
                                          preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Entendido", style: .default)
        alertView.addAction(okAction)
        self.present(alertView, animated: true)
    }
    
    @IBOutlet weak var artista: UITextField!
    @IBOutlet weak var titulo: UITextField!
    
    /**
     Botón que captura los datos escritos por el usuario y los ingresa en una Api y es procesada
 */
    @IBAction func buscar(_ sender: UIButton) {
        print("hola")
        let title = titulo.text!
        let artist = artista.text!
        if title.isEmpty || artist.isEmpty {
            print("Rellena todos los campos")
            let mensaje = "Llena todos los campos"
            alerta(mensaje: mensaje)
        }
        let url = "https://api.lyrics.ovh/v1/\(artist.replacingOccurrences(of: " ", with: "%20"))/\(title.replacingOccurrences(of: " ", with: "%20"))"
        let objetoUrl = URL(string:url)
        /**
         lee el URL ingresado y extrae el JSON, se especifica que parte del Json se requiere
         
 */
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
                        self.performSegue(withIdentifier: "boton", sender: self)
                        }
                    }
                    else{
                         print(json.values)
                        DispatchQueue.main.async { [unowned self] in
                            let ac = UIAlertController(title: "Error", message: "No se encontraron resultados", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                            self.present(ac, animated: true)
                        }
                    }
                    
                }catch {
                    
                    print("El Procesamiento del JSON tuvo un error")
                    
                }
                
            }
            
        }
        
        tarea.resume()
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "boton" {
            let nuevo = "si"
            let showSong = segue.destination as! mostrarCancion
            showSong.artista = artista.text!
            showSong.titulo = titulo.text!
            showSong.nuevo = nuevo
            
        }
    }

}

