% 変数
L = 1;                  % 音響菅の長さ
c0 = 107;               % 学籍番号下3桁
P = 1;                  % 係数
n = 3;                  % モード数
m = 10;                 % 分割数

% 理論値
x = linspace(0, L);                     % 理論値のx軸
riron_k = pi * (2 * n - 1) / 2;         % 波数
riron_f = c0 * riron_k / (2 * pi);      % 共振周波数
riron_p = P * cos(riron_k * x);         % 音圧分布

% 有限要素法
he = L / m;                             % 1要素の長さ

% イナータンスマトリクス
M = zeros(m+1, m+1);
for i = 1:m-1
    M(i,i) = 2;
    M(i+1, i) = -1;
    M(i, i+1) = -1;
end
M(1, 1) = 1;
M(m, m) = 2;
M = M / he;

% エラスタンスマトリクス
K = zeros(m+1, m+1);
for i = 1:m-1
    K(i, i) = 4;
    K(i+1, i) = 1;
    K(i, i+1) = 1;
end
K(1, 1) = 2;
K(m, m) = 4;
K = K * he / 6;

% 計算
[V, D] = eig(M, K);                         % 固有ベクトル・固有値
f = sqrt(abs(diag(D))) * c0 / (2 * pi);     % 共振周波数
[gosa_min, index] = min(abs(f - riron_f));  % 最も誤差の小さい共振周波数を探索
yugen_f = f(index);                         % 該当の共振周波数
yugen_p = V(:, index);                      % 該当の音圧分布