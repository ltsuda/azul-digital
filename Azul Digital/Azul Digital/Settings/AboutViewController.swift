//
//  AboutViewController.swift
//  Azul Digital
//
//  Created by Leonardo Tsuda on 08/10/16.
//  Copyright © 2016 Leonardo Tsuda. All rights reserved.
//

import UIKit
import SafariServices

class AboutViewController: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var cassioLabel: UILabel!
    @IBOutlet weak var jaquelineLabel: UILabel!
    @IBOutlet weak var leonardoLabel: UILabel!
    @IBOutlet weak var muriloLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var andersonLabel: UILabel!
    @IBOutlet weak var siteButton: UIButton!
    @IBOutlet weak var siteLabel: UILabel!
    @IBAction func site(_ sender: Any) {
        let safariViewController = SFSafariViewController(url: URL(string: "https://ltsuda.github.io/azul-digital")!)
        safariViewController.delegate = self
        present(safariViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = Project.Localizable.Common.about.localized
        navigationController?.navigationBar.barTintColor = UIColor(red: 15/255, green: 223/255, blue: 129/255, alpha: 1)
        authorLabel.text = Project.Localizable.Common.author.localized
        cassioLabel.text = "Cásso Otávio F. P. Castilho"
        jaquelineLabel.text = "Jaqueline Campaci Silva"
        leonardoLabel.text = "Leonardo Henrique Tsuda"
        muriloLabel.text = "Murilo Natã Komirchuk"
        teacherLabel.text = Project.Localizable.Common.instructor.localized
        andersonLabel.text = "Anderson Rocha"
        siteLabel.text = "Site:"
        siteButton.setTitle("azuldigital.github.io", for: .normal)
        siteButton.backgroundColor = .clear
        
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
