//
//  SongService.swift
//  iLyrics
//
//  Created by Ram Harshvardhan Radhakrishnan on 6/23/18.
//  Copyright © 2018 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

import Foundation

typealias SongResponse = (_ success: Bool?, _ content: [Song]?) -> ()
typealias LyricResponse = (_ success: Bool?, _ lyrics: String?) -> ()

public class SongService {
    
    private static let songListUrl = URL(string: "https://rss.itunes.apple.com/api/v1/us/itunes-music/hot-tracks/all/100/explicit.json")
    private static let songLyricAPI = "https://api.lyrics.ovh/v1"
    
    static func fetchSongs(completion: @escaping SongResponse) {
        
        guard let url = songListUrl else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            //Handling response
            
            if let _ = error {
                
                completion(false, nil)
                
            } else {
                
                if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    
                    do {
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        
                        if let json = json, let feedResults = json["feed"] as? [String: AnyObject],
                            let resultsArray = feedResults["results"] as? [[String: AnyObject]] {
                            
                            var songs = [Song]()
                            
                            for song in resultsArray {
                                
                                let newSong = Song.init(song)
                                
                                songs.append(newSong)
                            }
                            
                            completion(true, songs)
                            
                        } else {
                            completion(false, nil)
                        }
                        
                    } catch {
                        print(error)
                    }
                } else {
                    completion(false, nil)
                }
            }
        }.resume()
    }
    
    static func fetchLyrics(forSong songName: String, artist: String, completion: @escaping LyricResponse) {
        
        let completeAPI = "\(songLyricAPI)/\(artist)/\(songName)"
        
        let urlString = completeAPI.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: urlString!) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            //Handling response
            
            if let _ = error {
                
                completion(false, nil)
                
            } else {
                
                if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    
                    do {
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        
                        if let json = json, let lyrics = json["lyrics"] as? String {
                            
                            completion(true, lyrics)
                            
                        } else {
                            completion(false, nil)
                        }
                        
                    } catch {
                        print(error)
                    }
                } else {
                    completion(false, nil)
                }
            }
        }.resume()
    }
}

