//
//  CustomCell.swift
//  Plan
//
//  Created by Seth Ledford on 7/21/22.
//

import UIKit

class CustomCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var entryView: UIView!
    @IBOutlet weak var entryTextView: UITextView!
    var callback: ((String) -> ())?
    var callback2: (() -> ())?

    override func didMoveToSuperview() {
            super.didMoveToSuperview()
            // make sure scroll is disabled
            entryTextView.isScrollEnabled = false
            // make sure delegate is set
            entryTextView.delegate = self
            // if these are set in Storyboard this func is not needed
        }
    
    func textViewDidChange(_ textView: UITextView) {
        let str = entryTextView.text ?? ""
        // tell the controller
        callback?(str)
    }
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool{
        callback2?()
        return false;
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
