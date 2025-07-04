clear all;
close all;

text = extractFileText('lab11.docx');
x = double(char(text));  
[sym,p]=prawdop_sym(x);
N = length(x);
H = Shannon(x,N,p,sym);
[bit_seq,dict] = Huffman(sym,p);

% porownanie shannona do huffmana

bit_n = 0;
for i = 1:length(bit_seq)
    bit_n = bit_n + length(bit_seq{i});
end
bps = bit_n/length(bit_seq);

encoded_x = '';
for i = 1:length(x)
    idx = find(x(i)==sym);
    encoded_x = [encoded_x bit_seq{idx}];
end

code_map = containers.Map;
for i = 1:length(sym)
    code_map(bit_seq{i}) = sym(i);
end
if encoded_x(201)=='0'
    encoded_x(201) = '1';
else
    encoded_x(201) = '0';
end
decoded_x = [];
buffer = '';
for i = 1:length(encoded_x)
    buffer = [buffer encoded_x(i)];
    if isKey(code_map,buffer)
        decoded_x = [decoded_x code_map(buffer)];
        buffer ='';
    end
end

min_len = min(length(x), length(decoded_x));
num_errors = sum(x(1:min_len) ~= decoded_x(1:min_len));
disp(['Liczba błędnych symboli: ' num2str(num_errors)]);

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
