//
//  ContatosViewController.swift
//  WhatsApp
//
//  Created by Leonardo Natal da Silva on 14/11/19.
//  Copyright © 2019 Natal. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class ContatosViewController:
    UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableViewContatos: UITableView!
    var usuarios: [Usuario] = []
    var armazenamento: StorageReference!
    var database: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.armazenamento = Storage.storage().reference()
        self.database = Database.database().reference()
        
        
        tableViewContatos.separatorStyle = .none
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.usuarios = []
        
        self.recuperarUsuarios()
    }
    
    // metodos para listagem na tabela
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaContatos", for: indexPath) as! ContatoTableViewCell
        
        let usuarioRecuperado = self.usuarios[indexPath.row]
        
        celula.nomeLabel.text = usuarioRecuperado.nome
        celula.nomeLabel.text = usuarioRecuperado.email
        celula.fotoImageView.image = UIImage(named: "padrao")
        
        let imagensPerfil = self.armazenamento.child("imagens")
        if let nomeIMagem = usuarioRecuperado.foto {
            let localImagem = imagensPerfil.child("perfil").child(nomeIMagem)
            
            localImagem.downloadURL { (URL, erro) in
                
                let url = URL?.absoluteURL
                celula.fotoImageView.sd_setImage(with: url) { (image, erro, cache, url) in
                    if erro == nil {
                        print("sucesso ao carregar img")
                    }else {
                        print("erro ao caregar img")
                    }
                }
            }
        }
        
        
        return celula
    }
    
    func recuperarUsuarios() {
        
        let usuariosDB = self.database.child("usuarios")
        
        usuariosDB.queryOrdered(byChild: "nome").observe(.childAdded) { (snapshot) in
            
            let dados = snapshot.value as? NSDictionary
            
            let nome = dados!["nome"] as! String
            let email = dados!["email"] as! String
            
            
            let usuarioContato = Usuario(nome: nome, email: email)
            
            if snapshot.hasChild("foto") {
                let foto  = dados!["foto"] as! String
                usuarioContato.foto = foto
            }
            
        
            self.usuarios.append(usuarioContato)
            
            self.tableViewContatos.reloadData()
            
            
        }
        
    }
    


}
