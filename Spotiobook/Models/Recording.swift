import Firebase

struct Recording {
  let ref: DatabaseReference?
  let key: String
  let name: String
  let addedByUser: String
  var completed: Bool
  
  // add book url
  let url: String

  // MARK: Initialize with Raw Data
  init(name: String, addedByUser: String, completed: Bool, url: String, key: String = "") {
    self.ref = nil
    self.key = key
    self.name = name
    self.addedByUser = addedByUser
    self.completed = completed
    
    self.url = url
  }

  // MARK: Initialize with Firebase DataSnapshot
  init?(snapshot: DataSnapshot) {
    guard
      let value = snapshot.value as? [String: AnyObject],
      let name = value["name"] as? String,
      let addedByUser = value["addedByUser"] as? String,
      let completed = value["completed"] as? Bool,
      
      let url = value["url"] as? String
    else {
      return nil
    }

    self.ref = snapshot.ref
    self.key = snapshot.key
    self.name = name
    self.addedByUser = addedByUser
    self.completed = completed
    
    self.url = url
  }

  // MARK: Convert item to AnyObject
  func toAnyObject() -> Any {
    return [
      "name": name,
      "addedByUser": addedByUser,
      "url": url,
      "completed": completed
    ]
  }
}
