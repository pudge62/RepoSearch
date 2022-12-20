//
//  BFTRepoDataSource.h
//  RepoSearch
//
//

#import <UIKit/UIKit.h>
#import "BFTGithubService.h"

typedef void (^BFTRepoLoadMoreBlock)(NSUInteger startIndex);

NS_ASSUME_NONNULL_BEGIN

@interface BFTRepoDataSource : NSObject <UICollectionViewDataSource>

@property (nonatomic, strong) BFTRepoLoadMoreBlock loadMoreBlock;

- (void)bindCollectionView:(UICollectionView *)view;

- (void)reloadWithRepos:(NSArray<BFTGithubRepoModel *> *)models
             totalCount:(NSUInteger)count;

- (void)appendWithRepos:(NSArray<BFTGithubRepoModel *> *)models;

@end

NS_ASSUME_NONNULL_END
