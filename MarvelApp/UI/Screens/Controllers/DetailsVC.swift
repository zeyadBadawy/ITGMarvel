//
//  DetailsVC.swift
//  MarvelApp
//
//  Created by zeyad on 1/27/21.
//  Copyright © 2021 zeyad. All rights reserved.
//

import UIKit

class DetailsVC: DataLoadingVC {
    
    //MARK:- UI + Vars

    let scrollView = UIScrollView()
    let contentView = UIView()
    var collectionView:UICollectionView!
    let characterImageView = UIImageView()
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let comicLabel = UILabel()
    
    
    var character:MCharcter!
    var comics = [ComicsResult]()
    var presenter: DetailsPresenter?
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        layoutUI()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
        self.presenter = DetailsPresenter(delegate: self)
        self.presenter?.getCharcterDetails(id: self.character.id ?? 0)
    }
    
    //MARK:- UI layout and configurations
    private func setupUI(){
        view.backgroundColor = .lightGray
        nameLabel.font = UIFont.systemFont(ofSize: 30)
        descriptionLabel.font = UIFont.systemFont(ofSize: 15)
        descriptionLabel.numberOfLines = 0
        comicLabel.font = UIFont.systemFont(ofSize: 30)
        comicLabel.textColor = .red
        comicLabel.text = "Comics"
    }
    
    private func configureCollectionView(){
        let flowLayout = UIHelper.getSliderFolwLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ComicCell.self, forCellWithReuseIdentifier: ComicCell.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
    }
    
    private func updateUI(){
        let thumbnailPath = self.character.thumbnail?.path ?? ""
        let extensiton = self.character.thumbnail?.thumbnailExtension?.rawValue ?? ""
        let urlString =  "\(thumbnailPath).\(extensiton)"
        self.characterImageView.downloadImage(fromURL: urlString)
        self.nameLabel.text = character.name ?? ""
        self.title = character.name ?? ""
        self.descriptionLabel.text = character.resultDescription ?? ""
    }

    private func layoutUI(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        characterImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        comicLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToTheEdges(of: view)
        contentView.pinToTheEdges(of: scrollView)
        contentView.addSubViews(characterImageView , nameLabel , descriptionLabel , comicLabel,collectionView, comicLabel)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor) ,
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor) ,
            characterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor) ,
            characterImageView.heightAnchor.constraint(equalToConstant: 300) ,
            
            nameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 32),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            comicLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            comicLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            comicLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            collectionView.topAnchor.constraint(equalTo: comicLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
}
//MARK:- Presenter

extension DetailsVC: DetailsDelegate {
    func requestSucceed(comics: [ComicsResult]) {
        self.comics = comics
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func showProgressView() {
        self.showLoadingView()
    }
    
    func hideProgressView() {
        self.dismissLoadingView()
    }
    
    func requestDidFailed(message: String) {
        self.presentAlertOnMainThread(title: "Server error", messaeg: message, buttonTitle: "OK")
    
    }
}
//MARK:- CollectionView

extension DetailsVC: UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.comics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicCell.reuseID, for: indexPath) as! ComicCell
        cell.set(comic: self.comics[indexPath.item])
        cell.backgroundColor = .red
        cell.layer.cornerRadius = 12 
        return cell
    }
}
