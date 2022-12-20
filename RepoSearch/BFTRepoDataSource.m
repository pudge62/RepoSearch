//
//  BFTRepoDataSource.m
//  RepoSearch
//
//

#import "BFTRepoDataSource.h"
#import "BFTRepoCell.h"
#import "BFTRepoSectionFooter.h"

@interface BFTRepoDataSource ()

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation BFTRepoDataSource {
    NSUInteger _totalCount;
    NSArray<BFTGithubRepoModel *> *_models;
}

- (instancetype)init {
    if (self = [super init]) {
        _models = @[];
    }
    return self;
}

- (void)bindCollectionView:(UICollectionView *)view {
    self.collectionView = view;
    view.dataSource = self;
    [view registerClass:[BFTRepoCell class] forCellWithReuseIdentifier:BFTRepoCell.cellIdentifier];
    [view registerClass:[BFTRepoSectionFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:BFTRepoSectionFooter.footerIdentifier];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BFTRepoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:
        BFTRepoCell.cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = UIColor.redColor;
    [cell renderWithModel:_models[indexPath.item]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSAssert([kind isEqual:UICollectionElementKindSectionFooter], @"unexpected supplementary kind: %@", kind);
    BFTRepoSectionFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BFTRepoSectionFooter.footerIdentifier forIndexPath:indexPath];
    footer.backgroundColor = UIColor.greenColor;
    
    if (_models.count == 0) {
        footer.tipLabel.hidden = NO;
        footer.tipLabel.text = @"Nothing";
        footer.loadButton.hidden = YES;
    } else if (_models.count == _totalCount) {
        footer.tipLabel.hidden = NO;
        footer.tipLabel.text = @"No More";
        footer.loadButton.hidden = YES;
    } else if (_models.count < _totalCount) {
        footer.tipLabel.hidden = YES;
        footer.loadButton.hidden = NO;
        [footer.loadButton addTarget:self
                              action:@selector(__onLoadMoreButtonClick:)
                    forControlEvents:UIControlEventTouchUpInside];
    }
    
    return footer;
}

- (void)__onLoadMoreButtonClick:(UIButton *)button {
    if (self.loadMoreBlock) {
        self.loadMoreBlock(_models.count);
    }
}

- (void)reloadWithRepos:(NSArray<BFTGithubRepoModel *> *)models totalCount:(NSUInteger)count; {
    _totalCount = count;
    self->_models = [models copy];
    [self.collectionView reloadData];
}

- (void)appendWithRepos:(NSArray<BFTGithubRepoModel *> *)models {
    NSMutableArray<NSIndexPath *> *pathes = [NSMutableArray arrayWithCapacity:models.count];
    for (int i = 0; i < models.count; ++i) {
        [pathes addObject:[NSIndexPath indexPathForItem:_models.count + i inSection:0]];
    }
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:(models.count + _models.count)];
    [array addObjectsFromArray:_models];
    [array addObjectsFromArray:models];
    self->_models = array;
    [self.collectionView insertItemsAtIndexPaths:pathes];
}

@end
