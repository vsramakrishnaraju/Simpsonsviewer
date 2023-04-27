//
//  CharacterDetailViewController.swift
//  Simpsonsviewer
//
//  Created by Venkata K on 4/26/23.
//
import UIKit
import SDWebImage
import SwiftSoup

class CharacterDetailViewController: UIViewController {

    var character: Character?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        view.addSubview(nameLabel)

        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        view.addSubview(descriptionLabel)

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

        if let character = character {
            nameLabel.text = character.name
            descriptionLabel.text = character.description
            
            if let wikipediaURL = URL(string: character.description) {
                fetchImageFromWikipedia(url: wikipediaURL) { imageUrl in
                    DispatchQueue.main.async {
                        if let imageUrl = imageUrl {
                            imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "default-character"))
                        } else {
                            imageView.image = UIImage(named: "default-character")
                        }
                    }
                }
            } else {
                imageView.image = UIImage(named: "default-character")
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
