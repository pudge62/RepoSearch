//
//  BFTRepoSectionFooter.h
//  RepoSearch
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BFTRepoSectionFooter : UICollectionReusableView

@property (class, strong, nonatomic, readonly) NSString *footerIdentifier;

@property (strong, nonatomic, readonly) UILabel *tipLabel;
@property (strong, nonatomic, readonly) UIButton *loadButton;

@end

NS_ASSUME_NONNULL_END
