//import UIKit
//let customTransitioningDelegate = CenterTransitioningDelegate()
//
//class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
//    var selectedIndex1: Int = 0
//    var loaderView = UIView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // STEP 1: Make this controller its own delegate so we can control tab selection behavior
//        self.delegate = self
//
//        // Existing loader setup
//        loaderView = UIImageView(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(self.view.frame.height)))
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 350, height: 350))
//        loaderView.backgroundColor = UIColor(named: "appGreen")
//        let imageData = try! Data(contentsOf: Bundle.main.url(forResource: "animation_fadeSmooth", withExtension: "gif")!)
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = UIImage.sd_image(withGIFData: imageData)
//        imageView.center = loaderView.center
//        loaderView.addSubview(imageView)
//        self.view.addSubview(loaderView)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { [weak self] in
//            self?.getProfile_APICall()
//        })
//    }
//
//    func setupDatabar() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
//            self?.loaderView.removeFromSuperview()
//        })
//
//        let vc1 = Storyboard.Visits.instantiateViewController(withViewClass: VisitsViewController.self)
//        let vc2 = Storyboard.Clients.instantiateViewController(withViewClass: ClientsViewController.self)
//        let vc3 = Storyboard.Alerts.instantiateViewController(withViewClass: AlertsViewController.self)
//
//        // Embed each view controller in a UINavigationController
//        let nav1 = UINavigationController(rootViewController: vc1)
//        nav1.interactivePopGestureRecognizer?.delegate = nil
//        nav1.setupBlackTintColor()
//        let nav2 = UINavigationController(rootViewController: vc2)
//        nav2.interactivePopGestureRecognizer?.delegate = nil
//        nav2.setupBlackTintColor()
//        let nav3 = UINavigationController(rootViewController: vc3)
//        nav3.interactivePopGestureRecognizer?.delegate = nil
//        nav3.setupBlackTintColor()
//
//        // Set the tab bar items
//        setupTabBarItems(vc1: vc1, vc2: vc2, vc3: vc3)
//
//        // Add view controllers to the tab bar controller
//        viewControllers = [nav1, nav2, nav3]
//
//        // Select initial tab
//        self.selectedIndex = self.selectedIndex1
//
//        // Tab bar appearance customization
//        setupTabBarAppearance()
//    }
//
//    // STEP 2: didSelect — when user selects a tab item
//    // We ensure: selecting index 0 always shows its root (first screen)
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        guard let index = tabBar.items?.firstIndex(of: item),
//              let vcs = viewControllers,
//              index < vcs.count,
//              let nav = vcs[index] as? UINavigationController else {
//            return
//        }
//
//        if index != 4 {
//            print("guru")
//            // Always reset the first tab to its root VC when selected
//            nav.popToRootViewController(animated: false)
//        } else{
//            print("notpop")
//        }
//    }
//
//    // STEP 3: shouldSelect — prevent unintended pop/reset on re-tapping tabs other than index 0
//    func tabBarController(_ tabBarController: UITabBarController,
//                          shouldSelect viewController: UIViewController) -> Bool {
//        guard let vcs = tabBarController.viewControllers,
//              let tappedIndex = vcs.firstIndex(of: viewController) else {
//            return true
//        }
//
//        // If the same tab is tapped again
//        if viewController == tabBarController.selectedViewController {
//            if tappedIndex == 0 {
//                // Allow didSelect to fire so our didSelect can pop to root for tab 0
//                return true
//            } else {
//                // For other tabs, ignore the re-tap (prevents unwanted pops/animations)
//                return false
//            }
//        }
//
//        return true
//    }
//
//    private func setupTabBarItems(vc1: VisitsViewController, vc2: ClientsViewController, vc3: AlertsViewController) {
//        vc1.tabBarItem = UITabBarItem(
//            title: "Visits",
//            image: UIImage(named: "visits")?.withRenderingMode(.alwaysTemplate),
//            selectedImage: UIImage(named: "visits")?.withRenderingMode(.alwaysTemplate)
//        )
//
//        vc2.tabBarItem = UITabBarItem(
//            title: "Clients",
//            image: UIImage(named: "clients")?.withRenderingMode(.alwaysTemplate),
//            selectedImage: UIImage(named: "clientselected")?.withRenderingMode(.alwaysTemplate)
//        )
//
//        vc3.tabBarItem = UITabBarItem(
//            title: "Alerts",
//            image: UIImage(named: "alerts")?.withRenderingMode(.alwaysTemplate),
//            selectedImage: UIImage(named: "alerts")?.withRenderingMode(.alwaysTemplate)
//        )
//    }
//
//    private func setupTabBarAppearance() {
//        let tabBarAppearance = UITabBarAppearance()
//        tabBarAppearance.backgroundColor = UIColor(named: "appGreen") ?? .green
//
//        // Normal state appearance (unselected)
//        let normalColor: UIColor = UIColor.white.withAlphaComponent(0.7)
//        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = normalColor
//        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
//            .foregroundColor: normalColor,
//            .font: UIFont.robotoSlab(.regular, size: 14)
//        ]
//
//        // Selected state appearance
//        let selectedColor: UIColor = .white
//        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = selectedColor
//        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
//            .foregroundColor: selectedColor,
//            .font: UIFont.robotoSlab(.regular, size: 14)
//        ]
//
//        tabBar.standardAppearance = tabBarAppearance
//
//        if #available(iOS 15.0, *) {
//            tabBar.scrollEdgeAppearance = tabBarAppearance
//        }
//
//        // Apply shadow to the tab bar
//        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
//        tabBar.layer.shadowRadius = 5
//        tabBar.layer.shadowColor = UIColor.black.cgColor
//        tabBar.layer.shadowOpacity = 0.80
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setupTabBarAppearance()
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        // Apply corner radius and border to the tab bar
//        let radius: CGFloat = 15
//        let borderWidth: CGFloat = 0
//
//        let borderColor = UIColor.systemGray6.cgColor
//        var bounds = tabBar.bounds
//        bounds.size = CGSize(width: bounds.width, height: bounds.height + 5)
//
//        // Corner radius mask
//        let maskPath = UIBezierPath(roundedRect: bounds,
//                                    byRoundingCorners: [.topLeft, .topRight],
//                                    cornerRadii: CGSize(width: radius, height: radius))
//
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = maskPath.cgPath
//        maskLayer.frame = bounds
//        tabBar.layer.mask = maskLayer
//
//        // Border layer
//        let borderLayer = CAShapeLayer()
//        borderLayer.path = maskPath.cgPath
//        borderLayer.frame = bounds
//        borderLayer.fillColor = UIColor.clear.cgColor
//        borderLayer.strokeColor = borderColor
//        borderLayer.lineWidth = borderWidth
//        tabBar.layer.addSublayer(borderLayer)
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//}
//
//extension MainTabViewController {
//    private func getProfile_APICall() {
//        WebServiceManager.sharedInstance.callAPI(
//            apiPath: .getAllUsers(userId: UserDetails.shared.user_id),
//            method: .get,
//            params: [:],
//            isAuthenticate: true,
//            model: CommonRespons<[ProfileModel]>.self
//        ) { response, successMsg in
//            switch response {
//            case .success(let data):
//                DispatchQueue.main.async { [weak self] in
//                    if data.statusCode == 200 {
//                        UserDetails.shared.profileModel = data.data?.first
//                    } else {
//                        self?.view.makeToast(data.message ?? "")
//                    }
//                    DispatchQueue.main.async { [weak self] in
//                        self?.setupDatabar()
//                    }
//                }
//            case .failure(let error):
//                DispatchQueue.main.async { [weak self] in
//                    self?.view.makeToast(error.localizedDescription)
//                    DispatchQueue.main.async { [weak self] in
//                        self?.setupDatabar()
//                    }
//                }
//            }
//        }
//    }
//}

import UIKit
let customTransitioningDelegate = CenterTransitioningDelegate()

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
    var selectedIndex1: Int = 0
    var loaderView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self  // IMPORTANT
        setupLoader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { [weak self] in
            self?.getProfile_APICall()
        })
    }
    
    private func setupLoader() {
        loaderView = UIImageView(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(self.view.frame.height)))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 350, height: 350))
        loaderView.backgroundColor = UIColor(named: "appGreen")
        let imageData = try! Data(contentsOf: Bundle.main.url(forResource: "animation_fadeSmooth", withExtension: "gif")!)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.sd_image(withGIFData: imageData)
        imageView.center = loaderView.center
        loaderView.addSubview(imageView)
        self.view.addSubview(loaderView)
    }

    func setupDatabar() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            self?.loaderView.removeFromSuperview()
        })

        let vc1 = Storyboard.Visits.instantiateViewController(withViewClass: VisitsViewController.self)
        let vc2 = Storyboard.Clients.instantiateViewController(withViewClass: ClientsViewController.self)
        let vc3 = Storyboard.Alerts.instantiateViewController(withViewClass: AlertsViewController.self)

        let nav1 = UINavigationController(rootViewController: vc1)
        nav1.interactivePopGestureRecognizer?.delegate = nil
        nav1.setupBlackTintColor()
        let nav2 = UINavigationController(rootViewController: vc2)
        nav2.interactivePopGestureRecognizer?.delegate = nil
        nav2.setupBlackTintColor()
        let nav3 = UINavigationController(rootViewController: vc3)
        nav3.interactivePopGestureRecognizer?.delegate = nil
        nav3.setupBlackTintColor()

        setupTabBarItems(vc1: vc1, vc2: vc2, vc3: vc3)

        viewControllers = [nav1, nav2, nav3]
        self.selectedIndex = self.selectedIndex1
        setupTabBarAppearance()
    }

    // ✅ Tab change check
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        guard let vcs = tabBarController.viewControllers,
              let tappedIndex = vcs.firstIndex(of: viewController),
              let currentNav = tabBarController.selectedViewController as? UINavigationController else {
            return true
        }

        // Check if current tab top VC is CreateAlertViewController
        if currentNav.topViewController is CreateAlertViewController {
            if tappedIndex != tabBarController.selectedIndex {
                
                // 👇 Custom Popup Controller open karo
                let vc = Storyboard.Main.instantiateViewController(withViewClass: CommonPopupViewController.self)
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve

                // 👇 Properties set karo
                vc.strImage = "profile_alert"
                vc.strTitle = "Do you want to leave without saving changes?"
                vc.strButton = "Confirm"
                vc.strCancelButton = "Cancel"
                vc.strMessage = "Any unsaved changes will be lost."

                // 👇 Button click callback
                vc.buttonClickHandler = {
                    tabBarController.selectedIndex = tappedIndex
                }

                tabBarController.present(vc, animated: true)
                return false
            }
        }

        return true
    }

    
    
    
//    func tabBarController(_ tabBarController: UITabBarController,
//                          shouldSelect viewController: UIViewController) -> Bool {
//        guard let vcs = tabBarController.viewControllers,
//              let tappedIndex = vcs.firstIndex(of: viewController),
//              let currentNav = tabBarController.selectedViewController as? UINavigationController else {
//            return true
//        }
//
//        // Check if current tab top VC is CreateAlertViewController
//        if currentNav.topViewController is CreateAlertViewController {
//            if tappedIndex != tabBarController.selectedIndex {
//                let alert = UIAlertController(title: "Unsaved Changes",
//                                              message: "Do you want to leave without saving?",
//                                              preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//                alert.addAction(UIAlertAction(title: "Leave", style: .destructive, handler: { _ in
//                    tabBarController.selectedIndex = tappedIndex
//                }))
//                tabBarController.present(alert, animated: true)
//                return false
//            }
//        }
//
//        return true
//    }

    // keep your didSelect logic (pop to root for tab 0)
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item),
              let vcs = viewControllers,
              index < vcs.count,
              let nav = vcs[index] as? UINavigationController else {
            return
        }
        if index != 4 {
            nav.popToRootViewController(animated: false)
        }
    }

    private func setupTabBarItems(vc1: VisitsViewController, vc2: ClientsViewController, vc3: AlertsViewController) {
        vc1.tabBarItem = UITabBarItem(
            title: "Visits",
            image: UIImage(named: "visits")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(named: "visits")?.withRenderingMode(.alwaysTemplate)
        )

        vc2.tabBarItem = UITabBarItem(
            title: "Clients",
            image: UIImage(named: "clients")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(named: "clientselected")?.withRenderingMode(.alwaysTemplate)
        )

        vc3.tabBarItem = UITabBarItem(
            title: "Alerts",
            image: UIImage(named: "alerts")?.withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(named: "alerts")?.withRenderingMode(.alwaysTemplate)
        )
    }

    private func setupTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor(named: "appGreen") ?? .green

        let normalColor: UIColor = UIColor.white.withAlphaComponent(0.7)
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = normalColor
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: normalColor,
            .font: UIFont.robotoSlab(.regular, size: 14)
        ]

        let selectedColor: UIColor = .white
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: selectedColor,
            .font: UIFont.robotoSlab(.regular, size: 14)
        ]

        tabBar.standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }

        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 5
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.80
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBarAppearance()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let radius: CGFloat = 15
        let borderColor = UIColor.systemGray6.cgColor
        var bounds = tabBar.bounds
        bounds.size = CGSize(width: bounds.width, height: bounds.height + 5)

        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: radius, height: radius))

        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.frame = bounds
        tabBar.layer.mask = maskLayer

        let borderLayer = CAShapeLayer()
        borderLayer.path = maskPath.cgPath
        borderLayer.frame = bounds
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor
        borderLayer.lineWidth = 0
        tabBar.layer.addSublayer(borderLayer)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MainTabViewController {
    private func getProfile_APICall() {
        WebServiceManager.sharedInstance.callAPI(
            apiPath: .getAllUsers(userId: UserDetails.shared.user_id),
            method: .get,
            params: [:],
            isAuthenticate: true,
            model: CommonRespons<[ProfileModel]>.self
        ) { response, successMsg in
            switch response {
            case .success(let data):
                DispatchQueue.main.async { [weak self] in
                    if data.statusCode == 200 {
                        UserDetails.shared.profileModel = data.data?.first
                    } else {
                        self?.view.makeToast(data.message ?? "")
                    }
                    self?.setupDatabar()
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.view.makeToast(error.localizedDescription)
                    self?.setupDatabar()
                }
            }
        }
    }
}
