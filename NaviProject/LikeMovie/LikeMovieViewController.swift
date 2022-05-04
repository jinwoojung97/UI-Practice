import Foundation
import UIKit



class LikeMovieViewController: UIViewController{
    
 
    
    @IBOutlet weak var likeMovieCollectionView: UICollectionView?
    
    var nowPage: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Like.likeMovies)
        
        likeMovieCollectionView?.delegate = self
        likeMovieCollectionView?.dataSource = self

    }
    override func viewWillAppear(_ animated: Bool) {
        likeMovieCollectionView?.reloadData()
    }
    
}

extension LikeMovieViewController : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(Like.likeMovies.count)
        return Like.likeMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = likeMovieCollectionView?.dequeueReusableCell(withReuseIdentifier: "LikeMovieCell", for: indexPath) as? LikeMovieCell else{return UICollectionViewCell()}
        cell.likeMovieTitle.text = Like.likeMovies[indexPath.row].movieTitle
        cell.likeMoiveRating.text = Like.likeMovies[indexPath.row].movieRating
        cell.likeMovieImg.image = Like.likeMovies[indexPath.row].movieImage
        
    
        return cell
        
    }
    
    
}
