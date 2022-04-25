import UIKit
import Firebase

class BookListTableViewController: UITableViewController {
  // MARK: Constants
  let listToUsers = "ListToUsers"
  let showDetail = "showDetail"

  // MARK: Properties
  var items: [Book] = []
  var user: User?
  var onlineUserCount = UIBarButtonItem()
  var selectedBook: Book?
  
  let ref = Database.database().reference(withPath: "books")
  var refObservers: [DatabaseHandle] = []
  var handle: AuthStateDidChangeListenerHandle?

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.allowsMultipleSelectionDuringEditing = false

    onlineUserCount = UIBarButtonItem(
      title: "1",
      style: .plain,
      target: self,
      action: #selector(onlineUserCountDidTouch))
    onlineUserCount.tintColor = .white
    navigationItem.leftBarButtonItem = onlineUserCount
    user = User(uid: "FakeId", email: "hungry@person.food")
    
    let completed = ref.observe(.value) { snapshot in
      // 2
      var newItems: [Book] = []
      // 3
      for child in snapshot.children {
        // 4
        if
          let snapshot = child as? DataSnapshot,
          let bookItem = Book(snapshot: snapshot) {
          newItems.append(bookItem)
        }
      }
      self.items = newItems
      self.tableView.reloadData()
      
    }
    refObservers.append(completed)
  }

  override func viewWillAppear(_ animated: Bool) {
    handle = Auth.auth().addStateDidChangeListener { _, user in
      guard let user = user else { return }
      self.user = User(authData: user)
    }
  }

  override func viewDidDisappear(_ animated: Bool) {
    refObservers.forEach(ref.removeObserver(withHandle:))
    refObservers = []
    guard let handle = handle else { return }
    Auth.auth().removeStateDidChangeListener(handle)
  }

  // MARK: UITableView Delegate methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    let bookItem = items[indexPath.row]
    cell.textLabel?.text = bookItem.title
    
    let image_url = URL(string: bookItem.imgUrl)!
    guard let data = try? Data(contentsOf: image_url) else { return cell}
    cell.imageView?.image = UIImage(data: data)
    
    cell.detailTextLabel?.text = bookItem.author

    return cell
  }


  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      items.remove(at: indexPath.row)
      tableView.reloadData()
    }
  }
  
  // MARK: Select Book
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let bookItem = items[indexPath.row]
    selectedBook = bookItem
    self.performSegue(withIdentifier: showDetail, sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == showDetail {
          let detailController = segue.destination as! BookDetailViewController
          detailController.book = selectedBook
      }
  }
  
  // MARK: Add Item
  @IBAction func addItemDidTouch(_ sender: AnyObject) {
    let alert = UIAlertController(
      title: "Grocery Item",
      message: "Add an Item",
      preferredStyle: .alert)

    let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
      guard
        let textField = alert.textFields?.first,
        let text = textField.text,
        let user = self.user
      else { return }

      let recording = Recording(
        name: text,
        addedByUser: user.email,
        completed: false,
        url: "https://images-na.ssl-images-amazon.com/images/I/51trnozKxxL.jpg")

      let recordingRef = self.ref.child(text.lowercased())
      recordingRef.setValue(recording.toAnyObject())
    }

    let cancelAction = UIAlertAction(
      title: "Cancel",
      style: .cancel)

    alert.addTextField()
    alert.addAction(saveAction)
    alert.addAction(cancelAction)

    present(alert, animated: true, completion: nil)
  }

  @objc func onlineUserCountDidTouch() {
    performSegue(withIdentifier: listToUsers, sender: nil)
  }
}
