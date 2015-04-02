//
//  VoiceCell.m
//  Marenba
//
//  Created by sunqichao on 14-2-10.
//  Copyright (c) 2014年 sun qichao. All rights reserved.
//

#import "VoiceCell.h"

@implementation VoiceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)playVoice:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayCellVoiceotification" object:_selectObject];

}

@end
