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

//import UIKit
//let customTransitioningDelegate = CenterTransitioningDelegate()
//
//class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
//    var selectedIndex1: Int = 0
//    var loaderView = UIView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.delegate = self  // IMPORTANT
//        setupLoader()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { [weak self] in
//            self?.getProfile_APICall()
//        })
//    }
//    
//    private func setupLoader() {
//        loaderView = UIImageView(frame: CGRect(x: 0, y: 0, width: Int(self.view.frame.width), height: Int(self.view.frame.height)))
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 350, height: 350))
//        loaderView.backgroundColor = UIColor(named: "appGreen")
//        let imageData = try! Data(contentsOf: Bundle.main.url(forResource: "animation_fadeSmooth", withExtension: "gif")!)
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = UIImage.sd_image(withGIFData: imageData)
//        imageView.center = loaderView.center
//        loaderView.addSubview(imageView)
//        self.view.addSubview(loaderView)
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
//        setupTabBarItems(vc1: vc1, vc2: vc2, vc3: vc3)
//
//        viewControllers = [nav1, nav2, nav3]
//        self.selectedIndex = self.selectedIndex1
//        setupTabBarAppearance()
//    }
//
//    // ✅ Tab change check
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
//                
//                // 👇 Custom Popup Controller open karo
//                let vc = Storyboard.Main.instantiateViewController(withViewClass: CommonPopupViewController.self)
//                vc.modalPresentationStyle = .overFullScreen
//                vc.modalTransitionStyle = .crossDissolve
//
//                // 👇 Properties set karo
//                vc.strImage = "profile_alert"
//                vc.strTitle = "Do you want to leave without saving changes?"
//                vc.strButton = "Confirm"
//                vc.strCancelButton = "Cancel"
//                vc.strMessage = "Any unsaved changes will be lost."
//
//                // 👇 Button click callback
//                vc.buttonClickHandler = {
//                    tabBarController.selectedIndex = tappedIndex
//                }
//
//                tabBarController.present(vc, animated: true)
//                return false
//            }
//        }
//
//        return true
//    }
//
//    
//    
//    
//
//    // keep your didSelect logic (pop to root for tab 0)
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        guard let index = tabBar.items?.firstIndex(of: item),
//              let vcs = viewControllers,
//              index < vcs.count,
//              let nav = vcs[index] as? UINavigationController else {
//            return
//        }
//        if index != 4 {
//            nav.popToRootViewController(animated: false)
//        }
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
//    
//    
//    
//    private func setupTabBarAppearance() {
//        let tabBarAppearance = UITabBarAppearance()
//        tabBarAppearance.configureWithOpaqueBackground()
//        tabBarAppearance.backgroundColor = UIColor(hex: "#EDEDED")
//
//        tabBar.isTranslucent = false
//        tabBar.backgroundColor = UIColor(hex: "#EDEDED")
//        tabBar.barTintColor = UIColor(hex: "#EDEDED")
//        tabBar.tintColor = UIColor(named: "appGreen")
//        tabBar.unselectedItemTintColor = UIColor(hex: "#1E3037")
//
//        // ✅ Normal (unselected) state
//        let normalColor = UIColor(hex: "#1E3037")
//        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = normalColor
//        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
//            .foregroundColor: normalColor,
//            .font: UIFont.robotoSlab(.regular, size: 14)
//        ]
//
//        // ✅ Selected state
//        let selectedColor = UIColor(named: "appGreen") ?? UIColor(hex: "#2E9E8F")
//        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = selectedColor
//        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
//            .foregroundColor: selectedColor,
//            .font: UIFont.robotoSlab(.regular, size: 14)
//        ]
//
//        // ✅ Remove white flash/highlight on tap
//        tabBarAppearance.stackedLayoutAppearance.highlighted.iconColor = selectedColor
//        tabBarAppearance.stackedLayoutAppearance.highlighted.titleTextAttributes = [
//            .foregroundColor: selectedColor,
//            .font: UIFont.robotoSlab(.regular, size: 14)
//        ]
//        tabBarAppearance.stackedLayoutAppearance.focused.iconColor = selectedColor
//
//        // ✅ Remove any background effect behind selected item
//        tabBarAppearance.selectionIndicatorTintColor = UIColor.clear
//        tabBarAppearance.selectionIndicatorImage = UIImage()
//
//        tabBar.standardAppearance = tabBarAppearance
//        tabBar.scrollEdgeAppearance = tabBarAppearance
//
//        // ✅ iOS 26 — opt out of Liquid Glass, keep custom appearance
//        if #available(iOS 26.0, *) {
//            tabBar.preferredInteractionStyle = .iOS18Style
//        }
//
//        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
//        tabBar.layer.shadowRadius = 5
//        tabBar.layer.shadowColor = UIColor.black.cgColor
//        tabBar.layer.shadowOpacity = 0.20
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
//        // ✅ Re-apply on every layout pass — iOS 26 resets these
//        tabBar.backgroundColor = UIColor(hex: "#EDEDED")
//        tabBar.barTintColor = UIColor(hex: "#EDEDED")
//        tabBar.isTranslucent = false
//
//        let radius: CGFloat = 15
//        let borderColor = UIColor.systemGray6.cgColor
//        var bounds = tabBar.bounds
//        bounds.size = CGSize(width: bounds.width, height: bounds.height + 5)
//
//        let maskPath = UIBezierPath(
//            roundedRect: bounds,
//            byRoundingCorners: [.topLeft, .topRight],
//            cornerRadii: CGSize(width: radius, height: radius)
//        )
//
//        // ✅ Remove stale layers before re-adding
//        tabBar.layer.mask = nil
//        tabBar.layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
//
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = maskPath.cgPath
//        maskLayer.frame = bounds
//        tabBar.layer.mask = maskLayer
//
//        let borderLayer = CAShapeLayer()
//        borderLayer.path = maskPath.cgPath
//        borderLayer.frame = bounds
//        borderLayer.fillColor = UIColor.clear.cgColor
//        borderLayer.strokeColor = borderColor
//        borderLayer.lineWidth = 0
//        tabBar.layer.addSublayer(borderLayer)
//    }
//    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//}
//
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
//                    self?.setupDatabar()
//                }
//            case .failure(let error):
//                DispatchQueue.main.async { [weak self] in
//                    self?.view.makeToast(error.localizedDescription)
//                    self?.setupDatabar()
//                }
//            }
//        }
//    }
//    
//}

import UIKit

let customTransitioningDelegate = CenterTransitioningDelegate()

class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
    var selectedIndex1: Int = 0
    var loaderView = UIView()

    // MARK: - Floating Tab Bar Properties
    private var floatingTabBar: UIVisualEffectView?
    private var tabItemViews: [UIControl] = []
    private var selectionPillView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isHidden = true
        self.delegate = self
        setupLoader()
        
        // ✅ hide floating tab initially
        floatingTabBar?.isHidden = true
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
//        setupTabBarItems(vc1: vc1, vc2: vc2, vc3: vc3)
//
//        viewControllers = [nav1, nav2, nav3]
//        self.selectedIndex = self.selectedIndex1
//        setupTabBarAppearance()
//        adjustContentInsetsForFloatingTabBar()
//    }
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
        nav1.interactivePopGestureRecognizer?.delegate = nil
        nav2.setupBlackTintColor()

        let nav3 = UINavigationController(rootViewController: vc3)
        nav1.interactivePopGestureRecognizer?.delegate = nil
        nav3.setupBlackTintColor()

        setupTabBarItems(vc1: vc1, vc2: vc2, vc3: vc3)

        viewControllers = [nav1, nav2, nav3]
        selectedIndex = selectedIndex1

        // ✅ IMPORTANT: Build tab bar ONLY AFTER loader
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.setupTabBarAppearance()
            self.adjustContentInsetsForFloatingTabBar()
        }
    }
//    private func adjustContentInsetsForFloatingTabBar() {
//        let barHeight: CGFloat = 30
//        let bottomPad: CGFloat = 30
//        let totalInset = barHeight + bottomPad + 10
//        
//        guard let vcs = viewControllers else { return }
//        for vc in vcs {
//            if let nav = vc as? UINavigationController,
//               let root = nav.viewControllers.first {
//                // For UITableViewController
//                if let tableVC = root as? UITableViewController {
//                    tableVC.tableView.contentInset.bottom = totalInset
//                    tableVC.tableView.scrollIndicatorInsets.bottom = totalInset
//                }
//                // For UIViewController with tableView/collectionView
//                root.additionalSafeAreaInsets.bottom = totalInset
//            }
//        }
//    }
    private func adjustContentInsetsForFloatingTabBar() {
        let barHeight: CGFloat = 60
        let bottomPad: CGFloat = 30
        let totalInset = barHeight + bottomPad

        guard let vcs = viewControllers else { return }

        for vc in vcs {
            if let nav = vc as? UINavigationController,
               let root = nav.viewControllers.first {

                if let tableVC = root as? UITableViewController {
                    tableVC.tableView.contentInset.bottom = totalInset
                    tableVC.tableView.scrollIndicatorInsets.bottom = totalInset
                    tableVC.tableView.backgroundColor = .clear // ✅ IMPORTANT
                }

                // 👇 For normal UIViewController
                if let scrollView = root.view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
                    scrollView.contentInset.bottom = totalInset
                    scrollView.scrollIndicatorInsets.bottom = totalInset
                }

                root.view.backgroundColor = UIColor.clear // ✅ IMPORTANT
            }
        }
    }
    // ✅ Tab change check — existing functionality preserved
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        guard let vcs = tabBarController.viewControllers,
              let tappedIndex = vcs.firstIndex(of: viewController),
              let currentNav = tabBarController.selectedViewController as? UINavigationController else {
            return true
        }

        if currentNav.topViewController is CreateAlertViewController {
            if tappedIndex != tabBarController.selectedIndex {
                let vc = Storyboard.Main.instantiateViewController(withViewClass: CommonPopupViewController.self)
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.strImage = "profile_alert"
                vc.strTitle = "Do you want to leave without saving changes?"
                vc.strButton = "Confirm"
                vc.strCancelButton = "Cancel"
                vc.strMessage = "Any unsaved changes will be lost."
                vc.buttonClickHandler = {
                    tabBarController.selectedIndex = tappedIndex
                }
                tabBarController.present(vc, animated: true)
                return false
            }
        }
        return true
    }

    // ✅ Pop to root on tab tap — existing functionality preserved
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

    // MARK: - Tab Bar Appearance

    private func setupTabBarAppearance() {
        // ✅ Make system tab bar fully invisible
        tabBar.isHidden = true
        let transparent = UITabBarAppearance()
        transparent.configureWithTransparentBackground()
        transparent.backgroundColor         = UIColor.clear
        transparent.shadowColor             = UIColor.clear
        transparent.selectionIndicatorImage = UIImage()
        transparent.selectionIndicatorTintColor = UIColor.clear

        transparent.stackedLayoutAppearance.normal.iconColor   = UIColor.clear
        transparent.stackedLayoutAppearance.selected.iconColor = UIColor.clear
        transparent.stackedLayoutAppearance.normal.titleTextAttributes   = [.foregroundColor: UIColor.clear]
        transparent.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.clear]

        tabBar.standardAppearance   = transparent
        tabBar.scrollEdgeAppearance = transparent
        tabBar.isTranslucent        = false
        tabBar.backgroundColor      = UIColor.clear
        tabBar.barTintColor         = UIColor.clear
        tabBar.tintColor            = UIColor.clear
        tabBar.layer.shadowOpacity  = 0
        tabBar.layer.mask           = nil
        tabBar.layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })

        buildFloatingTabBar()
    }

    // MARK: - Build Floating Tab Bar

    private func buildFloatingTabBar() {
        // Remove old if exists
        floatingTabBar?.removeFromSuperview()
        tabItemViews.removeAll()
        selectionPillView = nil

        let padding:   CGFloat = 20
        let barHeight: CGFloat = 72
      //  let bottomPad: CGFloat = view.safeAreaInsets.bottom > 0 ? view.safeAreaInsets.bottom + 12 : 24
        let bottomPad: CGFloat = 10
        let barWidth           = view.bounds.width - (padding * 2)

        // ✅ Frosted glass pill container
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterialLight))
        blur.frame = CGRect(
            x: padding,
            y: view.bounds.height - barHeight - bottomPad,
            width: barWidth,
            height: barHeight
        )
        blur.layer.cornerRadius  = barHeight / 2
        blur.layer.masksToBounds = true
        blur.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.35)

        blur.layer.borderColor = UIColor.black.withAlphaComponent(0.08).cgColor
        blur.layer.borderWidth = 0.5

        // ✅ Selection pill (slides behind selected item)
        let itemCount  = viewControllers?.count ?? 3
        let itemWidth  = barWidth / CGFloat(itemCount)
        let pillW      = itemWidth - 16
        let pillH      = barHeight - 16

        let pillView   = UIView(frame: CGRect(x: 8, y: 8, width: pillW, height: pillH))
        pillView.backgroundColor    = UIColor(hex: "#EDEDED")
      //  pillView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        pillView.layer.cornerRadius = pillH / 2
        blur.contentView.addSubview(pillView)
        selectionPillView = pillView

        // Position pill at current selected index
        movePill(to: selectedIndex, in: blur, animated: false)

        // ✅ Tab items
        let normalImages:   [String] = ["Visits",  "clients",        "alerts"]
        let selectedImages: [String] = ["visitsselected",  "clientselected", "alertsselected"]
        let titles:         [String] = ["Visits",  "Clients",        "Alerts"]

        let appGreen: UIColor = UIColor(named: "appGreen") ?? UIColor(hex: "#2E9E8F")
        let darkColor: UIColor = UIColor(hex: "#1E3037")

        for i in 0..<itemCount {
            let container = UIControl(frame: CGRect(
                x: CGFloat(i) * itemWidth,
                y: 0,
                width: itemWidth,
                height: barHeight
            ))
            container.tag = i

            let imgView         = UIImageView()
            imgView.tag         = 100
            imgView.contentMode = .scaleAspectFit
            imgView.frame       = CGRect(x: (itemWidth - 24) / 2, y: 14, width: 24, height: 24)

            let label           = UILabel()
            label.tag           = 200
            label.font          = UIFont.robotoSlab(.regular, size: 12)
            label.textAlignment = .center
            label.frame         = CGRect(x: 0, y: 44, width: itemWidth, height: 18)
            

            let isSelected      = (i == selectedIndex)
            imgView.image       = UIImage(named: isSelected ? selectedImages[i] : normalImages[i])?
                                    .withRenderingMode(.alwaysTemplate)
            imgView.tintColor   = isSelected ? appGreen : darkColor
            label.text          = titles[i]
            label.textColor     = isSelected ? appGreen : darkColor
            label.font = UIFont.robotoSlab(.bold, size: 12)

            container.addSubview(imgView)
            container.addSubview(label)
            blur.contentView.addSubview(container)
            container.addTarget(self, action: #selector(floatingTabTapped(_:)), for: .touchUpInside)
            tabItemViews.append(container)
        }

        // ✅ Shadow on the outer layer (masksToBounds must be false for shadow)
        let shadowContainer = UIView(frame: blur.frame)
        shadowContainer.backgroundColor    = UIColor.clear
        shadowContainer.layer.shadowColor  = UIColor.black.cgColor
        shadowContainer.layer.shadowOpacity = 0.12
        shadowContainer.layer.shadowRadius  = 12
        shadowContainer.layer.shadowOffset  = CGSize(width: 0, height: 4)
        shadowContainer.layer.cornerRadius  = barHeight / 2

        view.addSubview(shadowContainer)
        view.addSubview(blur)
        floatingTabBar = blur
    }

    // MARK: - Floating Tab Actions

    @objc private func floatingTabTapped(_ sender: UIControl) {
        let tappedIndex = sender.tag

        guard let vcs = viewControllers, tappedIndex < vcs.count else { return }

        // ✅ Reuse CreateAlert popup check — same as existing shouldSelect logic
        if let currentNav = selectedViewController as? UINavigationController,
           currentNav.topViewController is CreateAlertViewController,
           tappedIndex != selectedIndex {

            let vc = Storyboard.Main.instantiateViewController(withViewClass: CommonPopupViewController.self)
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle   = .crossDissolve
            vc.strImage        = "profile_alert"
            vc.strTitle        = "Do you want to leave without saving changes?"
            vc.strButton       = "Confirm"
            vc.strCancelButton = "Cancel"
            vc.strMessage      = "Any unsaved changes will be lost."
            vc.buttonClickHandler = { [weak self] in
                self?.switchFloatingTab(to: tappedIndex)
            }
            present(vc, animated: true)
            return
        }

        switchFloatingTab(to: tappedIndex)
    }

    private func switchFloatingTab(to index: Int) {
        guard let vcs = viewControllers, index < vcs.count else { return }

        // ✅ Pop to root — same as existing tabBar didSelect logic
        if index != 4, let nav = vcs[index] as? UINavigationController {
            nav.popToRootViewController(animated: false)
        }

        selectedIndex = index

        if let blur = floatingTabBar {
            movePill(to: index, in: blur, animated: true)
        }
        updateFloatingTabColors(selected: index)
    }

    private func movePill(to index: Int, in blur: UIVisualEffectView, animated: Bool) {
        let itemCount = viewControllers?.count ?? 3
        let itemWidth = blur.bounds.width / CGFloat(itemCount)
        let pillW     = itemWidth - 16
        let newX      = CGFloat(index) * itemWidth + 8

        let move = {
            self.selectionPillView?.frame.origin.x  = newX
            self.selectionPillView?.frame.size.width = pillW
        }

        if animated {
            UIView.animate(
                withDuration: 0.28,
                delay: 0,
                usingSpringWithDamping: 0.72,
                initialSpringVelocity: 0.4,
                options: .curveEaseOut,
                animations: move
            )
        } else {
            move()
        }
    }

    private func updateFloatingTabColors(selected index: Int) {
        let appGreen:  UIColor = UIColor(named: "appGreen") ?? UIColor(hex: "#2E9E8F")
        let darkColor: UIColor = UIColor(hex: "#1E3037")

        let normalImages:   [String] = ["Visits",  "clients",        "alerts"]
        let selectedImages: [String] = ["visitsselected",  "clientselected", "alertsselected"]

        for control in tabItemViews {
            let i          = control.tag
            let isSelected = (i == index)
            let color      = isSelected ? appGreen : darkColor

            if let img = control.viewWithTag(100) as? UIImageView {
                img.image     = UIImage(named: isSelected ? selectedImages[i] : normalImages[i])?
                                    .withRenderingMode(.alwaysTemplate)
                img.tintColor = color
            }
            if let lbl = control.viewWithTag(200) as? UILabel {
                lbl.textColor = color
            }
        }
    }

    // MARK: - View Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.isHidden = true
      //  setupTabBarAppearance()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // ✅ Keep system tab bar invisible
        tabBar.backgroundColor = UIColor.clear
        tabBar.barTintColor    = UIColor.clear
        tabBar.isTranslucent   = true
        tabBar.layer.mask      = nil
        tabBar.layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })

        // ✅ Reposition floating bar on layout/rotation changes
        guard let blur = floatingTabBar else { return }
        let padding:   CGFloat = 20
        let barHeight: CGFloat = 70
        let bottomPad: CGFloat = 10

        blur.frame = CGRect(
            x: padding,
            y: view.bounds.height - barHeight - bottomPad,
            width: view.bounds.width - padding * 2,
            height: barHeight
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - API
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
