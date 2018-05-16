//
//  MusicPlayer.swift
//  SiegeDefense
//
//  Created by Ivan Huang on 3/9/18.
//  Copyright © 2018 Ivan Huang. All rights reserved.
//

import Foundation
import AVFoundation

class MusicPlayer {
    
    static var menuMusicLoaded = false
    static var levelMusicLoaded = false
    static var shopMusicLoaded = false
    
    static var music: AVAudioPlayer!
    
    
    static func loadLevelMusic() {
        if(!levelMusicLoaded) {
            music = loadSong(songPath: "building-adventure")!
            music.play()
            menuMusicLoaded = false
            levelMusicLoaded = true
            shopMusicLoaded = false
        }
    }
    
    static func loadShopMusic() {
        if(!shopMusicLoaded) {
            music = loadSong(songPath: "medieval-tradition")!
            music.play()
            menuMusicLoaded = false
            levelMusicLoaded = false
            shopMusicLoaded = true
        }
    }
    
    
    static func loadMenuMusic() {
        if(!menuMusicLoaded) {
            music = loadSong(songPath: "king-of-thrones")!
            music.play()
            menuMusicLoaded = true
            levelMusicLoaded = false
            shopMusicLoaded = false
        }
    }
    
    static func loadSong(songPath: String) -> AVAudioPlayer? {
        var song: AVAudioPlayer
        
        do {
            let songURL = Bundle.main.path(forResource: songPath, ofType: "mp3")
            song = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: songURL!))
            song.numberOfLoops = -1
            return song
        } catch {
            print("song not found")
            return nil
        }
        
        

    }
}
