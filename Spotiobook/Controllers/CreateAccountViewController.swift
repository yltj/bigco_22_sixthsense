
import UIKit
import Firebase

class CreateAccountViewController: UIViewController {

  // MARK: Outlets

  @IBOutlet weak var firstName: UITextField!
  @IBOutlet weak var lastName: UITextField!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var confirmPassoword: UITextField!
  
  @IBOutlet weak var createAccountButton: UIButton!
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: UIViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    firstName.delegate = self
    lastName.delegate = self
    email.delegate = self
    password.delegate = self
    confirmPassoword.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
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
