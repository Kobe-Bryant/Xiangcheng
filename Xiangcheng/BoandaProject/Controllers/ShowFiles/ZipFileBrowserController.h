//
//  ZipFileBrowserController.h
//  GuangXiOA
//
//  Created by zhang on 12-9-20.
//
//

#import <UIKit/UIKit.h>

@interface ZipFileBrowserController : UITableViewController
-(id)initWithStyle:(UITableViewStyle)style andZipFile:(NSString*)filePath;
- (id)initWithStyle:(UITableViewStyle)style andParentDir:(NSString*)parentDir;
@end
