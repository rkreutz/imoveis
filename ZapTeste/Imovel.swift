//
//  Imoveis.swift
//  ZapTeste
//
//  Created by Rodrigo Kreutz on 9/4/16.
//  Copyright © 2016 Rodrigo Kreutz. All rights reserved.
//

import UIKit

class Imovel: NSObject {
    
    var codImovel: Int = 0
    var tipoImovel: String = ""
    var endereco: Endereco = Endereco(dictionary: nil)
    var precoVenda: Double? = nil
    var precoLocacao: Double? = nil
    var fotos: [Foto] = []
    var subtipoImovel: String = ""
    var zapID: String = ""

    init(dictionary: NSDictionary?) {
        super.init()
        
        if let dictionary = dictionary {
            if let codImovel = dictionary["CodImovel"] as? Int {
                self.codImovel = codImovel
            }
            
            if let tipoImovel = dictionary["TipoImovel"] as? String {
                self.tipoImovel = tipoImovel
            }
            
            if let endereco = dictionary["Endereco"] as? NSDictionary {
                self.endereco = Endereco(dictionary: endereco)
            }
            
            if let precoVenda = dictionary["PrecoVenda"] as? Double {
                self.precoVenda = precoVenda
            }
            
            if let precoLocacao = dictionary["PrecoLocacao"] as? Double {
                self.precoLocacao = precoLocacao
            }
            
            if let fotos = dictionary["Fotos"] as? [NSDictionary] {
                for foto in fotos {
                    self.fotos.append(Foto(dictionary: foto))
                }
            }
            
            if let subtipoImovel = dictionary["SubtipoImovel"] as? String {
                self.subtipoImovel = subtipoImovel
            }
            
            if let zapID = dictionary["ZapID"] as? String {
                self.zapID = zapID
            }
        }
    }
    
}
