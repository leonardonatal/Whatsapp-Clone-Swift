//
//  FirebaseUtil.swift
//  WhatsApp
//
//  Created by Leonardo Natal da Silva on 12/11/19.
//  Copyright © 2019 Natal. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseUtil {
    
    var auth: Auth!
    
    init() {
        self.auth = Auth.auth()
    }
    
    func recuperarChaveUsuarioLogado() -> String {
        
        if self.verificaUsuarioLogado() {
            if let usuarioLogado = self.auth.currentUser {
                if let email = usuarioLogado.email {
                    let chave = Base64().codificarStringBase64(texto: email)
                    return chave
                }
            }
        }
        
        return ""
        
    }
    
    func verificaUsuarioLogado() -> Bool {
        return self.auth.currentUser != nil ? true : false
    }
}
