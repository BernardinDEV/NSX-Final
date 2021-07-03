//
//  NsxDetatilViewModel.swift
//  NSX
//
//  Created by bernardo frisso on 03/07/21.
//
import Foundation
import Alamofire
import RxSwift
import RxCocoa

struct NsxListViewModelConstants {
    static let rowNearEndToFetch = 12
}

class NsxListViewModel {

    // MARK: Properties
    private var networkService: NetworkServiceProtocol
    private var imageService: ImageServiceProtocol
    private var pictures: [String:UIImage] = [:]
    private var downloadedPictures: [String: Bool] = [:]
    private var nextPage: Int = 0
    var error = BehaviorRelay<AFError?>(value: nil)
    var loading = BehaviorRelay<Bool>(value: false)
    var refreshing = BehaviorRelay<Bool>(value: false)
    var cars = BehaviorRelay<[Nsx]>(value: [])

    // MARK: Initializers
    init(networkService: NetworkServiceProtocol = NetworkService(), imageService: ImageServiceProtocol = ImageService()) {
        self.networkService = networkService
        self.imageService = imageService
    }

    // MARK: Methods
    func setNetworkService(_ networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func setImageService(_ imageService: ImageServiceProtocol) {
        self.imageService = imageService
    }

    func nsx(at indexPath: IndexPath) -> Nsx? {
        if !self.cars.value.indices.contains(indexPath.row) {
            return nil
        }
        return self.cars.value[indexPath.row]
    }

    func car(by menuConfiguration: UIContextMenuConfiguration) -> Nsx? {
        return self.cars.value.item(for: menuConfiguration)
    }

    func picture(at indexPath: IndexPath) -> UIImage? {
        if let nsx = self.nsx(at: indexPath) {
            return self.pictures[nsx.id]
        }

        return nil
    }

    func picture(by menuConfiguration: UIContextMenuConfiguration) -> UIImage? {
        if let nsx = self.car(by: menuConfiguration) {
            return self.pictures[nsx.id]
        }

        return nil
    }

    func shouldReloadCell(at indexPath: IndexPath) -> Bool {
        return self.nsx(at: indexPath) != nil
    }

    func carCount() -> Int {
        return self.cars.value.count
    }

    func sizeForItemAt(_ indexPath: IndexPath, maxWidth: CGFloat) -> CGSize {
        let nsx = self.nsx(at: indexPath)
        if indexPath.row % 13 == 0 {

            if let coverWidth = nsx?.coverWidth, let coverHeight = nsx?.coverHeight {
                return CGSize.sizeProportion(maxWidth: maxWidth, withGivenWidth: CGFloat(coverWidth), andHeight: CGFloat(coverHeight))
            }

            return CGSize(width: maxWidth, height: maxWidth)
        }

        let size = (maxWidth / 3) - 10

        return CGSize(width: size, height: size)
    }

    func fetchPicture(to indexPath: IndexPath, completion: @escaping () -> Void) {
        guard let car = self.nsx(at: indexPath) else { return }

        if !self.downloadedPictures.keys.contains(car.id) {
            self.imageService.downloadImage(from: car.directLink()) { [weak self] response in
                if case .success(let picture) = response.result {
                    self?.pictures[car.id] = picture
                    completion()
                }
            }
        }

        self.downloadedPictures[car.id] = true
    }

    func fetchCars(isRefreshing: Bool = false) {
        if isRefreshing {
            self.refreshing.accept(true)
        } else if self.carCount() == 0 {
            self.loading.accept(true)
        }

      self.networkService.fetchNsx(page: self.nextPage, completion: { response in
            switch response.result {
            case.success(let carRusult):
                self.cars.accept(self.cars.value + carRusult.data)
                self.nextPage += 1
                break
            case .failure(let error):
                self.error.accept(error)
                break
            }
            self.loading.accept(false)
            self.refreshing.accept(false)
        })
    }

    func fetchMoreCarsIfNeeded(at indexPath: IndexPath) {
        if indexPath.row == (self.carCount() - NsxListViewModelConstants.rowNearEndToFetch) {
          self.fetchCars()
        }
    }

    func refreshCars() {
        self.cars.accept([])
        self.nextPage = 0
        self.fetchCars(isRefreshing: true)
    }

    func detailViewController(at indexPath: IndexPath) -> CarDetailViewController? {
        guard let car = self.nsx(at: indexPath) else { return nil}
        guard let picture = self.picture(at: indexPath) else { return nil }
        let viewModel = NsxDetailViewModel(nsx: car, picture: picture)
        let viewController = CarDetailViewController()
        viewController.viewModel = viewModel
        return viewController
    }

    func detailViewController(by menuConfiguration: UIContextMenuConfiguration) -> CarDetailViewController? {
        guard let nsx = self.car(by: menuConfiguration) else { return nil}
        guard let picture = self.picture(by: menuConfiguration) else { return nil }
        let viewModel = NsxDetailViewModel(nsx: nsx, picture: picture)
        let viewController = CarDetailViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
