//
//  HomeViewController.swift
//  ExamenOne
//
//  Created by Universidad Anahuac on 21/09/22.
//

import UIKit


struct HeroList: Decodable {
    let response, id, name: String?
    let image: Image
}

struct Image: Codable {
    let url: String?
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var heroes : [HeroList] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadingIndicatorView.hidesWhenStopped = true
        loadingIndicatorView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            self.loadHero()
        }
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func loadHero(){
        let urlBase = "https://www.superheroapi.com/api.php/423212276549393/"
        for i in 1...100 {
            let listHeroEndPoint =  URL.init(string: "\(urlBase)\(i)")!
            let task = URLSession.shared.dataTask(with: listHeroEndPoint){data, response, error in
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    let result = try! jsonDecoder.decode(HeroList.self, from: data)
                    self.heroes.append(result)
                    DispatchQueue.main.sync {
                        self.loadingIndicatorView.stopAnimating()
                        self.tableView.reloadData()
                    }
                    
                }
            }
            task.resume()
        }
        }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        heroes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                if(cell==nil){
                        cell=UITableViewCell()
                }
                let item = heroes[indexPath.row]
        cell?.textLabel?.text = item.name
                return cell!
    }
    
    
}
