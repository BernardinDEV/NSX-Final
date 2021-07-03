//
//  NsxListViewController.swift
//  NSX
//
//  Created by bernardo frisso on 03/07/21.
//

import Foundation
import UIKit
import RxSwift
import Alamofire

class NsxListViewController: UIViewController {

    // MARK: Enums
    enum ContextIdentifier: String {
        case nsxContext = "nsxContext"
    }

    // MARK: Properties
    private var bag = DisposeBag()
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    private var refreshControl = UIRefreshControl()
    var viewModel = NsxListViewModel()

    // MARK: Outlets
    @IBOutlet var carCollectionView: UICollectionView!

    // MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.setupActivityIndicator()
        self.viewModel.fetchCars()
        self.bindUI()
    }

    // MARK: Methods
    private func setupCollectionView() {
        self.carCollectionView.dataSource = self
        self.carCollectionView.delegate = self
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.carCollectionView.refreshControl = self.refreshControl

    }

    @objc func refresh(_ sender: AnyObject) {
      self.viewModel.fetchCars()
    }

    private func setupActivityIndicator() {
        self.activityIndicator.center = self.view.center
        self.view.addSubview(self.activityIndicator)
    }

    private func bindUI() {
        self.viewModel.loading.subscribe(onNext: { [weak self] isLoading in
            isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            self?.activityIndicator.isHidden = !isLoading
        }).disposed(by: self.bag)

        self.viewModel.refreshing.subscribe(onNext: { [weak self] isRefreshing in
            isRefreshing ? self?.refreshControl.beginRefreshing() : self?.refreshControl.endRefreshing()
        }).disposed(by: self.bag)

        self.viewModel.cars.subscribe(onNext: { [weak self] cars in
            self?.carCollectionView.reloadData()
        }).disposed(by: self.bag)

        self.viewModel.error.subscribe(onNext: { [weak self] error in
            if let error = error {
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Tentar novamente", style: .default, handler: { action in
                  self?.viewModel.fetchCars()
                }))

                self?.present(alert, animated: true, completion: nil)
            }
        }).disposed(by: self.bag)
    }
}

// MARK: CollectionViewDelegate
extension NsxListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.carCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarCollectionViewCell", for: indexPath) as! CarCollectionViewCell
        let picture = self.viewModel.picture(at: indexPath)

        if picture == nil {
            DispatchQueue.main.async {
                self.viewModel.fetchPicture(to: indexPath) {
                    if self.viewModel.shouldReloadCell(at: indexPath) {
                        self.carCollectionView.reloadItems(at: [indexPath])
                    }
                }
            }
        }

        cell.setPicture(picture)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewModel.fetchMoreCarsIfNeeded(at: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

      guard let car = self.viewModel.nsx(at: indexPath) else { return nil}
        guard let picture = self.viewModel.picture(at: indexPath) else { return nil }

        let menu = UIContextMenuConfiguration(identifier: car.menuID, previewProvider: {
            return CarPreviewViewController(picture: picture)
        }, actionProvider: { _ in
            return UIMenu(title: car.title, image: nil, identifier: nil, options: [], children: [
                UIAction(title: "Like", image: UIImage(systemName: "heart.fill")) {_ in
                    print("like action")
                },
                UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) {_ in
                    DispatchQueue.main.async {
                        guard let url = URL(string: car.link) else { return }
                        let shareViewController = UIActivityViewController(activityItems: [car.title, url, picture], applicationActivities: nil)
                        self.present(shareViewController, animated: true, completion: nil)
                    }
                }
            ])
        })

        return menu
    }
}

// MARK: Collection View Flow Delegate
extension NsxListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.viewModel.sizeForItemAt(indexPath, maxWidth: collectionView.bounds.width)
    }
}
