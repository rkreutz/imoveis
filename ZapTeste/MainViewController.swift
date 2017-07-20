//
//  ViewController.swift
//  ZapTeste
//
//  Created by Rodrigo Kreutz on 9/3/16.
//  Copyright © 2016 Rodrigo Kreutz. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonCreate: UIButton!
    @IBOutlet weak var lblActive: UILabel!
    
    var data: [Imovel] = []
    var active: Int = 0
    
    /****************************************************/
    // MARK: - ViewController methods
    /****************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.buttonCreate.layer.cornerRadius = 5.0
        
        if let path = NSBundle.mainBundle().pathForResource("imoveis", ofType: "json") {
            if let data = NSData(contentsOfFile: path) {
                let json: NSDictionary?
                do {
                    json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                } catch _ {
                    json = nil
                    print("Deu algum problema durante a inicilizacao do dicionario.")
                }
                
                if let json = json {
                    if let imoveis = json["Imoveis"] as? NSDictionary {
                        if let imoveis = imoveis["Imoveis"] as? [NSDictionary] {
                            for imovel in imoveis {
                                self.data.append(Imovel(dictionary: imovel))
                            }
                        }
                        if let quantidadeResultados = imoveis["QuantidadeResultados"] as? Int {
                            self.active = quantidadeResultados
                        }
                    }
                }
            }
        }
        
        self.lblActive.text = "\(self.active) anúncios ativos"
    }
    
    /****************************************************/
    // MARK: - TableView data source and delegate
    /****************************************************/
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.data.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (indexPath.section == 2) ? 220 : 200
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < self.data.count - 1 {
            return 5
        }
        
        let offset = self.view.frame.height - self.buttonCreate.frame.origin.y + 8
        return offset
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("zapCell", forIndexPath: indexPath) as! ZapTableViewCell
        
        let imovel = self.data[indexPath.section]
        
        for foto in imovel.fotos {
            if foto.principal {
                cell.propertyImage.image = nil
                cell.propertyImage.downloadedFrom(foto.urlImagem, contentMode: nil)
            }
        }
        
        if let precoLocacao = imovel.precoLocacao {
            let numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = .CurrencyStyle
            numberFormatter.locale = NSLocale(localeIdentifier: "pt-BR")
            
            cell.rentValue.hidden = false
            cell.rentTitle.hidden = false
            cell.rentValue.text = numberFormatter.stringFromNumber(precoLocacao)
        } else {
            cell.rentValue.hidden = true
            cell.rentTitle.hidden = true
        }
        
        if let precoVenda = imovel.precoVenda {
            let numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = .CurrencyStyle
            numberFormatter.locale = NSLocale(localeIdentifier: "pt-BR")
            
            cell.saleValue.hidden = false
            cell.saleTitle.hidden = false
            cell.saleValue.text = numberFormatter.stringFromNumber(precoVenda)
        } else {
            cell.saleValue.hidden = true
            cell.saleTitle.hidden = true
        }
        
        cell.about.text = "[\(imovel.codImovel)] - \(imovel.tipoImovel)"
        
        if imovel.endereco.logradouro == "" {
            cell.address.text = imovel.endereco.bairro
        } else if imovel.endereco.bairro == "" {
            cell.address.text = imovel.endereco.logradouro
        } else {
            cell.address.text = "\(imovel.endereco.logradouro) - \(imovel.endereco.bairro)"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0,0,tableView.frame.width, 5))
        return view
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.performSegueWithIdentifier("detailRealEstate", sender: self.data[indexPath.section])
    }
    
    /****************************************************/
    // MARK: - Scrollview delegate
    /****************************************************/
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0.5 {
            for consraint in self.view.constraints {
                if consraint.identifier == "bottomConstraint" {
                    consraint.constant = -50
                }
            }
        } else if velocity.y < -0.5 {
            for consraint in self.view.constraints {
                if consraint.identifier == "bottomConstraint" {
                    consraint.constant = 0
                }
            }
        }
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.layoutIfNeeded()
            self.tableView.reloadSections(NSIndexSet(index: self.data.count - 1), withRowAnimation: .None)
            })
    }
    
    
    /****************************************************/
    // MARK: - Navigation
    /****************************************************/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailRealEstate" {
            if let imovel = sender as? Imovel {
                let dstController = segue.destinationViewController as! DetailViewController
                
                dstController.imovel = imovel
            }
        }
    }
    
    @IBAction func rewindFromDetail(segue: UIStoryboardSegue) {
        
    }
    
}

