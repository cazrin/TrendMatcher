import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    @IBOutlet weak var descriptorCollectionView : UICollectionView!
    @IBOutlet weak var itemCollectionView : UICollectionView!
    
    var moveToFirstPages : Bool = true
    
    let descriptorCollectionViewTag = 1
    let itemCollectionViewTag = 2
    
    var items : [UIColor] = []
    var lastContentOffsets = [0, CGFloat(FLT_MIN), CGFloat(FLT_MIN)]
    
    var descriptorCollectionViewIndexPathForDeviceOrientation : NSIndexPath? = nil
    var itemCollectionViewIndexPathForDeviceOrientation : NSIndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        setUpData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.descriptorCollectionView.collectionViewLayout.invalidateLayout()
        self.itemCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if moveToFirstPages {
            scrollToPage(descriptorCollectionView, page: 1, animated: false)
            scrollToPage(itemCollectionView, page: 1, animated: false)
            moveToFirstPages = false
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.view.transform = CGAffineTransformIdentity
    }

    @IBAction func handleLongPress(sender: UILongPressGestureRecognizer) {
        UIView.animateWithDuration(0.2) {
            if sender.state == .Began {
                UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
                self.view.transform = CGAffineTransformMakeScale(0.92, 0.92)
            } else if sender.state == .Ended {
                UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: true)
                self.view.transform = CGAffineTransformMakeScale(1, 1)
            }
        }
    }
    
    @IBAction func handleLongerPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .Began {
            self.performSegueWithIdentifier("showSelection", sender: self)
        }
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
    
    // MARK - UIGestureRecognizerDelegate
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK - UIInterfaceOrientation
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        descriptorCollectionViewIndexPathForDeviceOrientation = self.descriptorCollectionView.indexPathsForVisibleItems().first as? NSIndexPath
        itemCollectionViewIndexPathForDeviceOrientation = self.itemCollectionView.indexPathsForVisibleItems().first as? NSIndexPath
        
        self.descriptorCollectionView.collectionViewLayout.invalidateLayout()
        self.itemCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if let descriptorIndexPath = self.descriptorCollectionViewIndexPathForDeviceOrientation {
            self.descriptorCollectionView.scrollToItemAtIndexPath(descriptorIndexPath, atScrollPosition: .Left, animated: false)
        }
        
        if let itemIndexPath = self.itemCollectionViewIndexPathForDeviceOrientation {
            self.itemCollectionView.scrollToItemAtIndexPath(itemIndexPath, atScrollPosition: .Left, animated: false)
        }
    }
    
    // MARK - Private
    
    func scrollToPage(collectionView: UICollectionView, page: Int, animated: Bool) {
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: page, inSection: 0), atScrollPosition: .Left, animated: animated)
    }
    
    func setUpData() {
        items = [UIColor.redColor(), UIColor.blueColor(), UIColor.greenColor(), UIColor.blackColor(), UIColor.yellowColor()]
        
        items.insert(items.last!, atIndex: 0)
        items.insert(items.first!, atIndex: items.count)
    }
}