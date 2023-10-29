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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        SpeedSlider.value = Float((gameSceneVC?.score)!)
    }
    
    @IBAction func SpeedSilderAction(_ sender: UISlider) {
        gameSceneVC?.score = Int(SpeedSlider.value)
        
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
