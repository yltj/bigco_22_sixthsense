
import UIKit
import Firebase

class BookDetailViewController: UIViewController {
    
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl: UILabel!
  
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var desc: UILabel!
  
    @IBOutlet weak var listen: UIButton!
  // MARK: Properties
    var book: Book!
  
    override func viewDidLoad() {
      super.viewDidLoad()
      let image_url = URL(string: book.imgUrl)!
      guard let data = try? Data(contentsOf: image_url) else { return }
      img.image = UIImage(data: data)
      lbl.text = book?.title
      author.text = book?.author
      desc.text = book?.content

        // Do any additional setup after loading the view.
    }
  

}
