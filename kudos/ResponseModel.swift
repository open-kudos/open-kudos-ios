import Foundation

class ResponseModel {
  let error: Bool
  let json: NSData?
  
  init(json: NSData?, error: Bool) {
    self.error = error
    self.json = json
  }
}