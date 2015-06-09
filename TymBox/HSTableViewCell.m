//
//  HSTableViewCell.m
//  TymBox030915
//
//  Created by Rama Krishna.G on 06/05/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import "HSTableViewCell.h"

@implementation HSTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _name = [[UILabel alloc] initWithFrame:(CGRectMake(66, 19, 180, 21))];
        _name.font = [UIFont systemFontOfSize:12];
        
        //_detailsLbl = [[UILabel alloc] initWithFrame:(CGRectMake(20, 35, 235, 21))];
        //_detailsLbl.font = [UIFont systemFontOfSize:12];
        //_seekerNamelbl.textAlignment = NSTextAlignmentCenter;
        
        //_valueLbl = [[UILabel alloc] initWithFrame:(CGRectMake(271, 22, 42, 21))];
        //_valueLbl.font = [UIFont systemFontOfSize:12];
        //_classificationLabel.textAlignment = NSTextAlignmentCenter;
        _ratingbtn = [[UIButton alloc] initWithFrame:(CGRectMake(250,16, 27, 27))];
        [_ratingbtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        //_valueBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blackButton.png"]];
        
        [_ratingbtn setBackgroundImage:[UIImage imageNamed:@"blackButton.png"]
                             forState:UIControlStateNormal];
        
        [self.contentView addSubview:_name];
        //[self.contentView addSubview:_detailsLbl];
        //[self.contentView addSubview:_valueLbl];
        [self.contentView addSubview:_ratingbtn];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
