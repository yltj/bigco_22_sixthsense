import UIKit
import Firebase

class OnlineUsersTableViewController: UITableViewController {
  // MARK: Constants
  let userCell = "UserCell"

  // MARK: Properties
  var currentUsers: [String] = []

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    currentUsers.append("hungry@person.food")
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(true)
  }

  // MARK: UITableView Delegate methods
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currentUsers.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath)
    let onlineUserEmail = currentUsers[indexPath.row]
    cell.textLabel?.text = onlineUserEmail
    return cell
  }

  // MARK: Actions
  @IBAction func signOutDidTouch(_ sender: AnyObject) {
    // 1
    guard let user = Auth.auth().currentUser else { return }
    let onlineRef = Database.database().reference(withPath: "online/\(user.uid)")
    // 2
    onlineRef.removeValue { error, _ in
      // 3
      if let error = error {
        print("Removing online failed: \(error)")
        return
      }
      // 4
      do {
        try Auth.auth().signOut()
        self.navigationController?.popToRootViewController(animated: true)
      } catch let error {
        print("Auth sign out failed: \(error)")
      }
    }
  }
}
