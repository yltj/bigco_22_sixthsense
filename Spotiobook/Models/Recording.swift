import Firebase

struct Recording {
  let ref: DatabaseReference?
  let key: String
  let name: String
  let addedByUser: String
  let s3path: String
  var completed: Bool

  // MARK: Initialize with Raw Data
  init(name: String, addedByUser: String, completed: Bool, key: String = "") {
    self.ref = nil
    self.key = key
    self.name = name
    self.addedByUser = addedByUser
    self.completed = completed
    self.s3path = "s3://spotiobooks/name"
  }

  // MARK: Initialize with Firebase DataSnapshot
  init?(snapshot: DataSnapshot) {
    guard
      let value = snapshot.value as? [String: AnyObject],
      let name = value["name"] as? String,
      let addedByUser = value["addedByUser"] as? String,
      let completed = value["completed"] as? Bool,
      let s3path = value["s3path"] as? String
      
    
    else {
      return nil
    }

    self.ref = snapshot.ref
    self.key = snapshot.key
    self.name = name
    self.addedByUser = addedByUser
    self.completed = completed
    self.s3path = s3path
  }

  // MARK: Convert item to AnyObject
  func toAnyObject() -> Any {
    return [
      "name": name,
      "addedByUser": addedByUser,
      "completed": completed,
      "s3path": s3path
    ]
  }
}
