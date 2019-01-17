//
//  BaseViewControllerRx.swift
//  CoreProject
//
//  Created by ha.van.duc on 1/5/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class BaseViewController: UIViewController {
    var bag = DisposeBag()

    private var _svIndicator: IndicatorCustomView?
    var svIndicator: IndicatorCustomView {
        if _svIndicator == nil {
            _svIndicator = IndicatorCustomView(frame: UIScreen.main.bounds)
        }
        return _svIndicator!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge()
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = false
        setupUI()
        setupRx()
    }

    func setupUI() {}
    func setupRx() {}

    deinit {
        Logger.log(msg: "\(self.className) deinit")
    }
}
