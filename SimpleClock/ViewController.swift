//
//  ViewController.swift
//  SimpleClock
//
//  Created by Tatum Manning on 6/8/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var dateTime: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var timerButton: UIButton!
    
    var dateTimer = Timer()
    
    var timer = Timer()
    
    var timeLeft : TimeInterval = 60.0
    
    var timerString : String?
    
    var alarmSound: AVAudioPlayer?
   
    var alarmSounding : Bool = false
    
    var daylightBackground : Bool = false
    

    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        dateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(displayDateTime), userInfo: nil, repeats: true)
        timerLabel.text = ""
        changeBackground()
    }
    
    
    @IBAction func selectTimer(_ sender: UIDatePicker) {
        timeLeft = sender.countDownDuration
    }
    
    @IBAction func startTimer(_ sender: UIButton) {
        
        if !alarmSounding {
            
            timer.invalidate()
            
            timeLeft = datePicker.countDownDuration
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(beginCountDown), userInfo: nil, repeats: true)
        } else {
            alarmSound?.stop()
            timerButton.setTitle("Start Timer", for: .normal)
            alarmSounding = false
        }
       
    }
    
    @objc func beginCountDown() {
        
        
        if timeLeft >= 0.0 {
       
            timerLabel.text = "Time remaining: \(setTimerFormat(timeLeft))"
            timeLeft -= 1.0
            
        } else {
            
            timer.invalidate()
            timerLabel.text = ""
            playAlarm()
            alarmSounding = true
            timerButton.setTitle("Stop Music", for: .normal)
        }

    }
    
    func playAlarm() {
        let path = Bundle.main.path(forResource: "alarm.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            alarmSound = try AVAudioPlayer(contentsOf: url)
            alarmSound?.play()
        } catch {
            // couldn't load file :(
            print("Couldn't find file")
        }
    }
    
    func setTimerFormat(_ interval: TimeInterval) -> String {
        
        let time = Int(interval)
        let secs = time % 60
        let mins = (time / 60) % 60
        let hours = (time / 3600)
        timerString = String(format: "%0.2d:%0.2d:%0.2d",hours,mins,secs)
        
        return timerString!
    }
    
    
    @objc func displayDateTime() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
        let formattedDate = dateFormatter.string(from: Date())
        
        if isDay() && !daylightBackground {
            changeBackground()
        }
        
        dateTime.text = formattedDate
        
    }
    
    func changeBackground() {

        let daylightImg = UIImage(named: "daylightImage")
        let nightskyImg = UIImage(named: "nightskyImage")
        if isDay() {
            backgroundImage.image = daylightImg
            daylightBackground = true
        } else {
            backgroundImage.image = nightskyImg
            daylightBackground = false
        }
    }
    
    func isDay() -> Bool {
        var isAM : Bool = false;
        let amPmFormatter = DateFormatter()
        amPmFormatter.dateFormat = "a" // "a" prints "pm" or "am"
        let dayString = amPmFormatter.string(from: Date())
        
        if dayString == "AM" {
            isAM = true;
        } else {
            isAM = false;
        }
        
        return isAM
        
    }
}

/*
 func changeBackground() {
     let hour = Calendar.current.component(.hour, from: Date())
     let daylightImg = UIImage(named: "daylightImage")
     let nightskyImg = UIImage(named: "nightskyImage")
     
     switch hour {
         case 1...11:
             backgroundImage.image = daylightImg
         case 12...24:
             backgroundImage.image = nightskyImg
         default:
            backgroundImage.image = daylightImg
      }
 }
 */


