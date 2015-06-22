import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var descriptorCollectionView : UICollectionView!
    @IBOutlet weak var itemCollectionView : UICollectionView!
    
    let descriptorCollectionViewTag = 1
    let itemCollectionViewTag = 2
    
    var items : [UIColor] = []
    var lastContentOffsets = [0, CGFloat(FLT_MIN), CGFloat(FLT_MIN)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.descriptorCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 0), atScrollPosition: .Left, animated: false)
        self.itemCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 0), atScrollPosition: .Left, animated: false)
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
        
        if lastContentOffsets[scrollView.tag] == CGFloat(FLT_MIN) {
            lastContentOffsets[scrollView.tag] = currentOffsetX;
            return;
        }
        
        if currentOffsetX < CGFloat(FLT_MIN) && lastContentOffsets[scrollView.tag] > currentOffsetX {
            // first page is visible and user is scrolling to the left
            lastContentOffsets[scrollView.tag] = currentOffsetX + offset
            scrollView.contentOffset = CGPointMake(lastContentOffsets[scrollView.tag], currentOffsetY)
        } else if currentOffsetX > offset && lastContentOffsets[scrollView.tag] < currentOffsetX {
            // last page is visible and user is scrolling to the right
            lastContentOffsets[scrollView.tag] = currentOffsetX - offset
            scrollView.contentOffset = CGPointMake(lastContentOffsets[scrollView.tag], currentOffsetY)
        } else {
            lastContentOffsets[scrollView.tag] = currentOffsetX
        }
    }
    
    // MARK - Private
    
    func setUpData() {
        items = [UIColor.redColor(), UIColor.blueColor(), UIColor.greenColor(), UIColor.blackColor(), UIColor.yellowColor()]
        
        items.insert(items.last!, atIndex: 0)
        items.insert(items.first!, atIndex: items.count)
    }
}