//
//  ViewController.m
//  RepoSearch
//
//

#import "ViewController.h"
#import "BFTRepoDataSource.h"
#import "BFTGithubService.h"

@interface ViewController () <UITextFieldDelegate, UICollectionViewDelegate>
@end

@implementation ViewController {
    UIView *_headerGroupView;
    UITextField *_keywordFiled;
    UIButton *_searchButton;
    
    UIView *_contentGroupView;
    UICollectionView *_repoCollectionView;
    BFTRepoDataSource *_repoDataSource;
    
    NSString *_currentKeyword;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    [self __createHeaderView];
    [self __createContentView];
}

- (void)__createHeaderView {
    _headerGroupView = [UIView new];
    _keywordFiled = [UITextField new];
    _keywordFiled.placeholder = @"input keyword, such as tetris";
    _keywordFiled.backgroundColor = UIColor.whiteColor;
    _keywordFiled.delegate = self;
    _searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_searchButton setTitle:@"Search" forState:UIControlStateNormal];
    [_searchButton addTarget:self action:@selector(__onSearchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_headerGroupView];
    _headerGroupView.translatesAutoresizingMaskIntoConstraints = NO;
    [_headerGroupView.topAnchor constraintEqualToAnchor:
        self.view.safeAreaLayoutGuide.topAnchor].active = true;
    [_headerGroupView.leadingAnchor constraintEqualToAnchor:
        self.view.safeAreaLayoutGuide.leadingAnchor].active = true;
    [_headerGroupView.trailingAnchor constraintEqualToAnchor:
        self.view.safeAreaLayoutGuide.trailingAnchor].active = true;
    [_headerGroupView addSubview:_keywordFiled];
    _keywordFiled.translatesAutoresizingMaskIntoConstraints = NO;
    [_keywordFiled.topAnchor constraintEqualToAnchor:_headerGroupView.topAnchor].active = true;
    [_keywordFiled.leadingAnchor constraintEqualToAnchor:_headerGroupView.leadingAnchor].active = true;
    [_keywordFiled.trailingAnchor constraintEqualToAnchor:_headerGroupView.trailingAnchor].active = true;
    [_headerGroupView addSubview:_searchButton];
    _searchButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_searchButton.topAnchor constraintEqualToAnchor:_keywordFiled.bottomAnchor].active = true;
    [_searchButton.leadingAnchor constraintEqualToAnchor:_headerGroupView.leadingAnchor].active = true;
    [_searchButton.trailingAnchor constraintEqualToAnchor:_headerGroupView.trailingAnchor].active = true;
    [_searchButton.bottomAnchor constraintEqualToAnchor:_headerGroupView.bottomAnchor].active = true;
}

- (void)__createContentView {
    _contentGroupView = [UIView new];
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 100);
    layout.minimumLineSpacing = 10;
    layout.footerReferenceSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 50);
    _repoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _repoCollectionView.delegate = self;
    _repoDataSource = [BFTRepoDataSource new];
    [_repoDataSource bindCollectionView:_repoCollectionView];
    
    __weak typeof (self) wself = self;
    _repoDataSource.loadMoreBlock = ^(NSUInteger startIndex) {
        typeof (self) self = wself;
        if (!self->_currentKeyword) {
            return;
        }
        [BFTGithubService.shared searchRepoWithKeyword:self->_currentKeyword startIndex:startIndex
             completion:^(BFTGithubRepoSearchResponse *response, NSError * error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error || !response) {
                    [self __showErrorDialog:error];
                } else {
                    [self->_repoDataSource appendWithRepos:response.items];
                }
            });
        }];
    };
    
    [self.view addSubview:_contentGroupView];
    _contentGroupView.translatesAutoresizingMaskIntoConstraints = NO;
    [_contentGroupView.topAnchor constraintEqualToAnchor:
        _headerGroupView.bottomAnchor].active = true;
    [_contentGroupView.leadingAnchor constraintEqualToAnchor:
        self.view.safeAreaLayoutGuide.leadingAnchor].active = true;
    [_contentGroupView.trailingAnchor constraintEqualToAnchor:
        self.view.safeAreaLayoutGuide.trailingAnchor].active = true;
    [_contentGroupView.bottomAnchor constraintEqualToAnchor:
        self.view.safeAreaLayoutGuide.bottomAnchor].active = true;
    
    [_contentGroupView addSubview:_repoCollectionView];
    _repoCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [_repoCollectionView.topAnchor constraintEqualToAnchor:_contentGroupView.topAnchor].active = true;
    [_repoCollectionView.leadingAnchor constraintEqualToAnchor:_contentGroupView.leadingAnchor].active = true;
    [_repoCollectionView.trailingAnchor constraintEqualToAnchor:_contentGroupView.trailingAnchor].active = true;
    [_repoCollectionView.bottomAnchor constraintEqualToAnchor:_contentGroupView.bottomAnchor].active = true;
}

- (void)__onSearchButtonClick:(UIButton *)button {
    [_keywordFiled resignFirstResponder];
    
    NSString *input = [_keywordFiled.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    if (input.length == 0) {
        return;
    }
    button.enabled = NO;
    [BFTGithubService.shared searchRepoWithKeyword:input startIndex:0
         completion:^(BFTGithubRepoSearchResponse *response, NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            button.enabled = YES;
            if (error || !response) {
                [self __showErrorDialog:error];
            } else {
                [self->_repoDataSource reloadWithRepos:response.items totalCount:response.totalCount];
                self->_currentKeyword = input;
            }
        });
    }];
}

- (void)__showErrorDialog:(NSError *)error {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
    [controller addAction:defaultAction];
    [self presentViewController:controller animated:YES completion:nil];
}

# pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    /// Dismiss keyboard when user click return button
    return [textField resignFirstResponder];
}

@end
