//
//  Followers.swift
//  GHFollowers
//
//  Created by Mardon Mashrabov on 05/08/2024.
//

import Foundation

struct Follower: Decodable, Hashable {
    let login: String
    let avatarUrl: String
}
