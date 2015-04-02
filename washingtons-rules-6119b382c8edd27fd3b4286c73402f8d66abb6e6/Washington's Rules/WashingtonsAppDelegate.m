//
//  WashingtonsAppDelegate.m
//  Washington's Rules
//
//  Created by John Hayes on 4/1/14.
//  Copyright (c) 2014 SoftWhatever. All rights reserved.
//

#import "WashingtonsAppDelegate.h"

@implementation WashingtonsAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize currentRule = _currentRule;
@synthesize appSettings = _appSettings;

- (NSString *)currentRule
{
    // If currentRule hasn't been set yet, go ahead and update it.
    if (_currentRule == nil) {
        [self initializeCurrentRule];
    }
    
    return _currentRule;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    /* To generate a new set of default rules:
        1. Modify data model.
        2. Comment switch persistentStoreCoordinator messages
        3. Clear the iPhone Simulator's Documents folder
        4. Run the simulator to build the database anew
        5. Comment switch persistentStoreCoordinator again
        6. Modify createStarterDataSet: to include your new data
        7. Uncomment this line
        8. Run
        8. Go find the WashingtonsDataModel.sqlite in iPhone Simulator's Documents folder and overwrite WashingtonsDefaultData.sqlite with it
        9. Comment out this line again
     */
    //[self createStarterDataSet];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // Remember what day it is for rule update purposes:
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSWeekdayCalendarUnit fromDate:[NSDate date]];

    NSString *today = [[NSString alloc] initWithFormat:@"%d", [comp weekday] ] ;
    [self setAppSettingNamed:AppSetting_LastViewedDay to:today];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self updateCurrentRuleIfNeeded];
    
    // DEBUG: ensure a new rule each launch, useful for UI design
    //[self updateCurrentRule];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    
    NSString *today = [[NSString alloc] initWithFormat:@"%d", [comp weekday] ] ;
    [self setAppSettingNamed:AppSetting_LastViewedDay to:today];

}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WashingtonsDataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


// Only use this persistent store coordinator when rebuilding the default data set.
// TODO: find a much better way to build the default data set. Probably just needs
// to be a separate child-project which creates a .sqlite db.

/*
  - (NSPersistentStoreCoordinator *)persistentStoreCoordinator
  {
      if (_persistentStoreCoordinator != nil) {
          return _persistentStoreCoordinator;
      }
 
      NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WashingtonsDataModel.sqlite"];
 
      NSError *error = nil;
      _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
      if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
 
          NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
          abort();
      }
 
      return _persistentStoreCoordinator;
  }
*/


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    @synchronized (self)
    {
        if (_persistentStoreCoordinator != nil)
            return _persistentStoreCoordinator;
        
        NSString *defaultStorePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"WashingtonsDefaultData" ofType:@"sqlite"];
        NSURL *storeDirectoryURL = [self applicationDocumentsDirectory];
        NSString *storePath = [[storeDirectoryURL relativePath] stringByAppendingPathComponent: @"WashingtonsDataModel.sqlite"];
        NSURL *storePathURL = [NSURL fileURLWithPath:storePath];
        
        NSError *error;
        if (![[NSFileManager defaultManager] fileExistsAtPath:storePath])
        {
            if ([[NSFileManager defaultManager] copyItemAtPath:defaultStorePath toPath:storePath error:&error])
                NSLog(@"Copied default data to %@", storePath);
            else
                NSLog(@"Error copying default DB to %@ (%@)", storePath, error);
        }
        
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storePathURL options:options error:&error])
        {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        return _persistentStoreCoordinator;
    }
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Washington's Data methods

// Private function for saving application settings
- (BOOL)setAppSettingNamed:(NSString *)name to:(NSString *)value
{
    BOOL returnValue;
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Setting"  inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(name = %@)", name];
    [request setEntity:entityDesc];
    [request setPredicate:pred];

    NSError *error;
    NSArray *matchedSettings = [[self managedObjectContext] executeFetchRequest:request error:&error];

    NSManagedObject *setting;
    if ([matchedSettings count] == 0) {
        NSLog(@"Saving setting named %@ for the first time. Value is %@.", name, value);
        setting = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:[self managedObjectContext]];
        
        [setting setValue:name forKey:@"name"];
    } else {
        setting = matchedSettings[0];
    }

    [setting setValue:value forKey:@"value"];
    if (![[self managedObjectContext] save:&error]) {
        NSLog(@"Error saving setting named: %@ with value: %@. Error: %@", name, value, error);
        returnValue = NO;
    }

    return YES;
}

// Returns the value of an application setting
- (NSString *)valueForAppSettingNamed:(NSString *)name
{
    NSString *settingValue;
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Setting"
                inManagedObjectContext:[self managedObjectContext]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(name = %@)", name];
    [request setEntity:entityDesc];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *matchedSettings = [[self managedObjectContext] executeFetchRequest:request error:&error];
    
    if ([matchedSettings count] == 0) {
        NSLog(@"setting named %@ was requested but not found.", name);
        settingValue = nil;
    } else {
        settingValue = [matchedSettings[0] valueForKey:@"value"];
    }
    
    return settingValue;
}

#pragma mark - Rule methods

// Initializes current rule - sets it to last viewed rule then updates if needed
- (void)initializeCurrentRule
{
    NSString *lastViewedRule = [self valueForAppSettingNamed:AppSetting_LastViewedRuleText];
    if (lastViewedRule == nil) {
        [self updateCurrentRule];
    } else {
        _currentRule = lastViewedRule;
    }
    
    [self updateCurrentRuleIfNeeded];
}

// Updates the current rule only if it's a new day since last updating rule
- (void)updateCurrentRuleIfNeeded
{
    NSString *lastViewedDay = [self valueForAppSettingNamed:AppSetting_LastViewedDay];    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSWeekdayCalendarUnit fromDate:[NSDate date]];

    // If it's not the same day as when last viewed, change the rule.
    if ([comp weekday] != [lastViewedDay integerValue]) {
        [self updateCurrentRule];
    }

}

// Updates the current rule. Call this any time you need to 
- (void)updateCurrentRule
{
    _currentRule = [self randomRuleText];
    
    // Update the view

    
    // Remember in settings the rule and day it was viewed
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSString *today = [[NSString alloc] initWithFormat:@"%d", [comp weekday]];
    
    [self setAppSettingNamed:AppSetting_LastViewedDay to:today];
    [self setAppSettingNamed:AppSetting_LastViewedRuleText to:_currentRule];

}

// Returns the text of a randomly chosen rule in the entire data set.
- (NSString *)randomRuleText
{

    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Rule"
                inManagedObjectContext:[self managedObjectContext]];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSError *error;
    NSUInteger objectCount = [[self managedObjectContext] countForFetchRequest:request error:&error];
    
    int randNum = arc4random() % (objectCount + 1);
    
    NSManagedObject *result = [[[self managedObjectContext ] executeFetchRequest:request error:&error] objectAtIndex:randNum];
    NSString *randomRuleText = [result valueForKey:@"text"];
    
    return randomRuleText;

}

#pragma mark - Utility Functions


// Builds the starter data file and puts it wherever the simulator stores its data.
- (void)createStarterDataSet
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    [context setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
    NSManagedObject *newRule;
    NSError *error;
    
    // Default rules data begins here
    NSArray *defaultRuleTexts = @[
                                  @"Every action done in company ought to be with some sign of respect to those that are present.",
                                  @"When in company, put not your hands to any part of the body not usually discovered.",
                                  @"Show nothing to your friend that may affright him.",
                                  @"In the presence of others sing not to yourself with a humming noise, nor drum with your fingers or feet.",
                                  @"If you cough, sneeze, sigh, or yawn, do it not loud but privately; and speak not in your yawning, but put your handkerchief or hand before your face and turn aside.",
                                  @"Sleep not when others speak, sit not when others stand, speak not when you should hold your peace, walk not on when others stop.",
                                  @"Put not off your clothes in the presence of others, nor go out your chamber half dressed.",
                                  @"At play and at fire it's good manners to give place to the last comer, and affect not to speak louder than ordinary.",
                                  @"Spit not in the fire, nor stoop low before it, neither put your hands into the flames to warm them, nor set your feet upon the fire especially if there be meat before it.",
                                  @"When you sit down, keep your feet firm and even, without putting one on the other or crossing them.",
                                  @"Shift not yourself in the sight of others nor gnaw your nails.",
                                  @"Shake not the head, feet, or legs, roll not the eyes, lift not one eyebrow higher than the other, wry not the mouth, and bedew no mans face with your spittle by approaching too near him when you speak.",
                                  @"Kill no vermin as fleas, lice, ticks, etc. in the sight of others. If you see any filth or thick spittle put your foot dexterously upon it; if it be upon the clothes of your companions, put it off privately, and if it be upon your own clothes return thanks to him who puts it off.",
                                  @"Turn not your back to others especially in speaking, jog not the table or desk on which another reads or writes, lean not upon any one.",
                                  @"Keep your nails clean and short, also your hands and teeth clean, yet without showing any great concern for them.",
                                  @"Do not puff up the cheeks, loll not out the tongue, rub the hands, or beard, thrust out the lips, or bite them or keep the lips too open or too close.",
                                  @"Be no flatterer, neither play with any that delights not to be play'd withal.",
                                  @"Read no letters, books, or papers in company; but when there is a cecessity for the doing of it you must ask leave. Come not near the books or writings of another so as to read them unless desired, nor give your opinion of them unasked; also look not nigh when another is writing a letter.",
                                  @"Let your countenance be pleasant, but in serious matters somewhat grave.",
                                  @"The gestures of the body must be suited to the discourse you are upon.",
                                  @"Reproach none for the infirmities of Nature, nor delight to put them that have in mind thereof.",
                                  @"Show not yourself glad at the misfortune of another, even though he were your enemy.",
                                  @"When you see a crime punished, you may be inwardly pleased; but always show pity to the suffering offender.",
                                  @"Do not laugh too loud or too much at any public spectacle.",
                                  @"Superfluous complements and all affectation of ceremony are to be avoided, yet where due they are not to be neglected.",
                                  @"In pulling off your hat to persons of distinction, such as noblemen, justices, churchmen etc., make a reverence, bowing more or less according to the custom of the better bred and quality of the person. Amongst your equals expect not always that they should begin with you first, but to pull off the hat when there is no need is affectation. In the manner of saluting and resaluting in words keep to the most usual Custom.",
                                  @"Tis ill manners to bid one more eminent than yourself be covered, as well as not to do it to whom it's due. Likewise he that makes too much haste to put on his hat does not well, yet he ought to put it on at the first, or at most the second time of being asked. Now what is herein spoken of qualification in behavior in saluting ought also to be observed in taking of place and sitting down, for ceremonies without bounds is troublesome.",
                                  @"If any one come to speak to you while you are are sitting, stand up though he be your inferior, and when you present seats let it be to every one according to his degree.",
                                  @"When you meet with one of greater quality than yourself, stop and retire, especially if it be at a door or any straight place, to give way for him to pass.",
                                  @"In walking the highest place in most countries seems to be on the right hand, therefore place yourself on the left of him whom you desire to honor; but if three walk together the middest place is the most honorable, and the wall is usually given to the most worthy if two walk together.",
                                  @"If any one far surpasses others, either in age, estate, or merit, yet would give place to a meaner than himself in his own lodging or elsewhere, the one ought not to except it; likewise he on the other part should not use much earnestness, nor offer it above once or twice.",
                                  @"To one that is your equal, or not much inferior you are to give the chief place in your lodging and he to who it is offered ought at the first to refuse it but at the second to accept though not without acknowledging his own unworthiness.",
                                  @"They that are in dignity or in office have in all places precedency, but whilst they are young they ought to respect those that are their equals in birth or other qualities though they have no public charge.",
                                  @"It is good manners to prefer them to whom we speak before ourselves, especially if they be above us, with whom in no sort we ought to begin.",
                                  @"Let your discourse with men of business be short and comprehensive.",
                                  @"Artificers & persons of low degree ought not to use many ceremonies to lords or others of high degree, but respect and highly honor them, and those of high degree ought to treat them with affability & courtesy, without arrogance.",
                                  @"In speaking to men of quality do not lean nor look them full in the face, nor approach too near them; at least keep a full pace from them.",
                                  @"In visiting the sick, do not presently play the physician if you be not knowing therein.",
                                  @"In writing or speaking, give to every person his due title according to his degree & the custom of the place.",
                                  @"Strive not with your superiors in argument, but always submit your judgment to others with modesty.",
                                  @"Undertake not to teach your equal in the art he himself professes; it savours of arrogance.",
                                  @"Let thy ceremonies in courtesy be proper to the dignity of his place with whom thou converses, for it is absurd to act the same with a clown and a prince.",
                                  @"Do not express joy before one sick or in pain for that contrary passion will aggravate his misery.",
                                  @"When a man does all he can, though it succeeds not well, blame not him that did it.",
                                  @"Being to advise or reprehend any one, consider whether it ought to be in public or in private, presently or at some other time, and in what terms to do it. And in reproving show no sign of cholar but do it with all sweetness and mildness.",
                                  @"Take all admonitions thankfully in what time or place soever given, but afterwards not being culpable, take a time & place convenient to let him him know it that gave them.",
                                  @"Mock not nor jest at any thing of importance, break no jests that are sharp biting, and if you deliver any thing witty and pleasant abstain from laughing thereat yourself.",
                                  @"Wherein you reprove another be unblameable yourself; for example is more prevalent than precepts.",
                                  @"Use no reproachful language against any one, neither curse nor revile.",
                                  @"Be not hasty to believe flying reports to the disparagement of any.",
                                  @"Wear not your clothes foul, ripped, or dusty but see they be brushed once every day at least and take heed that you approach not to any uncleaness.",
                                  @"In your apparel be modest, and endeavor to accommodate nature rather than to procure admiration. Keep to the fashion of your equals such as are civil and orderly with respect to times and places.",
                                  @"Run not in the streets, neither go too slowly, nor with mouth open, go not shaking your arms, kick not the earth with your feet, go not upon the toes, nor in a dancing fashion.",
                                  @"Play not the peacock, looking every where about you to see if you be well decked, if your shoes fit well, if your stockings sit neatly, and clothes handsomely.",
                                  @"Eat not in the streets, nor in the House, out of season.",
                                  @"Associate yourself with men of good quality if you esteem your own reputation; for 'tis better to be alone than in bad company.",
                                  @"In walking up and down in a house, only with one in company if he be greater than yourself, at the first give him the right hand and stop not till he does and be not the first that turns, and when you do turn let it be with your face towards him; if he be a man of great quality, walk not with him cheek by jowl but somewhat behind him, but yet in such a manner that he may easily speak to you.",
                                  @"Let your conversation be without malice or envy, for 'tis a sign of a tractable and commendable nature. And in all causes of passion admit reason to govern.",
                                  @"Never express anything unbecoming, nor act against the rules moral before your inferiors.",
                                  @"Be not immodest in urging your friends to discover a secret.",
                                  @"Utter not base and frivolous things amongst grave and learned men, nor very difficult questions or subjects among the ignorant, or things hard to be believed. Stuff not your discourse with sentences amongst your betters nor equals.",
                                  @"Speak not of doleful things in a time of mirth or at the table. Speak not of melancholy things as death and wounds, and if others mention them change if you can the discourse. Tell not your dreams but to your intimate friend.",
                                  @"A man ought not to value himself of his achievements, or rare qualities of wit, much less of his riches, virtue, or kindred.",
                                  @"Break not a jest where none take pleasure in mirth. Laugh not aloud, nor at all without occasion. Deride no mans misfortune, though there seem to be some cause.",
                                  @"Speak not injurious words neither in jest nor earnest; scoff at none although they give occasion.",
                                  @"Be not forward but friendly and courteous; the first to salute, hear, and answer; & be not pensive when it's a time to converse.",
                                  @"Detract not from others, neither be excessive in commanding.",
                                  @"Go not thither where you know not whether you shall be welcome or not. Give not advice without being asked & when desired do it briefly.",
                                  @"If two contend together take not the part of either unconstrained; and be not obstinate in your own opinion. In things indifferent be of the major side.",
                                  @"Reprehend not the imperfections of others, for that belongs to parents, masters, and superiors.",
                                  @"Gaze not on the marks or blemishes of others and ask not how they came. What you may speak in secret to your friend deliver not before others.",
                                  @"Speak not in an unknown tongue in company but in your own language, and that as those of quality do and not as the Vulgar. Sublime matters treat seriously.",
                                  @"Think before you speak. Pronounce not imperfectly, nor bring out your words too hastily, but orderly & distinctly.",
                                  @"When another speaks, be attentive yourself and disturb not the audience. If any hesitate in his words help him not, nor prompt him without desired, interrupt him not, nor answer him till his speech be ended.",
                                  @"In the midst of discourse ask not of what one treateth, but if you perceive any stop because of your coming you may well intreat him gently to proceed. If a person of quality comes in while you are conversing it's handsome to repeat what was said before.",
                                  @"While you are talking, point not with your finger at him of whom you discourse nor approach too near him to whom you talk, especially to his face.",
                                  @"Treat with men at fit times about business & whisper not in the company of others.",
                                  @"Make no comparisons, and if any of the company be commended for any brave act of virtue, commend not another for the same.",
                                  @"Be not apt to relate news if you know not the truth thereof. In discoursing of things you have heard, name not your author always. A secret discover not.",
                                  @"Be not tedious in discourse or in reading unless you find the company pleased therewith.",
                                  @"Be not curious to know the affairs of others, neither approach those that speak in private.",
                                  @"Undertake not what you cannot perform but be careful to keep your promise.",
                                  @"When you deliver a matter do it without passion & with discretion, however mean the person be you do it to.",
                                  @"When your superiors talk to any body hearken not, neither speak, nor laugh.",
                                  @"In company of these of higher quality than yourself speak not til you are asked a question, then stand upright, put of your hat & answer in few words.",
                                  @"In disputes, be not so desirous to overcome as not to give liberty to each one to deliver his opinion and submit to the judgment of the major part, especially if they are judges of the dispute.",
                                  @"Let thy carriage be such as becomes a man grave: settled and attentive to that which is spoken. Contradict not at every turn what others say.",
                                  @"Be not tedious in discourse, make not many digressions, nor repeat often the same manner of discourse.",
                                  @"Speak not evil of the absent for it is unjust.",
                                  @"Being set at meat scratch not neither spit, cough, or blow your nose except there's a necessity for it.",
                                  @"Make no show of taking great delight in your victuals, feed not with greediness; cut your bread with a knife, lean not on the table, neither find fault with what you eat.",
                                  @"Take no salt or cut bread with your knife greasy.",
                                  @"Entertaining any one at the table, it is decent to present him with meat. Undertake not to help others undesired by the master.",
                                  @"If you soak bread in the sauce let it be no more than what you put in your mouth at a time, and blow not your broth at table but stay till cools of it self.",
                                  @"Put not your meat to your mouth with your knife in your hand, neither spit forth the stones of any fruit pie upon a dish, nor cast anything under the table.",
                                  @"It's unbecoming to stoop much to one's meat. Keep your fingers clean & when foul wipe them on a corner of your table napkin.",
                                  @"Put not another bit into your mouth till the former be swallowed. Let not your morsels be too big for the jowls.",
                                  @"Drink not nor talk with your mouth full; neither gaze about you while you are drinking.",
                                  @"Drink not too leisurely nor yet too hastily. Before and after drinking, wipe your lips; breath not then or ever with too great a noise, for its uncivil.",
                                  @"Cleanse not your teeth with the table cloth napkin, fork, or knife; but if others do it, let it be done without a peep to them.",
                                  @"Rinse not your mouth in the presence of others.",
                                  @"It is out of use to call upon the company often to eat; nor need you drink to others every time you drink.",
                                  @"In the company of your betters, be not longer in eating than they are; lay not your arm but only your hand upon the table.",
                                  @"It belongs to the chiefest in company to unfold his napkin and fall to meat first, but he ought then to begin in time & to dispatch with dexterity that the slowest may have time allowed him.",
                                  @"Be not angry at the table whatever happens, & if you have reason to be so show it not; put on a cheerful countenance especially if there be strangers, for good humor makes one dish of meat a feast.",
                                  @"Set not yourself at the upper of the table; but if it be your due or that the master of the house will have it so, contend not, least you should trouble the company.",
                                  @"If others talk at the table, be attentive but talk not with meat in your mouth.",
                                  @"When you speak of God or his attributes, let it be seriously & with reverence. Honor & obey your natural parents although they be poor.",
                                  @"Let your recreations be manful not sinful.",
                                  @"Labor to keep alive in your breast that little spark of celestial fire called conscience."
                                  ];
    
    // Saving each rule
    for (id ruleText in defaultRuleTexts) {
        newRule = [NSEntityDescription insertNewObjectForEntityForName:@"Rule" inManagedObjectContext:context];

        [newRule setValue:ruleText forKey:@"text"];
        if (![context save:&error]) { NSLog(@"Error saving: %@", error); }
    }

    NSLog(@"Done initial load");
    
}

@end
