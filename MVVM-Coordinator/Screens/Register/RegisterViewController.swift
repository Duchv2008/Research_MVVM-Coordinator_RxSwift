//
//  RegisterViewController.swift
//  MVVM-Coordinator
//
//  Created by ha.van.duc on 1/16/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RegisterViewController: BaseViewController {
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var haveAccountBtn: UIButton!

    var viewModel: RegisterViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupRx() {
        let input = RegisterViewModel.Input.init(username: userNameTF.rx.text.orEmpty.asObservable(),
                                                 password: passwordTF.rx.text.orEmpty.asObservable(),
                                                 registerTrigger: registerBtn.rx.tap.asObservable(),
                                                 haveAccountTrigger: haveAccountBtn.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        output.loading.bind { [weak self] isLoading in
            guard let `self` = self else {
                return
            }
            self.svIndicator.isShow(isLoading)
        }.disposed(by: bag)

        output.error.bind { [weak self] error in
            guard let `self` = self else {
                return
            }
            self.showErrorAlert(error.message)
        }.disposed(by: bag)
    }
}
