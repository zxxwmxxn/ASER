function [X, y] = make_moons(n_samples, shuffle, noise, random_state)
    % Function to generate two interleaving half circles (moons)
    % n_samples: number of samples
    % shuffle: whether to shuffle the dataset
    % noise: standard deviation of Gaussian noise
    % random_state: seed for reproducibility

    if nargin < 1
        n_samples = 100; % 默认样本数量
    end
    if nargin < 2
        shuffle = true; % 默认打乱顺序
    end
    if nargin < 3
        noise = 0; % 默认没有噪声
    end
    if nargin < 4
        random_state = []; % 默认不指定随机种子
    end

    % 分成两半
    n_samples_out = floor(n_samples / 2); % 外环样本数量
    n_samples_in = n_samples - n_samples_out; % 内环样本数量

    % 设置随机数种子
    if ~isempty(random_state)
        rng(random_state);
    end
    % 外圈月亮 (第一类)
    outer_circ_x = cos(linspace(0, pi, n_samples_out));
    outer_circ_y = sin(linspace(0, pi, n_samples_out));

    % 内圈月亮 (第二类)
    inner_circ_x = 1 - cos(linspace(0, pi, n_samples_in));
    inner_circ_y = 1 - sin(linspace(0, pi, n_samples_in)) - 0.5;

    % 合并数据
    X = [outer_circ_x, inner_circ_x; outer_circ_y, inner_circ_y]';
    y = [zeros(n_samples_out, 1); ones(n_samples_in, 1)]; % 标签 0 和 1

    % 添加噪声
    if noise > 0
        X = X + noise * randn(size(X));
    end

    % 打乱顺序
    if shuffle
        idx = randperm(n_samples);
        X = X(idx, :);
        y = y(idx);
    end
end
