% 変数
L = 1;          % 音響菅の長さ
C0 = 107;       % 学籍番号下3桁
P = 1;          % 係数

% n(1-N)次モード
for n = 1:3
    % 理論値
    riron_f(n) = C0 * (2 * n - 1) / 4;          % 共振周波数
    
    % 有限要素法 m(1-M)分割
    for m = 5:5:100
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
        
        % 誤差計算
        [V, D] = eig(M_mat, K_mat);                         % 固有ベクトル・固有値
        f_m = sqrt(abs(diag(D))) * C0 / (2 * pi);           % 共振周波数
        f_dis(n, (m/5)) = min( abs( f_m - riron_f(n) ) );
    end
end

% グラフ描画
x = 5:5:100;       % プロット時の理論値のx軸
hold on
for i = 1:3
    p = plot(x, f_dis(i, :));
    p.LineWidth = 2;
end
hold off
xlabel('分割数');
ylabel('共振周波数誤差');
lgd = legend('第1次モード', '第2次モード', '第3次モード');

% Axes
ax = gca;
ax.FontSize = 24;