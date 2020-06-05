//
//  AppDelegate.swift
//  OMDB
//
//  Created by Sachindra on 04/06/20.
//  Copyright © 2020 Sachindra Pandey. All rights reserved.
//

import UIKit

class BaseCollectionViewController: UICollectionViewController {
    let sectionInsets = UIEdgeInsets(top: 20.0, left: 15.0, bottom: 20.0, right: 15.0)
    let backdropImageAspectRatio = (width: CGFloat(3.0), height: CGFloat(4.0))
    var collectionViewItemSize: CGSize {
        let paddingSpace = sectionInsets.left + sectionInsets.right + collectionView.contentInset.left + collectionView.contentInset.right
        let availableWidth = view.safeAreaLayoutGuide.layoutFrame.width - paddingSpace
        let availableHeight = availableWidth * backdropImageAspectRatio.height/backdropImageAspectRatio.width
        return CGSize(width: availableWidth, height: availableHeight);
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension BaseCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewItemSize.width/2.0, height: collectionViewItemSize.height/2.0);
    }
}
