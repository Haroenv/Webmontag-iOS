//
//  JobsViewController.m
//  Webmontag
//
//  Erstellt von Johannes Jakob am 05.04.2015
//  ©2015 Johannes Jakob
//

#import "JobsViewController.h"
#import "Reachability.h"  // Importiere Klasse zum Überprüfen der Internetverbindung

@interface JobsViewController () {
    // Deklariere Objekte und Variablen für das Parsen des RSS-Feeds
    
    NSXMLParser *Parser;  // XML-Parser
    NSMutableArray *Feed;  // Array, welches nach dem Parsen alle benötigten Informationen zu den Jobs enthält (enthält Dictionarys, welche Strings mit den Informationen enthalten)
    NSMutableDictionary *Item;  // Dictionary, in welchem der Titel, die Beschreibung und der Link des Jobs gesichert werden
    NSMutableString *Title;  // Hilfsvariable für Titel des Jobs
    NSMutableString *Description;  // Hilfsvariable für Beschreibung des Jobs
    NSMutableString *Link;  // Hilfsvariable für Link des Jobs
    NSMutableString *Category;  // Hilfsvariable für Kategorie des Jobs
    NSString *Element;  // Hilfsvariable für aktuelles XML-Element
    bool HasInternet;  // Hilfsvariable für Vorhandensein einer Internetverbindung
}

@end

@implementation JobsViewController

- (void)viewDidLoad {  // Wird nach dem Laden der View aufgerufen
    [super viewDidLoad];
    
    // Erstelle refreshControl, damit Tabelle aktualisiert werden kann (ruft Funktion RefreshTable auf)
    
    UIRefreshControl *RefreshControl = [[UIRefreshControl alloc] init];
    [RefreshControl addTarget:self action:@selector(RefreshTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = RefreshControl;
    
    // Stelle die URL für den RSS-Feeds anhand der Auswahlen in der JobsKategorien-View zusammen
    
    NSMutableString *URL = [NSMutableString stringWithString:@"http://webwirtschaft.net/?feed=job_feed&type"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    bool Freelance = [defaults boolForKey:@"Freelance"];
    bool Praktikum = [defaults boolForKey:@"Praktikum"];
    bool Projektbezogen = [defaults boolForKey:@"Projektbezogen"];
    bool Teilzeit = [defaults boolForKey:@"Teilzeit"];
    bool Vollzeit = [defaults boolForKey:@"Vollzeit"];
    
    if (!Freelance || !Praktikum || !Projektbezogen || !Teilzeit || !Vollzeit) {
        [URL appendString:@"="];
    }
    
    if (!Freelance) {
        [URL appendString:@"freelance,"];
    }
    
    if (!Praktikum) {
        [URL appendString:@"praktikum,"];
    }
    
    if (!Projektbezogen) {
        [URL appendString:@"projektbezogen,"];
    }
    
    if (!Teilzeit) {
        [URL appendString:@"teilzeit,"];
    }
    
    if (!Vollzeit) {
        [URL appendString:@"vollzeit,"];
    }
    
    [URL deleteCharactersInRange:NSMakeRange([URL length] - 1, 1)];  // Entferne letzten Character (letztes Komma)
    [URL appendString:@"&location&job_categories&s"];
    
    // Deklariere Objekte zur Überprüfung der Internetverbindung
    
    Reachability *InternetReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus NetworkStatus = [InternetReachability currentReachabilityStatus];
    
    if (NetworkStatus == NotReachable) {  // Wenn keine Internetverbindung besteht
        HasInternet = false;
        
        // Erstelle UITextView, die Text "Keine Internetverbindung" enthält und als tableFooterView verwendet wird (bei fehlender Internetverbindung wird nur die UITextView angezeigt)
        
        UITextView *NoInternetTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, 290, 100)];
        NoInternetTextView.text = @"Keine Internetverbindung";
        NoInternetTextView.textColor = [UIColor grayColor];
        NoInternetTextView.font = [UIFont systemFontOfSize:20];
        NoInternetTextView.editable = false;
        NoInternetTextView.scrollEnabled = false;
        self.tableView.tableFooterView = NoInternetTextView;
        
        // Zeige Fehlermeldung
        
        UIAlertView *NoInternetAlertView = [[UIAlertView alloc] initWithTitle:@"Keine Internetverbindung" message:@"Es besteht keine Verbindung zum Internet. Bitte überprüfe Deine Einstellungen." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [NoInternetAlertView show];
    } else {  // Wenn Internetverbindung besteht
        HasInternet = true;
        
        Feed = [[NSMutableArray alloc] init];  // Initialisiere Array Feed (zurücksetzen)
        NSURL *FeedURL = [NSURL URLWithString:URL];  // Deklariere URL als URL für XML-Parser
        Parser = [[NSXMLParser alloc] initWithContentsOfURL:FeedURL];  // Initialisiere XML-Parser mit URL
        [Parser setDelegate:self];  // Setze Delegate des XML-Parsers auf sich selbst
        [Parser setShouldResolveExternalEntities:NO];
        [Parser parse];  // Beginne das Parsen
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {  // Wird aufgerufen, wenn XML-Parser ein neues XML-Element begonnen hat
    Element = elementName;  // Sichere Namen des XML-Elements in Hilfsvariable
    
    if ([Element isEqualToString:@"item"]) {  // Wenn Element == "item" (item entspricht einem Job)
        // Initialisiere folgende Objekte (zurücksetzen)
        
        Item = [[NSMutableDictionary alloc] init];
        Title = [[NSMutableString alloc] init];
        Description = [[NSMutableString alloc] init];
        Link = [[NSMutableString alloc] init];
        Category = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {  // Wird aufgerufen, wenn XML-Parser Text in einem Element findet (z.B. <title>Gefundener Text</title>)
    if ([Element isEqualToString:@"title"]) {  // Wenn Element == "title"
        [Title appendString:string];  // Sichere gefundenen Text in Title
    } else if ([Element isEqualToString:@"description"]) {  // Wenn Element == "description"
        // Erstelle Scanner und Hilfsvariable, um HTML-Tags zu entfernen
        
        NSScanner *HTMLTagsScanner;
        NSString *HTMLTag = nil;
        HTMLTagsScanner = [NSScanner scannerWithString:string];
        while ([HTMLTagsScanner isAtEnd] == NO) {
            [HTMLTagsScanner scanUpToString: @"<" intoString: NULL];
            [HTMLTagsScanner scanUpToString: @">" intoString: &HTMLTag];
            string = [string stringByReplacingOccurrencesOfString:[NSString stringWithFormat: @"%@>", HTMLTag] withString: @""];
        }
        
        [Description appendString:string];  // Sichere gefundenen und bereinigten Text in Description
    } else if ([Element isEqualToString:@"link"]) {  // Wenn Element == "link"
        [Link appendString:string];  // Sichere gefundenen Text in Link
    } else if ([Element isEqualToString:@"job_listing:job_type"]) {  // Wenn Element == "job_listing:job_type"
        [Category appendString:string];  // Sichere gefundenen Text in Category
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {  // Wird aufgerufen, wenn XML-Parser ein XML-Element beendet hat
    if ([elementName isEqualToString:@"item"]) {  // Wenn Element == "item" (Wenn Job abgeschlossen)
        // Sichere Titel, Beschreibung und Link des Artikels in Dictionaray und füge dieses dem Array hinzu
        
        Item[@"title"] = Title;
        Item[@"description"] = Description;
        Item[@"link"] = Link;
        Item[@"job_listing:job_type"] = Category;
        [Feed addObject:[Item copy]];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {  // Wird aufgerufen, wenn XML-Parser das Dokument beendet hat
    UIView *TableViewFooter = [[UIView alloc] initWithFrame:(CGRectZero)];  // Erstelle leere View, die als tableFooterView dient, damit keine leeren Tabellen-Zellen angezeigt werden
    
    // Erstelle UITextView, die Text "Keine Jobs in den ausgewählten Kategorien" enthält und als tableFooterView verwendet wird (bei fehlenden Jobs in den ausgewählten Kategorien wird nur die UITextView angezeigt)
    
    UITextView *NoJobsTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, 290, 100)];
    NoJobsTextView.text = @"Keine Jobs in den ausgewählten Kategorien";
    NoJobsTextView.textColor = [UIColor grayColor];
    NoJobsTextView.font = [UIFont systemFontOfSize:20];
    NoJobsTextView.editable = false;
    NoJobsTextView.scrollEnabled = false;
    
    if (Feed.count == 0 && HasInternet) {  // Wenn keine Jobs und keine Internetverbindung
        self.tableView.tableFooterView = NoJobsTextView;  // tableFooterView = NoJobsTextView;
    } else if (Feed.count != 0) {  // Wenn Anzahl der Jobs != 0
        self.tableView.tableFooterView = TableViewFooter;  //tableFooterView = TableFooterView
    }
    
    [self.tableView reloadData];  // Lade Tabelleninhalt neu
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {  // Anzahl der Sektionen in der Tabelle (1)
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {  // Anzahl der Reihen in der Tabelle (Anzahl der Jobs)
    return Feed.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  // Wird für jede Tabellen-Zelle aufgerufen (indexPath.row = Position der Zelle)
    UITableViewCell *TableViewCell = [tableView dequeueReusableCellWithIdentifier:@"JobsCell" forIndexPath:indexPath];    // Deklariere Tabellen-Zelle als Zelle der Tabelle mit der ID "JobsCell" (im Storyboard festgelegt)
    
    // Ändere Text der Tabellen-Zelle zu Wert mit entsprechendem Schlüssel im Dictionary an der Stelle indexPath.row und lege die Schriftfarbe für das Antippen fest
    
    TableViewCell.textLabel.text = Feed[indexPath.row][@"title"];
    TableViewCell.textLabel.highlightedTextColor = [UIColor whiteColor];
    TableViewCell.detailTextLabel.text = Feed[indexPath.row][@"description"];
    TableViewCell.detailTextLabel.highlightedTextColor = [UIColor whiteColor];
    
    // Setze Symbol, welches die Kategorie angibt (anhand der im RSS-Feed gefundenen Kategorie)
    
    NSString *ImageNameString = Feed[indexPath.row][@"job_listing:job_type"];
    ImageNameString = [ImageNameString substringToIndex:[ImageNameString length] - 1];
    NSMutableString *ImageName = [NSMutableString stringWithString:ImageNameString];
    NSMutableString *SelectedImageName = [NSMutableString stringWithString:ImageNameString];
    [ImageName appendString:@".png"];
    [SelectedImageName appendString:@"Selected.png"];
    TableViewCell.imageView.image = [UIImage imageNamed:ImageName];
    TableViewCell.imageView.highlightedImage = [UIImage imageNamed:SelectedImageName];
    
    // Erstelle View mit grünem Hintergrund und lege sie als Hintergrund-View für angetippte Tabellen-Zellen fest
    
    UIView *TableViewCellSelection = [[UIView alloc] init];
    TableViewCellSelection.backgroundColor = [UIColor colorWithRed:0 green:0.75 blue:0.474 alpha:1];
    [TableViewCell setSelectedBackgroundView:TableViewCellSelection];
    
    return TableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {  // Wird aufgerufen, wenn eine Tabellen-Zelle angetippt wurde
    // Sichere Titel und Link des angetippten Jobs in den UserDefaults, damit diese Informationen in der Job-View genutzt werden können
    
    NSString *JobTitel = (Feed[indexPath.row])[@"title"];
    JobTitel = [JobTitel stringByReplacingOccurrencesOfString:@"\n\t\t" withString:@""];  // Entferne Escape-Zeichen
    NSString *JobURL = (Feed[indexPath.row])[@"link"];
    JobURL = [JobURL stringByReplacingOccurrencesOfString:@"\n\t\t" withString:@""];  // Entferne Escape-Zeichen
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:JobTitel forKey:@"JobTitel"];
    [defaults setObject:JobURL forKey:@"JobURL"];
    [defaults synchronize];
}

- (void)RefreshTable {  // Wird aufgerufen, wenn refreshControl verwendet wird
    // Wiederhole Vorgang aus der Funktion viewDidLoad, damit neu geparst und die Tabelle aktualisiert wird
    
    NSMutableString *URL = [NSMutableString stringWithString:@"http://webwirtschaft.net/?feed=job_feed&type"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    bool Freelance = [defaults boolForKey:@"Freelance"];
    bool Praktikum = [defaults boolForKey:@"Praktikum"];
    bool Projektbezogen = [defaults boolForKey:@"Projektbezogen"];
    bool Teilzeit = [defaults boolForKey:@"Teilzeit"];
    bool Vollzeit = [defaults boolForKey:@"Vollzeit"];
    
    if (!Freelance || !Praktikum || !Projektbezogen || !Teilzeit || !Vollzeit) {
        [URL appendString:@"="];
    }
    
    if (!Freelance) {
        [URL appendString:@"freelance,"];
    }
    
    if (!Praktikum) {
        [URL appendString:@"praktikum,"];
    }
    
    if (!Projektbezogen) {
        [URL appendString:@"projektbezogen,"];
    }
    
    if (!Teilzeit) {
        [URL appendString:@"teilzeit,"];
    }
    
    if (!Vollzeit) {
        [URL appendString:@"vollzeit,"];
    }
    
    [URL deleteCharactersInRange:NSMakeRange([URL length] - 1, 1)];
    [URL appendString:@"&location&job_categories&s"];
    
    Reachability *InternetReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus NetworkStatus = [InternetReachability currentReachabilityStatus];
    
    if (NetworkStatus == NotReachable) {
        HasInternet = false;
        
        Feed = [[NSMutableArray alloc] init];
        
        [self.tableView reloadData];
        
        UITextView *NoInternetTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, 290, 100)];
        NoInternetTextView.text = @"Keine Internetverbindung";
        NoInternetTextView.textColor = [UIColor grayColor];
        NoInternetTextView.font = [UIFont systemFontOfSize:20];
        NoInternetTextView.editable = false;
        NoInternetTextView.scrollEnabled = false;
        self.tableView.tableFooterView = NoInternetTextView;
        
        UIAlertView *NoInternetAlertView = [[UIAlertView alloc] initWithTitle:@"Keine Internetverbindung" message:@"Es besteht keine Verbindung zum Internet. Bitte überprüfe Deine Einstellungen." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [NoInternetAlertView show];
    } else {
        HasInternet = true;
        
        UIView *TableViewFooter = [[UIView alloc] initWithFrame:(CGRectZero)];
        
        UITextView *NoJobsTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, 290, 100)];
        NoJobsTextView.text = @"Keine Jobs in den ausgewählten Kategorien";
        NoJobsTextView.textColor = [UIColor grayColor];
        NoJobsTextView.font = [UIFont systemFontOfSize:20];
        NoJobsTextView.editable = false;
        NoJobsTextView.scrollEnabled = false;
        
        if (Feed.count == 0 && HasInternet) {
            self.tableView.tableFooterView = NoJobsTextView;
        } else if (Feed.count != 0) {
            self.tableView.tableFooterView = TableViewFooter;
        }
        
        Feed = [[NSMutableArray alloc] init];
        NSURL *FeedURL = [NSURL URLWithString:URL];
        Parser = [[NSXMLParser alloc] initWithContentsOfURL:FeedURL];
        [Parser setDelegate:self];
        [Parser setShouldResolveExternalEntities:NO];
        [Parser parse];
    }
    
    [self.refreshControl endRefreshing];  // Stoppe refreshControl
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
