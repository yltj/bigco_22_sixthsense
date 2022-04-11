
import UIKit

class BookDetailViewController: UIViewController {
    
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl: UILabel!
  
    // MARK: Properties
    var book: Book!
  
    override func viewDidLoad() {
      super.viewDidLoad()
      let image_url = URL(string: book.imgUrl)!
      guard let data = try? Data(contentsOf: image_url) else { return }
      img.image = UIImage(data: data)
      lbl.text = book?.title
      
      print(book?.title)

        // Do any additional setup after loading the view.
    }
  

}
