//
//  CustomCell.swift
//  Plan
//
//  Created by Seth Ledford on 7/20/22.
//

import Foundation
import UIKit

class CustomCell: UITableViewCell{
    
    var text : String?
    
    var txtView : UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(txtView)
        
        txtView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        txtView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        txtView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        txtView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        // txtView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let text = text {
            txtView.text = text
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

