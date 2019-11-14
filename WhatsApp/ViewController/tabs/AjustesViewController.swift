//
//  AjustesViewController.swift
//  WhatsApp
//
//  Created by Leonardo Natal da Silva on 11/11/19.
//  Copyright © 2019 Natal. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SDWebImage

class AjustesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var email: UILabel!
    
    
    var auth: Auth!
    var armazenamento: Storage!
    var database: DatabaseReference!
    var imagePicker = UIImagePickerController()
    var usuario: Usuario!
    
    @IBAction func alterarImagem(_ sender: Any) {
        
        imagePicker.sourceType = .savedPhotosAlbum
        self.armazenamento = Storage.storage()
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagemRecuperada = info[ UIImagePickerController.InfoKey.originalImage ] as! UIImage
        
        self.imagem.image = imagemRecuperada
        
        //COnfigurar storage
        let imagens = self.armazenamento.reference().child("imagens")
        
        if let imagem = imagemRecuperada.jpegData(compressionQuality: 0.3) {
            
            //Recuperar chave em base64 usuario
            let chave = FirebaseUtil().recuperarChaveUsuarioLogado()
            
            // salvar dados storage
            let nomeImagem = "\(chave).jpg"
            imagens.child("perfil").child(nomeImagem).putData(imagem, metadata: nil) { (metaData, erro) in
                
                if erro == nil {
                    print("Sucesso ao fazer upload")
                }else {
                    print("Erro ao fazer upload")
                }
            }
            
            self.atualizarDadosUsuario(foto: nomeImagem)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func atualizarDadosUsuario(foto: String) {
        
        // recupera ref de usuarios
        let usuarios = self.database.child("usuarios")
        
        let chave = FirebaseUtil().recuperarChaveUsuarioLogado()
        
        let dadosUsuario = [
            "nome": self.usuario?.nome,
            "email": self.usuario?.email,
            "foto": foto
        ]
        
        //salvar dados
        usuarios.child(chave).setValue(dadosUsuario)
        
    }
    
    func recuperaUsuario() {
        let usuarios = self.database.child("usuarios")
        
        let chave = FirebaseUtil().recuperarChaveUsuarioLogado()
        
        let usuarioLogado = usuarios.child(chave)
        usuarioLogado.observeSingleEvent(of: DataEventType.value) { (snapshot) in
            
            let dados = snapshot.value as? NSDictionary
            
            let nome = dados!["nome"] as? String
            let email = dados!["email"] as? String
            
            if self.usuario != nil{
                self.usuario = Usuario(nome: nome!, email: email!)
            }
            
            //exibir nome e e-mail
            self.nome.text = nome
            self.email.text = email
            
            if snapshot.hasChild("foto") {
                
                let foto = dados!["foto"] as? String
                self.usuario?.foto = foto
                
                //config Storage
                let imagens = self.armazenamento.reference().child("imagens")
                let localImagem = imagens.child("perfil").child(foto!)
                
                localImagem.downloadURL { (URL, erro) in
                    
                    let url = URL?.absoluteURL
                    self.imagem.sd_setImage(with: url) { (image, erro, cache, url) in
                        if erro == nil {
                            print("sucesso ao carregar img")
                        }else {
                            print("erro ao caregar img")
                        }
                    }
                }
                
            }
            
            
            
        }
    }
    

    @IBAction func deslogar(_ sender: Any) {
        
        self.auth = Auth.auth()
        
        do {
            try self.auth.signOut()
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("Erro ao deslogar")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        self.armazenamento = Storage.storage()
        self.database = Database.database().reference()
        
        self.imagem.image = UIImage(named: "padrao")
        
        self.recuperaUsuario()
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
