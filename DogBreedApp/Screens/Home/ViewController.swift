//
//  ViewController.swift
//  DogBreedApp
//
//  Created by Apple on 10/07/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet weak var btnFavourite: UIButton!{
        didSet{
            btnFavourite.layer.cornerRadius = 10
            btnFavourite.layer.borderColor = UIColor.red.cgColor
            btnFavourite.layer.borderWidth = 1
        }
    }
    var tempBridArr = [String]()
    private let userViewModel = UserViewModel()
    var dogsBreeds = [String]()
    var dogsImage = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadViewData()
    }
    
    func loadViewData(){
        self.title = Text.HomeTitle.rawValue
        indicator.stopAnimating()
        userViewModel.userViewModelDelegate = self
        userViewModel.userList(apiUrl: Api_Url.breedList)
        self.registerCell()
    }
    
    @IBAction func actionOnFavouritePic(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllers.FavouriteViewController.rawValue) as! FavouriteViewController
        let sortedArray = dogsBreeds.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        vc.dogsBreeds = sortedArray
        self.navigationController?.pushViewController(vc,animated: true)
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    func registerCell(){
        self.tableView.register(UINib(nibName: TableViewCells.DogBreedCell.rawValue, bundle: nil), forCellReuseIdentifier: TableViewCells.DogBreedCell.rawValue)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dogsBreeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: TableViewCells.DogBreedCell.rawValue, for: indexPath) as! DogBreedCell
        cell.breedName.text = self.dogsBreeds[indexPath.row].capitalized
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.dogsBreeds.count != 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllers.SeeAllBreedViewController.rawValue) as! SeeAllBreedViewController
            vc.imageString = self.dogsBreeds[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}


extension ViewController: UserViewModelDelegate {
    // Handle user data after loading
    func userList(status: ReqStatus, userModel: MesssageModel?, err: Error?) {
        switch status {
        case ReqStatus.START:
            indicator.startAnimating()
            break
        case ReqStatus.SUCCESS:
            indicator.stopAnimating()
            self.indicator.isHidden = true
            DispatchQueue.main.async {
                if let mData = userModel?.message {
                    print(mData)
                    for key in mData {
                        print(key)
                        self.tempBridArr.append(key.key)
                    }
                    let sortedArray = self.tempBridArr.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
                    self.dogsBreeds = sortedArray
                    self.tableView.reloadData()
                }
            }
            break
        case ReqStatus.ERROR:
            indicator.stopAnimating()
            break
            
        }
        
    }
    
}
