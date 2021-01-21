% 変数
L = 1;                                  % 音響菅の長さ
C0 = 107;                               % 学籍番号下3桁
P = 1;                                  % 係数
n = 3;                                  % モード数
m_vec = [5, 10, 30, 100];               % 分割数

% x軸
x_MIN = 0;
x_MAX = L;

% 理論値
riron_x = linspace(x_MIN, x_MAX);       % 理論値のx軸
riron_k = pi * (2 * n - 1) / 2;         % 波数
riron_f = C0 * riron_k / (2 * pi);      % 共振周波数
riron_p = P * cos(riron_k * riron_x);   % 音圧分布

% 理論値の描画
hold on
p = plot(riron_x, riron_p);
p.LineWidth = 3;

% 有限要素法
for i = 1: numel(m_vec)
    m = m_vec(i);                       % 分割数
    he(i) = L / m;                      % 1要素の長さ

    % イナータンスマトリクス
    M_mat = zeros(m+1, m+1);
    for j = 2:m
        M_mat(j,j) = 2;
        M_mat(j-1, j) = -1;
        M_mat(j, j-1) = -1;
    end
    M_mat(1, 1) = 1;
    M_mat = M_mat / he(i);

    % エラスタンスマトリクス
    K_mat = zeros(m+1, m+1);
    for j = 2:m
        K_mat(j, j) = 4;
        K_mat(j-1, j) = 1;
        K_mat(j, j-1) = 1;
    end
    K_mat(1, 1) = 2;
    K_mat = K_mat * he(i) / 6;

    % 計算
    [V, D] = eig(M_mat, K_mat);                     % 固有ベクトル・固有値
    f_m = sqrt(abs(diag(D))) * C0 / (2 * pi);       % 共振周波数

    [distance, index] = min(abs(f_m - riron_f));    % 最も理論値と近い共振周波数を探索
    yugen_p = V(:, index);                          % 音圧分布
    
    % 逆位相になっているものは反転する
    if yugen_p(1) < 0
        yugen_p = -yugen_p;
    end
    
    % 有限要素法の描画
    yugen_x = 0: he(i): 1;
    p = plot(yugen_x, yugen_p);
    p.LineWidth = 1.5;
end

hold off
xlabel('音響管(m)');
ylabel('音圧分布');
lgd = legend('理論値', '5分割', '10分割', '30分割', '100分割');

% Axes
ax = gca;
ax.FontSize = 24;