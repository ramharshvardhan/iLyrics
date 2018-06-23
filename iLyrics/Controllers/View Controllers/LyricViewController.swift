//
//  LyricViewController.swift
//  iLyrics
//
//  Created by Ram Harshvardhan Radhakrishnan on 6/23/18.
//  Copyright © 2018 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

import UIKit

class LyricViewController: UIViewController {
    
    // MARK: - IBOUTLETS
    @IBOutlet weak var lyricView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - PUBLIC PROPERTIES
    var lyrics: String?
    
    var song: Song?
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    fileprivate func setupView() {
        
        guard let song = song else { return }
        
        // Let's fetch the lyrics to the song
        SongService.fetchLyrics(forSong: song.songName, artist: song.artistName) { [weak self] (success, lyrics) in
            
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                strongSelf.lyricView.text = lyrics
            }
        }
    }
}
