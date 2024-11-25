function [X, y, centers] = make_Spheres(n_samples, n_features, centers, cluster_std, center_box, shuffle, random_state)
    % Function to generate isotropic Gaussian blobs for clustering
    % n_samples: number of samples or array specifying samples per cluster
    % n_features: number of features (dimensions)
    % centers: number of centers or specific centers
    % cluster_std: standard deviation of the clusters
    % center_box: bounding box for each cluster center
    % shuffle: whether to shuffle the samples
    % random_state: seed for reproducibility

    % 默认值
    if nargin < 1, n_samples = 100; end
    if nargin < 2, n_features = 2; end
    if nargin < 3, centers = 3; end
    if nargin < 4, cluster_std = 1.0; end
    if nargin < 5, center_box = [-10.0, 10.0]; end
    if nargin < 6, shuffle = true; end
    if nargin < 7, random_state = []; end

    % 设置随机种子
    if ~isempty(random_state)
        rng(random_state);
    end

    % 如果 centers 是一个标量，生成随机的簇中心
    if isscalar(centers)
        n_centers = centers;
        centers = (center_box(2) - center_box(1)) * rand(n_centers, n_features) + center_box(1);
    else
        n_centers = size(centers, 1);
    end

    % 如果 n_samples 是标量，将样本数量平均分配到各个簇
    if isscalar(n_samples)
        n_samples_per_center = repmat(floor(n_samples / n_centers), 1, n_centers);
        remaining_samples = n_samples - sum(n_samples_per_center);
        n_samples_per_center(1:remaining_samples) = n_samples_per_center(1:remaining_samples) + 1;
    else
        n_samples_per_center = n_samples;
    end

    % 簇标准差可以是标量或者向量
    if isscalar(cluster_std)
        cluster_std = repmat(cluster_std, 1, n_centers);
    end

    % 生成数据
    X = [];
    y = [];
    for i = 1:n_centers
        X = [X; mvnrnd(centers(i, :), cluster_std(i)^2 * eye(n_features), n_samples_per_center(i))];
        y = [y; i * ones(n_samples_per_center(i), 1)];
    end

    % 是否打乱数据
    if shuffle
        idx = randperm(size(X, 1));
        X = X(idx, :);
        y = y(idx);
    end
end
