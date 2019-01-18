//
//  LoginViewController.swift
//  MVVM-Coordinator
//
//  Created by ha.van.duc on 1/16/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {
    @IBOutlet private weak var usernameTF: UITextField!
    @IBOutlet private weak var usernameValidateLabel: UILabel!
    @IBOutlet private weak var passwordTF: UITextField!
    @IBOutlet private weak var passwordValidateLabel: UILabel!
    @IBOutlet private weak var loginBtn: UIButton!
    @IBOutlet private weak var registerBtn: UIButton!
    @IBOutlet private weak var forgotPasswordBtn: UIButton!

    var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTF.text = "duc@gmail.com"
        passwordTF.text = "123123"
    }

    override func setupRx() {
        let input = LoginViewModel.Input(username: usernameTF.rx.text.orEmpty.asObservable(),
                                         password: passwordTF.rx.text.orEmpty.asObservable(),
                                         loginTrigger: loginBtn.rx.tap.asObservable(),
                                         registerTrigger: registerBtn.rx.tap.asObservable(),
                                         forgotPasswordTrigger: forgotPasswordBtn.rx.tap.asObservable())
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

        output.validate
            .bind { [weak self] validate in
                guard let `self` = self else { return }
                self.loginBtn.isEnabled = validate.isPass
                self.usernameValidateLabel.text = validate.emailError
                self.passwordValidateLabel.text = validate.passwordError
            }.disposed(by: bag)
    }
}
