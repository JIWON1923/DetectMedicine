//
//  FirstPageViewController.swift
//  DetectMedicine
//
//  Created by 이지원 on 2022/09/01.
//

import UIKit

class FirstPageViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = 35
    }
    
    @IBAction func didTapStartButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
        UserDefaults.standard.set("False", forKey: "isFirst")
    }
}
