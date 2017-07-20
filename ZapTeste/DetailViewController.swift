//
//  DetailViewController.swift
//  ZapTeste
//
//  Created by Rodrigo Kreutz on 9/4/16.
//  Copyright © 2016 Rodrigo Kreutz. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var bottomView: GradientView!
    @IBOutlet weak var topView: GradientView!
    @IBOutlet weak var firstPriceTitle: UILabel!
    @IBOutlet weak var firstPriceValue: UILabel!
    @IBOutlet weak var secondPriceTitle: UILabel!
    @IBOutlet weak var secondPriceValue: UILabel!
    @IBOutlet weak var propertyType: UILabel!
    @IBOutlet weak var imageNumber: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var cityState: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var imovel: Imovel = Imovel(dictionary: nil)
    var contentMode: UIViewContentMode = .ScaleAspectFill
    
    /****************************************************/
    // MARK: - ViewController methods
    /****************************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        if let precoVenda = imovel.precoVenda {
            let numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = .CurrencyStyle
            numberFormatter.locale = NSLocale(localeIdentifier: "pt-BR")
            
            self.firstPriceTitle.text = "PREÇO DE VENDA"
            self.firstPriceValue.text = numberFormatter.stringFromNumber(precoVenda)
            if let precoLocacao = imovel.precoLocacao {
                let numberFormatter = NSNumberFormatter()
                numberFormatter.numberStyle = .CurrencyStyle
                numberFormatter.locale = NSLocale(localeIdentifier: "pt-BR")
                
                self.secondPriceTitle.text = "PREÇO DE LOCAÇÃO"
                self.secondPriceValue.text = numberFormatter.stringFromNumber(precoLocacao)
            } else {
                self.secondPriceTitle.text = ""
                self.secondPriceValue.text = ""
            }
        } else if let precoLocacao = imovel.precoLocacao {
            let numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = .CurrencyStyle
            numberFormatter.locale = NSLocale(localeIdentifier: "pt-BR")
            
            self.firstPriceTitle.text = "PREÇO DE LOCAÇÃO"
            self.firstPriceValue.text = numberFormatter.stringFromNumber(precoLocacao)
            self.secondPriceTitle.text = ""
            self.secondPriceValue.text = ""
        } else {
            self.firstPriceTitle.text = ""
            self.firstPriceValue.text = ""
            self.secondPriceTitle.text = ""
            self.secondPriceValue.text = ""
        }
        
        self.propertyType.text = self.imovel.tipoImovel
        
        self.imageNumber.text = "1 de \(self.imovel.fotos.count)"
        
        if self.imovel.endereco.bairro == "" {
            self.address.text = self.imovel.endereco.logradouro
        } else if self.imovel.endereco.logradouro == "" {
            self.address.text = self.imovel.endereco.bairro
        } else {
            self.address.text = "\(self.imovel.endereco.logradouro) - \(self.imovel.endereco.bairro)"
        }
        
        if self.imovel.endereco.estado == "" {
            self.cityState.text = self.imovel.endereco.cidade
        } else if self.imovel.endereco.cidade == "" {
            self.cityState.text = self.imovel.endereco.estado
        } else {
            self.cityState.text = "\(self.imovel.endereco.cidade) - \(self.imovel.endereco.estado)"
        }
        
        self.map.layer.cornerRadius = 8
        for view in self.map.subviews {
            if view.isKindOfClass(UILabel) {
                view.removeFromSuperview()
            }
        }
        let point = MKPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: -30.035006, longitude: -51.193981)
        self.map.addAnnotation(point)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: -29.970006, longitude: -51.153981), 20000, 20000)
        self.map.setRegion(coordinateRegion, animated: true)
        
        for constraint in self.view.constraints {
            if constraint.identifier == "rightConstraint" && self.imovel.fotos.count <= 1 {
                constraint.constant = -(self.rightButton.frame.width + 8)
            } else if constraint.identifier == "leftConstraint" {
                constraint.constant = -(self.leftButton.frame.width + 8)
            }
        }
    }
    
    /****************************************************/
    // MARK: - CollectionView data source and delegate
    /****************************************************/
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imovel.fotos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("zapCollectionCell", forIndexPath: indexPath) as! ZapCollectionViewCell
        
        cell.propertyImage.image = nil
        cell.propertyImage.downloadedFrom(imovel.fotos[indexPath.item].urlImagem, contentMode: self.contentMode)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch self.contentMode {
        case .ScaleAspectFill:
            self.contentMode = .ScaleAspectFit
            for constraint in self.view.constraints {
                if constraint.identifier == "topConstraint" {
                    constraint.constant = -(self.topView.frame.height)
                } else if constraint.identifier == "bottomConstraint" {
                    constraint.constant = -(self.bottomView.frame.height + self.contactButton.frame.height)
                } else if constraint.identifier == "rightConstraint" {
                    constraint.constant = -(self.rightButton.frame.width + 8)
                } else if constraint.identifier == "leftConstraint" {
                    constraint.constant = -(self.leftButton.frame.width + 8)
                }
            }
            break
        default:
            self.contentMode = .ScaleAspectFill
            for constraint in self.view.constraints {
                if constraint.identifier == "topConstraint" {
                    constraint.constant = 0
                } else if constraint.identifier == "bottomConstraint" {
                    constraint.constant = 0
                } else if constraint.identifier == "rightConstraint" && indexPath.item < self.imovel.fotos.count - 1 {
                    constraint.constant = 0
                } else if constraint.identifier == "leftConstraint" && indexPath.item > 0 {
                    constraint.constant = 0
                }
            }
            break
        }
        
        UIView.animateWithDuration(0.4) { 
            self.view.layoutIfNeeded()
            self.collectionView.reloadSections(NSIndexSet(index: 0))
        }
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let number = collectionView.indexPathsForVisibleItems()[0]
        self.imageNumber.text = "\(number.item + 1) de \(imovel.fotos.count)"
        
        if self.contentMode == UIViewContentMode.ScaleAspectFill {
            if number.item == 0 {
                for constraint in self.view.constraints {
                    if constraint.identifier == "rightConstraint" && number.item < self.imovel.fotos.count - 1 {
                        constraint.constant = 0
                    } else if constraint.identifier == "leftConstraint" {
                        constraint.constant = -(self.leftButton.frame.width + 8)
                    }
                }
            } else if number.item == self.imovel.fotos.count - 1 {
                for constraint in self.view.constraints {
                    if constraint.identifier == "rightConstraint" {
                        constraint.constant = -(self.rightButton.frame.width + 8)
                    } else if constraint.identifier == "leftConstraint" {
                        constraint.constant = 0
                    }
                }
            } else {
                for constraint in self.view.constraints {
                    if constraint.identifier == "rightConstraint" {
                        constraint.constant = 0
                    } else if constraint.identifier == "leftConstraint" {
                        constraint.constant = 0
                    }
                }
            }
        
            UIView.animateWithDuration(0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }

    /****************************************************/
    // MARK: - Interface actions
    /****************************************************/
    
    @IBAction func leftPad(sender: AnyObject) {
        let current = self.collectionView.indexPathsForVisibleItems()[0]
        if current.item > 0 {
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: current.item - 1, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)
        }
    }
    
    @IBAction func rightPad(sender: AnyObject) {
        let current = self.collectionView.indexPathsForVisibleItems()[0]
        if current.item < self.imovel.fotos.count - 1 {
            self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: current.item + 1, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)
        }
    }
    
}
