//
//  HomeViewController.swift
//  MovieApp
//
//  Created by user238852 on 09/04/24.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedDrinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkCell", for: indexPath) as! DrinkTableViewCell

            let drink = fetchedDrinks[indexPath.row]
            cell.drinkNameLabel.text = drink.strDrink

            // Load the drink image asynchronously
            if let imageURL = URL(string: drink.strDrinkThumb) {
                URLSession.shared.dataTask(with: imageURL) { data, response, error in
                    if let data = data {
                        DispatchQueue.main.async {
                            cell.drinkImageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }

            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Handle drink selection if needed
        }
    

    @IBOutlet weak var inputField: UITextField!
    
    @IBOutlet weak var switchButton: UISwitch!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var moreInfoButton: UIButton!
    
    
    @IBOutlet weak var searchButton: UIButton!

    var fetchedDrinks: [DrinkModel] = []
    var movie: MovieModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
    }

    // Setting a func that will clear the labels, image view and buttons initially
    func setupScreen() {

        tableView.dataSource = self
        tableView.delegate = self
        moreInfoButton.isHidden = true

        // Setting up the navigation bar
        navigationItem.title = "Home"
        let watchlistButton = UIBarButtonItem(image: UIImage(systemName: "video"), style: .plain, target: self, action: #selector(watchlistButtonTapped))
        navigationItem.rightBarButtonItem = watchlistButton

        // Setting the UITextField delegate to self
        inputField.delegate = self

        // Adding target action for moreInfoButton
        moreInfoButton.addTarget(self, action: #selector(moreInfoButtonTapped), for: .touchUpInside)
    }

    @IBAction func searchButtonTapped(_ sender: UIButton) {
        performSearch()
    }

    // UITextFieldDelegate method to handle return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSearch()
        return true
    }

    func performSearch() {
            let category = switchButton.isOn ? "Alcoholic" : "Non_Alcoholic"
            NetworkingManager.shared.searchForDrink(category: category) { drinks, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let drinks = drinks {
                    print("Drinks: \(drinks)")

                    DispatchQueue.main.async {
                        self.updateUI(with: drinks)
                    }
                }
            }

            inputField.resignFirstResponder()
        }

       
    func updateUI(with drinks: [DrinkModel]) {
            self.fetchedDrinks = drinks
            self.tableView.reloadData()
        }
    
 

    @objc func moreInfoButtonTapped() {
        // Checking if there is a movie object set in the UI
        guard let movie = movie else {
            return
        }

        // Instantiating the DetailViewController
        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController

        // Passing the selected movie to the detail view controller
        detailViewController.movie = movie

        // Pushing the detail view controller to the navigation stack
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    @IBAction func watchlistButtonTapped(_ sender: UIBarButtonItem) {
        // Showing the watchlist screen
        let watchlistViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WatchlistViewController") as! WatchlistViewController
        navigationController?.pushViewController(watchlistViewController, animated: true)
    }
}
