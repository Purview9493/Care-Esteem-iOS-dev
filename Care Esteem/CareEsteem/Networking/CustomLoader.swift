
import UIKit
//
//class CustomLoader: UIView {
//
//    private var backgroundImageView: UIImageView = UIImageView()
//    private var gifImageView: UIImageView = UIImageView()
//    private var interactionBlockingView: UIView?
//    private weak var parentView: UIView?
//
//    static let shared = CustomLoader()
//
//    private override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupLoader()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupLoader()
//    }
//
//    private func setupLoader() {
//        self.frame = UIScreen.main.bounds
//        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//        
//        // 1️⃣ Full-screen background image
////        backgroundImageView.frame = self.bounds
////        backgroundImageView.contentMode = .scaleAspectFill
////        backgroundImageView.image = UIImage(named: "bg_loader") // Add image to Assets
////        self.addSubview(backgroundImageView)
//
//        // 2️⃣ GIF view
//        gifImageView.frame = CGRect(x: 0, y: 0, width: 300, height: 350)
//        gifImageView.center = self.center
//        gifImageView.contentMode = .scaleAspectFill
//        gifImageView.backgroundColor = .clear
//
//        if let url = Bundle.main.url(forResource: "logo_animations", withExtension: "gif"),
//           let gifData = try? Data(contentsOf: url) {
//          //  gifImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//            gifImageView.image = UIImage.sd_image(withGIFData: gifData)
//        }
//        
//        self.addSubview(gifImageView)
//    }
//
//    /// Show loader
//    func showLoader(on parentView: UIView, blockInteraction: Bool = true) {
//        DispatchQueue.main.async {
//            self.parentView = parentView
//
//            if blockInteraction {
//                let blockView = UIView(frame: parentView.bounds)
//                blockView.backgroundColor = UIColor.clear
//                blockView.tag = 9998
//                parentView.addSubview(blockView)
//                self.interactionBlockingView = blockView
//            }
//
//            self.tag = 9999
//            parentView.addSubview(self)
//        }
//    }
//
//    /// Hide loader
//    func hideLoader() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
//            guard let self = self else { return }
//            self.removeFromSuperview()
//            self.interactionBlockingView?.removeFromSuperview()
//            self.interactionBlockingView = nil
//            self.parentView = nil
//        }
//    }
//}

import SDWebImage

class CustomLoader: UIView {

    private var gifImageView: UIImageView = UIImageView()
    private var interactionBlockingView: UIView?
    private weak var parentView: UIView?
    private var timeoutWorkItem: DispatchWorkItem?

    static let shared = CustomLoader()

    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupLoader()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLoader()
    }

    private func setupLoader() {
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)

        // GIF view
        gifImageView.frame = CGRect(x: 0, y: 0, width: 300, height: 350)
        gifImageView.center = self.center
        gifImageView.contentMode = .scaleAspectFill
        gifImageView.backgroundColor = .clear

        if let url = Bundle.main.url(forResource: "logo_animations", withExtension: "gif"),
           let gifData = try? Data(contentsOf: url) {
            gifImageView.image = UIImage.sd_image(withGIFData: gifData)
        }

        self.addSubview(gifImageView)
    }

    /// Show loader
    func showLoader(on parentView: UIView, blockInteraction: Bool = true, autoHideAfter seconds: TimeInterval = 30) {
        DispatchQueue.main.async {
            self.parentView = parentView

            // Prevent duplicate loader
            if parentView.viewWithTag(9999) != nil { return }

            if blockInteraction {
                let blockView = UIView(frame: parentView.bounds)
                blockView.backgroundColor = UIColor.clear
                blockView.tag = 9998
                parentView.addSubview(blockView)
                self.interactionBlockingView = blockView
            }

            self.tag = 9999
            parentView.addSubview(self)

            // Auto-hide safeguard
            self.timeoutWorkItem?.cancel()
            let workItem = DispatchWorkItem { [weak self] in
                self?.hideLoader()
            }
            self.timeoutWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: workItem)
        }
    }

    /// Hide loader
    func hideLoader() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.timeoutWorkItem?.cancel()
            self.timeoutWorkItem = nil

            self.removeFromSuperview()
            self.interactionBlockingView?.removeFromSuperview()
            self.interactionBlockingView = nil
            self.parentView = nil
        }
    }
}













//{
//    static let shared = CustomLoader()
//
//    private init() {
//    }
//
//    private var loaderView: UIView?
//    private var interactionBlockingView: UIView?
//
//    func showLoader(on view: UIView) {
//        guard loaderView == nil else { return }
//
//        let blockingView = UIView()
//        blockingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
//        blockingView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(blockingView)
//
//        let loader = UIView()
//        loader.backgroundColor = .white
//        loader.layer.cornerRadius = 10
//        loader.layer.masksToBounds = false
//        loader.layer.shadowColor = UIColor.black.cgColor
//        loader.layer.shadowOpacity = 0.3
//        loader.layer.shadowOffset = CGSize(width: 0, height: 2)
//        loader.layer.shadowRadius = 4
//        loader.translatesAutoresizingMaskIntoConstraints = false
//        
//        let activityIndicator = UIActivityIndicatorView(style: .large)
//        activityIndicator.tintColor = .black
//        activityIndicator.color = .black
//        activityIndicator.startAnimating()
//        
//        let label = UILabel()
//        label.text = "Please Wait..."
//        label.textColor = .black
//        label.font = UIFont.boldSystemFont(ofSize: 16)
//        
//        let stackView = UIStackView(arrangedSubviews: [activityIndicator])
//        stackView.axis = .horizontal
//        stackView.spacing = 8
//        stackView.alignment = .center
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        loader.addSubview(stackView)
//        
//        view.addSubview(loader)
//        
//        NSLayoutConstraint.activate([
//            blockingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            blockingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            blockingView.topAnchor.constraint(equalTo: view.topAnchor),
//            blockingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//
//        NSLayoutConstraint.activate([
//            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            loader.widthAnchor.constraint(equalToConstant: 70),
//            loader.heightAnchor.constraint(equalToConstant: 70),
//            stackView.centerXAnchor.constraint(equalTo: loader.centerXAnchor),
//            stackView.centerYAnchor.constraint(equalTo: loader.centerYAnchor)
//        ])
//        
//        loaderView = loader
//        interactionBlockingView = blockingView
//    }
//
//    func hideLoader() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {[weak self] in
//            
//            
//            //        DispatchQueue.main.async {
//            self?.loaderView?.removeFromSuperview()
//            self?.interactionBlockingView?.removeFromSuperview()
//            self?.loaderView = nil
//            self?.interactionBlockingView = nil
//        })
//    }
//}
