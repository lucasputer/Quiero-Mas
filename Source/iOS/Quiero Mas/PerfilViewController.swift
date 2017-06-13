//
//  PerfilViewController.swift
//  Quiero Mas
//
//  Created by Fernando N. Frassia on 5/24/17.
//  Copyright © 2017 Fernando N. Frassia. All rights reserved.
//

import UIKit
import SWRevealViewController
import Firebase

class PerfilViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var revealMenuButton: UIBarButtonItem!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var editOrSaveButton: UIButton!
    
    var profileDic: [String:[String:String]]?
    var profileIsEditing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRevealMenuButton()
        setTable()
        setObservers()
        FirebaseAPI.getDatosPerfil()
    }
    
    func setRevealMenuButton() {
        revealMenuButton.target = self.revealViewController()
        revealMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func setTable() {
        table.register(UINib(nibName: "PerfilStaticTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PerfilStaticTableViewCell")
        table.register(UINib(nibName: "PerfilEditableTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PerfilEditableTableViewCell")
    }
    
    func setObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadPerfil), name: NSNotification.Name(rawValue: perfilLoaded), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadPerfil), name: NSNotification.Name(rawValue: perfilUpdated), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.connectionAlert), name: NSNotification.Name(rawValue: connectionError), object: nil)
    }
    
    func loadPerfil() {
        if let storedDic = UserDefaults.standard.dictionary(forKey: "perfil") as? [String:[String:String]] {
            profileDic = storedDic
        }
        table.reloadData()
        spinner.stopAnimating()
    }
    
    func reloadPerfil() {
        showAlert(text: "Los cambios se guardaron correctamente")
    }
    
    func connectionAlert() {
        spinner.stopAnimating()
        showAlert(text: "Error de conexión")
    }
    
    func showAlert(text: String) {
        let alert = UIAlertController(title: "",
                                      message: text,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        return
    }
    
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if profileIsEditing {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PerfilEditableTableViewCell") as! PerfilEditableTableViewCell
            
            var titleString = ""
            switch indexPath.row {
            case 0:
                titleString = "TU NOMBRE"
            case 1:
                titleString = "TU EMAIL"
            case 2:
                titleString = "TU FECHA DE NACIMIENTO"
            case 3:
                titleString = "EL NOMBRE DE TU BEBÉ"
            case 4:
                titleString = "¿CÓMO LE DICEN?"
            case 5:
                titleString = "FECHA DE NACIMIENTO DE TU BEBÉ"
            default:
                titleString = ""
            }
            cell.titleProfile.text = titleString
            
            var descriptionString = "-"
            if profileDic != nil {
                switch indexPath.row {
                case 0:
                    if profileDic?["Datos"] != nil {
                        let datos = profileDic?["Datos"]
                        if datos?["Nombre Completo"] != nil {
                            descriptionString = (datos?["Nombre Completo"])!
                        }
                    }
                case 1:
                    if profileDic?["Datos"] != nil {
                        let datos = profileDic?["Datos"]
                        if datos?["Email"] != nil {
                            descriptionString = (datos?["Email"])!
                        }
                    }
                case 2:
                    if profileDic?["Datos"] != nil {
                        let datos = profileDic?["Datos"]
                        if datos?["Fecha de Nacimiento"] != nil {
                            descriptionString = (datos?["Fecha de Nacimiento"])!
                        }
                    }
                case 3:
                    if profileDic?["Bebé"] != nil {
                        let bebe = profileDic?["Bebé"]
                        if bebe?["Nombre"] != nil {
                            descriptionString = (bebe?["Nombre"])!
                        }
                    }
                case 4:
                    if profileDic?["Bebé"] != nil {
                        let bebe = profileDic?["Bebé"]
                        if bebe?["Apodo"] != nil {
                            descriptionString = (bebe?["Apodo"])!
                        }
                    }
                case 5:
                    if profileDic?["Bebé"] != nil {
                        let bebe = profileDic?["Bebé"]
                        if bebe?["Fecha de Nacimiento"] != nil {
                            descriptionString = (bebe?["Fecha de Nacimiento"])!
                        }
                    }
                default:
                    descriptionString = "-"
                }
            }
            cell.descriptionProfile.placeholder = descriptionString
            cell.descriptionProfile.delegate = self
            cell.descriptionProfile.tag = indexPath.row
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PerfilStaticTableViewCell") as! PerfilStaticTableViewCell
            
            var titleString = ""
            switch indexPath.row {
            case 0:
                titleString = "TU NOMBRE"
            case 1:
                titleString = "TU EMAIL"
            case 2:
                titleString = "TU FECHA DE NACIMIENTO"
            case 3:
                titleString = "EL NOMBRE DE TU BEBÉ"
            case 4:
                titleString = "¿CÓMO LE DICEN?"
            case 5:
                titleString = "FECHA DE NACIMIENTO DE TU BEBÉ"
            default:
                titleString = ""
            }
            cell.titleProfile.text = titleString
            
            var descriptionString = "-"
            if profileDic != nil {
                switch indexPath.row {
                case 0:
                    if profileDic?["Datos"] != nil {
                        let datos = profileDic?["Datos"]
                        if datos?["Nombre Completo"] != nil {
                            descriptionString = (datos?["Nombre Completo"])!
                        }
                    }
                case 1:
                    if profileDic?["Datos"] != nil {
                        let datos = profileDic?["Datos"]
                        if datos?["Email"] != nil {
                            descriptionString = (datos?["Email"])!
                        }
                    }
                case 2:
                    if profileDic?["Datos"] != nil {
                        let datos = profileDic?["Datos"]
                        if datos?["Fecha de Nacimiento"] != nil {
                            descriptionString = (datos?["Fecha de Nacimiento"])!
                        }
                    }
                case 3:
                    if profileDic?["Bebé"] != nil {
                        let bebe = profileDic?["Bebé"]
                        if bebe?["Nombre"] != nil {
                            descriptionString = (bebe?["Nombre"])!
                        }
                    }
                case 4:
                    if profileDic?["Bebé"] != nil {
                        let bebe = profileDic?["Bebé"]
                        if bebe?["Apodo"] != nil {
                            descriptionString = (bebe?["Apodo"])!
                        }
                    }
                case 5:
                    if profileDic?["Bebé"] != nil {
                        let bebe = profileDic?["Bebé"]
                        if bebe?["Fecha de Nacimiento"] != nil {
                            descriptionString = (bebe?["Fecha de Nacimiento"])!
                        }
                    }
                default:
                    descriptionString = "-"
                }
            }
            cell.descriptionProfile.text = descriptionString
            
            return cell
        }
    }
    
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return profileIsEditing ? 90 : 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
    
    //MARK: - IBAction
    @IBAction func editOrSave(_ sender: Any) {
        if profileIsEditing {
            if profileDic != nil {
                let user = FIRAuth.auth()?.currentUser
                guard let firebaseID = user?.uid else {return}
                if (profileDic?["Bebé"]?["Nombre"] == "" ||
                    profileDic?["Bebé"]?["Apodo"] == "" ||
                    profileDic?["Bebé"]?["Fecha de Nacimiento"] == "") &&
                    !(profileDic?["Bebé"]?["Nombre"] == "" &&
                    profileDic?["Bebé"]?["Apodo"] == "" &&
                    profileDic?["Bebé"]?["Fecha de Nacimiento"] == "") {
                    showAlert(text: "Todos los campos del bebé deben llenarse")
                }
                FirebaseAPI.storeFirebaseUser(firebaseID: firebaseID,
                                              name: profileDic?["Datos"]?["Nombre Completo"],
                                              birthday: profileDic?["Datos"]?["Fecha de Nacimiento"],
                                              email: profileDic?["Datos"]?["Email"],
                                              babyName: profileDic?["Bebé"]?["Nombre"],
                                              babyNickName: profileDic?["Bebé"]?["Apodo"],
                                              babyBirthday: profileDic?["Bebé"]?["Fecha de Nacimiento"])
                showAlert(text: "Los cambios se guardaron exitosamente")
            }
            editOrSaveButton.setTitle("Editar", for: .normal)
        } else {
            editOrSaveButton.setTitle("Guardar cambios", for: .normal)
        }
        profileIsEditing = !profileIsEditing
        table.reloadData()
        table.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
    }
    

    //MARK: - UITextfieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        table.scrollToRow(at: IndexPath(row: textField.tag, section: 0), at: .top, animated: true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            profileDic?["Datos"]?["Nombre Completo"] = textField.text
        case 1:
            profileDic?["Datos"]?["Email"] = textField.text
        case 2:
            profileDic?["Datos"]?["Fecha de Nacimiento"] = textField.text
        case 3:
            if textField.text == "" {
                profileDic?["Bebé"]?.removeValue(forKey: "Nombre")
            } else {
                if profileDic?["Bebé"] == nil {profileDic?["Bebé"] = [String:String]()}
                profileDic?["Bebé"]?["Nombre"] = textField.text
            }
        case 4:
            if textField.text == "" {
                profileDic?["Bebé"]?.removeValue(forKey: "Apodo")
            } else {
                if profileDic?["Bebé"] == nil {profileDic?["Bebé"] = [String:String]()}
                profileDic?["Bebé"]?["Apodo"] = textField.text
            }
        case 5:
            if textField.text == "" {
                profileDic?["Bebé"]?.removeValue(forKey: "Fecha de Nacimiento")
            } else {
                if profileDic?["Bebé"] == nil {profileDic?["Bebé"] = [String:String]()}
                profileDic?["Bebé"]?["Fecha de Nacimiento"] = textField.text
            }
        default:
            print("")
        }
        
        if profileDic?["Bebé"]?.count == 0 {
            profileDic?.removeValue(forKey: "Bebé")
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    
    
    
    
    
    
    
    
    
    

}
