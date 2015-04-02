#import "PTHolesViewController.h"
#import "PTRound.h"
#import "PTPuttViewController.h"
#import "UIView+Resize.h"
#import "UIViewController+CoreData.h"

@interface PTHolesViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) PTRound *round;
@property (strong, nonatomic) NSMutableArray *holeViewControllers;

@end

@implementation PTHolesViewController

#pragma mark - initialize

- (id)init {
	self = [super init];

	if (self) {
		[self initialize];
	}
	
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if (self) {
		[self initialize];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		[self initialize];
	}
	
	return self;
}

- (void) initialize {
	self.round = [PTRound newEntity];
}

#pragma mark - load view

- (void)viewDidLoad {
	[super viewDidLoad];
	[self addHoles];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self updateScrollViewContentSize];
}

- (void) addHoles {
	self.holeViewControllers = [[NSMutableArray alloc] init];
	
	NSInteger holeNumber = 0;
		
	for (PTHole *hole in self.round.holes) {
		PTPuttViewController *holeViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([PTPuttViewController class])];
		[self.holeViewControllers addObject:holeViewController];
		[self.scrollView addSubview:holeViewController.view];
		
		holeViewController.view.frame = self.scrollView.bounds;
		float x = self.scrollView.frame.size.width * holeNumber;
		holeViewController.view.x = x;
		holeNumber++;
	}
}

- (void) updateScrollViewContentSize {
	NSInteger countOfHoles = self.round.holes.count;
	float width = self.scrollView.frame.size.width * countOfHoles;
	float height = self.scrollView.frame.size.height;
	self.scrollView.contentSize = CGSizeMake(width, height);
}

@end
