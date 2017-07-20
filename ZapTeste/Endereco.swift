//
//  Endereco.swift
//  ZapTeste
//
//  Created by Rodrigo Kreutz on 9/4/16.
//  Copyright © 2016 Rodrigo Kreutz. All rights reserved.
//

import UIKit

class Endereco: NSObject {

    var logradouro: String = ""
    var numero: String = ""
    var complemento: String = ""
    var cep: String = ""
    var bairro: String = ""
    var cidade: String = ""
    var estado: String = ""
    
    init(dictionary: NSDictionary?) {
        super.init()
        
        if let dictionary = dictionary {
            if let logradouro = dictionary["Logradouro"] as? String {
                self.logradouro = logradouro
            }
            
            if let numero = dictionary["Numero"] as? String {
                self.numero = numero
            }
            
            if let complemento = dictionary["Complemento"] as? String {
                self.complemento = complemento
            }
            
            if let cep = dictionary["CEP"] as? String {
                self.cep = cep
            }
            
            if let bairro = dictionary["Bairro"] as? String {
                self.bairro = bairro
            }
            
            if let cidade = dictionary["Cidade"] as? String {
                self.cidade = cidade
            }
            
            if let estado = dictionary["Estado"] as? String {
                self.estado = estado
            }
        }
        
    }
    
}
