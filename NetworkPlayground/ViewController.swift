//
//  ViewController.swift
//  NetworkPlayground
//
//  Created by sehio on 19.08.2021.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {

    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    lazy var session : URLSession = {
            let config = URLSessionConfiguration.ephemeral
            config.allowsExpensiveNetworkAccess = false
            let session = URLSession(configuration: config, delegate: self,
                delegateQueue: .main)
            return session
    }()
    
    func downloadWithDelegate() {
       
    }
    
    func downloadWithDownloadTask() {
        let url = URL(string: "https://images.pexels.com/photos/3170437/pexels-photo-3170437.jpeg?cs=srgb&dl=pexels-happy-pixels-3170437.jpg&fm=jpg")
        
        guard let url = url else { return }
        
        let session = URLSession.shared
        let task = session.downloadTask(with: url) {
            loc, resp, err in
            
            guard err == nil else { print(err); return }
            
            let status = (resp as? HTTPURLResponse)?.statusCode
            guard status == 200 else { print(status as Any); return }

            if let url = loc, let d = try? Data(contentsOf: url) {
                let im = UIImage(data: d)
                DispatchQueue.main.async {
                    self.img.image = im
                }
            }
        }
        
        task.resume()
    }
   
    func downloadWithDataTask() {
        let url = URL(string: "https://images.pexels.com/photos/3170437/pexels-photo-3170437.jpeg?cs=srgb&dl=pexels-happy-pixels-3170437.jpg&fm=jpg")
        
        guard let url = url else { return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) {
            data, resp, err in
            
            guard err == nil else { print(err); return }
            
            let status = (resp as? HTTPURLResponse)?.statusCode
            guard status == 200 else { print(status as Any); return }

            if let d = data {
                let im = UIImage(data: d)
                DispatchQueue.main.async {
                    self.img.image = im
                    self.progressBar.isHidden = true
                }
            }
        }
        self.progressBar.isHidden = false
        self.progressBar.observedProgress = task.progress
        task.resume()
    }
   
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        //downloadWithDataTask()
        //downloadWithDataTask()
        downloadWithDelegate()
        
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten writ: Int64,
                    totalBytesExpectedToWrite exp: Int64) {
        print("downloaded \(100*writ/exp)%")
    }
    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        print("completed: error: \(error)")
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo fileURL: URL) {
        if let d = try? Data(contentsOf:fileURL) {
            let im = UIImage(data:d)
            DispatchQueue.main.async {
                self.img.image = im
            }
    }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.img.image = nil
        let url = URL(string: "https://images.pexels.com/photos/3170437/pexels-photo-3170437.jpeg?cs=srgb&dl=pexels-happy-pixels-3170437.jpg&fm=jpg")
        

        let req = URLRequest(url:url!)
        let task = self.session.downloadTask(with:req)
        task.resume()
    }


}

