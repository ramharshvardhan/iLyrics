//
//  Song.swift
//  iLyrics
//
//  Created by Ram Harshvardhan Radhakrishnan on 6/23/18.
//  Copyright © 2018 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

import Foundation

struct Song {
    let artistName: String
    let songName: String
    let songUrl: String
    
    init(_ payload: [String: AnyObject]) {
        self.artistName = payload["artistName"] as? String ?? ""
        self.songName = payload["name"] as? String ?? ""
        self.songUrl = payload["url"] as? String ?? ""
    }
}


