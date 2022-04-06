import UIKit
import Firebase

class GroceryListTableViewController: UITableViewController {
  // MARK: Constants
  let listToUsers = "ListToUsers"

  // MARK: Properties
  var items: [Recording] = []
  var user: User?
  var onlineUserCount = UIBarButtonItem()
  
  let ref = Database.database().reference(withPath: "recordings")
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
  }

  override func viewWillAppear(_ animated: Bool) {
    let completed = ref.observe(.value) { snapshot in
      // 2
      var newItems: [Recording] = []
      // 3
      for child in snapshot.children {
        // 4
        if
          let snapshot = child as? DataSnapshot,
          let groceryItem = Recording(snapshot: snapshot) {
          newItems.append(groceryItem)
        }
      }
      self.items = newItems
      self.tableView.reloadData()
    }
    refObservers.append(completed)
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
    let groceryItem = items[indexPath.row]

    cell.textLabel?.text = groceryItem.name
    cell.detailTextLabel?.text = groceryItem.addedByUser

    toggleCellCheckbox(cell, isCompleted: groceryItem.completed)

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

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else { return }
    var groceryItem = items[indexPath.row]
    let toggledCompletion = !groceryItem.completed

    toggleCellCheckbox(cell, isCompleted: toggledCompletion)
    groceryItem.completed = toggledCompletion
    tableView.reloadData()
  }

  func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
    if !isCompleted {
      cell.accessoryType = .none
      cell.textLabel?.textColor = .black
      cell.detailTextLabel?.textColor = .black
    } else {
      cell.accessoryType = .checkmark
      cell.textLabel?.textColor = .gray
      cell.detailTextLabel?.textColor = .gray
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
        completed: false)

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
