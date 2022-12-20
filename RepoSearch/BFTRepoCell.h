//
//  BFTRepoCell.h
//  RepoSearch
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BFTGithubRepoModel;

@interface BFTRepoCell : UICollectionViewCell

@property (class, strong, nonatomic, readonly) NSString *cellIdentifier;

- (void)renderWithModel:(BFTGithubRepoModel *)model;

@end

NS_ASSUME_NONNULL_END
