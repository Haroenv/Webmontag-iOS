//
//  VideosViewController.h
//  Webmontag
//
//  Erstellt von Johannes Jakob am 15.03.2015
//  ©2015 Johannes Jakob
//

// Header für Videos

#import <UIKit/UIKit.h>

@interface VideosViewController : UITableViewController <NSXMLParserDelegate>  // NSXMLParserDelegate für XML-Parser notwendig

@property (strong, nonatomic) IBOutlet UITableView *VideosTableView;  // Deklariere VideosTableView als IBOutlet

@end
