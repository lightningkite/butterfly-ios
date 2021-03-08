//
//  CircleImageView.swift
//  Butterfly
//
//  Created by Joseph Ivie on 10/2/20.
//

import UIKit

public class CircleImageView: UIImageView {
    public override func layoutSubviews(){
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2
    }
}
