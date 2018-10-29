//
//  ViewController.swift
//  RealmSwiftHelperExample
//
//  Created by ryan on 2018/10/26.
//  Copyright © 2018 bechoed. All rights reserved.
//

import UIKit
import RealmSwiftHelper
import RealmSwift
import RxSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private weak var tableView: UITableView?
    
    private let cellID = "cellID"
    private var clickedTime = 0
    private var notificationToken: NotificationToken?
    private lazy var disposeBag = DisposeBag()
    
    private var results: Results<Person>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableView = UITableView(frame: view.bounds)
        self.tableView = tableView
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        let instance = SingleInstance.shared()
        instance.test()
        
        let addButton = UIButton()
        addButton.backgroundColor = .green
        addButton.setTitle("添加", for: .normal)
        view.addSubview(addButton)
        addButton.bounds = CGRect(x: 0, y: 0, width: 200, height: 40)
        addButton.center = view.center
        addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        
        RealmSwiftHelper.shared()
            .config(dbName: "default", migration: {(migration, oldSchemaVersion) in
                print("old = \(oldSchemaVersion);  new = \(RealmSwiftHelper.shared().newSchemaVersion)")
                if oldSchemaVersion < 9 {
                    migration.enumerateObjects(ofType: Person.className(), { (oldPerson, newPerson) in
//                        oldPerson!["grade"] = "二年级"
                        print("sdsadsa")
                    })
                }
            })
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()))
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [unowned self] _ in
                let results = RealmSwiftHelper.shared().realm()?.objects(Person.self)
                self.results = results
                let notificationToken = results?.observe({ allPersons in
                    switch allPersons {
                    case .initial(_):
                        print("初始化")
                    case .update(_, let deletions, let insertions, let modifications):
                        print("更新\(deletions) \(insertions) \(modifications)")
                        self.tableView?.reloadData()
                    case .error(let error):
                        print("出错\(error)")
                    }
                })
                self.notificationToken = notificationToken
                
                }, onError: { error in
                    print("配置失败")
            }).disposed(by: disposeBag)
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    @objc func add() {
        let person = Person()
        person.age = 18
        person.name = "sa"
        clickedTime = clickedTime + 1
        person.id = "\(clickedTime)"
        _ = RealmSwiftHelper.shared()
            .write(action: RealmAction.add(object: person))
            .subscribeOn(ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global()))
            .subscribe(onSuccess: { _ in
                print("插入成功……")
            }, onError: { error in
                print("插入失败\(error)")
            }).disposed(by: disposeBag)
        
        print("添加……")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let results = results else {
            return 0
        }
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = self.results![indexPath.row]
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID)
        tableViewCell?.textLabel?.text = person.name
        return tableViewCell!
    }
    
}

