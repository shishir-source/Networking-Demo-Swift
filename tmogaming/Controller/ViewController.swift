//
//  ViewController.swift
//  tmogaming
//
//  Created by Shishir Ahmed on 1/7/20.
//  Copyright © 2020 Shishir Ahmed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var movieCollection: UICollectionView!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var searchView: UIView!
    
    var movies = [D]()
    
    var currentSearchTask: URLSessionDataTask?
    
    var selectedIndex = 0

    fileprivate func searchBar() {
        searchView.layer.borderColor = UIColor.lightGray.cgColor
        searchView.layer.borderWidth = 2
        searchView.layer.cornerRadius = 10
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 43, height: 43))
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.contentMode = .scaleAspectFill
        
        searchText.rightView = imageView
        searchText.rightViewMode = .always
        imageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar()
        
        movieCollection.register(MovieCell.nib(), forCellWithReuseIdentifier: MovieCell.identfier)
        movieCollection.dataSource = self
        movieCollection.delegate = self
        movieCollection.keyboardDismissMode = .onDrag
        
        searchText.delegate = self
        
        searchText.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as! MovieDetailsVC
            vc.movie = movies[selectedIndex]
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        movies.removeAll()
        guard let searchText = textField.text else{return}
        Client.newSearch(query: searchText) { [weak self] (d, error) in
            self?.movies = d
            self?.movieCollection.reloadData()
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
        if let text = searchText.text {
            movies.removeAll()
            Client.newSearch(query: text) { [weak self] (d, error) in
                self?.movies = d
                self?.movieCollection.reloadData()
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension ViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout , UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count > 0 ? movies.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identfier, for: indexPath) as! MovieCell
        
        cell.configure(movie: movies[indexPath.row])
        
        cell.backgroundColor = .gray
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: movieCollection.frame.width / 2 - 5 , height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
}
