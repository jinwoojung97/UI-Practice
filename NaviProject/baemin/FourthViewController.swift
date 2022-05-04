import Foundation
import UIKit

class FourthViewController : UIViewController{
    
    @IBOutlet weak var baeminCollectionView: UICollectionView!
    
    var nowPage: Int = 0
    
    //사진배열
    let dataArray: Array<UIImage> = [UIImage(named: "discount1")!, UIImage(named: "discount2")!, UIImage(named: "discount3")!, UIImage(named: "discount4")!, UIImage(named: "discount5")!]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baeminCollectionView.delegate = self
        baeminCollectionView.dataSource = self
    }
    
    
    
}

extension FourthViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    //컬렉션뷰 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    //컬렉션뷰 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = baeminCollectionView.dequeueReusableCell(withReuseIdentifier: "BaeminCell", for: indexPath) as! BaeminCell
        cell.imgView.image = dataArray[indexPath.row]
        return cell
    }
    
    
    
    
}
