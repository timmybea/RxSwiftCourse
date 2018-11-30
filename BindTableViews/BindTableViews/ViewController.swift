//
//  ViewController.swift
//  BindTableViews
//
//  Created by Tim Beals on 2018-10-09.
//  Copyright © 2018 Roobi Creative. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var datasource = Contributor.getDatasource()
    
    lazy var tableview: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(CustomCellTableViewCell.self, forCellReuseIdentifier: CustomCellTableViewCell.resuseID)
        tv.bounces = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillLayoutSubviews() {
        tableview.removeFromSuperview()
        
        let safeAreaLayout = view.safeAreaLayoutGuide
        
        view.addSubview(tableview)
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: safeAreaLayout.topAnchor),
            tableview.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableview.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableview.bottomAnchor.constraint(equalTo: safeAreaLayout.bottomAnchor)
            ])
    }

}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: CustomCellTableViewCell.resuseID) as? CustomCellTableViewCell
        cell!.setupForContributor(datasource[indexPath.row])
        return cell!
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
