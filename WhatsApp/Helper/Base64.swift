//
//  Base64.swift
//  WhatsApp
//
//  Created by Leonardo Natal da Silva on 11/11/19.
//  Copyright © 2019 Natal. All rights reserved.
//

import Foundation

class Base64 {
    
    func codificarStringBase64(texto: String) -> String {
        
        let dados = texto.data(using: String.Encoding.utf8)
        
        let base64 = dados!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        return base64
        
    }
    
}
