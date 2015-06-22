import UIKit

class DetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
        self.title = "Detail"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBarHidden = true
    }
}