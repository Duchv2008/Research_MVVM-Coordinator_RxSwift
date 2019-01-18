//
//  TutorialViewController.swift
//  MVVM-Coordinator
//
//  Created by ha.van.duc on 1/17/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TutorialViewController: BaseViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var pageControlView: UIPageControl!
    private var images = ["tutorial_1", "tutorial_2", "tutorial_3"]
    private var tutorialCompleted = PublishSubject<Void>()
    private var currentIndex: Int = 0
    var viewModel: TutorialViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    override func setupRx() {
        let input = TutorialViewModel.Input(tutorialTrigger: tutorialCompleted)
        _ = viewModel.transform(input: input)
    }

    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(nibWithCellClass: TutorialCollectionViewCell.self)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout

        pageControlView.numberOfPages = images.count
        bottomView.backgroundColor = .clear
    }
}

extension TutorialViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier:
                TutorialCollectionViewCell.className, for: indexPath) as? TutorialCollectionViewCell else {
                    return UICollectionViewCell()
        }
        let imageString = images[indexPath.row]
        let color = indexPath.row == 0 ? UIColor.blue : indexPath.row == 1 ? UIColor.red : UIColor.green
        cell.configure(imageString: imageString, color: color)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension TutorialViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = self.collectionView.bounds.size.width
        let newIndex = Int(ceil(offSet/width))
        if newIndex == currentIndex && newIndex == images.count - 1 {
            tutorialCompleted.onNext(())
        }
        currentIndex = Int(ceil(offSet/width))
        pageControlView.currentPage = currentIndex
    }
}
