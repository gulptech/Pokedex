//
//  PokemonDetailVC.swift
//  Pokedex-GulpTech
//
//  Created by Joseph Pilon on 3/28/16.
//  Copyright © 2016 Gulp Technologies. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var baseAttackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name.uppercaseString
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        pokemon.downloadPokemonDetails { () -> () in
            // This will run when complete
            self.updateUI()
        }
    }
    
    func updateUI() {
        self.heightLbl.text = self.pokemon.height
        self.weightLbl.text = self.pokemon.weight
        self.baseAttackLbl.text = self.pokemon.attack
        self.defenseLbl.text = self.pokemon.defense
        self.typeLbl.text = self.pokemon.type
        self.pokedexLbl.text = self.pokemon.pokedexId
        self.descriptionLbl.text = self.pokemon.description
        nextEvoImg.image = UIImage(named: "\(pokemon.nextEvo)")
        evoLbl.text = self.pokemon.nextEvoText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
