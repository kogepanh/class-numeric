% 変数
L = 1;          % 音響菅の長さ
C0 = 107;       % 学籍番号下3桁
P = 1;          % 係数
m_vec = [5, 10, 30, 50, 100];
yugen_f = zeros(3, numel(m_vec));

% n(1-N)次モード
for n = 1:3
    % 理論値
    riron_f(n) = C0 * (2 * n - 1) / 4;          % 共振周波数
    
    % 有限要素法 m(1-M)分割
    for l = 1: numel(m_vec)
        m = m_vec(l);
        he = L / m;                             % 1要素あたりの長さ
        
        % イナータンスマトリクス
        M_mat = zeros(m+1, m+1);
        for i = 2:m
            M_mat(i,i) = 2;
            M_mat(i-1, i) = -1;
            M_mat(i, i-1) = -1;
        end
        M_mat(1, 1) = 1;
        M_mat = M_mat / he;
        
        % エラスタンスマトリクス
        K_mat = zeros(m+1, m+1);
        for i = 2:m
            K_mat(i, i) = 4;
            K_mat(i-1, i) = 1;
            K_mat(i, i-1) = 1;
        end
        K_mat(1, 1) = 2;
        K_mat = K_mat * he / 6;
        
        % 計算
        [V, D] = eig(M_mat, K_mat);                         % 固有ベクトル・固有値
        f_m = sqrt(abs(diag(D))) * C0 / (2 * pi);           % 共振周波数
        [distance, index] = min(abs(f_m - riron_f(n)));     % 最も理論値と近い共振周波数を探索
        yugen_f(n, l) = f_m(index);                         % 共振周波数
    end
end
