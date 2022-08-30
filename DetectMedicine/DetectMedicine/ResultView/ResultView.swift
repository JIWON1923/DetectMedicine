//
//  ResultView.swift
//  DetectMedicine
//
//  Created by 이지원 on 2022/08/30.
//

import UIKit

class ResultView: UIView {
    
    //components
    let resultLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "description\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\ndescription\n"
        return label
    }()
    
    // initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // setupLayout
    func setupView() {
        layer.cornerRadius = 10
        backgroundColor = .white
        addSubview(resultLabel)
        
        NSLayoutConstraint.activate([
            resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
            resultLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            resultLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
        
    }
}
