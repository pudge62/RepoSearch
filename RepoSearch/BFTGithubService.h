//
//  BFTGithubService.h
//  RepoSearch
//
//

#import <Foundation/Foundation.h>

@class BFTGithubRepoSearchResponse;

typedef void(^BFTGithubRepoSearchCompletion)(
    BFTGithubRepoSearchResponse * _Nullable res, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface BFTGithubRepoModel : NSObject

@property (nonatomic, assign, readonly) NSUInteger repoId;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *repoDescription;
@property (nonatomic, strong, readonly) NSString *htmlUrl;

@end

@interface BFTGithubRepoSearchResponse : NSObject

@property (nonatomic, assign, readonly) NSUInteger totalCount;
@property (nonatomic, assign, readonly) BOOL isInCompleteResults;
@property (nonatomic, strong, readonly) NSArray<BFTGithubRepoModel *> *items;

@end

@interface BFTGithubService : NSObject

+ (instancetype)shared;

- (void)searchRepoWithKeyword:(NSString *)keyword
                   startIndex:(NSUInteger)index
                   completion:(BFTGithubRepoSearchCompletion)completion;

@end

NS_ASSUME_NONNULL_END
