//
//  ViewController.swift
//  tablasCoreData
//
//  Created by Javier Rodríguez Valentín on 29/09/2021.
//

import UIKit
import CoreData //hay que importar CoreData

class ViewController: UIViewController {
    //tengo que acceder al context de appDelegate
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //var arrayNames = ["Mario","Javi","Sara","Jorge","Irene","Erika","Elsa"]
    
    var arrayNames:[Persona] = []//opcional por si acaso no tiene datos
    
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var table: UITableView!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView() //para no ver líneas fuera de la tabla
        getData()
        
        input.attributedPlaceholder = NSAttributedString(string: "Escriba su nombre",attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        btn.layer.cornerRadius = 15
        btn.setTitle("Añadir", for: .normal)
        btn.backgroundColor = UIColor(red: 0/255, green: 128/255, blue: 254/255, alpha: 1.0)
        btn.tintColor = .black
        
    }
    
    //MARK: addButton
    @IBAction func btnAdd(_ sender: Any) {
        
        if input.text != "" {
            let newPerson = Persona(context: self.context) //creo una variable newPerson de la clase Persona que tenga las propiedades de Persona
            newPerson.nombre = input.text //igualo la variable al valor del input
            
            //ahora hago un try-catch para comprobar si hay errores y que si los hay no se detenga el programa. si no hay problemas es que ha podido hacer el código de try
            do {
                try self.context.save()
                getData()
                
            } catch {
                //print("Error al añadir un objeto")
                alert(msg: "Error al añadir un objeto")
            }
        }else{
            //print("Error: Valor vacío")
            alert(msg: "Valor vacío")
        }
    }
    
    //MARK: getData
    func getData(){
        
        do {
            self.arrayNames = try context.fetch(Persona.fetchRequest())
            DispatchQueue.main.async {
                //función asíncrona, es mejor hacerlo asíncrona porque así se ejecuta cada vez que se cambia algún dato
                //recargar la tabla
                self.table.reloadData()
            }
        } catch {
            alert(msg: "Error al obtener datos")
            //print("Error al añadir un objeto")
        }
    }
    
    //MARK: Alert
    func alert(msg:String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        
        present(alert, animated: true, completion: {/*Para poner el temporizador, se puede poner nil*/ Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: {_ in
            self.dismiss(animated: true, completion: nil)
        })})
    }
    
}

//MARK: extension dataSource
extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = arrayNames[indexPath.row].nombre
        return cell
    }
}

//MARK: extension delegate
extension ViewController: UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Nos indica el elemento seleccionado
        print("Has seleccionado: \(arrayNames[indexPath.row].nombre ?? "")")
        
        //Para modificar los datos
        //MARK: modificar datos
        //seleccionamos un item a modificar y se lo añadimos a una nueva variable
        let modifyPerson = arrayNames[indexPath.row]
        //creo un alert donde modificaré los datos
        let alert = UIAlertController(title: "Actualizar datos", message: "Elemento a editar", preferredStyle: .alert)
        alert.addTextField() //añado un campo de texto
        let textField = alert.textFields![0] //indico en una nueva variable el campo de texto del alert que voy a usar
        textField.text = modifyPerson.nombre //en el campo de texto me va a sacar la info que he seleccionado a modificar
        let alertButton = UIAlertAction(title: "Cambiar", style: .default){ (action) in //creamos un botón para guardar
            let textField2 = alert.textFields![0]
            modifyPerson.nombre = textField2.text
            do {
                try self.context.save()
                self.getData()
            } catch {
                //print("Error al eliminar un objeto")
                self.alert(msg: "Error al modificar un objeto")
            }
        }
        let cancelButton = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        //para que los botones nos salgan en el orden en que los ponemos debemos poner el style en .default en todos
        
        alert.addAction(alertButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //Selecciona un elemento para borrar. se elimina arrastrando el elemento hacia un lado
    //MARK: eliminar fila
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Eliminar") {_,_,_ in //estas tres variables no las está utilizando asi que no es necesario poner nada pero si es necesario indicarlas
            
            let erasePerson = self.arrayNames[indexPath.row]
            self.context.delete(erasePerson)
            do {
                try self.context.save()
                self.getData()
            } catch {
                //print("Error al eliminar un objeto")
                self.alert(msg: "Error al eliminar un objeto")
            }
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

