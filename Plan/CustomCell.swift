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
    var handleNewDataCB: ((String) -> ())?
    var newLineCB: (() -> ())?

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
        handleNewDataCB?(str)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
      {
          if(text == "\n")
          {
              //entryTextView.endEditing(true)
              newLineCB?()
          }
          return true
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
