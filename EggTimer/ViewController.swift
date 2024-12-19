//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    var player: AVAudioPlayer?
    
    let eggTime = [
        "Soft":3,
        "Medium":420,
        "Hard":600
    ]
    var counter = 0
    var timer:Timer?
    var totalTime:Float = 1.0
    var positiveCounter:Float = 0.0
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var hardnessLabel: UILabel!
    @IBOutlet weak var timerCountdown: UILabel!
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        let hardness = sender.currentTitle
        
        if hardness != nil{
            totalTime = Float(eggTime[hardness!]!)
            hardnessLabel.text = hardness
            counter = eggTime[hardness!]!
            startCounter()
        }else{
            print("Hardness is empty")
        }
    }
    
    func startCounter(){
        print("Reset")
        positiveCounter = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        var progressPercentage:Float = 0.0
        progressPercentage = positiveCounter/totalTime
        progressView.progress = Float(progressPercentage)
        
        
        //example functionality
        if counter > 0 {
            print("\(counter) seconds")
            timerCountdown.text = formatter.string(from: TimeInterval(counter))!
            counter -= 1
            positiveCounter += 1
        }else{
            timerCountdown.text = "Done!"
            playSound()
        }
    }
    
    let formatter : DateComponentsFormatter = {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .second]
            return formatter
    }()
    
    func stopAudio(player: AVAudioPlayer){
        DispatchQueue.main.async{
            print("stopp")
            player.stop()
        }
    }

    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player1 = player else { return }
            
            player1.play()
            
            // START OF BUG FIXING
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { Timer in
                self.stopAudio(player: player1)
            }
            
//            NOT WORKING USING ASYNCAFTER WITH DEADLINE
//            DispatchQueue.main.asyncAfter(deadline: .now()+1.5 ) {
//                print("stopp")
//                player.stop()
//            }
            
//            NOT WORKING USING TIMER WITH TIME INTERVAL
//            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { (timer) in
//                DispatchQueue.main.async{
//                    print("stopp")
//                    player.stop()
//                }
//            }
            
            // END OF BUG FIXING

        } catch let error {
            print(error.localizedDescription)
        }
    }
}
