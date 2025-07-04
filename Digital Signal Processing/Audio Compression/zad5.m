clear all;
close all;
% x2 = [ 0, 7, 0, 2, 0, 2, 0, 7, 4, 2 ];
% [sym2,p2]=prawdop_sym(x2);
% N2 = length(x2);
% H2 = Shannon(x2,N2,p2,sym2);
% % bit_seq = ['0','011','01','111'];

rng(0);
x4 = randi( [1 5], 1 ,10);
[sym4,p4]=prawdop_sym(x4);
N4 = length(x4);
H4 = Shannon(x4,N4,p4,sym4);
[bit_seq,dict] = Huffman(sym4,p4);

% porownanie shannona do huffmana

bit_n = 0;
for i = 1:length(bit_seq)
    bit_n = bit_n + length(bit_seq{i});
end
bps = bit_n/length(bit_seq);

encoded_x4 = '';
for i = 1:length(x4)
    idx = find(x4(i)==sym4);
    encoded_x4 = [encoded_x4 bit_seq{idx}];
end

code_map = containers.Map;
for i = 1:length(sym4)
    code_map(bit_seq{i}) = sym4(i);
end

decoded_x4 = [];
buffer = '';
for i = 1:length(encoded_x4)
    buffer = [buffer encoded_x4(i)];
    if isKey(code_map,buffer)
        decoded_x4 = [decoded_x4 code_map(buffer)];
        buffer ='';
    end
end
function [bit_seq, dict] = Huffman(sym, p)

    % Każdy symbol to osobny węzeł drzewa
    node = struct('sym', {}, 'prob', {}, 'code', {});
    for i = 1:length(sym)
        node(i).sym = sym(i);
        node(i).prob = p(i);
        node(i).code = {''}; % Ustaw jako komórkę z pustym ciągiem
    end

    while length(node) > 1
        % Sortuj rosnąco po prawdopodobieństwie
        [~, idx] = sort([node.prob]);
        node = node(idx);

        % Dwa węzły o najmniejszym prawdopodobieństwie
        left = node(1);
        right = node(2);

        % Dodaj '0' do kodów z lewej gałęzi
        for i = 1:length(left.code)
            left.code{i} = ['0' left.code{i}];
        end
        % Dodaj '1' do kodów z prawej gałęzi
        for i = 1:length(right.code)
            right.code{i} = ['1' right.code{i}];
        end

        % Nowy węzeł z połączonymi symbolami i kodami
        new_node.sym = [left.sym right.sym];
        new_node.prob = left.prob + right.prob;
        new_node.code = [left.code right.code];

        % Zaktualizuj listę węzłów
        node = [new_node node(3:end)];
    end

    % Stwórz słownik kodów
    dict = cell(1, length(sym));
    bit_seq = cell(1, length(sym));
    for i = 1:length(sym)
        idx = find(node.sym == sym(i));
        dict{i} = node.code{idx};
        bit_seq{i} = node.code{idx};
    end
end
