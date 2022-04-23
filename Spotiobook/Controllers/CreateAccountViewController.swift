
import UIKit
import Firebase

class CreateAccountViewController: UIViewController {

  let accountToList = "AccountToList"
  
//  @IBSegueAction func accountToList(_ coder: NSCoder) -> BookListTableViewController? {
//    return <#BookListTableViewController(coder: coder)#>
//  }
  
  // MARK: Outlets
  @IBOutlet weak var firstName: UITextField!
  @IBOutlet weak var lastName: UITextField!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var password: UITextField!
  
  @IBOutlet weak var confirmPassword: UITextField!
  var handle: AuthStateDidChangeListenerHandle?
    
  
  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    firstName.delegate = self
    lastName.delegate = self
    email.delegate = self
    password.delegate = self
    confirmPassword.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    handle = Auth.auth().addStateDidChangeListener { _, user in
      if user == nil {
//        self.navigationController?.popToRootViewController(animated: true)
      } else {
        self.performSegue(withIdentifier: self.accountToList, sender: nil)
        self.email.text = nil
        self.password.text = nil
      }
    }
  }
  @IBAction func signUpTouched(_ sender: UIButton) {
    guard
      let email = email.text,
      let password = password.text,
      !email.isEmpty,
      !password.isEmpty
    else { return }
    Auth.auth().createUser(withEmail: email, password: password) { _, error in
      if error == nil {
        Auth.auth().signIn(withEmail: email, password: password)
      } else {
        print("Error in createUser: \(error?.localizedDescription ?? "")")
      }
    }
  }
  

}

// MARK: - UITextFieldDelegate
extension CreateAccountViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == firstName {
      firstName.becomeFirstResponder()
    }
    if textField == lastName {
      lastName.resignFirstResponder()
    }
    return true
  }
}
