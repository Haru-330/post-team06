//
//  ViewController.swift
//  p2hacks
//
//  Created by Mugi on 2022/12/10.
//

import UIKit

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




//extension Bundle {
//    func decodeJSON<T: Codable>(_ file: String) -> T {
//        guard let url = self.url(forResource: file, withExtension: nil) else {
//            fatalError("Faild to locate \(file) in bundle.")
//        }
//        
//        guard let data = try? Data(contentsOf: url) else {
//            fatalError("Failed to load \(file) from bundle.")
//        }
//        
//        let decoder = JSONDecoder()
//        guard let loaded = try? decoder.decode(T.self, from: data) else {
//            fatalError("Failed to decode \(file) from bundle.")
//        }
//        return loaded
//    }
//}
//let postDatas: [PostJson] = Bundle.main.decodeJSON("Data.json")


class ItiranViewController: UIViewController {
    @IBOutlet weak var TitleImage: UIImageView!
    @IBOutlet weak var collectionview: UICollectionView! //collectionview
    @IBOutlet weak var SearchBar: UISearchBar! //検索バー
    @IBOutlet weak var TopButton: UIButton! //トップボタン
    @IBOutlet weak var WordButton: UIButton! //言葉ボタン
    @IBOutlet weak var PeopleButton: UIButton! //人ボタン
    @IBOutlet weak var MusicButton: UIButton! //音楽ボタン
    @IBOutlet weak var ThingButton: UIButton! //物事ボタン
    
    @IBAction func PostButton(_ sender: Any) {
        // storyboardのインスタンス取得
        let postStoryboard: UIStoryboard = UIStoryboard(name: "Post", bundle: nil)
        // 遷移先ViewControllerのインスタンス取得
        let postView = postStoryboard.instantiateViewController(withIdentifier: "Post") as! PostViewController
        // 画面遷移
        self.present(postView, animated: true, completion: nil)
    }
    @IBOutlet weak var PostButton: UIButton!
    
    
    let models = PostJson.createModels()
    
    var selectedImage: UIImage?
    let photos = ["1", "2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","","46","47","48","49","50",]
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        // Segue 準備
        //        func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        //            if (segue.identifier == "Detail") {
        //                let detailVC: DetailViewController = (segue.destination as? DetailViewController)!
        //                // DetailViewController のselectedImgに選択された画像を設定する
        //                detailVC.selectedImg = selectedImage
        //            }
        //        }
        //POSTDATAに入っているデータの確認用
        //print("🟥全てのデータ\(POSTDATA)")
    
        collectionview.dataSource = self
        collectionview.delegate = self
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            //キーボード閉じる
            SearchBar.resignFirstResponder()
            
        }
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
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//            textField.resignFirstResponder()
//            return true
//        }
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

extension ItiranViewController: UICollectionViewDelegate {
    // Cell が選択された場合
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        // [indexPath.row] から画像名を探し、UImage を設定
        selectedImage = UIImage(named: photos[indexPath.row])
        if selectedImage != nil {
            // SubViewController へ遷移するために Segue を呼び出す
            //performSegue(withIdentifier: "Detail",sender: nil)
            // storyboardのインスタンス取得
            let detailStoryboard: UIStoryboard = UIStoryboard(name: "Detail", bundle: nil)
            // 遷移先ViewControllerのインスタンス取得
            let detailView = detailStoryboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
            // 画面遷移
            self.present(detailView, animated: false)
            
        }
        
    }
}
