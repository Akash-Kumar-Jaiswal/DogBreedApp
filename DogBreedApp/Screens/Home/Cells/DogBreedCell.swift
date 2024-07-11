//
//  DogBridCell.swift
//  DogBreedApp
//
//  Created by Apple on 10/07/24.
//

import UIKit

class DogBreedCell: UITableViewCell {
    
    
    @IBOutlet weak var headingImg: UIImageView!{
        didSet{
            headingImg.layer.cornerRadius = headingImg.frame.height/2
        }
    }
    @IBOutlet weak var breedName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
