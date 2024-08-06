//
//  FollowersVC.swift
//  GHFollowers
//
//  Created by Mardon Mashrabov on 05/08/2024.
//

import UIKit

class FollowersListVC: UIViewController {
    private var collectionView: UICollectionView!
    
    private enum Section { case main }
    private var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    var username: String!
    private var currentPage = 1
    private var followers: [Follower] = []
    
    private let resultsPerPage = 50
    
    private var hasMoreFollowers = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        getFollowers(username: username, page: currentPage)
        configureCollectionView()
        configureDataSource()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func getFollowers(username: String, page: Int) {
        // Am I creating strong link when I added these variables a property?
        NetworkManager.shared.getFollowers(username: username, page: page, resultsPerPage: resultsPerPage) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .success(let followers):
                print(followers)
                if followers.count < resultsPerPage {
                    hasMoreFollowers = false
                }
                self.followers.append(contentsOf: followers)
                self.updateSnapshot()
            case.failure(let error):
                let alertController = UIAlertController(title: "Request failed", message: error.rawValue, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    // Handle OK button tap
                }
                
                alertController.addAction(okAction)
                
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view)
        )
        view.addSubview(collectionView)
        collectionView.register(
            FollowerCell.self,
            forCellWithReuseIdentifier: FollowerCell.identifier
        )
        collectionView.delegate = self
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: {(collectionView, indexPath, follower) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.identifier, for: indexPath) as? FollowerCell else {
                return UICollectionViewCell()
            }
            cell.setValues(follower: follower)
            return cell
        })
        
    }
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers, toSection: .main)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

extension FollowersListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard hasMoreFollowers else { return }
        
        let offsetY                 = scrollView.contentOffset.y
        let contentHeight           = scrollView.contentSize.height
        let height                  = scrollView.frame.size.height
        
        let shouldFetchMoreFollowers = (contentHeight - offsetY - height) < 0
        
        if(shouldFetchMoreFollowers) {
            currentPage += 1
            getFollowers(username: username, page: currentPage)
        }
    }
}
