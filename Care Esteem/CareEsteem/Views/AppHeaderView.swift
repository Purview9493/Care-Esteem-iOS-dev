
import UIKit

class AppHeaderView: UIView {
    let kCONTENT_XIB_NAME = "AppHeaderView"
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgProfile: AGImageView!
    lazy var badgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.textColor = .white
     label.font = UIFont.robotoSlab(.bold, size: 12)  //UIFont.systemFont(ofSize: 12, weight: .bold)
        label.backgroundColor = .systemRed
        return label
    }()
    @IBInspectable var hideBackButton: Bool = true {
            didSet {
                self.btnBack.isHidden = hideBackButton
            }
        }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
  
    func showBadge(count: Int) {
        if count == 0 {
                    badgeLabel.removeFromSuperview() // ✅ remove badge when 0
                    return
                }
        badgeLabel.text = "\(count)"

        if badgeLabel.superview == nil {
            btnNotification.addSubview(badgeLabel)

            NSLayoutConstraint.activate([
                badgeLabel.leftAnchor.constraint(equalTo: btnNotification.centerXAnchor, constant: -4),
                badgeLabel.topAnchor.constraint(equalTo: btnNotification.topAnchor, constant: 1),
                badgeLabel.widthAnchor.constraint(equalToConstant: 18),
                badgeLabel.heightAnchor.constraint(equalToConstant: 18)
            ])
        }

        // Ensure layout is done before setting corner radius
        badgeLabel.layoutIfNeeded()
        badgeLabel.layer.cornerRadius = badgeLabel.bounds.height / 2
    }
    @objc func onDidReceiveNotification(_ notification:Notification) {
            if let count: Int = notification.userInfo?["count"] as? Int, count > 0 {
                DispatchQueue.main.async {
                    print("count",count)
                    self.showBadge(count: count)
                }

            }
        }
    
    
    func commonInit() {
            print("Check Notification :- ")
            NotificationCenter.default.addObserver(self,
                                                       selector: #selector(onDidReceiveNotification(_:)),
                                                       name: .customNotification,
                                                       object: nil)

            Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
            contentView.fixInView(self)
            if notificationCount != 0 {
                DispatchQueue.main.async {
                    self.showBadge(count: notificationCount)
                }
            }
            // Restore saved count on launch
                    let savedCount = UserDefaults.standard.integer(forKey: "notificationCount")
                    if savedCount > 0 {
                        print("savedCount :- ",savedCount)
                        showBadge(count: savedCount)
                    } else {
                        self.showBadge(count: notificationCount)
                        print("notificationCount :- ",notificationCount)
                    }
            print("photo :- ",UserDetails.shared.profileModel?.profilePhotoName ?? "")
            if let photo = UserDetails.shared.profileModel?.profilePhotoName {
                if photo == "" {
                    // Get initials
                    self.imgProfile.isHidden = true
                         let fullName = UserDetails.shared.profileModel?.name ?? ""
                         let initials = getInitials(from: fullName)
                    btnProfile.titleLabel?.font = UIFont.robotoSlab(.regular, size: 16)
                         btnProfile.setTitle(initials, for: .normal)
                    print(" Button title set to initials: \(initials)")
                         imgProfile.image = Photo().imageWith(name: fullName)
                          btnProfile.setTitleColor(.white, for: .normal)
                           btnProfile.backgroundColor =  UIColor(named: "appGreen")
                           btnProfile.layer.cornerRadius = 20
                           btnProfile.clipsToBounds = true
                } else {
                    // Photo exists: Show image
                    btnProfile.setTitle("", for: .normal)
                    self.imgProfile.isHidden = false
                    self.imgProfile.sd_setImage(with: URL(string: photo), placeholderImage: UIImage(named: "logo1"))
                }
            } else {
                // No photo key: fallback to initials
                let fullName = UserDetails.shared.profileModel?.name ?? ""
                let initials = getInitials(from: fullName)

                btnProfile.setTitle(initials, for: .normal)
                print("🟡 Button title set to initials (fallback): \(initials)")

                btnProfile.setTitleColor(.white, for: .normal)
                btnProfile.backgroundColor = UIColor(named: "appGreen")
                btnProfile.layer.cornerRadius = 20
                btnProfile.clipsToBounds = true
                imgProfile.image = Photo().imageWith(name: fullName)
            }
        }
    // first letter of first name and first letter of last name function

    func getInitials(from fullName: String) -> String {
        let nameComponents = fullName.components(separatedBy: " ").filter { !$0.isEmpty }

        guard let first = nameComponents.first?.first else { return "" }
        let last = nameComponents.count > 1 ? nameComponents.last?.first : nil

        let initials = "\(first)\(last ?? Character(""))"
        return initials.uppercased()
    }
    @IBAction func btnProfileAction(_ sender:UIButton){
        guard let topVC = AppDelegate.shared.topViewController() else { return }
    
    // Avoid duplicate pushes
    if topVC is ProfileViewController {
        print("Already on ProfileViewController")
        return
    }
    
    if let nav = topVC.navigationController {
        // Avoid multiple ProfileVCs in stack
        if nav.viewControllers.contains(where: { $0 is ProfileViewController }) {
            print("ProfileVC already in stack")
            return
        }
        let vc = Storyboard.Main.instantiateViewController(withViewClass: ProfileViewController.self)
        nav.pushViewController(vc, animated: true)
    }
}
    @IBAction func btnNotificationAction(_ sender:UIButton){
        if !(AppDelegate.shared.topViewController() is NotificationViewController) {
            let vc = Storyboard.Main.instantiateViewController(withViewClass: NotificationViewController.self)
            AppDelegate.shared.topViewController()?.navigationController?.pushViewController(vc,
                                                                                             animated: true)
        }
    }
    @IBAction func btnBackAction(_ sender:UIButton){
        AppDelegate.shared.topViewController()?.navigationController?.popViewController(animated: true)
    }
}
extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

extension Notification.Name {
    static let customNotification = Notification.Name("com.example.customNotification")
    static let updateCount = Notification.Name("updateCount")
}
class Photo {
    func imageWith(name: String?) -> UIImage? {
         let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
         let nameLabel = UILabel(frame: frame)
         nameLabel.textAlignment = .center
         nameLabel.backgroundColor = UIColor(named: "appGreen")
         nameLabel.textColor = .white
        nameLabel.font = UIFont.robotoSlab(.bold, size: 20)
        //RobotoSlabFont(size: 20, weight: .Bold)
         var initials = ""
         if let initialsArray = name?.components(separatedBy: " ") {
             if let firstWord = initialsArray.first {
                 if let firstLetter = firstWord.first {
                     initials += String(firstLetter).capitalized }
             }
             if initialsArray.count > 1, let lastWord = initialsArray.last {
                 if let lastLetter = lastWord.first { initials += String(lastLetter).capitalized
                 }
             }
         } else {
             return nil
         }
         nameLabel.text = initials
         UIGraphicsBeginImageContext(frame.size)
         if let currentContext = UIGraphicsGetCurrentContext() {
             nameLabel.layer.render(in: currentContext)
             let nameImage = UIGraphicsGetImageFromCurrentImageContext()
             return nameImage
         }
         return nil
     }
}
