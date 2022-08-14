//
//  WatchListViewController.swift
//  LFMovieApp
//
//  Created by Oran on 15/07/2022.
//

import UIKit

class WatchListViewController: UIViewController {
    
    @IBOutlet weak var watchListTableView: UITableView!
    
    var service = Service.shard
    var watchListDataArray = [Show]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        watchListTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfEmpty()
        watchListTableView.reloadData()
    }
    
    func load() {
        watchListDataArray = []
        let arrayTv = UserDefaults.standard.array(forKey: "watchListTv") as? [Int] ?? [Int]()
        let arrayMovie = UserDefaults.standard.array(forKey: "watchListMovie")  as? [Int] ?? [Int]()
        
        Task {
            for id in arrayMovie {
                async let getFullDetailMovie = NetworkService().getFullDetail(.movie, id: id)
                await watchListDataArray.append(getFullDetailMovie!)
                watchListTableView.reloadData()
            }
            for id in arrayTv{
                async let getFullDetailTv = NetworkService().getFullDetail(.tv, id: id)
                await watchListDataArray.append(getFullDetailTv!)
                watchListTableView.reloadData()
            }
        }
    }
    
    func checkIfEmpty(){
        let arrayTv = UserDefaults.standard.array(forKey: "watchListTv") as? [Int] ?? [Int]()
        let arrayMovie = UserDefaults.standard.array(forKey: "watchListMovie")  as? [Int] ?? [Int]()
        watchListDataArray = []
        if arrayTv.isEmpty && arrayMovie.isEmpty {
            service.showAlert(vc: self, title: "Alert", message: "Watch List is Empty")
        } else {
            load()
        }
    }
    
    // MARK: - Prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? ShowDetailsViewController,
              let index = watchListTableView.indexPathForSelectedRow?.row
        else {
            return
        }
        detailViewController.selectedShow = watchListDataArray[index]
    }
}

// MARK: - TableView - DataSource

extension WatchListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return watchListDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = watchListTableView.dequeueReusableCell(withIdentifier: "watchListCell", for: indexPath) as! WatchListTableViewCell
        cell.setup(item: watchListDataArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            let item = watchListDataArray[indexPath.row]
            if service.arrayTvUserDefaults.contains(item.id) {
                service.arrayTvUserDefaults.remove(at: service.arrayTvUserDefaults.firstIndex(of: item.id)!)
                UserDefaults.standard.set(service.arrayTvUserDefaults, forKey: "watchListTv")
            } else if service.arrayMovieUserDefaults.contains(item.id){
                service.arrayMovieUserDefaults.remove(at: service.arrayMovieUserDefaults.firstIndex(of: item.id)!)
                UserDefaults.standard.set(service.arrayMovieUserDefaults, forKey: "watchListMovie")
            }
            service.checkIfInWatchList = false
            watchListDataArray.remove(at: indexPath.row)
            watchListTableView.reloadData()
        }
    }
}
