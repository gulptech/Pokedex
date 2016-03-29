//
//  Pokemon.swift
//  Pokedex-GulpTech
//
//  Created by Joseph Pilon on 3/27/16.
//  Copyright © 2016 Gulp Technologies. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: String!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _baseAttack: String!
    private var _nextEvoText: String!
    private var _firstEvo: String!
    private var _nextEvo: String!
    private var _pokemonUrl: String!
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
    var pokedexId: String {
        if _pokedexId == nil {
            _pokedexId = "0"
        }
        return _pokedexId
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var attack: String {
        if _baseAttack == nil {
            _baseAttack = ""
        }
        return _baseAttack
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var weight: String {
        return _weight
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var nextEvoText: String {
        if _nextEvoText == nil {
            _nextEvoText = "This pokemon does not evolve"
        }
        return _nextEvoText

    }
    var firstEvo: String {
        if _firstEvo == nil {
            _firstEvo = ""
        }
        return _firstEvo
    }
    var nextEvo: String {
        if _nextEvo == nil {
            _nextEvo = "0"
        }
        return _nextEvo
    }
    
    init(name: String, pokedexId: String) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string: self._pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let attack = dict["attack"] as? Int {
                    self._baseAttack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    if let type = types[0]["name"] {
                        self._type = type.capitalizedString
                    }
                    for i in 1..<types.count {
                        self._type = "\(self._type) / \(types[i]["name"]!.capitalizedString)"
                    }
                } else {
                    self._type = ""
                }
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    if let durl = NSURL(string: "\(URL_BASE)\(descArr[0]["resource_uri"]!)") {
                        Alamofire.request(.GET, durl).responseJSON { response in
                            let dresult = response.result
                            
                            if let descDict = dresult.value as? Dictionary<String,AnyObject> {
                                if let desc = descDict["description"] as? String {
                                    self._description = desc
                                }
                            }
                            completed()
                        }
                    }
                } else {
                    self._description = ""
                }
                
                if let evoArr = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evoArr.count > 0 {
                    
                    if let to = evoArr[0]["to"] as? String {
                        // Does not support mega (api still support mega)
                        if to.rangeOfString("mega") == nil {
                            
                            if let uri = evoArr[0]["resource_uri"] as? String {
                                let nextId = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "").stringByReplacingOccurrencesOfString("/", withString: "")
                                self._nextEvo = nextId
                            } else {
                                self._nextEvo = "0"
                            }
                            
                            if let lvl = evoArr[0]["level"] as? Int {
                                self._nextEvoText = "Next Evolution: \(to.capitalizedString) - LVL \(lvl)"
                            }
                        }
                    }
                } else {
                    self._nextEvo = "0"
                    self._nextEvoText = "This pokemon does not Evolve"
                }
            }
            completed()
        }
    }
}