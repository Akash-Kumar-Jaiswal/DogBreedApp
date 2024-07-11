//
//  SeeAllBreedViewController.swift
//  DogBreedApp
//
//  Created by Apple on 10/07/24.
//

import UIKit

class SeeAllBreedViewController: UIViewController {

    @IBOutlet weak var collectionViewForBreed: UICollectionView!
    
    var imageString = ""
    var urlImage = ""
    private let userViewModel = UserViewModel()
    var breedImages = [String]()
    var doggies = [Dogs]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        userViewModel.userViewModelDelegate = self
        self.loadApiData()
        self.registerCell()
        self.loadApiData()
    }
    
    func loadApiData(){
        self.title = "\(imageString.capitalized) Breed"
        self.urlImage = "\(Api_Url.BASE_URL)breed/\(imageString)/images"
        userViewModel.allBreedImage(apiUrl: self.urlImage)
    }

}

//MARK:- Task update related to core data
extension SeeAllBreedViewController{
    func getchAllFavouiteDogs(){
        guard let dogs = CoreDataManager.sharedManager.fetchAllDogs() else { self.collectionViewForBreed.reloadData()
            return}
        self.doggies = dogs
        self.collectionViewForBreed.reloadData()
    }
    
    //insert
    func makeFavourite(name: String, url : String, breed: String, isFavourite: Bool) {
        _ = CoreDataManager.sharedManager.insertDog(name: name, breed: name, url: url, isFavourite: isFavourite)
    }
    
    func makeUnFavourite(url : String) {
      let dog = CoreDataManager.sharedManager.delete(url: url)
        if dog?.count != 0 {
            self.getchAllFavouiteDogs()
        }
    }
}


extension SeeAllBreedViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @objc func actionONLikeDislike(sender:UIButton){
        let imageUrl = self.breedImages[sender.tag]
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.makeFavourite(name: imageString, url: imageUrl, breed: imageString, isFavourite: true)
        } else {
            self.makeUnFavourite(url: imageUrl)
        }
    }
    
    func makeLikeStatusChange(cell: BreedImageCell, imageUrl: String){
        let searchPredicate = NSPredicate(format: "url CONTAINS[C] %@", imageUrl)
        let array = (doggies as NSArray).filtered(using: searchPredicate)
        if(array.count == 0){
            cell.likeUnlikeBtn.isSelected = false;
        } else {
            cell.likeUnlikeBtn.isSelected = true;
        }
    }
    
    func registerCell(){
        self.collectionViewForBreed.register(UINib(nibName: TableViewCells.BreedImageCell.rawValue, bundle: nil), forCellWithReuseIdentifier: TableViewCells.BreedImageCell.rawValue)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 700)
        collectionViewForBreed.collectionViewLayout = layout
        collectionViewForBreed.dataSource = self
        collectionViewForBreed.delegate = self
        collectionViewForBreed.showsVerticalScrollIndicator = false
        collectionViewForBreed.backgroundColor = UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.breedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionViewForBreed.dequeueReusableCell(withReuseIdentifier: TableViewCells.BreedImageCell.rawValue, for: indexPath) as! BreedImageCell
        if self.breedImages.count != 0 {
            let imgUrl = self.breedImages[indexPath.item]
            if let getUrl = URL(string: imgUrl)  {
                cell.image.load(url: getUrl)
            }
            self.makeLikeStatusChange(cell: cell, imageUrl: imgUrl)
        }
        cell.likeUnlikeBtn.addTarget(self, action: #selector(actionONLikeDislike(sender: )), for: .touchUpInside)
        cell.likeUnlikeBtn.tag = indexPath.item
        cell.likeUnlikeBtn.layer.cornerRadius = 17.5
        cell.likeUnlikeBtn.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? BreedImageCell {
            cell.layoutIfNeeded()
            cell.layoutSubviews()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: (self.collectionViewForBreed.frame.width-20)/3, height: (self.collectionViewForBreed.frame.width-20)/3)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}

extension SeeAllBreedViewController: UserViewModelDelegate {
    // Handle user data after loading
    func userList(status: ReqStatus, userModel: AllBreedImageModel?, err: Error?) {
        switch status {
        case ReqStatus.START:
            break
        case ReqStatus.SUCCESS:
            DispatchQueue.main.async {
                if let mData = userModel?.message {
                    print(mData)
                    DispatchQueue.main.async {
                        self.breedImages = mData
                        self.getchAllFavouiteDogs()
                    }
                }
            }
            break
            
        case ReqStatus.ERROR:
            break
        }
    }
}
