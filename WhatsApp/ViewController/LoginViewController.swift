//
//  LoginViewController.swift
//  WhatsApp
//
//  Created by Leonardo Natal da Silva on 09/11/19.
//  Copyright © 2019 Natal. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var campoEmail: UITextField!
    
    
    @IBOutlet weak var campoSenha: UITextField!
    
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Login automatico do usuario
        self.auth = Auth.auth()
        
        
        
        //Add ouvinte de usuario autenticado
        self.auth.addStateDidChangeListener { (autenticacao, usuario) in
            if usuario != nil {
                self.performSegue(withIdentifier: "segueLoginAutomatico", sender: nil)
            }
        }
    }
    

    @IBAction func logar(_ sender: Any) {
        
        if let email = self.campoEmail.text {
            if let senha = self.campoSenha.text {
                
                self.auth.signIn(withEmail: email, password: senha) { (usuario, erro) in
                    
                    if erro == nil {
                        
                        if let usuarioLogado = usuario {
                            print("Sucesso ao logar \(usuarioLogado.user.email)")
                        }
                        
                        }else {
                        print("erro ao autenticar")
                    }
                }
                
            }else {
                print("Digite uma senha")
            }
        }else {
            print("Digite um email")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
