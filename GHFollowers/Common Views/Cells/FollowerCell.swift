//
//  FollowerCell.swift
//  GHFollowers
//
//  Created by Mardon Mashrabov on 05/08/2024.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    static let identifier = "FollowerCell"
    
    private let profileImg = UIImageView(frame: .zero)
    private let username = UILabel()
    
    private let cache = NetworkManager.shared.cache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Interface Builder is not supported!")
    }
    
    // Clear text labels, image views, and other UI elements
    // Remove any custom subviews or overlays.
    // Reset any state variables or flags.
    // Cancel network requests, timers, or animations
    override func prepareForReuse() {
        super.prepareForReuse()
        
        username.text = nil
        profileImg.image = nil
    }
    
    
    func configure() {
        contentView.addSubview(profileImg)
        contentView.addSubview(username)
        
        profileImg.translatesAutoresizingMaskIntoConstraints = false
        profileImg.image = UIImage(named: "avatar-placeholder")
        profileImg.contentMode = .scaleAspectFit
        
        username.translatesAutoresizingMaskIntoConstraints = false
        username.textAlignment = .center
        username.numberOfLines = 1
        username.textColor = UIColor.label
        
        let stackV = UIStackView()
        stackV.axis = .vertical
        stackV.addArrangedSubview(profileImg)
        stackV.addArrangedSubview(username)
        stackV.frame = contentView.bounds
        stackV.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        stackV.isLayoutMarginsRelativeArrangement = true
        contentView.addSubview(stackV)
    }
    
    func downloadAndSetImage(imageUrl: String) {
        let cacheKey = NSString(string: imageUrl)
        
        if let image = cache.object(forKey: cacheKey) {
            self.profileImg.image = image
            return
        }
        
        guard let url = URL(string: imageUrl) else { return }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {[weak self] data, response, error in
            guard let self = self else { return }
            guard error == nil else { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            
            cache.setObject(image, forKey: cacheKey)
            DispatchQueue.main.sync {
                self.profileImg.image = image
            }
        })
        task.resume()
    }
    
    func setValues(follower: Follower) {
        username.text = follower.login
        downloadAndSetImage(imageUrl: follower.avatarUrl)
    }
}
