//
//  WebSerivceManager.swift
//  RedditListing
//
//  Created by NIkhilD on 19/08/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import Reachability
import SVProgressHUD


// MARK: - API
struct Web_Service {
    //Listing
    static let Feed_Listing = "https://www.reddit.com/.json"
}


//MARK: - Acceptable Status Code
let accepTableStatusCodes = 200 ... 299


//MARK: - Check Network Connection
enum NetworkConnection {
    case available
    case notAvailable
}


func checkInternetConnection() -> NetworkConnection {
    if CheckNetwork.isNetworkAvailable() {
        return .available
    }
    return .notAvailable
}

//Network check
struct CheckNetwork {
    static func isNetworkAvailable() -> Bool {
        let reachability = try! Reachability()
        let networkStatus = reachability.connection
        
        if networkStatus != .unavailable {
            return true
        } else {
            return false
        }
    }
}



// MARK: - Web Service Manager
class WebSerivceManager: NSObject {
    
    //MARK: - SHOW LOADER
    class func showLoaderWhileGettingData() {
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultMaskType(.clear)
            SVProgressHUD.show()
        }
    }
    
    //MARK: - HIDE LOADER
    class func hideLoader() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    //MARK: - Call API
    class func request(url: String, method : HTTPMethod, showLoader : Bool, parameters : [String : Any], success:@escaping (Any) -> Void, failure:@escaping (Any) -> Void) {
        
        //Check Internet Connection
        if checkInternetConnection() == .available {
            //When INTERNET Connection is Available
            
            // If needs to show LOADER
            if showLoader {
                showLoaderWhileGettingData()
            }else {
                hideLoader()
            }
            
            //Check and Set HEADERs
            let headers: HTTPHeaders = ["Accept": "application/json"]
             
            var encoding : ParameterEncoding = JSONEncoding.default
            if method == .get {
                encoding = URLEncoding.default
            }
            
            //API
            AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { (response: AFDataResponse<Any>) in
                
                // Hide LOADER
                hideLoader()
                
                //Get Status Code
                if let statusCode = response.response?.statusCode {
                    
                    //Check if we are able to parse data
                    guard let responseData = response.value else {
                        print("Error: ", response.error?.localizedDescription as Any)
                        failure(response.error?.localizedDescription ?? "Some error has occured. Please try again later.")
                        return
                    }
                    
                    //Convert response in JSON
                    let jsonData = JSON(responseData)
                    
                    //Check Response Code
                    let status = accepTableStatusCodes.contains(statusCode)
                    
                    switch status {
                    case true:
                        
                        if statusCode == 200 {
                            //Success
                            print("Success Response: \(jsonData)")
                            success(responseData)
                            
                        } else if statusCode == 401 {
                            //Authentication Error
                            print("Authentication Error")
                            
                        } else {
                            //Error
                            failure(responseData)
                        }
                        break
                        
                    default:
                        //Error
                        if statusCode == 401 {
                            //Authentication Error
                            print("Authentication Error")
                            
                        } else {
                            //Error
                            failure(responseData)
                        }
                        break
                    }
                    
                }else {
                    //Server Error
                    print("Could not connect to the server errorrrr...")
                    failure("Server error has occured. Please try again later.")
                }
            }
            
        }else {
            
            //When No INTERNET Connection
            print("No internet connection found. Please try again later.")
            failure("No internet connection found. Please try again later.")
        }
        
    }
    
}


func getObjectViaCodable<T : Codable>(dict : [String : Any]) -> T? {
    if let jsonData = try?  JSONSerialization.data(
        withJSONObject: dict,
        options: .prettyPrinted
        ){
        if let res = try? JSONDecoder().decode(T.self, from: jsonData){
            return res
        } else {
            return nil
        }
    } else {
        return nil
    }
}

func getArrayViaCodable<T : Codable>(arrDict : [[String : Any]]) -> [T] {
    if let jsonData = try?  JSONSerialization.data(
        withJSONObject: arrDict,
        options: .prettyPrinted
        ) {
        if let res = try? JSONDecoder().decode([T].self, from: jsonData){
            return res
        } else {
            return []
        }
    } else {
        return []
    }
}
