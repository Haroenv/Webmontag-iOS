//
//  CopyrightViewController.m
//  Webmontag
//
//  Erstellt von Johannes Jakob am 16.03.2015
//  ©2015 Johannes Jakob
//

// Main für Copyright

#import "CopyrightViewController.h"

@interface CopyrightViewController ()

@end

@implementation CopyrightViewController

- (void)viewDidLoad {  // Wird nach dem Laden der View aufgerufen
    [super viewDidLoad];
    
    [CopyrightWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"copyright" ofType:@"html"]isDirectory:NO]]];  // Lade das Copyright (copyright.html) in der WebView
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
