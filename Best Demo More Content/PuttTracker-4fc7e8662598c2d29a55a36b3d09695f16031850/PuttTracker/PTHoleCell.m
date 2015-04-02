#import "PTHoleCell.h"
#import "PTHole.h"

@implementation PTHoleCell

- (void)setHole:(PTHole *)hole {
	_hole = hole;
	[self updateUI];
}

- (void) updateUI {
	self.textLabel.text = self.hole.description;
}

@end
