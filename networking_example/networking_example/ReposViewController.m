
#import "ReposViewController.h"

@implementation ReposViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.repositories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepoTableViewCell" forIndexPath:indexPath];
    
    Repository *repo = self.repositories[indexPath.row];
    
    cell.textLabel.text = repo.name;
    cell.detailTextLabel.numberOfLines = 0;
    if (repo.author) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Last commit by %@ at %@", repo.author, repo.date];
    }
    else {
        cell.detailTextLabel.text = @"No commits";
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
