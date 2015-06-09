#import <UIKit/UIKit.h>


@class TableViewCell;
@interface offerHelpTableViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *offersSegment;
@property (nonatomic, retain) IBOutlet TableViewCell *tableViewCellWithTableView;
- (IBAction)OffersSegmentAction:(id)sender;
@end