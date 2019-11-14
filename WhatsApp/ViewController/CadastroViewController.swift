//
//  CadastroViewController.swift
//  WhatsApp
//
//  Created by Leonardo Natal da Silva on 09/11/19.
//  Copyright © 2019 Natal. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class CadastroViewController: UIViewController {

    @IBOutlet weak var campoNome: UITextField!
    
    @IBOutlet weak var campoEmail: UITextField!
    
    @IBOutlet weak var campoSenha: UITextField!
    
    var auth: Auth!
    var database: Database!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.auth = Auth.auth()
        self.database = Database.database()
    }
    
    @IBAction func cadastrar(_ sender: Any) {
        
        //Validar Campos
        if let nome = self.campoNome.text {
            if let email = self.campoEmail.text {
                if let senha = self.campoSenha.text {
                    
                    self.auth.createUser(withEmail: email, password: senha) { (usuario, erro) in
                        
                        if erro == nil {
                            
                            //Config dados do usuario
                            var usuario: Dictionary<String, String> = [:]
                            
                            usuario["nome"] = nome
                            usuario["email"] = email
                            
                            //Converter para base 64 email
                            let chave = Base64().codificarStringBase64(texto: email)
                            
                            let usuarios =
                                self.database.reference().child("usuarios")
                            
                            usuarios.child(chave).setValue(usuario)
                            
                            print("sucesso")
                        }else {
                            print("Erro ao cadastrar usu")
                        }
                    }
                    
                }else {
                    print("Digite uma senha")
                }
            }else {
                print("Digite seu email")
            }
        }else {
            print("Digite seu nome")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
