//
//  ViewController.swift
//  PhotoChooser
//
//  Created by Harut Mikichyan on 10/22/19.
//  Copyright © 2019 Harut Mikichyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func presentPhotChooserViewController(_ sender: UIButton) {
        let photoChooserVC = PhotoChooserViewController()
        photoChooserVC.modalPresentationStyle = .fullScreen
        present(photoChooserVC, animated: true, completion: nil)
    }
}

