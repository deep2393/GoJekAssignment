//
//  GOJContactListVC.swift
//  GOJAssignment
//
//  Created by Deepak Singh on 23/11/19.
//  Copyright © 2019 Deepak Singh. All rights reserved.
//


import UIKit

class GOJContactListVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contactListTableView: UITableView!

    //MARK:- Variables
    private let viewModel: GOJContactListVM = GOJContactListVM(apiHandler: GOJApiHandler())

    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    //MARK:- Private Methods
    private func setupUI() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.contactListTableView.rowHeight = UITableView.automaticDimension
        self.contactListTableView.estimatedRowHeight = 64
        self.contactListTableView.dataSource = self
        self.contactListTableView.delegate = self
        self.contactListTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.addHandlers()
        self.viewModel.fetchContacts()
    }

    private func addHandlers() {
        self.viewModel.callbackHandler = { [weak self] (callbackType: GOJCallback) in
            if let weakSelf: GOJContactListVC = self {
                DispatchQueue.main.async {
                    switch callbackType {
                    case .showLoader:
                        weakSelf.activityIndicator.startAnimating()
                    case .hideLoader:
                        weakSelf.activityIndicator.stopAnimating()
                    case .reloadContent:
                        weakSelf.contactListTableView.reloadData()
                    default:
                        break
                    }
                }
            }
        }
    }

    //MARK:- Actions
    @IBAction func addAction(_ sender: Any) {
        if let controller: UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "GOJContactAddEditVCNavigationController") as? UINavigationController,
            let topController: GOJContactAddEditVC = controller.topViewController as? GOJContactAddEditVC{
            topController.viewModel = self.viewModel.getAddViewModel()
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
    }
}

//MARK:- UITableViewDataSource
extension GOJContactListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sectionViewModels.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.sectionViewModels[section].itemArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GOJContactListCell.self), for: indexPath) as? GOJContactListCell {
            let model: GOJContactListItemVM = self.viewModel.getItemViewModel(indexPath: indexPath)
            cell.configure(model: model, indexPath: indexPath)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel.sectionViewModels[section].sectionTitle
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.viewModel.getSectionIndexTitles()
    }

}

//MARK:- UITableViewDelegate
extension GOJContactListVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let detailController: GOJContactDetailVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: GOJContactDetailVC.self)) as? GOJContactDetailVC {
            let detailViewModel: GOJContactDetailVM = self.viewModel.getDetailsViewModel(indexPath: indexPath)
            detailController.viewModel = detailViewModel
            self.navigationController?.pushViewController(detailController, animated: true)
        }
    }
}
