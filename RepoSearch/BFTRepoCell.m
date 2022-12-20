//
//  BFTRepoCell.m
//  RepoSearch
//
//

#import "BFTRepoCell.h"
#import "BFTGithubService.h"

@implementation BFTRepoCell {
    BFTGithubRepoModel *_model;
    UILabel *_titleLabel;
    UILabel *_descriptionLabel;
}

+ (NSString *)cellIdentifier {
    return @"BFTRepoCell";
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self __createView];
    }
    return self;
}

- (void)__createView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Open" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(__onOpenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [button.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor
                                          constant:-16].active = YES;
    [button.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor
                                          constant:16].active = YES;
    [_titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor
                                              constant:16].active = YES;
    [_titleLabel.trailingAnchor constraintEqualToAnchor:button.leadingAnchor
                                               constant:-8].active = YES;
    
    _descriptionLabel = [UILabel new];
    [self.contentView addSubview:_descriptionLabel];
    _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_descriptionLabel.topAnchor constraintEqualToAnchor:_titleLabel.bottomAnchor
                                          constant:16].active = YES;
    [_descriptionLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor
                                              constant:16].active = YES;
    [_descriptionLabel.trailingAnchor constraintEqualToAnchor:button.leadingAnchor
                                                     constant:-8].active = YES;
}

- (void)__onOpenButtonClick:(UIButton *)button {
    NSURL *url = [NSURL URLWithString:_model.htmlUrl];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

- (void)renderWithModel:(BFTGithubRepoModel *)model {
    _model = model;
    _titleLabel.text = model.name;
    _descriptionLabel.text = model.repoDescription;
}

@end
