//
//  FirstPageViewController.swift
//  DetectMedicine
//
//  Created by 이지원 on 2022/09/01.
//

import UIKit

class FirstPageViewController: UIViewController {
    
    let appInformation = "약 상자를 촬영하면, 결과를 알려드립니다. 이약머약은 어떠한 정보도 수집하지 않습니다. 하면 화단에 있는 촬영하기 버튼을 통해 약을 인식해보세요. 준비가 되셨다면, 화면 하단에 있는 시작하기 버튼을 눌러보세요."

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var descriptions: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = 35
        descriptions.accessibilityLabel = appInformation
    }
    
    @IBAction func didTapStartButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
        UserDefaults.standard.set("False", forKey: "isFirst")
    }
}
