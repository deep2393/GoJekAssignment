//
//  GOJContactDetailVC.swift
//  GOJAssignment
//
//  Created by Deepak Singh on 23/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//


import UIKit
import MessageUI

class GOJContactDetailVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var contactDetailTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    //MARK:- Variables
    var viewModel: GOJContactDetailVM!

    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.viewModel == nil {
            assertionFailure("GOJContactDetailVC: Empty View Model")
        }
        self.setupUI()
    }
    //MARK:- Actions
    @IBAction func editAction(_ sender: Any) {
        if let controller: UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "GOJContactAddEditVCNavigationController") as? UINavigationController,
            let topController: GOJContactAddEditVC = controller.topViewController as? GOJContactAddEditVC{
            topController.viewModel = self.viewModel.getEditViewModel()
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
    }
    
    //MARK:- Private Methods
    private func setupUI() {
        self.contactDetailTableView.rowHeight = UITableView.automaticDimension
        self.contactDetailTableView.dataSource = self
        self.contactDetailTableView.delegate = self
        self.contactDetailTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.addHandlers()
        self.viewModel.fetchDetails()
    }

    private func addHandlers() {
        self.viewModel.callbackHandler = { [weak self] (callbackType: GOJCallback) in
            if let weakSelf: GOJContactDetailVC = self {
                DispatchQueue.main.async {
                    switch callbackType {
                    case .showLoader:
                        weakSelf.activityIndicator.startAnimating()
                    case .hideLoader:
                        weakSelf.activityIndicator.stopAnimating()
                    case .reloadContent:
                        weakSelf.contactDetailTableView.reloadData()
                    case .openCall(let mobile):
                        guard let numberUrl = URL(string: "tel://" + mobile) else { return }
                        UIApplication.shared.open(numberUrl)
                    case .openMail(let email):
                        if MFMailComposeViewController.canSendMail() {
                            let composer = MFMailComposeViewController()
                            composer.mailComposeDelegate = self
                            composer.setToRecipients([email])
                            composer.setSubject("")
                            composer.setMessageBody("", isHTML: false)
                            weakSelf.present(composer, animated: true, completion: nil)
                        }
                    case .openMessage(let mobile):
                        if (MFMessageComposeViewController.canSendText()) {
                            let controller = MFMessageComposeViewController()
                            controller.body = ""
                            controller.recipients = [mobile]
                            controller.messageComposeDelegate = self
                            weakSelf.present(controller, animated: true, completion: nil)
                        }
                    default:
                        break
                    }
                }
            }
        }
    }
}

//MARK:- UITableViewDataSource
extension GOJContactDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.cellItemModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model: GOJContactDetailItemVM = self.viewModel.cellItemModels[indexPath.row]
        switch model.cellType {
        case .header:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GOJContactDetailsHeaderCell.self), for: indexPath) as? GOJContactDetailsHeaderCell {
                cell.configure(viewModel: model)
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GOJContactDetailsInfoCell.self), for: indexPath) as? GOJContactDetailsInfoCell {
                cell.configure(viewModel: model)
                return cell
            }
        }
        return UITableViewCell()
    }

}

//MARK:- UITableViewDelegate
extension GOJContactDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let model: GOJContactDetailItemVM = self.viewModel.cellItemModels[indexPath.row]
        switch model.cellType {
        case .header:
            return 270
        default:
           return 60
        }
    }
}

//MARK:- MFMessageComposeViewControllerDelegate
extension GOJContactDetailVC: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK:- MFMailComposeViewControllerDelegate
extension GOJContactDetailVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}
