% 変数
L = 1;                                  % 音響菅の長さ
C0 = 107;                               % 学籍番号下3桁
P = 1;                                  % 係数
n = 3;                                  % モード数
m_max = 100;                            % 最大分割数

% 理論値
riron_x = linspace(0, L);               % 理論値のx軸
riron_k = pi * (2 * n - 1) / 2;         % 波数
riron_f = C0 * riron_k / (2 * pi);      % 共振周波数
riron_p = P * cos(riron_k * riron_x);   % 音圧分布

% 有限要素法
yugen_p_mat = zeros(m_max, m_max + 1);  % 分割数ごとの音圧分布行列
for m = 1: m_max
    he = L / m;                         % 1要素の長さ

    % イナータンスマトリクス
    M_mat = zeros(m+1, m+1);
    for j = 2:m
        M_mat(j,j) = 2;
        M_mat(j-1, j) = -1;
        M_mat(j, j-1) = -1;
    end
    M_mat(1, 1) = 1;
    M_mat = M_mat / he;

    % エラスタンスマトリクス
    K_mat = zeros(m+1, m+1);
    for j = 2:m
        K_mat(j, j) = 4;
        K_mat(j-1, j) = 1;
        K_mat(j, j-1) = 1;
    end
    K_mat(1, 1) = 2;
    K_mat = K_mat * he / 6;

    % 計算
    [V, D] = eig(M_mat, K_mat);                     % 固有ベクトル・固有値
    f_m = sqrt(abs(diag(D))) * C0 / (2 * pi);       % 有限要素法の共振周波数

    [distance, index] = min(abs(f_m - riron_f));    % 最も理論値と近い共振周波数を探索
    yugen_f = f_m(index);                           % 共振周波数
    yugen_p = V(:, index);                          % 音圧分布
    
    % 音圧分布行列に格納
    for j = 1:numel(yugen_p)
        yugen_p_mat(m, j) = yugen_p(j);
    end
end