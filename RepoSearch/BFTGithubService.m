//
//  BFTGithubService.m
//  RepoSearch
//

#import "BFTGithubService.h"

static NSString *API_HOST = @"https://api.github.com";
static NSString *API_PATH_SEARCH = @"/search/repositories";

@implementation BFTGithubRepoModel

+ (instancetype)modelWithJsonObject:(id)object {
    BFTGithubRepoModel *model = [BFTGithubRepoModel new];
    model->_repoId = [object[@"id"] unsignedLongValue];
    model->_name = object[@"name"];
    model->_htmlUrl = object[@"html_url"];
    model->_repoDescription = object[@"description"];
    return model;
}

@end

@implementation BFTGithubRepoSearchResponse

+ (instancetype)responseWithJsonObject:(id)object {
    BFTGithubRepoSearchResponse *res = [BFTGithubRepoSearchResponse new];
    res->_totalCount = [object[@"total_count"] intValue];
    res->_isInCompleteResults = [object[@"incomplete_results"] boolValue];
    NSMutableArray *items = [NSMutableArray array];
    for (id item in object[@"items"]) {
        @autoreleasepool {
            BFTGithubRepoModel *model = [BFTGithubRepoModel modelWithJsonObject:item];
            [items addObject:model];
        }
    }
    res->_items = [items copy];
    return res;
}

@end

@interface NSURL (BFT)

@end

@implementation NSURL (BFT)

+ (NSURL *)bft_GETURLFromString:(NSString *)urlString params:(NSDictionary *)params {
    NSURL *parsedURL = [NSURL URLWithString:urlString];
    NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in [params keyEnumerator]) {
        if (![[params objectForKey:key] isKindOfClass:[NSString class]]) {
            continue;
        }
        NSString *value = (NSString *)[params objectForKey:key];
        NSCharacterSet *allowedCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~"];
        NSString *urlEncodingKey = [key stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        NSString *urlEncodingValue = [value stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", urlEncodingKey, urlEncodingValue]];
    }
    NSString *query = [pairs componentsJoinedByString:@"&"];
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", urlString, queryPrefix, query]];
}

@end

@interface BFTGithubService ()

@end

@implementation BFTGithubService {
    NSURLSession *_session;
    NSTimer *_throttleTimer;
    NSUInteger _throttleIndex;
}

+ (instancetype)shared {
    static BFTGithubService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [BFTGithubService new];
    });
    return service;
}

- (instancetype)init {
    if (self = [super init]) {
        _session = [NSURLSession sharedSession];
        _throttleTimer = [NSTimer timerWithTimeInterval:60 repeats:YES block:^(NSTimer *timer) {
            self->_throttleIndex = 0;
        }];
        [[NSRunLoop mainRunLoop] addTimer:_throttleTimer forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)searchRepoWithKeyword:(NSString *)keyword
                   startIndex:(NSUInteger)index
                   completion:(BFTGithubRepoSearchCompletion)completion {
    
    if (++_throttleIndex > 10) {
        NSError *error = [NSError errorWithDomain:@"BFTGithubService" code:0 userInfo:@{
            NSLocalizedDescriptionKey: @"retry after 1 min"
        }];
        completion(nil, error);
        return;
    }
    
    const NSUInteger pageSize = 10;
    NSUInteger pageNo = (index / pageSize) + 1;
    
    NSURL *url = [NSURL bft_GETURLFromString:[API_HOST stringByAppendingString:API_PATH_SEARCH] params:@{
        @"q": keyword,
        @"per_page": @(pageSize).stringValue,
        @"page": @(pageNo).stringValue
    }];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request setValue:@"application/vnd.github+json" forHTTPHeaderField:@"accept"];
    NSURLSessionTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
            return;
        }
        NSError *jError = nil;
        id jObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jError];
        if (jError || !jObject) {
            completion(nil, jError);
            return;
        }
        BFTGithubRepoSearchResponse *res =
            [BFTGithubRepoSearchResponse responseWithJsonObject:jObject];
        completion(res, nil);
    }];
    [task resume];
}

@end
