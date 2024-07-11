//
//  UserViewModel.swift
//  DogBreedApp
//
//  Created by Apple on 10/07/24.
//

import Foundation

protocol UserViewModelDelegate : AnyObject {
    
    func userList(status: ReqStatus, userModel: MesssageModel?, err: Error?)
    func userList(status: ReqStatus, userModel: BreedImageModel?, err: Error?)
    func userList(status: ReqStatus, userModel: AllBreedImageModel?, err: Error?)
    
}

class UserViewModel {
    
    var userViewModelDelegate: UserViewModelDelegate?
    
    public func userList(apiUrl: String) {
        Services.shared.breedList(apiUrl: apiUrl) { (status, userModel, err) in
            DispatchQueue.main.async {
                self.userViewModelDelegate?.userList(status: status, userModel: userModel, err: err)
            }
        }
    }
    
    public func setBreedImage(apiUrl: String) {
        Services.shared.setBreedImage(apiUrl: apiUrl) { (status, userModel, err) in
            DispatchQueue.main.async {
                self.userViewModelDelegate?.userList(status: status, userModel: userModel, err: err)
            }
        }
    }
    
    public func allBreedImage(apiUrl: String) {
        Services.shared.getallImgaesOfBreeds(apiUrl: apiUrl) { (status, userModel, err) in
            DispatchQueue.main.async {
                self.userViewModelDelegate?.userList(status: status, userModel: userModel, err: err)
            }
        }
    }
    
}

extension UserViewModelDelegate {
    func userList(status: ReqStatus, userModel: MesssageModel?, err: Error?){}
    func userList(status: ReqStatus, userModel: BreedImageModel?, err: Error?){}
    func userList(status: ReqStatus, userModel: AllBreedImageModel?, err: Error?){}
}
