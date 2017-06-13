//
//  TodasViewController.swift
//  Quiero Mas
//
//  Created by Fernando N. Frassia on 5/15/17.
//  Copyright © 2017 Fernando N. Frassia. All rights reserved.
//

import UIKit
import SWRevealViewController

class TodasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var revealMenuButton: UIBarButtonItem!
    @IBOutlet weak var orangeView: UIView!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRevealMenuButton()
        setAppMainColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = appMainColor
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
    
    
    //MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodasTableViewCell", for: indexPath) as! TodasTableViewCell
        
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
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "RecetaViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}