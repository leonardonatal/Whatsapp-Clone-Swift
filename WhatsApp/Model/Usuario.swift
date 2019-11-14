//
//  Usuario.swift
//  WhatsApp
//
//  Created by Leonardo Natal da Silva on 12/11/19.
//  Copyright © 2019 Natal. All rights reserved.
//

import Foundation

class Usuario {
    
    var nome: String
    var email: String
    var foto: String?
    
    init(nome: String, email: String) {
        self.nome = nome
        self.email = email
    }
    
}
