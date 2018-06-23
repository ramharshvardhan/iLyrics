//
//  ViewController.swift
//  iLyrics
//
//  Created by Ram Harshvardhan Radhakrishnan on 6/23/18.
//  Copyright © 2018 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOUTLETS
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - PRIVATE PROPERTIES
    fileprivate var songs: [Song]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //Pagination properties
    fileprivate var allObjects: NSMutableArray = []
    fileprivate var subArray: [Any] = []
    fileprivate var numberOfObjectsInSubArray = 10
    fileprivate var dataLoaded = false

    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80.0
        
        // Let's load all songs first.
        loadSongs()
    }
}

// MARK: - TABLEVIEW METHODS
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard dataLoaded else { return 1 }
        
        return subArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let songs = songs else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongCell
        
        let song = songs[indexPath.item]
        
        cell.artistName.text = song.artistName
        cell.songName.text = song.songName
        
        if indexPath.row == subArray.count - 1 {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let songs = songs else { return }
        guard songs.indices.contains(indexPath.row) else { return }
        
        let storyboard = UIStoryboard.init(name:"Main", bundle:Bundle.main)
        if let lyricVC = storyboard.instantiateViewController(withIdentifier: "lyricDetail") as? LyricViewController {
            
            let song = songs[indexPath.row]
            
            lyricVC.song = song
            
            navigationController?.pushViewController(lyricVC, animated: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
        {
            // End of scrolling
            
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()

            numberOfObjectsInSubArray += 10
            
            if (numberOfObjectsInSubArray < allObjects.count) {
                
                subArray = allObjects.subarray(with: NSMakeRange(0, numberOfObjectsInSubArray))
                
            } else {
                
                subArray = allObjects.subarray(with: NSMakeRange(0, allObjects.count))
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } else {
            
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    }
}

// MARK: - HELPERS
extension ViewController {
    
    fileprivate func loadSongs() {
        
        SongService.fetchSongs { [weak self] (success, songs) in
            
            guard let strongSelf = self else { return }
            
            strongSelf.songs = songs
            
            strongSelf.dataLoaded = true
            
            strongSelf.allObjects.addObjects(from: songs!)
            
            strongSelf.subArray = strongSelf.allObjects.subarray(with: NSMakeRange(0, strongSelf.numberOfObjectsInSubArray))
        }
    }
}

