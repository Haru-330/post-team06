//
//  ViewController.swift
//  p2hacks
//
//  Created by Mugi on 2022/12/10.
//

import UIKit
import RealmSwift



extension Bundle {
    func decodeJSON<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Faild to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        return loaded
    }
}
//let postDatas: [PostJson] = Bundle.main.decodeJSON("Data.json")


class ItiranViewController: UIViewController {
    @IBOutlet weak var TitleImage: UIImageView!
    @IBOutlet weak var collectionview: UICollectionView! //collectionview
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBAction func PostButton(_ sender: Any) {
        // storyboardのインスタンス取得
        let postStoryboard: UIStoryboard = UIStoryboard(name: "Post", bundle: nil)
        // 遷移先ViewControllerのインスタンス取得
        let postView = postStoryboard.instantiateViewController(withIdentifier: "Post") as! PostViewController
        // 画面遷移
        self.present(postView, animated: true, completion: nil)
    }
    @IBOutlet weak var PostButton: UIButton!
    
    @IBAction func KariButton(_ sender: Any) {
        // Segueのidentifierを指定
                self.performSegue(withIdentifier: "toDetail", sender: self)
    }
    
    let models = PostJson.createModels()
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        //POSTDATAに入っているデータの確認用
        print("🟥全てのデータ\(POSTDATA)")
        
        collectionview.dataSource = self
        
        //画面の中心を表す
        let ViewWidth = Float(UIScreen.main.bounds.size.width)
        //アイコンを中心に表示
        let IconWidthGap = (ViewWidth - Float(TitleImage.frame.width)) / 2
        TitleImage.frame = CGRect.init(x: CGFloat(IconWidthGap),
                                       y: TitleImage.frame.minY,
                                       width: TitleImage.frame.width,
                                       height: TitleImage.frame.height)
        
        
        //コレクションビューで使用するセルを登録
        collectionview!.register(UINib(nibName: "CustomCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCellCollectionViewCell")
        
        // セルの大きさを設定
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionview.frame.width, height: 159)
        layout.minimumLineSpacing = 0
        
        
        collectionview.collectionViewLayout = layout
    }
}

//searchbar ios13以降の仕様
extension UISearchBar {
    var textField: UITextField? {
        if #available(iOS 13.0, *) {
            return searchTextField
        } else {
            return value(forKey: "searchField") as? UITextField
        }
    }
    
}


extension ItiranViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //セルオブジェクトを取り出し、セルにモデルオブジェクトを渡して設定を行う
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "CustomCellCollectionViewCell", for: indexPath)
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        
        if let cell = cell as? CustomCellCollectionViewCell {
            cell.setupCell(model: models[indexPath.row])
        }
        return cell
    }
}

