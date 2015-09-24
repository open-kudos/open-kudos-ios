//
//  DataManager.swift
//  TopApps
//


import Foundation

let baseURL = "http://dev.open-kudos-backend.asinica.lt"
let loginURL = "/login"
let registerURL = "/register"
let remainingKudosURL = "/kudos/remaining"
let incomingKudosURL = "/kudos/incoming"
let totalKudosURL = "/kudos/received"
let giveKudosURL = "/kudos/send"
let userHomeURL = "/user/home"
let userUpdateProfileURL = "/user/update"
let userSearchURL = "/user/list"

class DataManager {
    
    class func isLoggedIn(success: ((response: ResponseModel!) -> Void)) {
        //1
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL)!)
        request.HTTPMethod = "GET"
        loadDataFromURL(request, completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                success(response: ResponseModel(json: urlData, error: false))
            } else {
                success(response: ResponseModel(json: nil, error: true))
            }
        })
    }
    
    class func login(email : String, password : String, success: ((response: ResponseModel!) -> Void)) {
        //1
        let params = "email=\(email)&password=\(password)"
        loadDataFromURL(createPostRequest(baseURL+loginURL, params: params), completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                print("url login suc: \(params)")
                success(response: ResponseModel(json: urlData, error: false))
            } else {
                print("url login err: \(error!.description)")
                success(response: ResponseModel(json: nil, error: true))
            }
        })
    }
    
    class func register(firstName : String, lastName : String, email : String, password : String, confirmPassword : String, success: ((response: ResponseModel!) -> Void)) {
        //1
        let params = "firstName=\(firstName)&lastName=\(lastName)&email=\(email)&password=\(password)&confirmPassword=\(confirmPassword)"
        loadDataFromURL(createPostRequest(baseURL+registerURL, params: params), completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                print("url register: \(params)")
                success(response: ResponseModel(json: urlData, error: false))
            } else {
                print("url register: \(error!.description)")
                success(response: ResponseModel(json: nil, error: true))
            }
        })
    }
    
    class func fetcRemainingKudos(success: ((response: ResponseModel!) -> Void)) {
        //1
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL+remainingKudosURL)!)
        request.HTTPMethod = "GET"
        loadDataFromURL(request, completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                success(response: ResponseModel(json: urlData, error: false))
            } else {
                success(response: ResponseModel(json: nil, error: true))
            }
        })
    }
    
    class func fetchIncomingKudos(success: ((response: ResponseModel!) -> Void)) {
        //1
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL+incomingKudosURL)!)
        request.HTTPMethod = "GET"
        loadDataFromURL(request, completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                success(response: ResponseModel(json: urlData, error: false))
            } else {
                success(response: ResponseModel(json: nil, error: true))
            }
        })
    }
    
    class func fetchTotalKudos(success: ((response: ResponseModel!) -> Void)) {
        //1
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL+totalKudosURL)!)
        request.HTTPMethod = "GET"
        loadDataFromURL(request, completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                success(response: ResponseModel(json: urlData, error: false))
            } else {
                success(response: ResponseModel(json: nil, error: true))
            }
        })
    }
    
    class func giveKudos(email : String, amount : String, message : String, success: ((response: ResponseModel!) -> Void)) {
        //1
        let params = "receiverEmail=\(email)&amount=\(amount)&message=\(message)"
        loadDataFromURL(createPostRequest(baseURL+giveKudosURL, params: params), completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                print("give kudos params: \(params)")
                success(response: ResponseModel(json: urlData, error: false))
            } else {
                print("give kudos error: \(error!.description)")
                success(response: ResponseModel(json: nil, error: true))
            }
        })
    }
    
    class func logout() -> Void {
        let session = NSURLSession.sharedSession()
        session.resetWithCompletionHandler { () -> Void in
            print("session reset on logout")        }
    }
    
    class func updateUserProfile(success: ((response: ResponseModel!) -> Void)) {
        //1
        var params = "team=\(DataContainerSingleton.sharedDataContainer.team!)"
        params = params + "&position=\(DataContainerSingleton.sharedDataContainer.position!)"
        params = params + "&firstName=\(DataContainerSingleton.sharedDataContainer.firstName!)"
        params = params + "&lastName=\(DataContainerSingleton.sharedDataContainer.lastName!)"
        params = params + "&department=\(DataContainerSingleton.sharedDataContainer.department!)"
        params = params + "&startedToWorkDay=\(DataContainerSingleton.sharedDataContainer.startedToWork!)"
        params = params + "&email=\(DataContainerSingleton.sharedDataContainer.email!)"
        params = params + "&birthday=\(DataContainerSingleton.sharedDataContainer.birthday!)"
        params = params + "&phone=\(DataContainerSingleton.sharedDataContainer.phone!)"
        print("update profile params: \(params)")
        loadDataFromURL(createPostRequest(baseURL+userUpdateProfileURL, params: params), completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                success(response: ResponseModel(json: urlData, error: false))
            } else {
                print("update profile error: \(error!.description)")
                success(response: ResponseModel(json: nil, error: true))
            }
        })
    }
    
    
    class func getUser(success: ((response: ResponseModel!) -> Void)) {
        //1
        let request = NSMutableURLRequest(URL: NSURL(string: baseURL+userHomeURL)!)
        request.HTTPMethod = "GET"
        loadDataFromURL(request, completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                success(response: ResponseModel(json: urlData, error: false))
            } else {
                success(response: ResponseModel(json: nil, error: true))
            }
        })
    }
    
    class func searchUser(filter : String, success: ((response: ResponseModel!) -> Void)) {
        //1
        let params = "filter=\(filter)"
        loadDataFromURL(createPostRequest(baseURL+userSearchURL, params: params), completion:{(data, error) -> Void in
            //2
            if let urlData = data {
                print("search user params: \(params)")
                success(response: ResponseModel(json: urlData, error: false))
            } else {
                print("search user err: \(error!.description)")
                success(response: ResponseModel(json: nil, error: true))
            }
        })
    }
    
    private class func loadDataFromURL(request: NSMutableURLRequest, completion:(data: NSData?, error: NSError?) -> Void) {
        let session = NSURLSession.sharedSession()
        
        // Use NSURLSession to get data from an NSURL
        let loadDataTask = session.dataTaskWithRequest(request, completionHandler: {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
                    completion(data: data, error: nil)
                } else {
                    let statusError = NSError(domain:"open.kudos", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "Unhandled HTTP error code"])
                    completion(data: nil, error: statusError)
                }
            }
        })
        
        loadDataTask.resume()
    }
    
    private class func createPostRequest(url : String, params : String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
}