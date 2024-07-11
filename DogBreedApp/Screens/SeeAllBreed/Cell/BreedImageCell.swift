//
//  BreedImageCell.swift
//  DogBreedApp
//
//  Created by Apple on 10/07/24.
//

import UIKit

class BreedImageCell: UICollectionViewCell {
    
    
    @IBOutlet weak var likeUnlikeBtn: UIButton!
    
    @IBOutlet weak var image: UIImageView!{
        didSet{
            image.layer.cornerRadius = 5
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
