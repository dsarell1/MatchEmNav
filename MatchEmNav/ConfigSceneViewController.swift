//
//  ConfigSceneViewController.swift
//  MatchEmNav
//
//  Created by Dylan Sarell on 10/29/23.
//

import UIKit

class ConfigSceneViewController: UIViewController {

    var gameSceneVC: GameSceneViewController?
    
    @IBOutlet weak var SpeedSlider: UISlider!
    @IBOutlet weak var bigRecToggle: UISwitch!
    @IBOutlet weak var gameTimerStepper: UIStepper!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        SpeedSlider.value = Float(1 / (gameSceneVC?.newRectInterval)!)
        bigRecToggle.isOn = (gameSceneVC?.bigRec)!
        gameTimerStepper.value = Double((gameSceneVC?.timeRemaining)!)
    }
    
    @IBAction func SpeedSilderAction(_ sender: UISlider) {
        var rate = 1.0 / Double(SpeedSlider.value)
        //gameSceneVC?.newRectInterval = Double(SpeedSlider.value)
        gameSceneVC?.newRectInterval = rate
    }
    
    @IBAction func bigRecAction(_ sender: UISwitch) {
        gameSceneVC?.bigRec = bigRecToggle.isOn
    }
    @IBAction func gameTimerAction(_ sender: UIStepper) {
        gameTimerStepper.minimumValue = 10
        gameTimerStepper.maximumValue = 60
        gameSceneVC?.timeRemaining = Int(gameTimerStepper.value)
    }
    
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
