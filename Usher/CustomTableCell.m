//
//  CustomTableCell.m
//  Usher
//
//  Created by Asad Khaliq on 12/3/14.
//  Copyright (c) 2014 Usher Team. All rights reserved.
//

#import "CustomTableCell.h"
#import "NSObject+MyManager.h"

@implementation CustomTableCell


@synthesize nameLabel = _nameLabel;
@synthesize distanceLabel = _distanceLabel;
@synthesize starsLabel = _starsLabel;
@synthesize buttonImage = _buttonImage;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)buttonClicked2:(id)sender {
    NSMutableSet *set = [[MyManager sharedManager] get_completed_activities];
    if (_buttonImage.alpha == 1) {
        _buttonImage.alpha = 0.2;
        [set removeObject:_nameLabel.text];
    } else {
        _buttonImage.alpha = 1;
        [set addObject:_nameLabel.text];
    }
}

@end
