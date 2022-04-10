import Firebase

struct Book {
  let ref: DatabaseReference?
  let key: String
  let title: String
  let author: String
  let chapter: Int
  let content: String
  let imgUrl: String
  
  // MARK: Initialize with Raw Data
  init(title: String, author: String, chapter: Int, content: String, imgUrl: String, key: String = "") {
    self.ref = nil
    self.key = key
    self.title = title
    self.author = author
    self.chapter = chapter
    self.content = content
    self.imgUrl = imgUrl
  }

  // MARK: Initialize with Firebase DataSnapshot
  init?(snapshot: DataSnapshot) {
    guard
      let value = snapshot.value as? [String: AnyObject],
      let title = value["title"] as? String,
      let author = value["author"] as? String,
      let chapter = value["chapter"] as? Int,
      let content = value["content"] as? String,
      let imgUrl = value["imgUrl"] as? String
    
    else {
      return nil
    }

    self.ref = snapshot.ref
    self.key = snapshot.key
    self.title = title
    self.author = author
    self.chapter = chapter
    self.content = content
    self.imgUrl = imgUrl
  }

  // MARK: Convert GroceryItem to AnyObject
  func toAnyObject() -> Any {
    return [
      "title": title,
      "author": author,
      "chapter": chapter,
      "content": content,
      "imgUrl": imgUrl
    ]
  }
}
