//
//  CharacterDetailViewController.swift
//  Simpsonsviewer
//
//  Created by Venkata K on 4/26/23.
//
import UIKit
import SwiftSoup
import SDWebImage

class CharacterDetailViewController: UIViewController {

    var character: Character?
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // Add subviews
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        view.addSubview(nameLabel)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        view.addSubview(descriptionLabel)

        // Set constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])

        // Populate views
        if let character = character {
            nameLabel.text = character.name
            descriptionLabel.text = character.description
            
            if let imageUrlString = character.imageUrl, let imageUrl = URL(string: imageUrlString) {
                imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "error"))
            } else {
                imageView.image = UIImage(named: "error")
            }
        }
    }

    func fetchImageFromWikipedia(url: URL, completion: @escaping (URL?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let html = String(data: data, encoding: .utf8) {
                do {
                    let document = try SwiftSoup.parse(html)
                    if let imgElement = try document.select("img").first(),
                       let imgSrc = try imgElement.attr("src").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                       let imgUrl = URL(string: imgSrc) {
                        completion(imgUrl)
                    } else {
                        completion(nil)
                    }
                } catch {
                    print("Error: \(error)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }

}
