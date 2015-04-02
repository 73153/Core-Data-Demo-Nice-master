#import "NSObject+Alerts.h"

@implementation NSObject (Alerts)

- (void)showAlertForError:(NSError *)error {
	[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
}

- (void)showAlertWithMessage:(NSString *)message {
	[[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil] show];
}

@end
