//
//  TodasViewController.swift
//  Quiero Mas
//
//  Created by Fernando N. Frassia on 5/15/17.
//  Copyright © 2017 Fernando N. Frassia. All rights reserved.
//

import UIKit
import SWRevealViewController

class TodasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var revealMenuButton: UIBarButtonItem!
    @IBOutlet weak var orangeView: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var recetaTF: UITextField!
    @IBOutlet weak var ingredienteTF: UITextField!
    
    var recetasArray: [[String:[String:Any]]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRevealMenuButton()
        setAppMainColor()
        addTapKeyboardDismiss()
    }
    
    func addTapKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.cancelsTouchesInView = false
        orangeView.addGestureRecognizer(tap)
    }
    
    func endEditing() {
        recetaTF.resignFirstResponder()
        ingredienteTF.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Plan de nutrición"
        self.navigationController?.navigationBar.backgroundColor = appMainColor
        reloadRecetas()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadRecetas), name: NSNotification.Name(rawValue: recetasUpdated), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    func setRevealMenuButton() {
        revealMenuButton.target = self.revealViewController()
        revealMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func setAppMainColor() {
        orangeView.backgroundColor = appMainColor
    }
    
    func reloadRecetas() {
        loadRecetasArray()
        reloadTable()
    }
    
    func loadRecetasArray() {
        if let recetasDic = UserDefaults.standard.dictionary(forKey: defRecetas) {
            if let porNombreDic = recetasDic[firPorNombre] as? [String:Any] {
                recetasArray = porNombreDic.toArray() as? [[String:[String:Any]]]
            }
        }
    }
    
    func reloadTable() {
        if recetasArray != nil {
            table.reloadData()
            spinner.stopAnimating()
        }
    }
    
    
    //MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        var sections = 0
        if recetasArray != nil {
            sections = recetasArray!.count
        }
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodasTableViewCell", for: indexPath) as! TodasTableViewCell
        
        if let receta = recetasArray?[indexPath.section] {
            for (key, element) in receta {
                cell.recetaName.text = key
                if let thumbnail = element["Thumbnail"] as? String {
                    cell.recetaImg.sd_setImage(with: URL(string:thumbnail), placeholderImage: UIImage(named: "Thumbnail Receta"))
                }
                if FirebaseAPI.isRecetaFavorite(name: key) {
                    cell.recetaFav.imageView?.image = UIImage(named: "Favorito Lleno")
                } else {
                    cell.recetaFav.imageView?.image = UIImage(named: "Favorito Vacio")
                }
                cell.recetaFav.tag = indexPath.section
                cell.recetaFav.addTarget(self, action: #selector(favUnfav(_:)), for: .touchUpInside)
            }
        }
    
        return cell
    }
    
    
    //MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let hView = UIView()
        hView.backgroundColor = .white
        return hView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let receta = recetasArray?[indexPath.section] {
            let story = UIStoryboard(name: "Main", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "RecetaViewController") as! RecetaViewController
            for (key, element) in receta {
                vc.recetaNombre = key
                vc.recetaDict = element
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - IBAction
    @IBAction func favUnfav(_ sender: UIButton) {
        if let receta = recetasArray?[sender.tag] {
            for (key, _) in receta {
                FirebaseAPI.favUnfavReceta(name: key)
                table.reloadData()
            }
        }
    }
    
    @IBAction func filtrarRecetas(_ sender: UIButton) {
        loadRecetasArray()
        view.endEditing(true)
        guard recetasArray != nil else {return}
        var i = 0
        var recetasFiltered = [[String:[String:Any]]]()
        while i < recetasArray!.count {
            let receta = recetasArray![i]
            for (_, element) in receta {
                if agregarPorNombre(receta: element) || agregarPorIngrediente(receta: element) {
                    recetasFiltered.append(receta)
                }
            }
            i += 1
        }
        
        if recetasFiltered.count > 0 {
            recetasArray = recetasFiltered
        }   else if recetaTF.text != "" || ingredienteTF.text != "" {
            showAlert(text: "No se encontraron recetas para esta búsqueda")
        }
        table.reloadData()
    }
    
    
    //MARK: - Aux
    func agregarPorNombre(receta: [String:Any]) -> Bool {
        if let recetaNombre = receta[firRecetaNombre] as? String {
            return recetaNombre.lowercased().range(of: recetaTF.text!) != nil
        }
        return false
    }
    
    func agregarPorIngrediente(receta: [String:Any]) -> Bool {
        if let ingredientes = receta[firRecetaIngredientes] as? [[String:String]] {
            for ingrediente in ingredientes {
                if ingrediente[firRecetaIngredientesNombre]!.lowercased().range(of:ingredienteTF.text!) != nil {
                    return true
                }
            }
        }
        return false
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
    
    
    //MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    
    
    
    
    
    
    
}
