# To Read
# https://en.wikipedia.org/wiki/Entropy_(information_theory)
# https://pl.wikipedia.org/wiki/Entropia_(teoria_informacji)

def eval(line):
    hand, bid = line.split()
    hand = hand.translate(str.maketrans('TJQKA', face))
    best = max(type(hand.replace('0', r)) for r in hand)
    return best, hand, int(bid)

def type(hand):
    return sorted(map(hand.count, hand), reverse=True)

for face in 'ABCDE', 'A0CDE':
    print(sum(rank * bid for rank, (*_, bid) in
              enumerate(sorted(map(eval, open('input.txt'))), start=1)))