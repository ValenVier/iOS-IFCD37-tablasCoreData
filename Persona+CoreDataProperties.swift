//
//  Persona+CoreDataProperties.swift
//  tablasCoreData
//
//  Created by Javier Rodríguez Valentín on 29/09/2021.
//
//

import Foundation
import CoreData


extension Persona {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Persona> {
        return NSFetchRequest<Persona>(entityName: "Persona")
    }

    @NSManaged public var nombre: String?

}

extension Persona : Identifiable {

}
