#import "TitaniumRootViewController.h"
#import "teamID.h"

@interface TitaniumRootViewController ()
@property (nonatomic, strong) UITextView *logTextView;
@end

@implementation TitaniumRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.logTextView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.logTextView.editable = NO;
    self.logTextView.backgroundColor = [UIColor blackColor];
    self.logTextView.textColor = [UIColor greenColor];
    self.logTextView.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:self.logTextView];
    
    [self redirectLogs];
    
    NSLog(@"Running Titanium...");
    NSString *teamID = get_team_identifier_NSString(@"/var/containers/Bundle/Application/537C82E4-7F89-4070-964F-678A7E77FB08/Avito.app/Avito");
    NSLog(@"%@", teamID);

}

- (void)redirectLogs {
    int pipefd[2];
    pipe(pipefd);
    
    dup2(pipefd[1], STDOUT_FILENO);
    dup2(pipefd[1], STDERR_FILENO);
    
    close(pipefd[1]);
    
    NSFileHandle *fileHandle = [[NSFileHandle alloc] initWithFileDescriptor:pipefd[0]];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:NSFileHandleReadCompletionNotification
                                                      object:fileHandle
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
        NSData *data = note.userInfo[NSFileHandleNotificationDataItem];
        if (data.length > 0) {
            NSString *log = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.logTextView.text = [self.logTextView.text stringByAppendingFormat:@"\n%@", log];
                [self.logTextView scrollRangeToVisible:NSMakeRange(self.logTextView.text.length, 1)];
            });
            [fileHandle readInBackgroundAndNotify];
        }
    }];
    
    [fileHandle readInBackgroundAndNotify];
}

@end
