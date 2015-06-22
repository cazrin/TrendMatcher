import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var descriptorCollectionView : UICollectionView!
    @IBOutlet weak var itemCollectionView : UICollectionView!
    
    var items : [UIColor] = []
    var lastContentOffsetX = CGFloat(FLT_MIN)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
    }
    
    // MARK - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView .dequeueReusableCellWithReuseIdentifier("DescriptorCell", forIndexPath: indexPath) as! UICollectionViewCell
        
        let itemColor = items[indexPath.row]
        cell.backgroundColor = itemColor
        
        return cell
    }
    
    // MARK - UICollectionViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentOffsetX = scrollView.contentOffset.x
        let currentOffsetY = scrollView.contentOffset.y
        
        let pageWidth = scrollView.frame.size.width
        let offset = pageWidth * CGFloat(items.count - 2)
        
        if lastContentOffsetX == CGFloat(FLT_MIN) {
            lastContentOffsetX = currentOffsetX;
            return;
        }
        
        if currentOffsetX < CGFloat(FLT_MIN) && lastContentOffsetX > currentOffsetX {
            // first page is visible and user is scrolling to the left
            lastContentOffsetX = currentOffsetX + offset
            scrollView.contentOffset = CGPointMake(lastContentOffsetX, currentOffsetY)
        } else if currentOffsetX > offset && lastContentOffsetX < currentOffsetX {
            // last page is visible and user is scrolling to the right
            lastContentOffsetX = currentOffsetX - offset
            scrollView.contentOffset = CGPointMake(lastContentOffsetX, currentOffsetY)
        } else {
            lastContentOffsetX = currentOffsetX
        }
    }
    
    // MARK - Private
    
    func setUpData() {
        items = [UIColor.redColor(), UIColor.blueColor(), UIColor.greenColor(), UIColor.blackColor(), UIColor.yellowColor()]
        
        items.insert(items.last!, atIndex: 0)
        items.insert(items.first!, atIndex: items.count)
    }
}