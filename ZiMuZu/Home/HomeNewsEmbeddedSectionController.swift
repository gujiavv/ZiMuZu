//
//  HomeNewsEmbeddedSectionController.swift
//  ZiMuZu
//
//  Created by 张洋威 on 2017/8/7.
//  Copyright © 2017年 zhangyangwei.com. All rights reserved.
//

import UIKit
import IGListKit
import Kingfisher

let newsSectionInsetsWidth: CGFloat = 20.0
let newsMiniLineSpacing: CGFloat = 10.0
var newsItemWidth: CGFloat = (kScreenWidth - 2 * newsSectionInsetsWidth)

class HomeNewsEmbeddedSectionController: ListSectionController {
    private var tvs: TVs?
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: newsSectionInsetsWidth, bottom: 0, right: newsSectionInsetsWidth)
        self.minimumLineSpacing = newsMiniLineSpacing
    }
    
    override func numberOfItems() -> Int {
        return tvs?.tvs.count ?? 0
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let height = collectionContext?.containerSize.height ?? 0
        return CGSize(width: newsItemWidth, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(withNibName: "NewsCell", bundle: nil, for: self, at: index) as? NewsCell else {
            fatalError()
        }
        let news = tvs?.tvs[index] as! News
        cell.newsTitle.text = news.title
        cell.newsType.text = news.type_cn
        cell.posterImageView.kf.setImage(with: news.poster)
        cell.postDate.text = news.datelineString
        return cell
    }
    
    override func didUpdate(to object: Any) {
        tvs = object as? TVs
    }
}

final class HomeNewsEmbeddedCollectionViewCell: UICollectionViewCell {
    
    lazy var collectionView: UICollectionView = {
        let layout = HomeNewsLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        self.contentView.addSubview(view)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.frame
    }
}

final class HomeNewsLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if velocity.x == 0 {
            return proposedContentOffset
        }
        var index: Float
        if velocity.x > 0 {
            index = ceil(Float((proposedContentOffset.x - newsSectionInsetsWidth - newsItemWidth * 0.3) / (newsItemWidth + newsMiniLineSpacing)))
        } else {
            index = floor(Float((proposedContentOffset.x - newsSectionInsetsWidth - newsItemWidth * 0.7) / (newsItemWidth + newsMiniLineSpacing)))
        }
        return CGPoint(x: CGFloat(index) * CGFloat(newsItemWidth + newsMiniLineSpacing), y: 0)
    }
    
}

