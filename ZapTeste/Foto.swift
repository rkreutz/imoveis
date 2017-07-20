//
//  Foto.swift
//  ZapTeste
//
//  Created by Rodrigo Kreutz on 9/4/16.
//  Copyright © 2016 Rodrigo Kreutz. All rights reserved.
//

import UIKit

class Foto: NSObject {
    
    var urlImagem: String = ""
    var principal: Bool = false
    var descricao: String = ""
    var origem: String = ""
    var codImobiliaria: Int = 0
    
    init(dictionary: NSDictionary?) {
        super.init()
        
        if let dictionary = dictionary {
            if let urlImagem = dictionary["UrlImagem"] as? String {
                self.urlImagem = urlImagem
            }
            
            if let principal = dictionary["Principal"] as? Bool {
                self.principal = principal
            }
            
            if let descricao = dictionary["Descricao"] as? String {
                self.descricao = descricao
            }
            
            if let origem = dictionary["Origem"] as? String {
                self.origem = origem
            }
            
            if let codImobiliaria = dictionary["CodImobiliaria"] as? Int {
                self.codImobiliaria = codImobiliaria
            }
        }
    }
    
}
