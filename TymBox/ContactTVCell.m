//
//  ContactTVCell.m
//  TymBox030915
//
//  Created by Bhagavan on 3/30/15.
//  Copyright (c) 2015 vertex. All rights reserved.
//

#import "ContactTVCell.h"

@implementation ContactTVCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _contactImage = [[UIImageView alloc] initWithFrame:(CGRectMake(10, 5, 50, 50))];
        
        _fullnamelbl = [[UILabel alloc] initWithFrame:(CGRectMake(68, 8, 232, 21))];
        _fullnamelbl.font = [UIFont systemFontOfSize:12];
        //_seekerNamelbl.textAlignment = NSTextAlignmentCenter;
        
        _phonelbl = [[UILabel alloc] initWithFrame:(CGRectMake(68, 30, 86, 21))];
        _phonelbl.font = [UIFont systemFontOfSize:12];
        
        _emaillbl = [[UILabel alloc] initWithFrame:(CGRectMake(164, 30, 142, 21))];
        _emaillbl.font = [UIFont systemFontOfSize:12];
        //_classificationLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_contactImage];
        [self.contentView addSubview:_phonelbl];
        [self.contentView addSubview:_emaillbl];
        [self.contentView addSubview:_fullnamelbl];
    }
    
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
