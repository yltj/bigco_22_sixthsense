
import UIKit
import Firebase

class BookDetailViewController: UIViewController {
    
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl: UILabel!
  
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var desc: UILabel!
  // MARK: Properties
    var book: Book!
  
    override func viewDidLoad() {
      super.viewDidLoad()
      let image_url = URL(string: book.imgUrl)!
      guard let data = try? Data(contentsOf: image_url) else { return }
      img.image = UIImage(data: data)
      lbl.text = book?.title
      author.text = book?.author
      desc.text = book?.desc

        // Do any additional setup after loading the view.
    }
    @IBAction func listenDidTouch(_ sender: Any) {
      let vc = RecordingsViewController()
      vc.book = book
      self.present(vc, animated: true, completion: nil)
    }
  

}
