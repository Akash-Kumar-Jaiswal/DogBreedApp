//
//  FavouriteViewController.swift
//  DogBreedApp
//
//  Created by Apple on 10/07/24.
//

import UIKit

class FavouriteViewController: UIViewController {
    
    
    @IBOutlet weak var collectionViewFavourite: UICollectionView!
    @IBOutlet weak var emptyMessage: UILabel!
    
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
    var pickerCountTapped = 0
    var doggies = [Dogs]()
    var tempDogies = [Dogs]()
    var dogsBreeds = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Text.AllBreed.rawValue
        self.dogsBreeds.insert(Text.SeeAll.rawValue, at: 0)
        self.emptyMessage.isHidden = true
        self.registerCell()
        self.getchAllFavouiteDogs()
        self.createRightBarButton()
    }
    
    func setupForPicker(){
        picker = UIPickerView.init()
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: Text.TextColor.rawValue)
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.items = [UIBarButtonItem.init(title: Text.Done.rawValue, style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
    }
    
    @objc func onDoneButtonTapped() {
        self.doggies.removeAll()
        self.doggies = self.tempDogies
        toolBar.removeFromSuperview()
        print(picker.selectedRow(inComponent: 0))
        let selectedIndex = picker.selectedRow(inComponent: 0)
        let breebName = self.dogsBreeds[selectedIndex]
        self.title = breebName.capitalized
        if selectedIndex != 0 {
            self.soredBasisOfBreed(breedName: breebName)
        } else {
            self.collectionViewFavourite.reloadData()
            collectionViewFavourite.isHidden = false
            emptyMessage.isHidden = true
        }
        picker.removeFromSuperview()
        self.pickerCountTapped = 0
    }
    
    func createRightBarButton(){
        let rightButtonItem = UIBarButtonItem.init(
            title: Text.Filter.rawValue,
            style: .done,
            target: self,
            action: #selector(rightButtonAction(sender: ))
        )
        self.navigationItem.rightBarButtonItem = rightButtonItem
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.orange
    }
    
    @objc func rightButtonAction(sender: UIBarButtonItem){
        
        if self.pickerCountTapped >= 1{
            toolBar.removeFromSuperview()
            picker.removeFromSuperview()
            self.pickerCountTapped = 0
            return
        }
        self.setupForPicker()
        self.pickerCountTapped = self.pickerCountTapped+1
    }
    
    
    func getchAllFavouiteDogs(){
        guard let dogs = CoreDataManager.sharedManager.fetchAllDogs() else {return}
        self.doggies = dogs
        self.tempDogies = dogs
        if self.doggies.count != 0 {
            self.collectionViewFavourite.reloadData()
            self.collectionViewFavourite.isHidden = false
            self.emptyMessage.isHidden = true
        } else {
            self.collectionViewFavourite.isHidden = true
            self.emptyMessage.isHidden = false
        }
    }
    
}

extension FavouriteViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func registerCell(){
        self.collectionViewFavourite.register(UINib(nibName: TableViewCells.BreedImageCell.rawValue, bundle: nil), forCellWithReuseIdentifier: TableViewCells.BreedImageCell.rawValue)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 700)
        collectionViewFavourite.collectionViewLayout = layout
        collectionViewFavourite.dataSource = self
        collectionViewFavourite.delegate = self
        collectionViewFavourite.showsVerticalScrollIndicator = false
        collectionViewFavourite.backgroundColor = UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.doggies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionViewFavourite.dequeueReusableCell(withReuseIdentifier: TableViewCells.BreedImageCell.rawValue, for: indexPath) as! BreedImageCell
        if self.doggies.count != 0 {
            let imgUrl = self.doggies[indexPath.item].value(forKey: "url")
            if let getUrl = URL(string: imgUrl as! String)  {
                cell.image.load(url: getUrl)
            }
        }
        cell.likeUnlikeBtn.isSelected = true
        cell.likeUnlikeBtn.layer.cornerRadius = 17.5
        cell.likeUnlikeBtn.clipsToBounds = true
        cell.likeUnlikeBtn.isUserInteractionEnabled = false
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? BreedImageCell {
            cell.layoutIfNeeded()
            cell.layoutSubviews()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: (self.collectionViewFavourite.frame.width-20)/3, height: (self.collectionViewFavourite.frame.width-20)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension FavouriteViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return dogsBreeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dogsBreeds[row].capitalized
    }
    
    func soredBasisOfBreed(breedName: String){
        let searchPredicate = NSPredicate(format: "name CONTAINS[C] %@", breedName)
        let array = (doggies as NSArray).filtered(using: searchPredicate) as! [Dogs]
        self.doggies.removeAll()
        self.doggies = array as [Dogs]
        if self.doggies.count != 0 {
            toolBar.removeFromSuperview()
            print(picker.selectedRow(inComponent: 0))
            picker.removeFromSuperview()
            self.view.endEditing(true)
            self.collectionViewFavourite.isHidden = false
            self.collectionViewFavourite.reloadData()
            self.emptyMessage.isHidden = true
        } else {
            self.collectionViewFavourite.isHidden = true
            self.emptyMessage.isHidden = false
        }
        
    }
}
