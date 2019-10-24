//
//  PhotoChooserViewController.swift
//  PhotoChooser
//
//  Created by Harut Mikichyan on 10/21/19.
//  Copyright © 2019 Harut Mikichyan. All rights reserved.
//


import UIKit

class PhotoChooserViewController: UIViewController {
    
    //MARK: - Properties
    private var isZoom = false
    private var isCrop = false
    private var tap: UITapGestureRecognizer!
    private var selectedIndexPath: Int = 0
    
    private let photoChooserCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private let collectionHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        let subView = UIView()
        let subViewHeight: CGFloat = 4
        view.addSubview(subView)
        subView.backgroundColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
        subView.layer.cornerRadius = subViewHeight / 2
        //Add Constraints
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.heightAnchor.constraint(equalToConstant: subViewHeight).isActive = true
        subView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        subView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        return view
    }()
    
    private let selectedImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        return iv
    }()
    
    private let selectedImageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 1
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.flashScrollIndicators()
        scrollView.bounces = true
        scrollView.backgroundColor = .black
        return scrollView
    }()
    
    private let cropButton: UIButton = {
        let cropBtn = UIButton(type: .custom)
        cropBtn.isUserInteractionEnabled = true
        cropBtn.backgroundColor = .black
        cropBtn.setImage(#imageLiteral(resourceName: "crop"), for: .normal)
        cropBtn.layer.cornerRadius = 30
        cropBtn.layer.masksToBounds = true
        cropBtn.addTarget(self, action: #selector(cropButtonTapped), for: .touchUpInside)
        return cropBtn
    }()
    
    private let zoomButton: UIButton = {
        let cropBtn = UIButton(type: .custom)
        cropBtn.isUserInteractionEnabled = true
        cropBtn.backgroundColor = .black
        cropBtn.setImage(#imageLiteral(resourceName: "zoom"), for: .normal)
        cropBtn.layer.cornerRadius = 30
        cropBtn.layer.masksToBounds = true
        //        cropBtn.imageView?.image = #imageLiteral(resourceName: "crop")
        cropBtn.addTarget(self, action: #selector(zoomButtonTapped), for: .touchUpInside)
        return cropBtn
    }()
    
    @IBOutlet weak var controlBarView: UIView!
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        view.bringSubviewToFront(cropButton)
        view.bringSubviewToFront(zoomButton)
        
        photoChooserCollectionViewAddAutoLayout()
        collectionHeaderViewAddAutoLayout()
        selectedImageScrollViewAddAutoLayout()
        selectedImageAddAutoLayout()
        cropZoomButtonsAddAutoLayout()
        
        photoChooserCollectionView.delegate = self
        photoChooserCollectionView.dataSource = self
        selectedImageScrollView.delegate = self
        photoChooserCollectionView.register(PhotoChooserCollectionViewCell.self, forCellWithReuseIdentifier: PhotoChooserCollectionViewCell.id)
        
        setupScrollViewPanGesture()
    }
    
    @objc func handleDoubleTap(tap:UITapGestureRecognizer){
        if selectedImageScrollView.zoomScale > selectedImageScrollView.minimumZoomScale {
            selectedImageScrollView.setZoomScale(selectedImageScrollView.minimumZoomScale, animated: true)
        } else {
            let location = tap.location(in: selectedImage)
            let rect = CGRect(x: location.x, y: location.y, width: 1, height: 1)
            selectedImageScrollView.zoom(to: rect, animated: true)
        }
    }
    
    @objc func zoomButtonTapped() {
        isZoom = !isZoom
        selectedImageScrollView.maximumZoomScale = isZoom ? 2 : 1
        selectedImageScrollView.minimumZoomScale = isZoom ? 0.05 : 1
        cropButton.isHidden = isZoom
        isZoom ? selectedImageScrollView.addGestureRecognizer(tap) : selectedImageScrollView.removeGestureRecognizer(tap)
    }
    
    @objc func cropButtonTapped() {
        //TODO: - Create CropView
    }
    
    //MARK: - Actions
    @IBAction func dismissPhotoChooserViewController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Private Interface
    private func addSubViews() {
        view.addSubview(photoChooserCollectionView)
        view.addSubview(collectionHeaderView)
        view.addSubview(selectedImageScrollView)
        selectedImageScrollView.addSubview(selectedImage)
        view.addSubview(cropButton)
        view.addSubview(zoomButton)
    }
    
    private func setupScrollViewPanGesture() {
        tap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(tap:)))
        tap.numberOfTapsRequired = 2
        selectedImageScrollView.addGestureRecognizer(tap)
    }
    
    private func centerContent() {
        let imageViewSize = selectedImage.frame.size
        var vertical:CGFloat = 0, horizontal:CGFloat = 0
        
        if imageViewSize.width < selectedImageScrollView.bounds.size.width  {
            vertical = (selectedImageScrollView.bounds.size.width - imageViewSize.width) / 2.0
        }
        
        if imageViewSize.height < selectedImageScrollView.bounds.size.height  {
            horizontal = (selectedImageScrollView.bounds.size.height - imageViewSize.height) / 2.0
        }
        
        selectedImageScrollView.contentInset = UIEdgeInsets(top: horizontal, left: vertical, bottom: horizontal, right: vertical)
    }
    
    //MARK: - Constraint Methods
    private func selectedImageScrollViewAddAutoLayout() {
        selectedImageScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        selectedImageScrollView.bottomAnchor.constraint(equalTo: collectionHeaderView.topAnchor).isActive = true
        selectedImageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        selectedImageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        selectedImageScrollView.topAnchor.constraint(equalTo: controlBarView.bottomAnchor).isActive = true
    }
    
    private func photoChooserCollectionViewAddAutoLayout() {
        photoChooserCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        photoChooserCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        photoChooserCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        photoChooserCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        photoChooserCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4).isActive = true
    }
    
    private func collectionHeaderViewAddAutoLayout() {
        collectionHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionHeaderView.bottomAnchor.constraint(equalTo: photoChooserCollectionView.topAnchor).isActive = true
        collectionHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionHeaderView.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func selectedImageAddAutoLayout() {
        selectedImage.translatesAutoresizingMaskIntoConstraints = false
        
        selectedImage.topAnchor.constraint(equalTo: selectedImageScrollView.topAnchor).isActive = true
        selectedImage.bottomAnchor.constraint(equalTo: selectedImageScrollView.bottomAnchor).isActive = true
        selectedImage.heightAnchor.constraint(equalTo: selectedImageScrollView.heightAnchor).isActive = true
        selectedImage.widthAnchor.constraint(equalTo: selectedImageScrollView.widthAnchor).isActive = true
    }
    
    private func cropZoomButtonsAddAutoLayout() {
        cropButton.translatesAutoresizingMaskIntoConstraints = false
        zoomButton.translatesAutoresizingMaskIntoConstraints = false
        //cropButton Constraint
        cropButton.bottomAnchor.constraint(equalTo: collectionHeaderView.topAnchor, constant: -40).isActive = true
        cropButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        cropButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        cropButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        //zoomButton Constraint
        zoomButton.bottomAnchor.constraint(equalTo: collectionHeaderView.topAnchor, constant: -40).isActive = true
        zoomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        zoomButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        zoomButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
}

extension PhotoChooserViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeader = CGFloat(10)
        let cellFooter = CGFloat(20)
        return CGSize(width: collectionView.bounds.height / 2, height: collectionView.bounds.height - cellHeader - cellFooter)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage.image = UIImage(named: "testImage")
        //idHidden checkMark
        let isSelected = selectedIndexPath == indexPath.row
        if !isSelected {
            selectedIndexPath = indexPath.row
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoChooserCollectionViewCell.id, for: indexPath) as! PhotoChooserCollectionViewCell
        let isSelected = selectedIndexPath == indexPath.row
        cell.changeCheckMarkStatus(isSelected: !isSelected)
        cell.imageView.image = UIImage(named: "testImage")
        
        if indexPath.row == 0 {
            selectedImage.image = UIImage(named: "testImage")
        }
        return cell
    }
}

extension PhotoChooserViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.selectedImage
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerContent()
    }
}
