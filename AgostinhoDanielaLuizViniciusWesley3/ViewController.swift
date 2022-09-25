//
//  ViewController.swift
//  AgostinhoDanielaLuizViniciusWesley3
//
//  Created by Agostinho José Schlindwein on 25/09/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func gotoMainScreen(_ sender: Any) {
        if let listTableViewController = storyboard?.instantiateViewController(withIdentifier: "ListTableViewController") {
            show(listTableViewController, sender: nil)
        }
    }
}

