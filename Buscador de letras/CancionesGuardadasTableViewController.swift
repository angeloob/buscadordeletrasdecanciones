//
//  CancionesGuardadasTableViewController.swift
//  Buscador de letras
//
//  Created by Angel Olvera on 2/23/19.
//  Copyright © 2019 Angel Olvera. All rights reserved.
//

import UIKit
import CoreData
/**
 CancionesGuardadasTableViewController lee los registros almacenados en CoreData y los despliega en un TableView
 */
class CancionesGuardadasTableViewController: UITableViewController {
    
    var listaCanciones = [Canciones]()
    
    /**
     se hace la conexion con CoreDAta
 */
    func conexion()-> NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.persistentContainer.viewContext
    }
    
    /**
     almacena los datos en una variable de tipo NSFetchRequest, en caso de que no se pueda guardar imprime un error en consola.
 */
    func mostrarDatos() {
        let contexto = conexion()
        let fetchRequest : NSFetchRequest<Canciones> = Canciones.fetchRequest()
        do {
            listaCanciones = try contexto.fetch(fetchRequest)
        } catch let error as NSError {
            print("error al mostrar datos", error.localizedDescription)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mostrarDatos()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listaCanciones.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let song = listaCanciones[indexPath.row]
        cell.textLabel?.text = song.titulo
        cell.detailTextLabel?.text = song.grupo
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    /**
     Si el usuario borra una fila, tambien borrara los registros
 */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let contexto = conexion()
        let song = listaCanciones[indexPath.row]
        if editingStyle == .delete {
            contexto.delete(song)
            do{
                try contexto.save()
            }catch let error as NSError {
                print("error al mostrar al eliminar", error.localizedDescription)
            }
            mostrarDatos()
            tableView.reloadData()
//            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "letrasTablas", sender: self)
    }
    /**
     aqui se colocan los valores que desean ser enviados a la siguiente vista
 */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "letrasTablas"{
            if let id = tableView.indexPathForSelectedRow{
                let fila = listaCanciones[id.row]
                let nuevo = "no"
                let destino = segue.destination as! mostrarCancion
                destino.artista = fila.grupo!
                destino.titulo = fila.titulo!
                destino.nuevo = nuevo
            }
        }
    }
    

}
