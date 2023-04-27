//
//  SimpsonsCharactersListViewController.swift
//  Simpsonsviewer
//
//  Created by Venkata K on 4/27/23.
//

import Foundation

import UIKit
import SDWebImage

class SimpsonsCharactersListViewController: UITableViewController, UISearchResultsUpdating {
    private var characters: [Character] = []
    private var filteredCharacters: [Character] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Simpsons Characters"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CharacterCell")
        fetchCharacters()

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Characters"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func fetchCharacters() {
        guard let url = URL(string: "https://api.duckduckgo.com/?q=simpsons+characters&format=json") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let relatedTopics = jsonResponse["RelatedTopics"] as? [[String: Any]] {
                        self.characters = relatedTopics.compactMap { relatedTopic in
                            guard let name = relatedTopic["Text"] as? String,
                                  let description = relatedTopic["FirstURL"] as? String else {
                                return nil
                            }

                            let icon = relatedTopic["Icon"] as? [String: Any]
                            let imageUrl = icon?["URL"] as? String

                            return Character(name: name, description: description, imageUrl: "https://duckduckgo.com"+(imageUrl ?? ""))
                        }

                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                } catch let error {
                    print("Error: \(error)")
                }
            }
        }.resume()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCharacters.isEmpty ? characters.count : filteredCharacters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)
        let character = filteredCharacters.isEmpty ? characters[indexPath.row] : filteredCharacters[indexPath.row]
        cell.textLabel?.text = character.name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let characterDetailVC = CharacterDetailViewController()
        characterDetailVC.character = filteredCharacters.isEmpty ? characters[indexPath.row] : filteredCharacters[indexPath.row]
        navigationController?.pushViewController(characterDetailVC, animated: true)
    }

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredCharacters = characters.filter { character in
                character.name.lowercased().contains(searchText.lowercased()) || character.description.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredCharacters = []
        }
        tableView.reloadData()
    }
}

