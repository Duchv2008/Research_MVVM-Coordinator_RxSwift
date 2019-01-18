//
//  ViewController.swift
//  MVVM-Coordinator
//
//  Created by ha.van.duc on 1/16/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MainViewController: BaseViewController {
    @IBOutlet private weak var logoutBtn: UIButton!
    var viewModel: MainViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupRx() {
        let input = MainViewModel.Input(logoutTrigger: logoutBtn.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        output.loading
            .bind { [weak self] isLoading in
                guard let `self` = self else { return }
                self.svIndicator.isShow(isLoading)
            }.disposed(by: bag)

        output.error
            .bind { [weak self] error in
                guard let `self` = self else { return }
                self.showErrorAlert(error.message)
            }.disposed(by: bag)
    }
}
