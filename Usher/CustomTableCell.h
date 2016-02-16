//
//  CustomTableCell.h
//  Usher
//
//  Created by Asad Khaliq on 12/3/14.
//  Copyright (c) 2014 Usher Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *starsLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonImage;

@end
